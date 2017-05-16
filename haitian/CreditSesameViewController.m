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
    NSString* sign = @"tpzo0mxpJsYjY+Y5P1O0DudLH7qCECVibLnNokE8qPFk4aj8sDX8WBPukKPIucSHtWtCnhfFCFcyU4JtNv+ZdFoo7FtCvciUb3I3+JWEJpNSk0M9j4kNAiGXfb6Hc57ELndTQguAdyRnYZ6BxV/uWk/N3xDZfKAY6Z/0PtXaORo=";
    
    NSString* params = @"IVrQOrk7WJgT5OboAN%2BDIHzPPvjY8jIiwWojj%2FK%2FLqB4fv%2F%2B7tfqao%2B5p63VfKP%2B%2BP7nYmay3HcBZL4nZduIoHnQQUMm24cnoayYRMBSebwsyjIk4zJw8V%2B%2B5w3AHMRLO0L25YUuABv6u8chB7NOYu%2B08nI%2FBx17mzMPIjK8yC4%3D";
    NSString* appId = @"1002755";
    
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
