//
//  LoadDetailViewController.m
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "LoadDetailViewController.h"
#import "WebVC.h"
#import "BasicInformationViewController.h"
#import "CreditSesameViewController.h"
#import "IdVerificationViewController.h"
#import "OtherInformationAuthenticationViewController.h"
#import "CreditSesameViewController.h"
#define margen 30

@interface LoadDetailViewController ()<UITableViewDelegate,UITableViewDataSource>



@property(strong, nonatomic)UIView *headView;

@property(strong, nonatomic)UIView*footView;
@property(strong, nonatomic)UIImageView*headImageView;
@end

@implementation LoadDetailViewController

{
    int edu;
    int qixian;
    NSArray *textArray;
    NSMutableArray *mutableArray1;
    NSMutableArray *mutableArray2;
    UITableView *tab ;
    NSArray * jsonObject2;
    NSArray *imageArray;
}
//-(UIView *)footView
//{
//    if (_footView==nil) {
//        _footView=[[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-40-64, WIDTH, 40)];
//        UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40 )];
//        [but setTitle:@"提交" forState:UIControlStateNormal];
//        [but addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
//        
//        //        but.enabled=NO;
//        but.backgroundColor=[UIColor redColor];
//        [_footView addSubview:but];
//    }
//    return _footView;
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"贷款详情";
    self.view.backgroundColor=AppPageColor;
    textArray=@[@"基本信息认证",@"手机运营商",@"芝麻信用",@"身份证",@"其他信息认证"];
    imageArray=@[@"BasicInformationAboutTheCertification",@"Operator",@"Credit_Sesame",@"IdCertification",@"OtherInformationAuthentication"];
    mutableArray1=[NSMutableArray array];
    
    [self getList];
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50)];
    tab.delegate=self;
    tab.tableHeaderView=self.headView;
    tab.dataSource=self;
    [self.view addSubview:tab];
//    [self.view addSubview:self.footView];
       // Do any additional setup after loading the view.
}
-(void)getList
{
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:
                       Context.currentUser.uid,@"uid",
                       self.product.id,@"id",
                      
                       nil];
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=product&a=postDetail",SERVERE] parameters:dic1 success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSDictionary *dic=responseObject[@"data"];
            NSData*data=    [dic[@"data_id"] dataUsingEncoding:NSASCIIStringEncoding];
            id jsonObject1 = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
            NSArray *arr1=jsonObject1;
            for (NSString *string in arr1) {
                DLog(@"%@",[textArray objectAtIndex:[string integerValue]]);
                [mutableArray1 addObject:[textArray objectAtIndex:[string integerValue]-1]];
            }
            [mutableArray1 addObject:@"其他信息认证"];
            NSData*jsondata=    [dic[@"other_id"] dataUsingEncoding:NSASCIIStringEncoding];
            jsonObject2 = [NSJSONSerialization JSONObjectWithData:jsondata
                                                            options:NSJSONReadingAllowFragments
                                                              error:nil];
          
            [tab reloadData];

        }
        else
        {}
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"认证资料";
    label.textColor=[UIColor blackColor];
    [view addSubview:label];
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mutableArray1.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.imageView setImage:[UIImage imageNamed:imageArray[indexPath.row]]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=[mutableArray1 objectAtIndex:indexPath.row];
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 5, 80, cell.frame.size.height-10)];
    [but setTitle:@"去认证" forState:UIControlStateNormal];
    
    [cell.contentView addSubview:but];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[mutableArray1 objectAtIndex:indexPath.row]isEqualToString:@"基本信息认证"]) {
         [self.navigationController pushViewController:[BasicInformationViewController new] animated:YES];
    }
    else if ([[mutableArray1 objectAtIndex:indexPath.row]isEqualToString:@"手机运营商"])
    {
      [self.navigationController pushViewController:[CreditSesameViewController new] animated:YES];
    
    }
    else if ([[mutableArray1 objectAtIndex:indexPath.row]isEqualToString:@"芝麻信用"])
    {
        [self.navigationController pushViewController:[CreditSesameViewController new] animated:YES];
        
    }
    else if ([[mutableArray1 objectAtIndex:indexPath.row]isEqualToString:@"身份证"])
    {
         [self.navigationController pushViewController:[IdVerificationViewController new] animated:YES];
        
    }
    else if ([[mutableArray1 objectAtIndex:indexPath.row]isEqualToString:@"其他信息认证"])
    {
        OtherInformationAuthenticationViewController *other=[[OtherInformationAuthenticationViewController alloc]init];
        other.dataArray=jsonObject2;
        other.product=self.product;
        [self.navigationController pushViewController:other animated:YES];
        
    }



}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
-(void)click
{
    
//    if ([self.product.post_title isEqualToString:@"现金巴士"]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                           Context.currentUser.username,@"mobile",
                           [NSString stringWithFormat:@"%d",edu],@"amount",
                           [NSString stringWithFormat:@"%d",qixian],@"loandays",
                           nil];
        NSString *urlStr = [NSString stringWithFormat:@"http://app.jishiyu11.cn:81/api/cashbus/url"];
        [manager POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
            NSDictionary *imagedic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
            NSString *link=[[imagedic objectForKey:@"data"]objectForKey:@"url"];
            
            WebVC *vc = [[WebVC alloc] init];
//            [vc setNavTitle:self.product.post_title];
            [vc loadFromURLStr:link];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:NO];
        } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
            DLog(@"%@",error);
            
        } ];
