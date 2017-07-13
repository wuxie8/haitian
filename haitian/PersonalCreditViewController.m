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
    [self getList];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(void)getList
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=credit_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"edu"]]) {
                    UITextField *text=[self.view viewWithTag:1000];
                text.text=dictionary[@"edu"];
            }
            if (![UtilTools isBlankString:dictionary[@"creditcard"]]) {
                UITextField *text=[self.view viewWithTag:1001];
                text.text=dictionary[@"creditcard"];
            }
            if (![UtilTools isBlankString:dictionary[@"credit_record"]]) {
                UITextField *text=[self.view viewWithTag:1002];
                text.text=dictionary[@"credit_record"];
            }
            if (![UtilTools isBlankString:dictionary[@"liabilities_status"]]) {
                UITextField *text=[self.view viewWithTag:1003];
                text.text=dictionary[@"liabilities_status"];
            }
            if (![UtilTools isBlankString:dictionary[@"loan_record"]]) {
                UITextField *text=[self.view viewWithTag:1004];
                text.text=dictionary[@"loan_record"];
            }
            if (![UtilTools isBlankString:dictionary[@"taobao_id"]]) {
                UITextField *text=[self.view viewWithTag:1005];
                text.text=dictionary[@"taobao_id"];
            }
            if (![UtilTools isBlankString:dictionary[@"loan_use"]]) {
                UITextField *text=[self.view viewWithTag:1006];
                text.text=dictionary[@"loan_use"];
            }
        }
        else
        {
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
    
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
-(void)complete
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        [(UITextField *) [self.view viewWithTag:1000] text],@"edu",
                        [(UITextField *) [self.view viewWithTag:1001] text],@"creditcard",
                        [(UITextField *) [self.view viewWithTag:1002] text],@"credit_record",
                        [(UITextField *) [self.view viewWithTag:1003] text],@"liabilities_status",
                        [(UITextField *) [self.view viewWithTag:1004] text],@"loan_record",
                        [(UITextField *) [self.view viewWithTag:1005] text],@"taobao_id",
                        [(UITextField *) [self.view viewWithTag:1006] text],@"loan_use",
                        
                        nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=credit_add",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"上传成功"];
            if (self.clickBlock) {
                self.clickBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MessageAlertView showErrorMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
    
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
