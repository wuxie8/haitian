//
//  LoginViewController.m
//  haitian
//
//  Created by Admin on 2017/4/14.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountPassswordViewController.h"
#import "User.h"
#define ViewHeight 50
#define ButtonWeight 150
@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UIButton *but;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * image=[[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ButtonWeight)];
    [image setImage:[UIImage imageNamed:@"LoginBackGround"]];
  image.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:image];
    self.title=@"验证码登录";
    
    UIView *  loginView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame), WIDTH, HEIGHT-ButtonWeight)];
    [self.view addSubview:loginView];
    NSArray *arr=@[@"Account",@"code"];
    NSArray *arr1=@[@"请输入手机号",@"请输入验证码"];
    self.view.backgroundColor=AppPageColor;
    for (int i=0; i<arr.count; i++) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20, 20+i*(ViewHeight+10), WIDTH-20*2-150*i, ViewHeight)];
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
//        [image1 setImage:[UIImage imageNamed:@"LoginBackGround"]];
        image1.contentMode=UIViewContentModeScaleAspectFill;
        [image1 setImage:[UIImage imageNamed:arr[i]]];
        [view addSubview:image1];
        
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+10, 0, view.frame.size.width-CGRectGetMaxX(image1.frame)+20,  ViewHeight)];
        text.placeholder=arr1[i];
        text.keyboardType= UIKeyboardTypeNumberPad;
        text.delegate=self;
        text.tag=1000+i;
        [view addSubview:text];
        
//        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(5, 39, WIDTH-10, 1)];
//        backView.backgroundColor=PageColor;
//        [view addSubview:backView];
        if (i==arr.count-1) {
            but=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(text.frame)+10, 20+i*(ViewHeight+10), WIDTH-20*2-CGRectGetMaxX(text.frame), ViewHeight)];
            but.backgroundColor=AppButtonbackgroundColor;
            [but addTarget:self action:@selector(verificationCodeRegister) forControlEvents:UIControlEventTouchUpInside];
            [but setTitle:@"获取验证码" forState:UIControlStateNormal];
            but.titleLabel.font    = [UIFont systemFontOfSize:  14];
            but.layer.cornerRadius =  20;
            //将多余的部分切掉
            but.layer.masksToBounds = YES;
            but.layer.borderWidth = 1;
            but.layer.borderColor = [[UIColor grayColor] CGColor];
            [loginView  addSubview:but];
        }
        [loginView addSubview:view];
    }
    
    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20+2*(ViewHeight+10)+20, WIDTH-20*2, 50)];
    loginButton.backgroundColor=AppButtonbackgroundColor;
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
      loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius=15;
    [loginView addSubview:loginButton];
    
    UIButton *accountPasswordBut=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(loginButton.frame)+10, 150, 30)];
    [accountPasswordBut setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [accountPasswordBut addTarget:self action:@selector(accountPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:accountPasswordBut];

    
 
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
    [[NetWorkManager sharedManager]postJSON:verificationCoderegister parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [[NetWorkManager sharedManager]postJSON:dologin parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=(NSDictionary *)responseObject;
        if ([resultDic[@"status"]boolValue]) {
            User *user=[[User alloc]init];
            user.token=resultDic[@"token"];
            user.uid=resultDic[@"uid"];
            user.username=resultDic[@"username"];
            Context.currentUser=user;
            if ( [NSKeyedArchiver archiveRootObject:Context.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")]) {
                //保存用户登录状态以及登录成功通知
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kIsLogin"];
                
            }
        }
        else
        {
            [MessageAlertView showErrorMessage:resultDic[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}

-(void)accountPasswordClick
{
    AccountPassswordViewController *AccountPasssword=[[AccountPassswordViewController alloc]init];
    [self.navigationController pushViewController:AccountPasssword animated:YES];

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
