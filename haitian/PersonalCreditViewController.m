//
//  PersonalCreditViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "PersonalCreditViewController.h"
#import "YLSOPickerView.h"
@interface PersonalCreditViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonalCreditViewController
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
    
    arr=@[@"文化程度",@"有无信用卡",@"两年内信用记录",@"负债情况",@"有无成功贷款记录",@"是否有使实名淘宝账号",@"贷款用途"];
    NSArray *arr1=@[@"大专以下",@"大专",@"本科",@"研究生及以上"];
    NSArray *arr2=@[@"有",@"没有"];
    NSArray *arr3=@[@"无信用记录",@"信用记录良好",@"少量逾期",@"征信较差"];
    NSArray *arr4=@[@"有",@"没有"];
    NSArray *arr5=@[@"有",@"没有"];
    NSArray *arr6=@[@"有",@"没有"];
    NSArray *arr7=@[@"购车贷款",@"购房贷款",@"网购贷款",@"过桥短期资金",@"装修贷款",@"教育培训贷款",@"旅游贷款",@"股票配资贷款",@"三农贷款",@"其他"];
    array=@[arr1,arr2,arr3,arr4,arr5,arr6,arr7];
    dic=[NSMutableDictionary dictionary];
    for (int i=0; i<arr.count; i++) {
        [dic setObject:array[i] forKey:arr[i]];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:arr[i] object:nil];

    }

    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
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
    YLSOPickerView *picker = [[YLSOPickerView alloc]init];
    picker.array=[array objectAtIndex:textField.tag-1000];
    picker.title=[arr objectAtIndex:textField.tag-1000];
 
    
    [picker show];
    return NO;
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
