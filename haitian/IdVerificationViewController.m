//
//  IdVerificationViewController.m
//  haitian
//
//  Created by Admin on 2017/4/24.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "IdVerificationViewController.h"

@interface IdVerificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UIView *headView;

@property(strong, nonatomic)UIView *footView;
@end

@implementation IdVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"身份认证";
    
    
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.scrollEnabled=NO;
    tab.tableHeaderView=self.headView;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(UIView *)headView
{
    if (_headView==nil) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 20 )];
        headLabel.text=@"*温馨提示： 请填写真实有效信息以便通过认证";
        headLabel.textAlignment=NSTextAlignmentCenter;
        [_headView addSubview:headLabel];
        
    }
    return _headView;
}
-(UIView *)footView
{
    if (!_footView) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
        UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, 40 )];
        [but setTitle:@"下一步" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
            
        but.enabled=NO;
        but.backgroundColor=AppPageColor;
        [_footView addSubview:but];
    }
    return _footView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UIImageView *cellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, WIDTH-30*2, 100)];
    cellImageView.image=[UIImage imageNamed:@"BindCreditCard"];
    cellImageView.tag=indexPath.row+1000;
    cellImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *cellImageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellImageClick:)];
    [cellImageView addGestureRecognizer:cellImageTap];
    [cell.contentView addSubview:cellImageView];
    return cell;
}
-(void)cellImageClick:(UITapGestureRecognizer *)tap
{
    NSInteger section = tap.view.tag;
    DLog(@"%ld",(long)section);
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
