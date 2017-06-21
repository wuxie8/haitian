//
//  PersonalDataViewController.m
//  haitian
//
//  Created by Admin on 2017/5/31.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalCreditViewController.h"
#import "EnterpriseManagementSituationViewController.h"
#import "FamilyAndLivingConditionsViewController.h"
#import "OtherContactsViewController.h"
#import "RealEstateViewController.h"
#import "CarProductionViewController.h"
#import "UploadDocumentsViewController.h"
@interface PersonalDataViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation PersonalDataViewController
{
    UITableView *tab;
    NSArray *arr;
    NSArray *placeArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人资料";
    
    
    
   NSArray *arr1=@[@"手机号码",@"姓名",@"身份证号码"];
    placeArray=@[@"",@"请输入姓名",@"请输入身份证号码"];
    NSArray *arr2=@[@"个人资信",@"企业经营情况",@"家庭及居住情况",@"其他联系人",@"房产",@"车产",@"运营商验证",@"网购信用",@"证件上传",@"我的银行卡"];
    arr=@[arr1,arr2];
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0 , 0, WIDTH, HEIGHT-50)];
    tab.delegate=self;
    tab.dataSource=self;
    [self getList];
    tab.backgroundColor=AppPageColor;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = backItem;
}
-(void)getList
{
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:
                        
                        Context.currentUser.uid,@"uid",
                        nil];
    
    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@/userinfo/detail",SERVEREURL] parameters:dic1 success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *diction=[dic[@"data"] objectForKey:@"data"];
            UITextField *text1=    [self.view viewWithTag:1001];
            [text1 setText:[diction objectForKey:@"realname"]];
            UITextField *text2=    [self.view viewWithTag:1002];
            [text2 setText:[diction objectForKey:@"idcard"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];


}
-(void)complete
{
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:

                      Context.currentUser.uid,@"uid",
                       [(UITextField *)[self.view viewWithTag:1001] text],@"realname",
                       [(UITextField *)[self.view viewWithTag:1002] text],@"idcard",

                       nil];

    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@/userinfo/add",SERVEREURL] parameters:dic1 success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            [MessageAlertView showSuccessMessage:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];


}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arr objectAtIndex:section]count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer=@"addressCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenfer];
    }
    
    cell.textLabel.text=[[arr objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row];
    if (indexPath.section==0) {
        UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-300, 0, 280, cell.frame.size.height)];
        textField.textAlignment=NSTextAlignmentRight;
        textField.placeholder=[placeArray  objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            textField.text=Context.currentUser.username;
        }
        textField.delegate=self;
        textField.tag=1000+indexPath.row;
        [cell.contentView addSubview:textField];
    }
    else{
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;

    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:[PersonalCreditViewController new] animated:YES];

                break;
            case 1:
                [self.navigationController pushViewController:[EnterpriseManagementSituationViewController new] animated:YES];
                
                break;
            case 2:
                [self.navigationController pushViewController:[FamilyAndLivingConditionsViewController new] animated:YES];
                
                break;
            case 3:
                [self.navigationController pushViewController:[OtherContactsViewController new] animated:YES];
                
                break;
            case 4:
                [self.navigationController pushViewController:[RealEstateViewController new] animated:YES];
                
                break;
            case 5:
                [self.navigationController pushViewController:[CarProductionViewController new] animated:YES];
                
                break;
            case 8:
                [self.navigationController pushViewController:[UploadDocumentsViewController new] animated:YES];
                
                break;
                
            default:
                break;
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
