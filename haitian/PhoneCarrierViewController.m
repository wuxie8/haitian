//
//  PhoneCarrierViewController.m
//  haitian
//
//  Created by Admin on 2017/7/10.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "PhoneCarrierViewController.h"
#import <sqlite3.h>

#define ViewHeight 50
#define ButtonWeight 150
@interface PhoneCarrierViewController ()

@end


@implementation PhoneCarrierViewController
{
    UIButton *but;
    NSDictionary *dic1;
    NSString *otherInfo;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title=@"手机运营商";
        UIView *  loginView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT-ButtonWeight)];
    [self.view addSubview:loginView];
    NSArray *arr=@[@"Account",@"code"];
    NSArray *arr1=@[@"请输入手机号",@"请输入服务密码"];
    self.view.backgroundColor=AppPageColor;
    for (int i=0; i<arr.count; i++) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20, 20+i*(ViewHeight+10), WIDTH-20*2, ViewHeight)];
        view.tag=100+i;
        //设置圆角
        view.layer.cornerRadius = ViewHeight/2;
        //将多余的部分切掉
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [[UIColor grayColor] CGColor];
        view.backgroundColor=[UIColor whiteColor];
        [loginView addSubview:view];
        
        UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15,20,  20)];
        image1.contentMode=UIViewContentModeScaleAspectFill;
        [image1 setImage:[UIImage imageNamed:arr[i]]];
        [view addSubview:image1];
        
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+10, 0, view.frame.size.width-CGRectGetMaxX(image1.frame)+20,  ViewHeight)];
        text.placeholder=arr1[i];
        if (i==1) {
            text.secureTextEntry = YES;
        }
        text.keyboardType= UIKeyboardTypeNumberPad;
        text.delegate=self;
        text.tag=1000+i;
        [view addSubview:text];
        

        [loginView addSubview:view];
    }
    
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20+2*(ViewHeight+10)+20, WIDTH-20*2, 50)];
    loginButton.backgroundColor=AppButtonbackgroundColor;
    [loginButton setTitle:@"提交" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(mobilePhoneOwnership) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius=15;
    [loginView addSubview:loginButton];
    
    
    
    
    // Do any additional setup after loading the view.
}



-(void)loginClick
{
    NSMutableDictionary *diction=[NSMutableDictionary dictionary];
    for (int i=0; i<2; i++) {
        UIView *view1=[self.view viewWithTag:100+i];
        
        UITextField *text1=(UITextField *)[view1 viewWithTag:1000+i];
        [diction setObject:text1.text forKey:[NSString stringWithFormat:@"%d",i]];
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       diction[@"0"],@"username",
                       
                       diction[@"1"],@"code",
                       @"2",@"logintype",
                       nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@%@",SERVERE,dologin] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=(NSDictionary *)responseObject;
        if ([resultDic[@"status"]boolValue]) {

        
        }
        else
        {
            [MessageAlertView showErrorMessage:resultDic[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}
#pragma mark 运营商验证
-(void)phoneCarrier:(NSDictionary *)paraDic
{
    
    [[NetWorkManager sharedManager]postJSON:@"http://api.tanzhishuju.com/api/gateway" parameters:paraDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"0010"]) {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"api.common.getStatus",@"method",
                               @"0618854278903691",@"apiKey",
                               @"1.0.0",@"version",
                               @"mobile",@"bizType",
                               responseObject[@"token"],@"token",
                               
                               
                               //                           @"1",@"sign",
                               //                                                      @"371102199303215716",@"identityCardNo",
                               //                                                      @"吴公胜",@"identityName",
                               
                               
                               
                               nil];
            [self getResultSign:dic step:@"2"];
            
        }
        else
        {
            [MessageAlertView showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
}

-(void)mobilePhoneOwnership{
    NSMutableDictionary *diction=[NSMutableDictionary dictionary];

    for (int i=0; i<2; i++) {
        UIView *view1=[self.view viewWithTag:100+i];
        
        UITextField *text1=(UITextField *)[view1 viewWithTag:1000+i];
        [diction setObject:text1.text forKey:[NSString stringWithFormat:@"%d",i]];
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"api.mobile.area",@"method",
                       @"0618854278903691",@"apiKey",
                       @"1.0.0",@"version",
                       //                                                      @"371102199303215716",@"identityCardNo",
                       //                                                      @"吴公胜",@"identityName",
                       diction[@"0"],@"mobileNo",
                       
                       
                       nil];
    [self getResultSign:dic step:@"0"];

}
//第一步  提交申请
-(void)getSign:(NSString *)value
{
    NSMutableDictionary *diction=[NSMutableDictionary dictionary];
    for (int i=0; i<2; i++) {
        UIView *view1=[self.view viewWithTag:100+i];
        
        UITextField *text1=(UITextField *)[view1 viewWithTag:1000+i];
        [diction setObject:text1.text forKey:[NSString stringWithFormat:@"%d",i]];
    }

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"api.mobile.get",@"method",
                       @"0618854278903691",@"apiKey",
                       @"1.0.0",@"version",

                       diction[@"0"],@"username",
                        [UtilTools base64EncodedString:diction[@"1"]],@"password",
                       @"busi",@"contentType",

                       
                       nil];
    NSMutableDictionary *paradic=[NSMutableDictionary dictionaryWithDictionary:dic];
    if (![UtilTools isBlankString:value]) {
        [paradic setObject:value forKey:@"otherInfo"];
    }
    [self getResultSign:paradic step:@"1"];

}

-(void)getResultSign:(NSDictionary *)signDic step:(NSString *)step
{


    [[NetWorkManager sharedManager]postJSON:@"http://app.jishiyu11.cn/index.php?g=app&m=userdetail&a=mobileSign" parameters:signDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableDictionary *paradic=[NSMutableDictionary dictionaryWithDictionary:signDic];
        [paradic setObject:[responseObject[@"data"] objectForKey:@"sign"] forKey:@"sign"];
        if ([step isEqualToString:@"0"]) {

            [self getmobilePhoneOwnership:paradic];
        }
        else if ([step isEqualToString:@"1"]) {
            [self phoneCarrier:paradic];

        }
        else if ([step isEqualToString:@"2"])
        {
            dic1=paradic;
            [self getStatus:paradic];
        }
        else{
            [self getRusult:paradic];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];

}
//第一步 获取归属地
-(void)getmobilePhoneOwnership:(NSDictionary *)paraDic
{
    
    [[NetWorkManager sharedManager]postJSON:@"http://api.tanzhishuju.com/api/gateway" parameters:paraDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            NSString *typeString = [NSString stringWithFormat:@"%@%@",responseObject[@"province"],responseObject[@"type"]];
            if ([typeString isEqualToString:@"北京移动"]) {
                NSString *title = NSLocalizedString(@"请输入服务密码", nil);
                NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
                NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                // Add the text field for the secure text entry.
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    // Listen for changes to the text field's text so that we can toggle the current
                    // action's enabled property based on whether the user has entered a sufficiently
                    // secure entry.
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
                    
                    textField.secureTextEntry = YES;
                }];
                
                // Create the actions.
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Secure Text Entry\" alert's cancel action occured.");
                    
                    // Stop listening for text changed notifications.
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                }];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Secure Text Entry\" alert's other action occured.");
                    [self getSign:otherInfo];
                    // Stop listening for text changed notifications.
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                }];
                
                // The text field initially has no text in the text field, so we'll disable it.
