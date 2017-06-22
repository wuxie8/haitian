//
//  BasicInformationViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "BasicInformationViewController.h"
#import "YLSOPickerView.h"

@interface BasicInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UIView *footView;
@end

@implementation BasicInformationViewController
{
    NSArray *arr;
    NSArray *array;
    NSMutableDictionary *dic;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"基本信息认证";
    arr=@[@"本人姓名",@"本人身份证号码",@"申请金额",@"贷款申请期限",@"可接受最高还款额度",@"教育程度",@"现单位是否缴纳社保",@"车辆情况",@"职业类别"];
    NSArray *arr1=[NSArray array];
    NSArray *arr2=[NSArray array];
    NSArray *arr3=@[@"500",@"600",@"700",@"800",@"900",@"1000"];
    NSArray *arr4=@[@"7天",@"15天",@"一个月",@"3个月"];
    NSArray *arr5=[NSArray array];
    NSArray *arr6=@[@"大专以下",@"大专",@"本科",@"研究生及以上"];
    NSArray *arr7=@[@"缴纳本地社保",@"未缴纳社保"];
    NSArray *arr8=@[@"无车",@"本人名下有车，无贷款",@"本人名下有车,有按揭贷款",@"本人名下有车,但已经抵押",@"其他"];
    NSArray *arr9=@[@"企业主",@"个体工商户",@"上班人群",@"学生",@"无固定职业"];
    array=@[arr1,arr2,arr3,arr4,arr5,arr6,arr7,arr8,arr9];
    dic=[NSMutableDictionary dictionary];
    for (int i=0; i<arr.count; i++) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:arr[i] object:nil];
        
    }
    
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-40)];
    tab.delegate=self;
    tab.dataSource=self;
    [self.view addSubview:tab];
    [self.view addSubview:self.footView];
    // Do any additional setup after loading the view.
}
-(UIView *)footView
{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-40-64, WIDTH, 40)];
        UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40 )];
        [but setTitle:@"提交" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
      
        //        but.enabled=NO;
        but.backgroundColor=[UIColor redColor];
        [_footView addSubview:but];
    }
    return _footView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=arr[indexPath.row];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-300, 0, 250, cell.frame.size.height)];
    textField.textAlignment=NSTextAlignmentRight;
    textField.placeholder=@"请选择";
    textField.delegate=self;
    textField.tag=1000+indexPath.row;
    [cell.contentView addSubview:textField];
    
    return cell;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    switch (textField.tag-1000) {
        case 2:
             case 3:
             case 5:
             case 6:
             case 7:
             case 8:
            
        {
            YLSOPickerView *picker = [[YLSOPickerView alloc]init];
            picker.array=[array objectAtIndex:textField.tag-1000];
            picker.title=[arr objectAtIndex:textField.tag-1000];
            
            
            [picker show];
            return NO;

        }
            break;
            
        default:
            break;
    }
    return YES;
   }
-(void)getValue:(NSNotification *)notification
{
    
    
    UITextField *text=[self.view viewWithTag:1000+[arr indexOfObject:notification.name]];
    text.text=notification.object;
    //    [self.dic setObject:notification.object forKey:@"10"];
    
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
