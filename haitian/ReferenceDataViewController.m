//
//  ReferenceDataViewController.m
//  haitian
//
//  Created by Admin on 2017/5/2.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "ReferenceDataViewController.h"
#import "AddressBookVC.h"
@interface ReferenceDataViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(strong, nonatomic)UIView*headView;

@property(strong, nonatomic)UIView*footView;

@property (nonatomic,strong)UIView *addTapView;//蒙层

@end

@implementation ReferenceDataViewController
{
    NSArray *arr1;
    NSArray *arr2;
    NSArray *arr3;
    NSDictionary *dic;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"资料提交";
    arr1=@[@"通讯录认证",@"运营商认证"];
    arr2=@[@"AuthenticationImage",@"CreditSesame",@"BindCreditCard"];
    arr3=@[@"待认证",@"待认证"];
    NSNumber *num1=[NSNumber numberWithBool:NO];
    dic=[NSDictionary dictionaryWithObjectsAndKeys:
         num1 , @"0",
         num1, @"1",
         [NSNumber numberWithBool:NO], @"2",nil];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.tableHeaderView=self.headView;
    tab.tableFooterView=self.footView;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(UIView *)headView
{
    if (!_headView) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
        _headView.backgroundColor=[UIColor redColor];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
        imageView.image=[UIImage imageNamed:@"DataSubmitted-3"];
//        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_headView addSubview:imageView];
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
        
        but.layer.cornerRadius =  20;
        //            //将多余的部分切掉
        but.layer.masksToBounds = YES;
        but.enabled=NO;
        but.backgroundColor=AppPageColor;
        [_footView addSubview:but];
    }
    return _footView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    headerView.backgroundColor=AppBackColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, tableView.frame.size.width-20*2-40, 20)];
    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [label setBackgroundColor:[UIColor clearColor]];
    label.adjustsFontSizeToFitWidth=YES;
    label.text=@"*温馨提示：请填写真实有效信息以获得更高信用额度";
    [headerView setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:label];
    return  headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr1.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.imageView.image=[UIImage imageNamed:arr2[indexPath.row]];
    cell.textLabel.text=arr1[indexPath.row];
    if ([(NSNumber *)[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]boolValue]) {
        cell.detailTextLabel.text=@"已认证";
        
    }
    else
    {
        cell.detailTextLabel.text=@"待认证";
        
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.detailTextLabel.textColor=[UIColor blueColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication].keyWindow addSubview:self.addTapView];
            UITapGestureRecognizer *tapGer                     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearView)];
            [_addTapView addGestureRecognizer:tapGer];
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 60, WIDTH-20, HEIGHT-100)];
            view.backgroundColor=[UIColor whiteColor];
            [self.addTapView addSubview:view];
            UILabel  *label=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2-90, 5, 200, 30)];
            label.text=@"用户使用协议";
            label.textAlignment=NSTextAlignmentCenter;
            [view addSubview:label];
            
            UIButton *cancleButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame)-30-10, 5, 30, 30)];
            [cancleButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
            [cancleButton addTarget:self action:@selector(disappearView) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:cancleButton];
            UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(label.frame)+10, WIDTH-30, HEIGHT-CGRectGetMaxY(label.frame)-150)];
            textview.font=[UIFont systemFontOfSize:16];
            textview.text=@"待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证待认证";
            [view addSubview:textview];
            
            UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2-50, CGRectGetMaxY(textview.frame)+5, 100, 30)];
            [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
            [but setTitleColor:AppButtonbackgroundColor forState:UIControlStateNormal];
            [but setTitle:@"阅读并同意" forState:UIControlStateNormal];
            [view addSubview:but];
        }
            break;
        case 1:
            
            break;
            
    
        default:
            break;
    }
}

#pragma mark 实现方法
-(void)nextStep
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)disappearView
{
    [_addTapView removeFromSuperview];

}
-(void)click
{
    XHJAddressBook *_addBook=[XHJAddressBook new];
    NSArray *array=[_addBook getAllPerson];
    DLog(@"%@",array);
    [_addTapView removeFromSuperview];

}
#pragma mark 懒加载 
-(UIView*)addTapView
{
    if(_addTapView==nil)
    {
        _addTapView                                         = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        _addTapView.backgroundColor                         = [UIColor grayColor];
        _addTapView.userInteractionEnabled                  = YES;
//        _addTapView.alpha                                   = 0.8;
    }
    return _addTapView;
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
