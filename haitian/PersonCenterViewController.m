//
//  PersonCenterViewController.m
//  haitian
//
//  Created by Admin on 2017/4/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "LoginViewController.h"
#import "HelpCenterViewController.h"
#import "FeedbackViewController.h"
#import "SetUpViewController.h"
#import "PersonalDataViewController.h"
@interface PersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UIView *headView;
@end

@implementation PersonCenterViewController
{
    NSArray *arr;
    NSArray  *arr1;
    UITableView *tab;
    UIButton *but;
   }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人中心";
   
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:tab];
   
   
   arr1=@[@"",@"PersonalData",@"InviteFriends",@"HelpCenter",@"feedback",@"SetUp"];
    arr=@[@"",@"个人资料",@"邀请好友",@"帮助中心",@"意见反馈",@"设置"];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {
        [but setTitle:Context.currentUser.username forState:UIControlStateNormal];
    }
    else{
        [but setTitle:@"点击登陆" forState: UIControlStateNormal ];
        [but addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];}
}

//几个  section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }
    return  60;
}
//对应的section有多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
            
        case 0:
        {
            cell.backgroundColor=AppButtonbackgroundColor;
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake( 20 , 20, 40, 40)];
            [image setImage:[UIImage imageNamed:@"avatar"]];
            [cell.contentView addSubview:image];
            but=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, 20, 150, 40)];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {
                [but setTitle:Context.currentUser.username forState:UIControlStateNormal];
            }
            else{
            [but setTitle:@"点击登陆" forState: UIControlStateNormal ];
                [but addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];}
            [cell.contentView addSubview:but];
        }
            break;
       
//        case 1:
//        {
//            
//            UITapGestureRecognizer *minimalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(minimalTap)];
//            minimalTap.numberOfTouchesRequired = 1;
//            minimalTap.numberOfTapsRequired = 1;
//           
//            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width/2, cell.frame.size.height)];
//            view.userInteractionEnabled=YES;
//            [view addGestureRecognizer:minimalTap];
//            [cell.contentView addSubview:view];
//            UITapGestureRecognizer *minimalTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
//           
//            minimalTap2.numberOfTouchesRequired = 1;
//            minimalTap2.numberOfTapsRequired = 1;
//            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width/2, 0, cell.frame.size.width/2, cell.frame.size.height)];
//            view1 .userInteractionEnabled=YES;
//            [view1 addGestureRecognizer:minimalTap2];
//            [cell.contentView addSubview:view1];
//            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
//            image.image=[UIImage imageNamed:@"MyBorrow"];
//            image.contentMode=UIViewContentModeScaleAspectFill;
//            image.clipsToBounds=YES;
//            [cell.contentView addSubview:image];
//            
//            UILabel *textlabel1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+20, 10, WIDTH/2-CGRectGetMaxX(image.frame), 15)];
//            textlabel1.text=@"我的借款";
//            [cell.contentView addSubview:textlabel1];
//            
//            
//            UILabel *detailtextlabel1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+20, CGRectGetMaxY(textlabel1.frame)+10, WIDTH/2-CGRectGetMaxX(image.frame), 15)];
//            detailtextlabel1.text=@"查看借款详情";
//            [cell.contentView addSubview:detailtextlabel1];
//            
//            UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(20+WIDTH/2, 10, 30, 30)];
//            image2.image=[UIImage imageNamed:@"CardVoucher"];
//            image2.contentMode=UIViewContentModeScaleAspectFill;
//            image2.clipsToBounds=YES;
//            [cell.contentView addSubview:image2];
//            
//            UILabel *textlabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image2.frame)+20, 10, WIDTH/2-CGRectGetMaxX(image.frame), 15)];
//            textlabel2.text=@"我的借款";
//            [cell.contentView addSubview:textlabel2];
//            
//            
//            UILabel *detailtextlabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image2.frame)+20, CGRectGetMaxY(textlabel2.frame)+10, WIDTH/2-CGRectGetMaxX(image.frame), 15)];
//            detailtextlabel2.text=@"1张卡券可用";
//            [cell.contentView addSubview:detailtextlabel2];
//            
//        }
//          
//            break;
       
        default:
        {
            [cell.imageView setImage:[UIImage imageNamed:arr1[indexPath.section]]];
            cell.textLabel.text=arr[indexPath.section];
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

        }
            break;
    }
   
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {
                
                PersonalDataViewController *setup=[PersonalDataViewController new];
                setup.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:setup animated:YES];
            }
            else{
                [self.navigationController pushViewController:[LoginViewController new] animated:YES];

            }
        }
            break;
        case 3:
        {HelpCenterViewController *helpCenter=[[HelpCenterViewController alloc]init];
            helpCenter.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:helpCenter animated:YES];
        }
            break;
        case 4:
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {

                FeedbackViewController *feedback=[[FeedbackViewController alloc]init];
                feedback.hidesBottomBarWhenPushed=YES;
                
                [self.navigationController pushViewController:feedback animated:YES];
            }
            else{
                [self.navigationController pushViewController:[LoginViewController new] animated:YES];

            }
           
        }
            break;
            case 5:
        {
            SetUpViewController *setup=[SetUpViewController new];
            setup.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:setup animated:YES];

        }
            
        default:
            break;
    }

}
-(void)login
{
    LoginViewController *login=[[LoginViewController alloc]init];
    login.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:login animated:YES];

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
