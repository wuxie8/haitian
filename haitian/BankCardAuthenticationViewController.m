//
//  BankCardAuthenticationViewController.m
//  haitian
//
//  Created by Admin on 2017/4/26.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "BankCardAuthenticationViewController.h"

@interface BankCardAuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UIView *footView;
@end

@implementation BankCardAuthenticationViewController
{
    NSArray *arr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收、还款银行卡";
    NSArray *arr1=@[@"持卡人姓名",@"持卡人身份号"];
    NSArray *arr2=@[@"选择银行",@"银行卡号",@"预留手机号",@""];
    arr=@[arr1,arr2];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.tableFooterView=self.footView;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(UIView *)footView
{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, 60)];
        lab.text=@"温馨提示:\n填写的银行卡必须是本人名下的借记卡";
        lab.numberOfLines=0;
        [_footView addSubview:lab];
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lab.frame)+30, WIDTH-20, 50)];
        [button setImage:[UIImage imageNamed:@"BanKCardBinging"] forState:UIControlStateNormal];
        [_footView addSubview:button];
    }
    return _footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arr objectAtIndex:(section)] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text=[[arr objectAtIndex:(indexPath.section)] objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    return cell;
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
