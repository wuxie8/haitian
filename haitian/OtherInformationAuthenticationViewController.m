//
//  OtherInformationAuthenticationViewController.m
//  haitian
//
//  Created by Admin on 2017/6/22.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "OtherInformationAuthenticationViewController.h"
#import "YLSOPickerView.h"


@interface OtherInformationAuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UIView*headView;
@end

@implementation OtherInformationAuthenticationViewController
{
    NSArray *arr;
    NSArray *array;
     NSArray *placeArray;
    NSMutableArray *dataMutableArray;
    NSMutableArray *placeMutableArray;

    NSMutableDictionary *dic;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backItem;
}
-(UIView *)headView
{
    if (!_headView) {
        _headView=[[UIView alloc ]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *redLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH-40, 30)];
        redLabel.textAlignment=NSTextAlignmentCenter;
        redLabel.text=@"恭喜，您已满足贷款要求。您必须完成补充信息，才能最终放款";
        redLabel.adjustsFontSizeToFitWidth=YES;
        redLabel.textColor=[UIColor redColor];
        [_headView addSubview:redLabel];
    }
    return _headView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr=@[@"个人邮箱",@"配偶",@"居住地址",@"居住方式",@"公司名称",@"公司地址",@"公司电话",@"紧急联系人A",@"关系A",@"手机号码A",@"紧急联系人B",@"关系B",@"手机号码B"];
  placeArray=@[@"请填写邮箱",@"请选择",@"请填写详细地址",@"请选择",@"请输入公司名称",@"请输入公司地址",@"请输入电话",@"姓名A",@"关系A",@"手机号码A",@"姓名B",@"关系B",@"手机号码B"];
    dataMutableArray=[NSMutableArray array];
    placeMutableArray =[NSMutableArray array];
  
    for (int i=0; i<self.dataArray.count; i++) {

      

       [dataMutableArray addObject: [arr objectAtIndex:[self.dataArray[i] integerValue]-1]];
        
        [placeMutableArray addObject:[placeArray objectAtIndex:[self.dataArray[i] integerValue]-1 ]];
    }
    for (int i=0; i<dataMutableArray.count; i++) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getValue:) name:dataMutableArray[i] object:nil];
        
    }
    dic=[NSMutableDictionary dictionary];
//    [self getList];
    UITableView *tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.tableHeaderView=self.headView;
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
    return dataMutableArray.count;
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
    cell.textLabel.text=dataMutableArray[indexPath.row];
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-300, 0, 250, cell.frame.size.height)];
    textField.textAlignment=NSTextAlignmentRight;
    textField.placeholder=placeMutableArray[indexPath.row];
    textField.delegate=self;
    textField.tag=1000+indexPath.row;
    [cell.contentView addSubview:textField];
    
    return cell;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DLog(@"%@",[dataMutableArray objectAtIndex:textField.tag-1000]);

    [self.view endEditing:YES];
    if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"居住方式"]) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array=@[@"有住房，无贷款",@"有住房，有贷款",@"与父母／配偶同住",@"租房同住",@"单位宿舍／用房",@"学生公寓",];
        picker.title=@"居住方式";
        
        
        [picker show];
        return NO;

    }
   else if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"婚姻情况"]) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array=@[@"未婚",@"已婚，有子女",@"已婚，无子女",@"离异",@"丧偶",@"复婚",@"其他"];
        picker.title=@"婚姻情况";
        
        
        [picker show];
        return NO;
        
    }
   else if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"关系A"]) {
       YLSOPickerView *picker = [[YLSOPickerView alloc]init];
       picker.array=@[@"父母",@"配偶",@"兄弟",@"姐妹"];
       picker.title=@"关系";
       
       
       [picker show];
       return NO;
       
   }
   else if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"关系B"]) {
       YLSOPickerView *picker = [[YLSOPickerView alloc]init];
       picker.array=@[@"父母",@"配偶",@"兄弟",@"姐妹"];
       picker.title=@"关系";
       
       
       [picker show];
       return NO;
       
   }

    return YES;
   }
-(void)getValue:(NSNotification *)notification
{
    UITextField *text=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:notification.name]];
    text.text=notification.object;
    
}
-(void)complete
{

    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        self.product.id,@"pid",

                        nil];
    NSMutableDictionary * mutDic2 = [[NSMutableDictionary alloc]initWithDictionary:dic2];
    

    if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"个人邮箱"]] text]]) {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"个人邮箱"]] text] forKey:@"email"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"配偶"]] text]])
        
    {
     [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"配偶"]] text] forKey:@"mate"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住地址"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住地址"]] text] forKey:@"dwell_address"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住方式"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住方式"]] text] forKey:@"dwell_typ"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司名称"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司名称"]] text] forKey:@"company_name"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司地址"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司地址"]] text] forKey:@"company_addr"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司电话"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司电话"]] text] forKey:@"company_te"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人A"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人A"]] text] forKey:@"user_a"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系A"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系A"]] text] forKey:@"relation_a"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码A"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码A"]] text] forKey:@"mobile_a"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人B"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人B"]] text] forKey:@"user_b"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系B"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系B"]] text] forKey:@"relation_b"];
    }
    else if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码B"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码B"]] text] forKey:@"mobile_b"];
    }
    
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=other_info_add",SERVERE] parameters:mutDic2 success:^(NSURLSessionDataTask *task, id responseObject) {
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