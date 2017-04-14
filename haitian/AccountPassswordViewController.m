//
//  AccountPassswordViewController.m
//  haitian
//
//  Created by Admin on 2017/4/14.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AccountPassswordViewController.h"
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
        text.delegate=self;
        text.tag=1000+i;
        [view addSubview:text];
        
//        //        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(5, 39, WIDTH-10, 1)];
//        //        backView.backgroundColor=PageColor;
//        //        [view addSubview:backView];
//        if (i==arr.count-1) {
//            but=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(text.frame)+10, 20+i*(ViewHeight+10), WIDTH-20*2-CGRectGetMaxX(text.frame), ViewHeight)];
//            but.backgroundColor=AppBackColor;
//            [but addTarget:self action:@selector(verificationCode) forControlEvents:UIControlEventTouchUpInside];
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
    loginButton.backgroundColor=AppBackColor;
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius=15;
    [loginView addSubview:loginButton];
    
    UIButton *accountPasswordBut=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(loginButton.frame)+10, 150, 30)];
    [accountPasswordBut setTitle:@"验证码快捷登录" forState:UIControlStateNormal];
    [loginView addSubview:accountPasswordBut];
    
    UIButton *ForgotpasswordBut=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loginButton.frame)-150, CGRectGetMaxY(loginButton.frame)+10, 150, 30)];
    [ForgotpasswordBut setTitle:@"忘记密码" forState:UIControlStateNormal];
    [ForgotpasswordBut addTarget:self action:@selector(ForgotpasswordButClick) forControlEvents:UIControlEventTouchUpInside];
 ForgotpasswordBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [loginView addSubview:ForgotpasswordBut];
    // Do any additional setup after loading the view.
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
