//
//  NewRemindViewController.m
//  haitian
//
//  Created by Admin on 2017/5/15.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "NewRemindViewController.h"
#import "YLSOPickerView.h"
#import "HcdDateTimePickerView.h"
#define RemianType @"请选择类型"
#define RepeatType @"请选择重复方式"

#define RemianTime @"请选择提醒时间"

@interface NewRemindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UIView*footView;
@end

@implementation NewRemindViewController
{
    NSArray *array;
    NSArray *placeArray;
    UITextView *_textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新建提醒";
    NSArray *sectionArr1=@[@"类型",@"姓名",@"金额"];
    NSArray *sectionArr2=@[@"还款日",@"重复",@"提醒"];
    NSArray *placesectionArr1=@[self.remindTitle,@"请输入姓名",@"请输入金额"];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString  *string = [[NSString alloc]init];
    string = [dateFormatter stringFromDate:date];
    NSArray *placesectionArr2=@[string,@"每月",@"提前30分钟"];

    placeArray=@[placesectionArr1,placesectionArr2];
    array=@[sectionArr1,sectionArr2];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:RemianType object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:RepeatType object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:RemianTime object:nil];

    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.tableFooterView=self.footView;
    [self.view addSubview:tab];
    
    // Do any additional setup after loading the view.
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0 , 0 , WIDTH, 40)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    label.text=@"添加提醒";
    [view addSubview:label];
    view.backgroundColor=BaseColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;

    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0 , 0 , WIDTH, 20)];
    view.backgroundColor=BaseColor;
    return view;
}
-(UIView *)footView
{
    if (_footView==nil) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.3*HEIGHT)];
        _footView.backgroundColor=BaseColor;
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 100)];
        _textView.text=@"备注...";
        _textView.delegate=self;
        _textView.font=[UIFont systemFontOfSize:15];
        _textView.scrollEnabled=YES;
        _textView.backgroundColor=[UIColor whiteColor];
        [_footView addSubview:_textView];
        
        UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(20 , CGRectGetMaxY(_textView.frame)+10, WIDTH-40, 50)];
        but.backgroundColor=AppButtonbackgroundColor;
        but.layer.masksToBounds=YES;
        but.layer.cornerRadius=10;
        [but setTitle:@"保存" forState:UIControlStateNormal];
        [_footView addSubview:but];
    }
    
    return _footView;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"备注..."]) {
        textView.text = @"";
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([UtilTools isBlankString:textView.text]) {
        textView.text = @"备注...";

    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[array objectAtIndex:(section)] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer=@"addressCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenfer];
    }
    
    cell.textLabel.text=[[array objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-300, 0, 280, cell.frame.size.height)];
    textField.textAlignment=NSTextAlignmentRight;
    textField.placeholder=[[placeArray objectAtIndex:(indexPath.section)] objectAtIndex:indexPath.row];
    textField.delegate=self;
    textField.tag=1000+[[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
    [cell.contentView addSubview:textField];
    
      return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==1000) {
        if (![self.remindTitle isEqualToString:@"自定义"]) {
            return NO;
        }
        
    }
    else if (textField.tag==1010) {
        HcdDateTimePickerView* dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDatetimeMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:0]];
        dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
            UITextField *text=[self.view viewWithTag:1010];
            text.text=datetimeStr;
        };
        [self.view addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
        return NO;
    }
    else if (textField.tag==1011) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array = @[@"只提醒一次",@"每周",@"每两周",@"每月",@"每半年"];
        picker.title = RepeatType;
        
        [picker show];
        return NO;
        
    }
    else if (textField.tag==1012) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array = @[@"还款发生时",@"提前30分钟",@"提起1小时",@"提前1天",@"提前2天"];
        picker.title = RemianTime;
        [picker show];
        return NO;
        
    }
    return YES;
}
-(void)getValue:(NSNotification *)notification
{
    if ([notification.name isEqualToString:RepeatType]) {
        UITextField *text=[self.view viewWithTag:1011];
        text.text=notification.object;
    }
    else if([notification.name isEqualToString:RemianTime])
    {
        UITextField *text=[self.view viewWithTag:1012];
        text.text=notification.object;

    }
        
    
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
