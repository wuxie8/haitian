//
//  IdVerificationViewController.m
//  haitian
//
//  Created by Admin on 2017/4/24.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "IdVerificationViewController.h"
#import "IDAuthViewController.h"
#import "AVCaptureViewController.h"
#import "IdOpposite ViewController.h"
#import "FaceStreamDetectorViewController.h"
@interface IdVerificationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UIView *headView;

@property(strong, nonatomic)UIView *footView;
@end

@implementation IdVerificationViewController
{
    NSArray *arr;
    UIButton *but;
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    DLog(@"%@",Context.idInfo.IDPositiveImage);
    DLog(@"%@",Context.idInfo.IDOppositeImage);

    if (Context.idInfo.IDPositiveImage) {
        UIImageView *imageView1=[self.view viewWithTag:1000];
        imageView1.image=Context.idInfo.IDPositiveImage;
        imageView1.userInteractionEnabled=NO;
    }
    if (Context.idInfo.IDOppositeImage) {
        UIImageView *imageView2=[self.view viewWithTag:1001];
        imageView2.image=Context.idInfo.IDOppositeImage;
        imageView2.userInteractionEnabled=NO;
    }
    if (Context.idInfo.IDPositiveImage&&Context.idInfo.IDOppositeImage) {
        but.enabled=YES;
        but.backgroundColor=AppButtonbackgroundColor;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"身份认证";
    arr=@[@"IdPositive",@"IdOpposite"];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.scrollEnabled=NO;
    tab.tableHeaderView=self.headView;
    tab.tableFooterView=self.footView;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UIImageView *cellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, WIDTH-30*2, 200)];
    cellImageView.tag=indexPath.row+1000;
    cellImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *cellImageTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellImageClick:)];
    [cellImageView addGestureRecognizer:cellImageTap];
    if (indexPath.row==0) {
        cellImageView.image=Context.idInfo.IDPositiveImage?Context.idInfo.IDPositiveImage:[UIImage imageNamed:arr[indexPath.row]];
    }
    if (indexPath.row==1) {
        cellImageView.image=Context.idInfo.IDOppositeImage?Context.idInfo.IDOppositeImage:[UIImage imageNamed:arr[indexPath.row]];
    }

    [cell.contentView addSubview:cellImageView];


    return cell;
}
-(void)cellImageClick:(UITapGestureRecognizer *)tap
{
    NSInteger row = tap.view.tag;
    if (row==1000) {
        AVCaptureViewController *AVCaptureVC = [[AVCaptureViewController alloc] init];
        AVCaptureVC.direction=@"Positive";
        [self.navigationController pushViewController:AVCaptureVC animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:[IdOpposite_ViewController new] animated:YES];
    }
}

#pragma mark 懒加载
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
       but=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, WIDTH-20, 40 )];
        [but setTitle:@"下一步" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        but.enabled=NO;
        but.backgroundColor=AppPageColor;
        [_footView addSubview:but];
    }
    return _footView;
}

#pragma mark 实现的方法
-(void)nextStep
{
    FaceStreamDetectorViewController *face=[[FaceStreamDetectorViewController alloc]init];
    [self.navigationController pushViewController:face animated:YES];
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
