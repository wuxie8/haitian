//
//  CarProductionViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "CarProductionViewController.h"
#import "YLSOPickerView.h"
#import "LZCityPickerController.h"

@interface CarProductionViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CarProductionViewController
{
    NSArray *arr;
    NSArray *array;
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
    
    arr=@[@"名下车产",@"新车市价",@"使用年限",@"目前该车是否存在按揭",@"目前该车是否抵押"];
    NSArray *arr1=@[@"无车产",@"有产车有抵押",@"有产车无抵押"];
    NSArray *arr2=[NSArray array];
    NSArray *arr3=@[@"0-6个月",@"1年",@"2年",@"3年",@"3-5年",@"5年以上"];
    NSArray *arr4=@[@"有",@"无"];
    NSArray *arr5=@[@"有",@"无"];
    for (int i=0; i<arr.count; i++) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:arr[i] object:nil];
        
    }
    array=@[arr1,arr2,arr3,arr4,arr5];
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
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=car_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"car"]]) {
                UITextField *text=[self.view viewWithTag:1000];
                text.text=dictionary[@"car"];
            }
            if (![UtilTools isBlankString:dictionary[@"car_price"]]) {
                UITextField *text=[self.view viewWithTag:1001];
                text.text=dictionary[@"car_price"];
            }
            if (![UtilTools isBlankString:dictionary[@"use_time"]]) {
                UITextField *text=[self.view viewWithTag:1002];
                text.text=dictionary[@"use_time"];
            }
            if (![UtilTools isBlankString:dictionary[@"installment"]]) {
                UITextField *text=[self.view viewWithTag:1003];
                text.text=dictionary[@"installment"];
            }
            if (![UtilTools isBlankString:dictionary[@"installment"]]) {
                UITextField *text=[self.view viewWithTag:1004];
                text.text=dictionary[@"installment"];
            }
            if (![UtilTools isBlankString:dictionary[@"mortgage"]]) {
                UITextField *text=[self.view viewWithTag:1005];
                text.text=dictionary[@"mortgage"];
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
    switch (textField.tag-1000) {
        case 0:
        case 2:
        case 4:
         case 3:
        case 5:
            
        {  YLSOPickerView *picker = [[YLSOPickerView alloc]init];
            picker.array=[array objectAtIndex:textField.tag-1000];
            picker.title=[arr objectAtIndex:textField.tag-1000];
            
            
            [picker show];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
            //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
            tapGestureRecognizer.cancelsTouchesInView = YES;
            //将触摸事件添加到当前view
            [picker addGestureRecognizer:tapGestureRecognizer];
            return NO;}
                   
        default:
            break;
    }
    return YES;
}
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    YLSOPickerView *pickView=(YLSOPickerView *)tap.view;
    [pickView quit];
    
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
                        [(UITextField *) [self.view viewWithTag:1000] text],@"car",
                        [(UITextField *) [self.view viewWithTag:1001] text],@"car_price",
                        [(UITextField *) [self.view viewWithTag:1002] text],@"use_time",
                        [(UITextField *) [self.view viewWithTag:1003] text],@"installment",
                        [(UITextField *) [self.view viewWithTag:1004] text],@"mortgage",
                        nil];
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=car_add",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
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
