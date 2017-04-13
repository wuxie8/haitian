//
//  HomePageViewController.m
//  haitian
//
//  Created by Admin on 2017/4/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "HomePageViewController.h"
#import "ASValueTrackingSlider.h"

#define ImageHeight 200
@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UIView*headView;
@end

@implementation HomePageViewController
{
    NSArray *arr1;
    NSArray *arr2;
    NSArray *arr3;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    arr1=@[@"applyFor",@"audit",@"borrow"];
     arr2=@[@"APP申请，大数据授信",@"APP申请，大数据授信",@"APP申请，大数据授信"];
     arr3=@[@"APP申请，大数据授信",@"APP申请，大数据授信",@"APP申请，大数据授信"];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT-44)];
    tab.delegate=self;
    tab.tableHeaderView=self.headView;
    tab.dataSource=self;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}


-(UIView *)headView
{
    if (!_headView) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 520)];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,  ImageHeight)];
        [image setImage:[UIImage imageNamed:@"banner"]];
        [_headView addSubview:image];
        
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0,  ImageHeight, WIDTH, 87)];
        whiteView.backgroundColor=[UIColor grayColor];
        [_headView addSubview:whiteView];
        
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(21,  ImageHeight-13, WIDTH-21*2, 90)];
        view.backgroundColor=[UIColor whiteColor];
        [_headView addSubview:view];
        
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, 100, 20)];
        label1.text=@"每月还款 ";
        label1.center=CGPointMake(WIDTH/2-(WIDTH/2-20)/2, label1.center.y);
        label1.textAlignment=NSTextAlignmentCenter;
        [view addSubview:label1];
        
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(38, 51, 100, 20)];
        label2.text=@"953～1033";
        CGPoint point=CGPointMake(label1.center.x, label2.center.y);
        label2.center=point;
            label2.textAlignment=NSTextAlignmentCenter;
        [view addSubview:label2];
        
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(60+WIDTH/2, 20, 100, 20)];
        label3.center=CGPointMake(WIDTH/2+(WIDTH/2-20)/2, label3.center.y);
        label3.text=@"还款期限 ";
         label3.textAlignment=NSTextAlignmentCenter;
        [view addSubview:label3];
        
        
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(60+WIDTH/2, 51, 100, 20)];
        label4.text=@"12个月";
         label4.textAlignment=NSTextAlignmentCenter;
        label4.center=CGPointMake(label3.center.x, label4.center.y);
        [view addSubview:label4];
        _headView.backgroundColor=[UIColor whiteColor];
        
        UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(whiteView.frame), WIDTH, 210)];
        
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(42, 50, 40, 20)];
        lab1.text=@"金额";
        [view1 addSubview:lab1];
        ASValueTrackingSlider *asValue=[[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+10, 50, 250, 10)];
        asValue.maximumValue=10000;
        asValue.minimumValue=0;
        asValue.value=5000;
        NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
        [tempFormatter setPositivePrefix:@"¥"];
        [tempFormatter setNegativePrefix:@"¥"];
        [asValue setMaxFractionDigitsDisplayed:0];
        [asValue setNumberFormatter:tempFormatter];
        asValue.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
        asValue.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
      
        [asValue showPopUpView];
      
        asValue.minimumValueImage=[UIImage imageNamed:@"dot"];
        [asValue setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        asValue.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
        [view1 addSubview:asValue];
       
        
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(42, CGRectGetMaxY(lab1.frame)+50, 40, 20)];
        lab2.text=@"期限";
        [view1 addSubview:lab2];
        
        ASValueTrackingSlider *asValue2=[[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab2.frame)+10, CGRectGetMaxY(lab1.frame)+50, 250, 20)];
        asValue2.maximumValue=12;
        asValue2.minimumValue=1;
        NSNumberFormatter *tempFormatter2 = [[NSNumberFormatter alloc] init];
        [tempFormatter2 setPositiveSuffix:@"个月"];
        [tempFormatter2 setNegativeSuffix:@"个月"];
        asValue2.value=asValue2.maximumValue;
        [asValue2 setMaxFractionDigitsDisplayed:0];
        [asValue2 setNumberFormatter:tempFormatter2];
        asValue2.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
        asValue2.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
        UIImage *leftTrack2 = [[UIImage imageNamed:@"dot"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
        [asValue2 showPopUpView];
        [asValue2 setMinimumTrackImage:leftTrack2 forState:UIControlStateNormal];
        
        asValue2.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
        [view1 addSubview:asValue2];
        
        UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(18, CGRectGetMaxY(lab2.frame)+30, WIDTH-36, 50)];
        [but setImage:[UIImage imageNamed:@"ApplyImmediately"] forState:UIControlStateNormal];
        [view1 addSubview:but];
        
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame)+15, WIDTH, 5)];
        view2.backgroundColor=[UIColor grayColor];
         [_headView addSubview:view1];
        [_headView addSubview:view2];
       
    }
    return _headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3    ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.imageView.clipsToBounds=YES;
    cell.imageView.image=[UIImage imageNamed:arr1[indexPath.row]];
    
    cell.textLabel.text=arr2[indexPath.row];
    cell.detailTextLabel.text=arr3[indexPath.row];
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
