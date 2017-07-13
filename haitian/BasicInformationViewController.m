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

@end

@implementation BasicInformationViewController
{
    NSArray *arr;
    NSArray *array;
    NSMutableDictionary *dic;
    NSDictionary *diction;
    UITableView *tab;
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
    
    
    NSArray *arr3=[self.product.edufanwei containsString:@"-"]?[NSArray array]:[self.product.edufanwei componentsSeparatedByString:@","];
    NSArray *arr4=[self.product.qixianfanwei containsString:@"-"]?[NSArray array]:[self.product.qixianfanwei componentsSeparatedByString:@","];
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
    [self getList];
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-40)];
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
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=base_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[responseObject[@"data"] objectForKey:@"data"];
            diction=[array1 firstObject];
            
            if (![UtilTools isBlankString:diction[@"name"]]) {
                UITextField *text=[self.view viewWithTag:1000];
                text.text=diction[@"name"];
            }
            if (![UtilTools isBlankString:diction[@"idcard"]]) {
                UITextField *text=[self.view viewWithTag:1001];
                
                text.text=diction[@"idcard"];
            }
            if (![UtilTools isBlankString:diction[@"money"]]) {
                UITextField *text=[self.view viewWithTag:1002];
                text.text=diction[@"money"];
            }
            if (![UtilTools isBlankString:diction[@"deadline"]]) {
                UITextField *text=[self.view viewWithTag:1003];
                text.text=diction[@"deadline"];
            }
            if (![UtilTools isBlankString:diction[@"limit"]]) {
                UITextField *text=[self.view viewWithTag:1004];
                text.text=diction[@"limit"];
            }
            if (![UtilTools isBlankString:diction[@"edu"]]) {
                UITextField *text=[self.view viewWithTag:1005];
                text.text=diction[@"edu"];
            }
            if (![UtilTools isBlankString:diction[@"insurance"]]) {
                UITextField *text=[self.view viewWithTag:1006];
                text.text=diction[@"insurance"];
            }
            if (![UtilTools isBlankString:diction[@"car_status"]]) {
                UITextField *text=[self.view viewWithTag:1007];
                text.text=diction[@"car_status"];
            }
            if (![UtilTools isBlankString:diction[@"profession"]]) {
                UITextField *text=[self.view viewWithTag:1008];
                text.text=diction[@"profession"];
            }
            
            
            //            [tab reloadData];
        }
        else
        {}
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];
    
}
-(void)complete
{
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        [(UITextField *) [self.view viewWithTag:1000] text],@"name",
                        [(UITextField *) [self.view viewWithTag:1001] text],@"idcard",
                        [(UITextField *) [self.view viewWithTag:1002] text],@"money",
                        [(UITextField *) [self.view viewWithTag:1003] text],@"deadline",
                        [(UITextField *) [self.view viewWithTag:1004] text],@"limit",
                        [(UITextField *) [self.view viewWithTag:1005] text],@"edu",
                        [(UITextField *) [self.view viewWithTag:1006] text],@"insurance",
                        [(UITextField *) [self.view viewWithTag:1007] text],@"car_status",
                        [(UITextField *) [self.view viewWithTag:1008] text],@"profession",
                        nil];
    
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=base_add",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"上传成功"];
            if (self.clickBlock) {
                self.clickBlock();
            }
            Context.currentUser.base_auth=YES;
            [NSKeyedArchiver archiveRootObject:Context.currentUser toFile:DOCUMENT_FOLDER(@"loginedUser")];
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
    if (indexPath.row==1) {
        textField.keyboardType=UIKeyboardTypeNumberPad;

    }
    if (indexPath.row==2) {
        if ([self.product.edufanwei containsString:@"-"]) {
            textField.placeholder=self.product.edufanwei;
            
        }
        else
        {
            textField.placeholder=@"请选择";
            
        }
        textField.keyboardType=UIKeyboardTypeNumberPad;

    }
    if (indexPath.row==3) {
        if ([self.product.edufanwei containsString:@"-"]) {
            textField.placeholder=self.product.qixianfanwei;
            UILabel *unitLabel1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame)-20, 0, 20, cell.frame.size.height)];
            unitLabel1.text=[self.product.fv_unit isEqualToString:@"1"]?@"天":@"月";
            //            if ([self.product.post_title isEqualToString:@"平安i贷"]) {
            //                unitLabel1.text=@"月";
            //            }
            unitLabel1.textAlignment=NSTextAlignmentRight;
            unitLabel1.textColor=[UIColor grayColor];
            [textField setRightView:unitLabel1];
            [textField setRightViewMode:UITextFieldViewModeAlways];
            [cell.contentView addSubview:textField];
            textField.keyboardType=UIKeyboardTypeNumberPad;

            
        }
        else
        {
            textField.placeholder=@"请选择";
            
        }
        
    }
    textField.delegate=self;
    textField.tag=1000+indexPath.row;
    [cell.contentView addSubview:textField];
    //    if (![UtilTools isBlankString:diction[@"name"]]) {
    //        textField.text=diction[@"name"];
    //    }
    
    
    return cell;
}
#pragma mark UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
        if (textField.tag==1002) {
            //字条串是否包含有某字符串
            if ([self.product.edufanwei rangeOfString:@"-"].location == NSNotFound) {
                NSArray *edufanweiArr=   [self.product.edufanwei   componentsSeparatedByString:@","];
                if (![edufanweiArr containsObject:textField.text]) {
                    [MessageAlertView  showErrorMessage:@"请输入正确金额"];
                    textField.text=[NSString stringWithFormat:@"%@",[edufanweiArr lastObject]];
                }
                
            } else {
                NSArray *edufanweiArray = [self.product.edufanwei componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
                if ([textField.text intValue]<[edufanweiArray[0]intValue]) {
                    [MessageAlertView showErrorMessage:@"不能小于最小额度"];
                    textField.text=[NSString stringWithFormat:@"%@",[edufanweiArray firstObject]];
    
                }
                if ([textField.text intValue]>[edufanweiArray[1] intValue]) {
                    [MessageAlertView showErrorMessage:@"不能大于最大额度"];
                    textField.text=[NSString stringWithFormat:@"%@",[edufanweiArray lastObject]];
    
    
                }else
                {
                    
    
                }
    
    
            }
        }
        else if (textField.tag==1003)
        {
            //字条串是否包含有某字符串
            if ([self.product.qixianfanwei rangeOfString:@"-"].location == NSNotFound) {
    
                NSArray *edufanweiArr=   [self.product.edufanwei   componentsSeparatedByString:@","];
                if (![edufanweiArr containsObject:textField.text]) {
                    [MessageAlertView  showErrorMessage:@"请输入正确期限"];
//                    textField.text=[NSString stringWithFormat:@"%d",qixian];
    
                }
                else
                {
//                    qixian=[textField.text intValue];
//                    UILabel *label=[self.view viewWithTag:1001];
//                    if (qixian) {
//                        float feilv=edu/qixian+edu*[self.product.feilv floatValue]/100;
//    
//                        label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
//                    }
    
    
                }
    
            } else {
                NSArray *qixianfanweiArray = [self.product.qixianfanwei componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
                if ([textField.text intValue]<[qixianfanweiArray[0]intValue]) {
                    [MessageAlertView showErrorMessage:@"不能小于最小期限"];
                    textField.text=[NSString stringWithFormat:@"%@",[qixianfanweiArray firstObject]];
    
                }
                if ([textField.text intValue]>[qixianfanweiArray[1]intValue]) {
                    [MessageAlertView showErrorMessage:@"不能大于最大期限"];
                    textField.text=[NSString stringWithFormat:@"%@",[qixianfanweiArray lastObject]];
    
                }
                else
                {
//                    qixian=[textField.text intValue];
//                    UILabel *label=[self.view viewWithTag:1001];
//                    if (qixian) {
//                        float feilv=edu/qixian+edu*[self.product.feilv floatValue]/100;
//                        
//                        label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
//                    }
                    
                    
                    
                }
                
            }
        }
        
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [self.view endEditing:YES];
    switch (textField.tag-1000) {
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
        case 2:
        {
            if ([self.product.edufanwei containsString:@"-"]) {
                return YES;
            }
            else{
                YLSOPickerView *picker = [[YLSOPickerView alloc]init];
                picker.array=[array objectAtIndex:textField.tag-1000];
                picker.title=[arr objectAtIndex:textField.tag-1000];
                
                
                [picker show];
                return NO;
            }
        }
        case 3:
        {
            if ([self.product.edufanwei containsString:@"-"]) {
                return YES;
            }
            else{
                YLSOPickerView *picker = [[YLSOPickerView alloc]init];
                picker.array=[array objectAtIndex:textField.tag-1000];
                picker.title=[arr objectAtIndex:textField.tag-1000];
                
                
                [picker show];
                return NO;
            }
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
