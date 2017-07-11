//
//  SmsCodeViewController.m
//  haitian
//
//  Created by Admin on 2017/7/10.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "SmsCodeViewController.h"
#define ViewHeight 50
#define ButtonWeight 150
@interface SmsCodeViewController ()

@end



@implementation SmsCodeViewController
{
    UIButton *but;
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
        
        //        if (i==arr.count-1) {
        //            but=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(text.frame)+10, 20+i*(ViewHeight+10), WIDTH-20*2-CGRectGetMaxX(text.frame), ViewHeight)];
        //            but.backgroundColor=AppButtonbackgroundColor;
        //            [but addTarget:self action:@selector(verificationCodeRegister) forControlEvents:UIControlEventTouchUpInside];
        //            [but setTitle:@"获取验证码" forState:UIControlStateNormal];
        //            but.titleLabel.font    = [UIFont systemFontOfSize:  14];
        //            but.layer.cornerRadius =  20;
        //            //将多余的部分切掉
        //            but.layer.masksToBounds = YES;
        //            but.layer.borderWidth = 1;
        //            but.layer.borderColor = [[UIColor grayColor] CGColor];
        //            [loginView  addSubview:but];
        //        }
        [loginView addSubview:view];
    }
    
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20+2*(ViewHeight+10)+20, WIDTH-20*2, 50)];
    loginButton.backgroundColor=AppButtonbackgroundColor;
    [loginButton setTitle:@"提交" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius=15;
    [loginView addSubview:loginButton];
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)verificationCodeRegister
{
    UIView *view1=[self.view viewWithTag:100];
    
    UITextField *text1=(UITextField *)[view1 viewWithTag:1000];
    
    if (text1.text.length==0) {
        [MessageAlertView showErrorMessage:@"请输入手机号"];
        return;
    }
    else if (text1.text.length!=11)
    {
        [MessageAlertView showErrorMessage:@"请输入正确的手机号"];
        return;
    }
    
    __block NSInteger second = 60;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                [but setTitle:[NSString stringWithFormat:@"%ld秒",(long)second] forState:UIControlStateNormal];
                second--;
                [but setEnabled:NO];
                but.alpha=0.4;
                but.backgroundColor=[UIColor grayColor];
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                [but setTitle:@"获取验证码" forState:UIControlStateNormal];
                [but setEnabled:YES];
                but.alpha=1;
                but.backgroundColor=AppButtonbackgroundColor;
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       text1.text,@"mobile",
                       
                       nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@%@",SERVERE,verificationCoderegister] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"status"]boolValue]) {
            [MessageAlertView showSuccessMessage:@"发送成功"];
        }
        else
        {
            [MessageAlertView showErrorMessage:[NSString stringWithFormat:@"%@",dic[@"info"]]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
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
-(void)phoneCarrier:(NSDictionary *)paraDic
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
                       //                           @"1",@"sign",
                       //                               @"371102199303215716",@"identityCardNo",
                       //                               @"吴公胜",@"identityName",
                       diction[@"0"],@"username",
                       diction[@"1"],@"password",
                       
                       
                       nil];
    DLog(@"%@",dic);
    
    [[NetWorkManager sharedManager]postJSON:@"http://api.tanzhishuju.com/api/gateway" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
}
-(void)getSign
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
                       //                           @"1",@"sign",
                       //                               @"371102199303215716",@"identityCardNo",
                       //                               @"吴公胜",@"identityName",
                       diction[@"0"],@"username",
                       diction[@"1"],@"password",
                       
                       
                       nil];
    DLog(@"%@",dic);
    
    [[NetWorkManager sharedManager]postJSON:@"http://api.tanzhishuju.com/api/gateway" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DLog(@"%@",responseObject);
        NSMutableDictionary *paradic=[NSMutableDictionary dictionaryWithDictionary:dic];
        [paradic setObject:@"" forKey:@"sign"];
        [self phoneCarrier:paradic];
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