//                otherAction.enabled = NO;
                
                // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
//                self.secureTextAlertAction = otherAction;
                
                // Add the actions.
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
          
                
            }
            else if([typeString isEqualToString:@"广西电信"]||[typeString isEqualToString:@"山西电信"]){
                NSString *title = NSLocalizedString(@"请输入身份证号码", nil);
                NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
                NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                // Add the text field for the secure text entry.
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    // Listen for changes to the text field's text so that we can toggle the current
                    // action's enabled property based on whether the user has entered a sufficiently
                    // secure entry.
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
                    
                    textField.secureTextEntry = YES;
                }];
                
                // Create the actions.
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Secure Text Entry\" alert's cancel action occured.");
                    
                    // Stop listening for text changed notifications.
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                }];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Secure Text Entry\" alert's other action occured.");
                    [self getSign:otherInfo];
                    // Stop listening for text changed notifications.
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                }];
                
                // The text field initially has no text in the text field, so we'll disable it.
                //                otherAction.enabled = NO;
                
                // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
                //                self.secureTextAlertAction = otherAction;
                
                // Add the actions.
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
           
            else if([typeString isEqualToString:@"吉林电信"]){
                NSString *title = NSLocalizedString(@"请输入验证码", nil);
                NSString *message = NSLocalizedString(@"请发送CXDD到10001获取验证码", nil);

                NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
                NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                // Add the text field for the secure text entry.
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    // Listen for changes to the text field's text so that we can toggle the current
                    // action's enabled property based on whether the user has entered a sufficiently
                    // secure entry.
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
                    
                    textField.secureTextEntry = YES;
                }];
                
                // Create the actions.
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Secure Text Entry\" alert's cancel action occured.");
                    
                    // Stop listening for text changed notifications.
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                }];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Secure Text Entry\" alert's other action occured.");
                    [self getSign:otherInfo];
                    // Stop listening for text changed notifications.
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
                }];
                
                // The text field initially has no text in the text field, so we'll disable it.
                //                otherAction.enabled = NO;
                
                // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
                //                self.secureTextAlertAction = otherAction;
                
                // Add the actions.
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                [self getSign:@""];

            }
           
        }
        else
        {
            [MessageAlertView showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    otherInfo=textField.text;
    // Enforce a minimum length of >= 5 characters for secure text alerts.
//    self.secureTextAlertAction.enabled = textField.text.length >= 5;
}
//第三步 获取结果
-(void)getRusult:(NSDictionary *)paraDic
{
    
    [[NetWorkManager sharedManager]postJSON:@"http://api.tanzhishuju.com/api/gateway" parameters:paraDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MessageAlertView showSuccessMessage:@"认证成功"];
        [self OperatorStatus];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
}
//第二步 轮询
-(void)OperatorStatus
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       Context.currentUser.uid,@"uid",
                       @"1",@"auth",
                       nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=mobile_auth",SERVERE] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            if (self.clickBlock) {
                self.clickBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];


}
-(void)getStatus:(NSDictionary *)paraDic
{
    
    [[NetWorkManager sharedManager]postJSON:@"http://api.tanzhishuju.com/api/gateway" parameters:paraDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
    
        if ([responseObject[@"code"] hasPrefix:@"0"]||[UtilTools isBlankString:responseObject[@"code"]]) {
            if ([responseObject[@"code"] isEqualToString:@"0000"]) {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"api.common.getResult",@"method",
                                   @"0618854278903691",@"apiKey",
                                   @"1.0.0",@"version",
                                   @"mobile",@"bizType",
                                   responseObject[@"token"],@"token",
                                   nil];
                [self getResultSign:dic step:@"3"];

            }
            else
            {
                [self performSelector:@selector(getStatus:) withObject:dic1 afterDelay:5];

            }
          
        }
        else{
            [MessageAlertView showErrorMessage:responseObject[@"msg"]];
        
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
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
