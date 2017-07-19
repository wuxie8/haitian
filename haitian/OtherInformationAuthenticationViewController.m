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
    
    arr=@[@"个人邮箱",@"配偶",@"居住地址",@"居住方式",@"公司名称",@"公司地址",@"公司电话",@"紧急联系人A",@"关系A",@"手机号码A",@"紧急联系人B",@"关系B",@"手机号码B",@"紧急联系人C",@"关系C",@"手机号码C",@"紧急联系人D",@"关系D",@"手机号码D",@"紧急联系人E",@"关系E",@"手机号码E"];
  placeArray=@[@"请填写邮箱",@"请输入",@"请填写详细地址",@"请选择",@"请输入公司名称",@"请输入公司地址",@"请输入电话",@"姓名A",@"请选择",@"请输入手机号",@"姓名B",@"请选择",@"请输入手机号",@"姓名C",@"请选择",@"请输入手机号",@"姓名D",@"请选择",@"请输入手机号",@"姓名E",@"请选择",@"请输入手机号"];
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
    [self getList];
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
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=other_info_list",SERVERE] parameters:dic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *array1=[[responseObject objectForKey:@"data"]objectForKey:@"data"];
            NSDictionary *dictionary=[array1 firstObject];
            if (![UtilTools isBlankString:dictionary[@"email"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"个人邮箱"]] ;
                text1.text=dictionary[@"email"];

            }
            if (![UtilTools isBlankString:dictionary[@"mate"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"配偶"]] ;
                text1.text=dictionary[@"mate"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"dwell_address"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住地址"]] ;
                text1.text=dictionary[@"dwell_address"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"dwell_type"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住方式"]] ;
                text1.text=dictionary[@"dwell_type"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"company_name"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司名称"]] ;
                text1.text=dictionary[@"company_name"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"company_addr"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司地址"]] ;
                text1.text=dictionary[@"company_addr"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"user_a"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人A"]] ;
                text1.text=dictionary[@"user_a"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"relation_a"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系A"]] ;
                text1.text=dictionary[@"relation_a"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"mobile_a"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码A"]] ;
                text1.text=dictionary[@"mobile_a"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"user_b"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人B"]] ;
                text1.text=dictionary[@"user_b"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"relation_b"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系B"]] ;
                text1.text=dictionary[@"relation_b"];
                
            }
            if (![UtilTools isBlankString:dictionary[@"mobile_b"]]) {
                UITextField *text1=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码B"]] ;
                text1.text=dictionary[@"mobile_b"];
                
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
- (void)keyboardHide:(UITapGestureRecognizer *)tap
{
    YLSOPickerView *pickView=(YLSOPickerView *)tap.view;
    [pickView quit];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    [self.view endEditing:YES];
    if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"居住方式"]) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array=@[@"有住房，无贷款",@"有住房，有贷款",@"与父母／配偶同住",@"租房同住",@"单位宿舍／用房",@"学生公寓",];
        picker.title=@"居住方式";
        
        
        [picker show];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = YES;
        //将触摸事件添加到当前view
        [picker addGestureRecognizer:tapGestureRecognizer];
        return NO;

    }
    if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"婚姻情况"]) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array=@[@"未婚",@"已婚，有子女",@"已婚，无子女",@"离异",@"丧偶",@"复婚",@"其他"];
        picker.title=@"婚姻情况";
        
        
        [picker show];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = YES;
        //将触摸事件添加到当前view
        [picker addGestureRecognizer:tapGestureRecognizer];
        return NO;
        
    }
   if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"关系A"]) {
       YLSOPickerView *picker = [[YLSOPickerView alloc]init];
       picker.array=@[@"父母",@"配偶",@"兄弟",@"姐妹"];
       picker.title=@"关系A";
       
       
       [picker show];
       UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
       //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
       tapGestureRecognizer.cancelsTouchesInView = YES;
       //将触摸事件添加到当前view
       [picker addGestureRecognizer:tapGestureRecognizer];
       return NO;
       
   }
    if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"关系B"]) {
       YLSOPickerView *picker = [[YLSOPickerView alloc]init];
       picker.array=@[@"父母",@"配偶",@"兄弟",@"姐妹"];
       picker.title=@"关系B";
       
       
       [picker show];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = YES;
        //将触摸事件添加到当前view
        [picker addGestureRecognizer:tapGestureRecognizer];
       return NO;
       
   }
    if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"关系C"]) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array=@[@"父母",@"配偶",@"兄弟",@"姐妹"];
        picker.title=@"关系C";
        
        
        [picker show];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = YES;
        //将触摸事件添加到当前view
        [picker addGestureRecognizer:tapGestureRecognizer];
        return NO;
        
    }
    if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"关系D"]) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array=@[@"父母",@"配偶",@"兄弟",@"姐妹"];
        picker.title=@"关系D";
        
        
        [picker show];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = YES;
        //将触摸事件添加到当前view
        [picker addGestureRecognizer:tapGestureRecognizer];
        return NO;
        
    }
    if ([[dataMutableArray objectAtIndex:textField.tag-1000] isEqualToString:@"关系E"]) {
        YLSOPickerView *picker = [[YLSOPickerView alloc]init];
        picker.array=@[@"父母",@"配偶",@"兄弟",@"姐妹"];
        picker.title=@"关系E";
        
        
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
-(void)getValue:(NSNotification *)notification
{
    UITextField *text=[self.view viewWithTag:1000+[dataMutableArray indexOfObject:notification.name]];
    text.text=notification.object;
    
}
-(void)complete
{

    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                        Context.currentUser.uid,@"uid",
                        self.productID,@"pid",

                        nil];
    NSMutableDictionary * mutDic2 = [[NSMutableDictionary alloc]initWithDictionary:dic2];
    for (NSString *string in dataMutableArray) {
       if ([UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:string]] text]]){
           [MessageAlertView showErrorMessage:[NSString stringWithFormat:@"请填写%@",string]];
           return;
           break;
           
      }
    }

    if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"个人邮箱"]] text]]) {
        if ([UtilTools validateEmail:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"个人邮箱"]] text]]) {
            [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"个人邮箱"]] text] forKey:@"email"];

        }
        else{
            [MessageAlertView showErrorMessage:@"请输入正确的邮箱"];
             return;
        }
    }
    if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"配偶"]] text]])
        
    {
     [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"配偶"]] text] forKey:@"mate"];
    }
   if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住地址"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住地址"]] text] forKey:@"dwell_address"];
    }
    if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住方式"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"居住方式"]] text] forKey:@"dwell_typ"];
    }
     if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司名称"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司名称"]] text] forKey:@"company_name"];
    }
     if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司地址"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司地址"]] text] forKey:@"company_addr"];
    }
     if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司电话"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"公司电话"]] text] forKey:@"company_te"];
    }
    if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人A"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人A"]] text] forKey:@"user_a"];
    }
     if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系A"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系A"]] text] forKey:@"relation_a"];
    }
    if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码A"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码A"]] text] forKey:@"mobile_a"];
    }
     if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人B"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"紧急联系人B"]] text] forKey:@"user_b"];
    }
     if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系B"]] text]])
        
         
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"关系B"]] text] forKey:@"relation_b"];
    }
     if (![UtilTools isBlankString: [(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码B"]] text]])
        
    {
        [mutDic2 setObject:[(UITextField *) [self.view viewWithTag:1000+[dataMutableArray indexOfObject:@"手机号码B"]] text] forKey:@"mobile_b"];
    }
    
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userdetail&a=other_info_add",SERVERE] parameters:mutDic2 success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"上传成功"];
            if (self.clickBlock) {
                self.clickBlock();
            }
            [self.navigationController popViewControllerAnimated:NO];
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
