//
//  RemindViewController.m
//  haitian
//
//  Created by Admin on 2017/5/22.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindTableViewCell.h"
#import "AddBillViewController.h"
#import "AddBillVC.h"
#define  headViewHeight 180
@interface RemindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UIView *headView;

@property(strong, nonatomic)UIView *footView;
@end

@implementation RemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"首页";
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0 , 0, WIDTH, HEIGHT-50)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.backgroundColor=AppButtonbackgroundColor;
    tab.tableFooterView=self.footView;
    tab.tableHeaderView=self.headView;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(UIView *)headView
{
    
    if (_headView==nil) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, headViewHeight)];
        _headView.backgroundColor=[UIColor whiteColor];
        UIImageView *headimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, headViewHeight)];
        headimage.backgroundColor=[UIColor greenColor];
        headimage.image =[UIImage imageNamed:@"RemindHeadImage"];
        [_headView addSubview:headimage];

        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 50, 50)];
        image.backgroundColor=[UIColor redColor];
        
        UILabel *balancelab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10,  130, 64, 15)];
        balancelab.text=@"余额";
        balancelab.textColor=[UIColor whiteColor];
        [_headView addSubview:balancelab];
        [_headView addSubview:image];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10,  150  , 64, 15)];
        lab.text=@"166.66";
        [_headView addSubview:lab];
    }
    return _headView;
}
-(UIView *)footView
{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        _footView.backgroundColor=[UIColor whiteColor];
        UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        
        [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [but setTitle:@"+添加账单提醒" forState:UIControlStateNormal];
        but.titleLabel.textAlignment=NSTextAlignmentCenter;
        [but addTarget:self action:@selector(addRemind) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:but];
    }
    return _footView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return  3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor=AppButtonbackgroundColor;
    return  view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer=@"cell";
    
    RemindTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if (cell==nil) {
        cell=[[RemindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)addRemind
{
    AddBillViewController *addBill=[AddBillViewController new];
    addBill.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addBill animated:YES];
    
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
