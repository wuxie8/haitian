//
//  EnterpriseManagementSituationViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "EnterpriseManagementSituationViewController.h"
#import "YLSOPickerView.h"
#import "LZCityPickerController.h"

@interface EnterpriseManagementSituationViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EnterpriseManagementSituationViewController
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
    
    arr=@[@"您在企业身份",@"您在企业的股份",@"企业实际经营所在地",@"经营企业类型",@"经营公司所属行业",@"营业执照时间",@"企业经营年限",@"每月对私流水",@"每月对公流水"];
    NSArray *arr1=@[@"法人",@"股东",@"其他"];
    NSArray *arr2=@[@"少于10%",@"10%-20%",@"20%-30%",@"30%-40%",@"40%-50%",@"50%及以上"];
    NSArray *arr3=[NSArray array];
    NSArray *arr4=@[@"政府或事业单位",@"国企央企",@"外资企业",@"上市公司",@"普通民营企业",@"个体工商户"];
    NSArray *arr5=@[@"批发／零售",@"制造业",@"金融／保险／证券",@"住宿／餐饮／旅游",@"商业服务／娱乐／艺术／体育",@"计算机／互联网",@"通讯电子",@"建筑／房地产",@"法律／咨询",@"卫生／教育／社会服务",@"公共事业／社会团体",@"生物／制药",@"广告／媒体",@"其他"];
    NSArray *arr6=@[@"未办理",@"已办理且注册不满6个月",@"已办理且注册不满一年",@"已办理且注册超过一年"];
    NSArray *arr7=@[@"不足半年",@"半年～1年",@"1年～2年",@"2年～3年",@"3年以上"];
    NSArray *arr8=@[@"购车贷款",@"购房贷款",@"网购贷款",@"过桥短期资金",@"装修贷款",@"教育培训贷款",@"旅游贷款",@"股票配资贷款",@"三农贷款",@"其他"];
    array=@[arr1,arr2,arr3,arr4,arr5,arr6,arr7,arr8];
    for (int i=0; i<arr.count; i++) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:arr[i] object:nil];
        
    }
    [self getList];
   
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    
    [self.view addSubview:tab];
   
    // Do any additional setup after loading the view.
}
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    YLSOPickerView *pickView=(YLSOPickerView *)tap.view;
    [pickView quit];

}
-(void)getList
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        nil];
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=company_status_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"company_identity"]]) {
                UITextField *text=[self.view viewWithTag:1000];
                text.text=dictionary[@"company_identity"];
            }
            if (![UtilTools isBlankString:dictionary[@"company_share"]]) {
                UITextField *text=[self.view viewWithTag:1001];
                text.text=dictionary[@"company_share"];
            }
            if (![UtilTools isBlankString:dictionary[@"address"]]) {
                UITextField *text=[self.view viewWithTag:1002];
                text.text=dictionary[@"address"];
            }
            if (![UtilTools isBlankString:dictionary[@"type"]]) {
                UITextField *text=[self.view viewWithTag:1003];
                text.text=dictionary[@"type"];
            }
            if (![UtilTools isBlankString:dictionary[@"industry"]]) {
                UITextField *text=[self.view viewWithTag:1004];
                text.text=dictionary[@"industry"];
            }
            if (![UtilTools isBlankString:dictionary[@"charter_date"]]) {
                UITextField *text=[self.view viewWithTag:1005];
                text.text=dictionary[@"charter_date"];
            }
            if (![UtilTools isBlankString:dictionary[@"operation_year"]]) {
                UITextField *text=[self.view viewWithTag:1006];
                text.text=dictionary[@"operation_year"];
            }
            if (![UtilTools isBlankString:dictionary[@"private"]]) {
                UITextField *text=[self.view viewWithTag:1007];
                text.text=dictionary[@"private"];
            }
            if (![UtilTools isBlankString:dictionary[@"public"]]) {
                UITextField *text=[self.view viewWithTag:1008];
                text.text=dictionary[@"public"];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    switch (textField.tag-1000) {
        case 0:
            case 1:
            case 3:
            case 4:
            case 5:
            case 6:
         
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
            case 2:
        {
            
            [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
                UITextField *text=[self.view viewWithTag:1002];
                text.text=address;

                
                
            }];
            
            return NO;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
-(void)complete
{
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        [(UITextField *) [self.view viewWithTag:1000] text],@"company_identity",
                        [(UITextField *) [self.view viewWithTag:1001] text],@"company_share",
                        [(UITextField *) [self.view viewWithTag:1002] text],@"address",
                        [(UITextField *) [self.view viewWithTag:1003] text],@"type",
                        [(UITextField *) [self.view viewWithTag:1004] text],@"industry",
                        [(UITextField *) [self.view viewWithTag:1005] text],@"charter_date",
                        [(UITextField *) [self.view viewWithTag:1006] text],@"operation_year",
                         [(UITextField *) [self.view viewWithTag:1007] text],@"private",
                         [(UITextField *) [self.view viewWithTag:1008] text],@"public",
                        nil];
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=company_status_add",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
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
-(void)getValue:(NSNotification *)notification
{
    
    
    UITextField *text=[self.view viewWithTag:1000+[arr indexOfObject:notification.name]];
    text.text=notification.object;

    //    [self.dic setObject:notification.object forKey:@"10"];
    
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
