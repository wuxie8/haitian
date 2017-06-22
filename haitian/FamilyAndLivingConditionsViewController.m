//
//  FamilyAndLivingConditionsViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "FamilyAndLivingConditionsViewController.h"
#import "YLSOPickerView.h"
#import "LZCityPickerController.h"
static NSString *const family = @"婚姻情况";
@interface FamilyAndLivingConditionsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FamilyAndLivingConditionsViewController
{
    NSArray *arr;
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
    
    arr=@[@"婚姻情况",@"所在城市",@"居住详细地址",@"户籍所在地"];
    [self getList];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:family object:nil];

    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(void)getList
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=family_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"marriage_status"]]) {
                UITextField *text=[self.view viewWithTag:1000];
                text.text=dictionary[@"marriage_status"];
            }
            if (![UtilTools isBlankString:dictionary[@"city"]]) {
                UITextField *text=[self.view viewWithTag:1001];
                text.text=dictionary[@"city"];
            }
            if (![UtilTools isBlankString:dictionary[@"address"]]) {
                UITextField *text=[self.view viewWithTag:1002];
                text.text=dictionary[@"address"];
            }
            if (![UtilTools isBlankString:dictionary[@"hj_address"]]) {
                UITextField *text=[self.view viewWithTag:1003];
                text.text=dictionary[@"hj_address"];
            }
            //            if (![UtilTools isBlankString:dictionary[@"industry"]]) {
            //                UITextField *text=[self.view viewWithTag:1004];
            //                text.text=dictionary[@"industry"];
            //            }
            //            if (![UtilTools isBlankString:dictionary[@"charter_date"]]) {
            //                UITextField *text=[self.view viewWithTag:1005];
            //                text.text=dictionary[@"charter_date"];
            //            }
            //            if (![UtilTools isBlankString:dictionary[@"operation_year"]]) {
            //                UITextField *text=[self.view viewWithTag:1006];
            //                text.text=dictionary[@"operation_year"];
            //            }
            //            if (![UtilTools isBlankString:dictionary[@"private"]]) {
            //                UITextField *text=[self.view viewWithTag:1007];
            //                text.text=dictionary[@"private"];
            //            }
            //            if (![UtilTools isBlankString:dictionary[@"public"]]) {
            //                UITextField *text=[self.view viewWithTag:1008];
            //                text.text=dictionary[@"public"];
            //            }
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
    NSArray *arr1=@[@"已婚",@"未婚",@"离异"];

    [self.view endEditing:YES];
    if (textField.tag-1000==0)        {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
            picker.array=arr1;
            picker.title=family;
            
            
            [picker show];
            return NO;
    }
    else{
    
        {
            
            [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
                UITextField *text=[self.view viewWithTag:textField.tag];
                text.text=address;
                
                
                
            }];
            
            return NO;}
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
                        [(UITextField *) [self.view viewWithTag:1000] text],@"marriage_status",
                        [(UITextField *) [self.view viewWithTag:1001] text],@"city",
                        [(UITextField *) [self.view viewWithTag:1002] text],@"address",
                        [(UITextField *) [self.view viewWithTag:1003] text],@"hj_address",
                        
                        nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=family_add",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
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
