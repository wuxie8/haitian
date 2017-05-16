//
//  CreditSesameViewController.m
//  haitian
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CreditSesameViewController.h"
#import "LMZXSDK.h"
#import <ZMCreditSDK/ALCreditService.h>

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
    
}

- (void)launchSDK {
    
    // 商户需要从服务端获取
    NSString* sign = @"XusqllQQjawQPF2pmFelPuWrS6zLwLpTzKG5HoSNDyYEshqdjjs1MgOAL7LP8RHceCLu5PPh5SbKAM0ghtR5e%2FvA25eeOY1V4WAVtQq%2FGer197sUNzJsXONAgGAT1ukwJ%2FTIGew384iqRXIf4nV%2BcUjCmlWTC7NXkwKgBE%2FrNdo%3D";
    
    NSString* params = @"ApO88WwMflzmDXYX1aTdnz0L3%2FUF8kHXtd5GF1tFJKzDSo2tmOcRmaoDYGiSNUpVyx4jqWl2HgM30v0hOXNDUlKA5ZGrExYmT5qMPbtplGFHpJe4k%2ByZHHIz6CJFuYcq8b2fGMg%2FXAH0Hq2XV2Yhu9ZOahx5W8ryJPnBh8kt1ks%3D";
    NSString* appId = @"1000100";
    
    [[ALCreditService sharedService] queryUserAuthReq:appId sign:sign params:params extParams:nil selector:@selector(result:) target:self];
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