//    }
//    else
//    {
//        WebVC *vc = [[WebVC alloc] init];
//        [vc setNavTitle:self.product.post_title];
//        [vc loadFromURLStr:self.product.link];
//        vc.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:vc animated:NO];
//    }

    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
//    if ([self.product.post_title isEqualToString:@"平安i贷"]&&textField.tag==501) {
//        
//        return NO;
//        
//    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    if (textField.tag==500) {
//        //字条串是否包含有某字符串
//        if ([self.product.edufanwei rangeOfString:@"-"].location == NSNotFound) {
//            NSArray *arr=   [self.product.edufanwei   componentsSeparatedByString:@","];
//            if (![arr containsObject:textField.text]) {
//                [MessageAlertView  showErrorMessage:@"请输入正确金额"];
//                textField.text=[NSString stringWithFormat:@"%d",edu];
//            }
//            else
//            {
//                edu=[textField.text intValue];
//                UILabel *label=[self.view viewWithTag:1001];
//                if (qixian) {
//                    float feilv=edu/qixian+edu*[self.product.feilv floatValue]/100;
//                    
//                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
//                }
//                
//                
//            }
//        } else {
//            NSArray *array = [self.product.edufanwei componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
//            if ([textField.text intValue]<[array[0]intValue]) {
//                [MessageAlertView showErrorMessage:@"不能小于最小额度"];
//                textField.text=[NSString stringWithFormat:@"%d",edu];
//                
//            }
//            if ([textField.text intValue]>[array[1]intValue]) {
//                [MessageAlertView showErrorMessage:@"不能大于最大额度"];
//                textField.text=[NSString stringWithFormat:@"%d",edu];
//                
//                
//            }else
//            {
//                edu=[textField.text intValue];
//                UILabel *label=[self.view viewWithTag:1001];
//                if (qixian) {
//                    float feilv=edu/qixian+edu*[self.product.feilv floatValue]/100;
//                    
//                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
//                }
//                
//                
//            }
//            
//            
//        }
//    }
//    else
//    {
//        //字条串是否包含有某字符串
//        if ([self.product.qixianfanwei rangeOfString:@"-"].location == NSNotFound) {
//            
//            NSArray *arr=   [self.product.edufanwei   componentsSeparatedByString:@","];
//            if (![arr containsObject:textField.text]) {
//                [MessageAlertView  showErrorMessage:@"请输入正确期限"];
//                textField.text=[NSString stringWithFormat:@"%d",qixian];
//                
//            }
//            else
//            {
//                qixian=[textField.text intValue];
//                UILabel *label=[self.view viewWithTag:1001];
//                if (qixian) {
//                    float feilv=edu/qixian+edu*[self.product.feilv floatValue]/100;
//                    
//                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
//                }
//                
//                
//            }
//            
//        } else {
//            NSArray *array = [self.product.qixianfanwei componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
//            if ([textField.text intValue]<[array[0]intValue]) {
//                [MessageAlertView showErrorMessage:@"不能小于最小期限"];
//                textField.text=[NSString stringWithFormat:@"%d",qixian];
//                
//            }
//            if ([textField.text intValue]>[array[1]intValue]) {
//                [MessageAlertView showErrorMessage:@"不能大于最大期限"];
//                textField.text=[NSString stringWithFormat:@"%d",qixian];
//                
//            }
//            else
//            {
//                qixian=[textField.text intValue];
//                UILabel *label=[self.view viewWithTag:1001];
//                if (qixian) {
//                    float feilv=edu/qixian+edu*[self.product.feilv floatValue]/100;
//                    
//                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
//                }
//                
//                
//                
//            }
//            
//        }
//    }
//    
}
-(UIView *)headView
{
    if (!_headView) {
        
        _headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 250)];
        UIView *yellowView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 100)];
        yellowView.backgroundColor=kColorFromRGBHex(0xfffcf5);
        [_headView addSubview:yellowView];
        
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(margen, 20, WIDTH/2-margen*2, margen)];
        textField.delegate=self;
        textField.tag=500;
        textField.text=@"1000";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        NSString *maxString;
        if ([self.product.edufanwei rangeOfString:@"-"].location == NSNotFound) {
            NSArray *arr=   [self.product.edufanwei   componentsSeparatedByString:@","];
            maxString=[arr lastObject];
        }
        else
        {
            NSRange range=[self.product.edufanwei rangeOfString:@"-"];
            maxString=[self.product.edufanwei substringFromIndex:(range.location+1)];
        }
        
        
        textField.text=maxString;
        edu=[maxString intValue];
        UILabel *unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame)-30, 0, 30, 20)];
        unitLabel.text=@"元";
        unitLabel.textColor=[UIColor grayColor];
        [textField setRightView:unitLabel];
        [textField setRightViewMode:UITextFieldViewModeAlways];
        [yellowView addSubview:textField];
        
        UITextField *textField1=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH/2+margen, 20, WIDTH/2-margen*2, 30)];
        textField1.delegate=self;
        textField1.tag=501;
        NSString *maxString1;
        if ([self.product.qixianfanwei rangeOfString:@"-"].location == NSNotFound) {
            NSArray *arr=   [self.product.qixianfanwei   componentsSeparatedByString:@","];
            maxString1=[arr lastObject];
        }
        else
        {
            NSRange range1=[self.product.qixianfanwei rangeOfString:@"-"];
            maxString1=[self.product.qixianfanwei substringFromIndex:(range1.location+1)];
        }
        maxString1=[maxString1 substringToIndex:maxString1.length-1];
        textField1.text=@"30";
        qixian=[maxString1 intValue];
        //    if ([self.product.post_title isEqualToString:@"平安i贷"]) {
        //        qixian=20;
        //        textField1.text=@"20";
        //
        //    }
        textField1.borderStyle = UITextBorderStyleRoundedRect;
        textField1.keyboardType = UIKeyboardTypeNumberPad;
        UILabel *unitLabel1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField1.frame)-30, 0, 30, 20)];
        unitLabel1.text=[self.product.fv_unit isEqualToString:@"1"]?@"天":@"月";
        //            if ([self.product.post_title isEqualToString:@"平安i贷"]) {
        //                unitLabel1.text=@"月";
        //            }
        unitLabel1.textColor=[UIColor grayColor];
        [textField1 setRightView:unitLabel1];
        [textField1 setRightViewMode:UITextFieldViewModeAlways];
        [yellowView addSubview:textField1];
        
        
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(margen, CGRectGetMaxY(textField.frame)+20, WIDTH/2-margen*2, 30)];
        label3.text=[NSString stringWithFormat:@"额度范围：%@元",self.product.edufanwei];
        //        label3.text=@"50000";
        label3.adjustsFontSizeToFitWidth=YES;
        [yellowView addSubview:label3];
        
        
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(margen+WIDTH/2, CGRectGetMaxY(textField.frame)+20, WIDTH/2-margen*2, 30)];
        label4.text=[NSString stringWithFormat:@"期限范围：%@%@",self.product.qixianfanwei,[self.product.fv_unit isEqualToString:@"1"]?@"天":@"月"];
        //        label4.text=@"7-30";
        label4.adjustsFontSizeToFitWidth=YES;
        [yellowView addSubview:label4];
        
        UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yellowView.frame), WIDTH, 100)];
        view4.backgroundColor=[UIColor whiteColor];
        [_headView addSubview:view4];
        for (int i=0; i<3; i++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3*i, 30, WIDTH/3, 20)];
            label.textAlignment=NSTextAlignmentCenter;
            //        label.textColor=AppBlue;
            label.tag=1000+i;
            [view4 addSubview:label];
            
            UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3*i, CGRectGetMaxY(label.frame)+10, WIDTH/3, 20)];
            label1.text=@"500-1000元";
            label1.tag=100+i;
            label1.textAlignment=NSTextAlignmentCenter;
            
            [view4 addSubview:label1];
            UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(WIDTH/3*i, 10, 1, 80)];
            backgroundView.backgroundColor=[UIColor lightGrayColor];
            [view4 addSubview:backgroundView];
            switch (i) {
                case 0:
                {
                    label.text=self.product.feilv;
                    //                                    label.text=@"0.04";
                    label1.text=[self.product.fv_unit isEqualToString:@"1"]?@"参考日利率":@"参考月利率";
                    //                    label1.text=@"参考月利率";
                    
                }
                    break;
                case 1:
                {
                    
                    if([self.product.feilv containsString:@"-"])
                    {
                        NSArray *array = [self.product.feilv componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
                        
                        float feilv1=edu/qixian+edu*[[array firstObject] floatValue]/100;
                        
                        float feilv2=edu/qixian+edu*[[array lastObject] floatValue]/100;
                        
                        label.text=[NSString stringWithFormat:@"%d-%d",(int)feilv1,(int)feilv2];
                    }
                    else{
                        
                        float feilv=edu/qixian+edu*[self.product.feilv floatValue]/100;
                        
                        label.text=[NSString stringWithFormat:@"%d",(int)feilv];
                    }
                    
                    
                    label1.text=[self.product.fv_unit isEqualToString:@"1"]?@"每日还款":@"每月还款";
                    
                }
                    break;
                case 2:
                {
                    label.text=self.product.zuikuaifangkuan;
                    label1.text=@"最快放款时间";
                    
                }
                    break;
                default:
                    break;
            }
        }
        UIView *view5=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view4.frame), WIDTH, 40)];
        view5.layer.borderWidth=1;
        view5.layer.borderColor=[UIColor grayColor].CGColor;
        view5.backgroundColor=[UIColor whiteColor];
        [_headView addSubview:view5];
        
        UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, WIDTH, 30)];
        label5.text=[self.product.fv_unit isEqualToString:@"1"]?@"按日计息，随借随还":@"参考月利率";
        label5.textAlignment=NSTextAlignmentCenter;
        [view5 addSubview:label5];
        view5.layer.borderWidth=1;
        
        //        UIView *view6=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view5.frame)+20, WIDTH, HEIGHT-CGRectGetMaxY(view5.frame)-20)];
        //        view6.backgroundColor=[UIColor whiteColor];
        //        [_headView addSubview:view6];
        //        UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 30)];
        //        label6.textAlignment=NSTextAlignmentCenter;
        //        label6.text=@"申请条件";
        //        //    label6.textColor=AppBlue;
        //        [view6 addSubview:label6];
        //        UILabel *_feliv_Label=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label6.frame)+20, WIDTH-40, 70)];
        //        //    [_feliv_Label setText:self.product.shenqingtiaojian];
        //        [_feliv_Label setTextColor:[UIColor grayColor]];
        //        _feliv_Label.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
        //        _feliv_Label.numberOfLines=0;
        //        _feliv_Label.textAlignment=NSTextAlignmentLeft;
        //        _feliv_Label.font=[UIFont systemFontOfSize:16];
        //        [view6 addSubview:_feliv_Label];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
            
            UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(10, HEIGHT-64-50, WIDTH-20, 40)];
            //        but.backgroundColor=AppBlue;
            
            [but setTitle:@"马上申请" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
            [_headView addSubview:but];
        }
        
    }
    return _headView;
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

