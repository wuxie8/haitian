//
//  CreditSesameViewController.m
//  haitian
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CreditSesameViewController.h"
#import <ZMCreditSDK/ALCreditService.h>
#import "WebVC.h"
#define  APIKEY         @"9073253582026649"
#define  UID            @"u123456"
#define  CALLBACKURL    @"http://192.168.117.239:8080/credit_callback.php"


#define  APISECRET @"wTCzqpY30jF9DHd8saT3E2tQU0q7aUhK"
#define  lm_url @"https://api.limuzhengxin.com/api/gateway"
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface CreditSesameViewController ()

@end

@implementation CreditSesameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"芝麻信用";

    [self launchSDK];


}
- (void)result:(NSMutableDictionary*)dic{
    NSLog(@"result%@",dic);
    
    NSString* system  = [[UIDevice currentDevice] systemVersion];
    if([system intValue]>=7){
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)launchSDK {
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:
                        @"18763895506",@"mobileNo",
                        
                        nil];
   
    NSString *string=[self convertToJsonData:dic1];
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        string,@"identity_param",
                        
                        @"1",@"identity_type",
                        
                        nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];

    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    NSString *urlStr = [NSString stringWithFormat:@"http://app.jishiyu11.cn:81/api/alipay/encrypt"];
    DLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    [manager GET:urlStr parameters:dic2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            WebVC *vc = [[WebVC alloc] init];
            [vc setNavTitle:@"芝麻信用"];
            [vc loadFromURLStr:[NSString stringWithFormat:@"%@",[responseObject[@"data"]objectForKey:@"url"]]];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
        else
            {
            [MessageAlertView showErrorMessage:responseObject[@"msg"]];
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error);

    }];

 
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
