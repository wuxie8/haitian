//
//  RealEstateViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "RealEstateViewController.h"
#import "YLSOPickerView.h"
#import "LZCityPickerController.h"
@interface RealEstateViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RealEstateViewController
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
    [self getList];
    arr=@[@"名下房产",@"房产所在地",@"房产类型",@"房产当前市价",@"目前该房是否存在按揭",@"目前该房是否抵押"];
    NSArray *arr1=@[@"无房产",@"商品房",@"商住连用",@"经济适用房",@"宅基地",@"军产房",@"商铺",@"写字楼",@"其他"];
    NSArray *arr2=[NSArray array];
    NSArray *arr3=@[@"商品房",@"商住连用",@"经济适用房",@"宅基地",@"军产房",@"商铺",@"写字楼",@"其他"];
    NSArray *arr4=[NSArray array];
    NSArray *arr5=@[@"有",@"无"];
    NSArray *arr6=@[@"有",@"无"];
    array=@[arr1,arr2,arr3,arr4,arr5,arr6];
    for (int i=0; i<arr.count; i++) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:arr[i] object:nil];
        
    }
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
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=house_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"house"]]) {
                UITextField *text=[self.view viewWithTag:1000];
                text.text=dictionary[@"house"];
            }
            if (![UtilTools isBlankString:dictionary[@"house_address"]]) {
                UITextField *text=[self.view viewWithTag:1001];
                text.text=dictionary[@"house_address"];
            }
            if (![UtilTools isBlankString:dictionary[@"house_type"]]) {
                UITextField *text=[self.view viewWithTag:1002];
                text.text=dictionary[@"house_type"];
            }
            if (![UtilTools isBlankString:dictionary[@"house_price"]]) {
                UITextField *text=[self.view viewWithTag:1003];
                text.text=dictionary[@"house_price"];
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
      
        case 5:
      
        {  YLSOPickerView *picker = [[YLSOPickerView alloc]init];
            picker.array=[array objectAtIndex:textField.tag-1000];
            picker.title=[arr objectAtIndex:textField.tag-1000];
            
            
            [picker show];
            return NO;}
        case 1:
        {
            
            [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
                UITextField *text=[self.view viewWithTag:1001];
                text.text=address;
                
            }];
            
            return NO;}
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
-(void)complete
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        [(UITextField *) [self.view viewWithTag:1000] text],@"house",
                        [(UITextField *) [self.view viewWithTag:1001] text],@"house_address",
                        [(UITextField *) [self.view viewWithTag:1002] text],@"house_type",
                        [(UITextField *) [self.view viewWithTag:1003] text],@"house_price",
                        [(UITextField *) [self.view viewWithTag:1004] text],@"installment",
                        [(UITextField *) [self.view viewWithTag:1005] text],@"mortgage",
                        
                        nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=house_add",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"上传成功"];
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
