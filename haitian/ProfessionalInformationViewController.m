//
//  ProfessionalInformationViewController.m
//  haitian
//
//  Created by Admin on 2017/4/28.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "ProfessionalInformationViewController.h"
#import "YLSOPickerView.h"
#import "LZCityPickerController.h"
#import "FamilyInformationViewController.h"
@interface ProfessionalInformationViewController ()<UITableViewDelegate,UITableViewDataSource>


#define professional @"请选择职业"
#define schoolRecord  @"请选择学历"
@property(strong, nonatomic)UIView*headView;

@property(strong, nonatomic)UIView*footView;

@property(strong, nonatomic)NSMutableDictionary*dic;
@end

@implementation ProfessionalInformationViewController
{
    NSArray *arr;
    NSArray *placeArr;
    NSArray *_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"职业信息";
    NSArray *arr1=@[@"您的职业"];
    NSArray *arr2=@[@"单位名称",@"所在地区",@"详细地址",@"学历信息"];
    arr=@[arr1,arr2];
    
    NSArray *arr3=@[@"请选择职业"];
    NSArray *arr4=@[@"请输入单位名称",@"请输入省市区",@"请输入单位详细地址",@"请选择"];
    placeArr=@[arr3,arr4];
    _dataArray=@[@"上班族",@"企业主",@"个体户",@"学生党",@"其他"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:professional object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getschoolRecordValue:) name:schoolRecord object:nil];

    
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.backgroundColor=AppPageColor;
    tab.tableFooterView=self.footView;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(UIView *)footView
{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
       
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, WIDTH-20, 60)];
        [button setImage:[UIImage imageNamed:@"NextButton"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ImmediatelyBinding) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius =  20;
        //            //将多余的部分切掉
        button.layer.masksToBounds = YES;
        [_footView addSubview:button];
    }
    return _footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arr objectAtIndex:(section)] count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-100, 5, 200, 30)];
        lab.text=@"请填写您的真实资料以便通过审核";
        lab.adjustsFontSizeToFitWidth=YES;
        [view addSubview:lab];
        return view;

    }
    return nil;
   }
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
cell.textLabel.text=[[arr objectAtIndex:(indexPath.section)] objectAtIndex:indexPath.row];
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-300, 0, 280, cell.frame.size.height)];
        textField.textAlignment=NSTextAlignmentRight;
        textField.placeholder=[[placeArr objectAtIndex:(indexPath.section)] objectAtIndex:indexPath.row];
        textField.delegate=self;
        textField.tag=1000+[[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
        [cell.contentView addSubview:textField];
  
    return cell;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==1000) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array = _dataArray;
        picker.title = professional;
        [picker show];
        return NO;
        
    }
    else if (textField.tag==1011) {
        [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
            UITextField *text=[self.view viewWithTag:1011];
            text.text=address;
            [self.dic setObject:address forKey:@"11"];

    
            
        }];

        return NO;
        
    }
    else if (textField.tag==1013) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array = @[@"高中及中专以下",@"大学专科",@"大学本科",@"研究生及以上"];
        picker.title = schoolRecord;
        [picker show];
        return NO;
        
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUInteger tag=textField.tag;
    [self.dic setObject:textField.text forKey:[NSString stringWithFormat:@"%lu",(unsigned long)tag]];
}


#pragma mark 实现方法

-(void)ImmediatelyBinding
{
    [self.navigationController pushViewController:[FamilyInformationViewController new] animated:YES];

}
-(void)getValue:(NSNotification *)notification
{
    UITextField *textField=(UITextField *)[self.view viewWithTag:1000];
    textField.text=notification.object;
    [self.dic setObject:notification.object forKey:@"1000"];
    
}
-(void)getschoolRecordValue:(NSNotification *)notification
{
    UITextField *textField=(UITextField *)[self.view viewWithTag:1013];
    textField.text=notification.object;
    [self.dic setObject:notification.object forKey:@"1013"];

}
#pragma mark 懒加载
-(NSMutableDictionary *)dic
{
    if (_dic==nil) {
        _dic=[NSMutableDictionary dictionary];
    }
    return _dic;
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
