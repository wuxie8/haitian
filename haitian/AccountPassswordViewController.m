//
//  AccountPassswordViewController.m
//  haitian
//
//  Created by Admin on 2017/4/14.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AccountPassswordViewController.h"
#import "ForgotPasswordViewController.h"
#import "User.h"
#import "RegisterVC.h"
#import <JPUSHService.h>

#define ViewHeight 50
#define ButtonWeight 150
@interface AccountPassswordViewController ()

@end

@implementation AccountPassswordViewController
{
    UIButton *but;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * image=[[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ButtonWeight)];
    [image setImage:[UIImage imageNamed:@"LoginBackGround"]];
    image.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:image];
    self.title=@"密码登录";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain  target:self action:@selector(registere)];
    self.navigationItem.rightBarButtonItem = backItem;
    UIView *  loginView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame), WIDTH, HEIGHT-ButtonWeight)];
    [self.view addSubview:loginView];
    NSArray *arr=@[@"Account",@"code"];
    NSArray *arr1=@[@"请输入手机号",@"请输入密码"];
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
        //        [image1 setImage:[UIImage imageNamed:@"LoginBackGround"]];
        image1.contentMode=UIViewContentModeScaleAspectFill;
        [image1 setImage:[UIImage imageNamed:arr[i]]];
        [view addSubview:image1];
        
        UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+10, 0, view.frame.size.width-CGRectGetMaxX(image1.frame)+20,  ViewHeight)];
        text.placeholder=arr1[i];
        text.keyboardType= UIKeyboardTypeNumberPad;
        text.tag=1000+i;
        if (i==1) {
            text.secureTextEntry = YES;
        }
        [view addSubview:text];
       

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
     [accountPasswordBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [accountPasswordBut setTitle:@"验证码快捷登录" forState:UIControlStateNormal];
    [accountPasswordBut addTarget:self action:@selector(VerificationCodeLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:accountPasswordBut];
    
    UIButton *ForgotpasswordBut=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loginButton.frame)-150, CGRectGetMaxY(loginButton.frame)+10, 150, 30)];
    [ForgotpasswordBut setTitle:@"忘记密码" forState:UIControlStateNormal];
      [ForgotpasswordBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ForgotpasswordBut addTarget:self action:@selector(forgotpasswordButClick) forControlEvents:UIControlEventTouchUpInside];
 ForgotpasswordBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [loginView addSubview:ForgotpasswordBut];
    // Do any additional setup after loading the view.
}

-(void)registere
{
    RegisterVC *registervc=[[RegisterVC alloc]init];
    [self.navigationController pushViewController:registervc animated:YES];
    
}
-(void)VerificationCodeLogin
{

    [self.navigationController popViewControllerAnimated:NO];
}
-(void)forgotpasswordButClick
{
    ForgotPasswordViewController *forgotPassword=[[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgotPassword animated:YES];

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
                       
                       diction[@"1"],@"password",
                       @"1",@"logintype",
                       nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@%@",SERVERE,dologin] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
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
                UIViewController *viewCtl = self.navigationController.viewControllers[self.navigationController.viewControllers.count-3];
                [JPUSHService setAlias:diction[@"0"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

                [self.navigationController popToViewController:viewCtl animated:YES];
            }
        }
        else
        {
            [MessageAlertView showErrorMessage:resultDic[@"info"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
    
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    
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
