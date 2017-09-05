//
//  ProductDetailViewController.m
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "WebVC.h"
#import "UIImageView+AFNetworking.h"
#define interval 10
#define controlsHeight 30


@interface ProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UIView *productDetailsTbbHeadView;

@property(strong, nonatomic)UIView *footView;

@end

@implementation ProductDetailViewController
{
    NSArray *sectionArray;
    NSArray *imageArray;
    NSArray *titleArray;
    
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"认证资料";
    sectionArray=@[@"申请条件",@"借款审核细节",@"新手指导"];
    titleArray=@[@"贷款类型",@"面向人群",@"审核方式",@"到账方式",@"实际到账",@"还款途径",@"提前还款",@"逾期还款",@"能否提额",@"所属平台"];

    imageArray=@[kColorFromRGBHex(0x4ed19d),kColorFromRGBHex(0x2591f3),[UIColor redColor]];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboard)];
    [self.view addGestureRecognizer:tap];
    UITableView *productDetailsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-210-50-64) style:UITableViewStyleGrouped];
    productDetailsTableView.delegate=self;
    productDetailsTableView.dataSource=self;
//    productDetailsTableView.tableHeaderView=self.productDetailsTbbHeadView;
    productDetailsTableView.tableFooterView=[UIView new];
    [self.view addSubview:productDetailsTableView];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
        
        [self.view addSubview:self.footView];
    }
    // Do any additional setup after loading the view.
}
-(void)keyboard{
    [self.view endEditing:YES];
}
-(UIView *)productDetailsTbbHeadView
{
    if (!_productDetailsTbbHeadView) {
        _productDetailsTbbHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        _productDetailsTbbHeadView.backgroundColor=[UIColor whiteColor];
        UIImageView *   _image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
        //    _image.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
            [_image setImage:[UIImage imageNamed:self.productModel.smeta]];
            
        }
        else
        {
            [_image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,self.productModel.smeta]]];
        }
        [_productDetailsTbbHeadView addSubview:_image];
        UILabel *   _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+interval, 20, WIDTH-CGRectGetMaxX(_image.frame), 25)];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.text=self.productModel.post_title;
        _titleLabel.font= [UIFont boldSystemFontOfSize:16 ];
        [_productDetailsTbbHeadView addSubview:_titleLabel];
        UILabel *   _detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+interval , CGRectGetMaxY(_titleLabel.frame)+5, WIDTH-CGRectGetMaxX(_image.frame), 20  )];
        _detailLabel.font=[UIFont systemFontOfSize:14];
        [_detailLabel setTextColor:kColorFromRGBHex(0xa3a3a3)];
        //        _detailLabel.text=[NSString stringWithFormat:@"利率%@",self.productModel.feilv];
        _detailLabel.textAlignment=NSTextAlignmentLeft;
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"利率%@",self.productModel.feilv]];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(2, [AttributedStr length]-2)];
        
        _detailLabel.attributedText=AttributedStr;
        
        
        [_productDetailsTbbHeadView addSubview:_detailLabel];
        
        //        UILabel *applicationsLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_detailLabel.frame), WIDTH/2, 30)];
        //        applicationsLabel.text=@"申请金额";
        //        applicationsLabel.font=[UIFont systemFontOfSize:14];
        //        applicationsLabel.textAlignment=NSTextAlignmentCenter;
        //        [_productDetailsTbbHeadView addSubview:applicationsLabel];
        //
        //
        //      UILabel *   _post_hits_Label=[[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(applicationsLabel.frame), WIDTH/2, 20  )];
        //        _post_hits_Label.font=[UIFont systemFontOfSize:14];
        //        _post_hits_Label.text=@"1203568";
        //        [_post_hits_Label setTextColor:[UIColor redColor]];
        //        _post_hits_Label.textAlignment=NSTextAlignmentCenter;
        //
        //
        //        [_productDetailsTbbHeadView addSubview:_post_hits_Label];
        //
        //
        //     UILabel *    _interestrateLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, CGRectGetMaxY(_detailLabel.frame), WIDTH/2, 30)];
        //        _interestrateLabel.font=[UIFont systemFontOfSize:14];
        //
        //        _interestrateLabel.textAlignment=NSTextAlignmentCenter;
        //
        //        [_productDetailsTbbHeadView addSubview:_interestrateLabel];
        //    UILabel *     _feliv_Label=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2 ,CGRectGetMaxY(_interestrateLabel.frame), WIDTH/2, 20)];
        //        [_feliv_Label setTextColor:[UIColor grayColor]];
        //        _feliv_Label.textAlignment=NSTextAlignmentCenter;
        //        _feliv_Label.font=[UIFont systemFontOfSize:14];
        //        [_productDetailsTbbHeadView addSubview:_feliv_Label];
        //
        
    }
    return _productDetailsTbbHeadView;
}
-(UIView *)footView
{
    if (!_footView) {
        _footView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-50-250, WIDTH, 50)];
        UIButton *footBut=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        [footBut setTitle:@"立即申请" forState:0];
        footBut.backgroundColor=kColorFromRGBHex(0x1786e2);
        [footBut addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        
        [_footView addSubview:footBut];
    }
    return _footView;
}
-(void)nextStep
{
    if (self.backblock) {
        self.backblock();
    }
   
    WebVC *vc = [[WebVC alloc] init];
    [vc setNavTitle:self.productModel.post_title];
    [vc loadFromURLStr:self.productModel.link];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:NO];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    backView.backgroundColor=kColorFromRGBHex(0xf3f3f3);
    [view addSubview:backView];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10 , 20, 10, 10)];
    imageview.backgroundColor=imageArray[section];
    [view addSubview:imageview];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10, 20, WIDTH-CGRectGetMaxX(imageview.frame), 10)];
    label.text=[sectionArray objectAtIndex:section];
    label.font=[UIFont boldSystemFontOfSize:18];
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1:
//            return   [UtilTools getTextHeight:self.productModel.shenqingtiaojian hight:WIDTH font:[UIFont systemFontOfSize:18]].height+50;
            return 300;
            break;
        case 2:
            return   100;
            break;
        default:
            return 0;
            break;
    }
    
}
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    //防止重复赋值数据叠加
    for (UILabel * label in cell.contentView.subviews) {
        
        [label removeFromSuperview];
        
    }
    switch (indexPath.section) {
        case 0:
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, WIDTH-30*2, 100)];
            label.text=self.productModel.shenqingtiaojian;
            label.numberOfLines=0;
            [cell.contentView addSubview:label];
        }
            break;
        case 1:
        {
            for (int i=0; i<10; i++) {
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 10+(30+5)*i, WIDTH-30*2, 30)];
                label.text=titleArray[i];
                label.numberOfLines=0;
                [cell.contentView addSubview:label];

            }
                  }
            //
            //            cell.textLabel.text=self.productModel.shenqingtiaojian;
            //            cell.textLabel.numberOfLines=0;
            break;
        case 2:
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, WIDTH-30*2, 90)];
            label.numberOfLines=0;
            label.text=@"sndlkas";

            [cell.contentView addSubview:label];
        }
            break;
        default:
            break;
    }
    return cell;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag==500) {
        //字条串是否包含有某字符串
        if (![self.productModel.edufanwei containsString:@"-"]) {
            NSArray *arr=   [self.productModel.edufanwei   componentsSeparatedByString:@","];
            if (![arr containsObject:textField.text]) {
                [MessageAlertView  showErrorMessage:@"请输入正确金额"];
                textField.text=[NSString stringWithFormat:@"%@",[arr lastObject]];
            }
            else
            {
                //                edu=[textField.text intValue];
                //                UILabel *label=[self.view viewWithTag:1001];
                //                if (qixian) {
                //                    float feilv=edu/qixian+edu*[self.productModel.feilv floatValue]/100;
                //
                //                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
                //                }
                
                
            }
        } else {
            NSArray *array = [self.productModel.edufanwei componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
            if ([textField.text intValue]<[array[0]intValue]) {
                [MessageAlertView showErrorMessage:@"不能小于最小额度"];
                textField.text=[NSString stringWithFormat:@"%@",[array lastObject]];
                
            }
            if ([textField.text intValue]>[array[1]intValue]) {
                [MessageAlertView showErrorMessage:@"不能大于最大额度"];
                textField.text=[NSString stringWithFormat:@"%@",[array lastObject]];
                
                
            }else
            {
                //                edu=[textField.text intValue];
                //                UILabel *label=[self.view viewWithTag:1001];
                //                if (qixian) {
                //                    float feilv=edu/qixian+edu*[self.productModel.feilv floatValue]/100;
                //
                //                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
                //                }
                
                
            }
            
            
        }
    }
    else
    {
        //字条串是否包含有某字符串
        if (![self.productModel.qixianfanwei containsString:@"-"]) {
            
            NSArray *arr=   [self.productModel.qixianfanwei   componentsSeparatedByString:@","];
            if (![arr containsObject:textField.text]) {
                [MessageAlertView  showErrorMessage:@"请输入正确期限"];
                textField.text=[NSString stringWithFormat:@"%@",[arr firstObject]];
                
            }
            else
            {
                //                qixian=[textField.text intValue];
                //                UILabel *label=[self.view viewWithTag:1001];
                //                if (qixian) {
                //                    float feilv=edu/qixian+edu*[self.productModel.feilv floatValue]/100;
                //
                //                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
                //                }
                
                
            }
            
        } else {
            NSArray *array = [self.productModel.qixianfanwei componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
            if ([textField.text intValue]<[array[0]intValue]) {
                [MessageAlertView showErrorMessage:@"不能小于最小期限"];
                textField.text=[NSString stringWithFormat:@"%@",[array firstObject]];
                
            }
            if ([textField.text intValue]>[array[1]intValue]) {
                [MessageAlertView showErrorMessage:@"不能大于最大期限"];
                textField.text=[NSString stringWithFormat:@"%@",[array firstObject]];
                
            }
            else
            {
                //                qixian=[textField.text intValue];
                //                UILabel *label=[self.view viewWithTag:1001];
                //                if (qixian) {
                //                    float feilv=edu/qixian+edu*[self.productModel.feilv floatValue]/100;
                //
                //                    label.text=[NSString stringWithFormat:@"%d",(int)feilv ];
                //                }
                
                
                
            }
            
        }
    }
    
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
