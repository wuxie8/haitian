//
//  FamilyInformationViewController.m
//  haitian
//
//  Created by Admin on 2017/5/2.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "FamilyInformationViewController.h"
#import "YLSOPickerView.h"
#import "LZCityPickerController.h"
#import "ContactInformationViewController.h"
#define professional @"请选择婚姻状况"
#define schoolRecord  @"请选择学历"
@interface FamilyInformationViewController ()<UITableViewDelegate,UITableViewDataSource>



@property(strong, nonatomic)UIView*headView;

@property(strong, nonatomic)UIView*footView;

@property(strong, nonatomic)NSMutableDictionary*dic;
@end

@implementation FamilyInformationViewController
{
    NSArray *arr;
    NSArray *placeArr;
    NSArray *_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"职业信息";
    
    
    arr=@[@"婚姻状况",@"家庭住址",@"家庭详细地址"];
    placeArr=@[@"请选择",@"请选择",@"请输入家庭住址"];
    _dataArray=@[@"已婚",@"未婚"];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
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
    cell.textLabel.text=arr[indexPath.row];
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-300, 0, 280, cell.frame.size.height)];
    textField.textAlignment=NSTextAlignmentRight;
    textField.placeholder=placeArr[indexPath.row];
    textField.delegate=self;
    textField.tag=1000+[[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
    [cell.contentView addSubview:textField];
    
    return cell;
}
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    YLSOPickerView *pickView=(YLSOPickerView *)tap.view;
    [pickView quit];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==1000) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array = _dataArray;
        picker.title = professional;
        [picker show];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = YES;
        //将触摸事件添加到当前view
        [picker addGestureRecognizer:tapGestureRecognizer];
        return NO;
        
    }
    else if (textField.tag==1001) {
        [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
            UITextField *text=[self.view viewWithTag:1001];
            text.text=address;
            [self.dic setObject:address forKey:@"1001"];
            
        }];
        
        return NO;
        
    }
    else if (textField.tag==1013) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array = @[@"高中及中专以下",@"大学专科",@"大学本科",@"研究生及以上"];
        picker.title = schoolRecord;
        [picker show];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = YES;
        //将触摸事件添加到当前view
        [picker addGestureRecognizer:tapGestureRecognizer];
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
    [self.navigationController pushViewController:[ContactInformationViewController new] animated:YES];

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
