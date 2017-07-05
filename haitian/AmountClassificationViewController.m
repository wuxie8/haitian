//
//  AmountClassificationViewController.m
//  jishi
//
//  Created by Admin on 2017/3/29.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AmountClassificationViewController.h"
#import "AmountTableViewCell.h"
#import "LoanClickViewController.h"
@interface AmountClassificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AmountClassificationViewController
{
    NSMutableArray *arr;
    NSMutableArray *array;
      NSMutableArray *amountarray;
    NSMutableArray *describearray;
    NSMutableArray *idarray;

    UITableView *tab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"极速贷款";
    self.view.backgroundColor=AppPageColor;
//   arr=@[@"speed",@"PopularLoan",@"StudentLoan"];
//     array=@[@"极速微额贷款",@"热门极速贷",@"学生贷"];
//     amountarray=@[@"2000元以下",@"2000-10000元",@"1万-10万"];
//    describearray=@[@"有手机服务密码就能贷 \n微额快速，闪电放款",@"有手机服务密码就能贷 \n 1分钟申请，10分钟放款",@"放款快，学生的最爱 \n额度高，利率低，如你所想"];
    [self getList];
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.backgroundColor=AppPageColor;
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
-(void)getList
{
    arr=[NSMutableArray array];
    array=[NSMutableArray array];
    amountarray=[NSMutableArray array];
    describearray=[NSMutableArray array];
    idarray=[NSMutableArray array];
    [[NetWorkManager sharedManager]postJSON:@"http://app.jishiyu11.cn/index.php?g=app&m=product&a=product_type" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
            NSArray *arr1=responseObject[@"data"];
            for (NSDictionary *dic in arr1) {
                [arr addObject:dic[@"icon"]];
                [array addObject:dic[@"property_name"]];

                [amountarray addObject:dic[@"money"]];

                [describearray addObject:dic[@"description"]];
                [idarray addObject:dic[@"property_id"]];
                
            }
            [tab reloadData];
        }
        else
        {}
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];

}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 120;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   AmountTableViewCell *cell=[[AmountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
      cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,arr[indexPath.row]]];
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    result = [UIImage imageWithData:data];
    
    [cell.image setImage:result];
//    e.image=[UIImage imageNamed:arr[indexPath.row]];
    cell.titleLabel.text=array[indexPath.row];
    cell.post_hits_Label.text=amountarray[indexPath.row];
    cell.feliv_Label.text=describearray[indexPath.row];
    cell.backgroundColor=AppPageColor;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    LoanClickViewController *loanclick=[[LoanClickViewController alloc]init];
    loanclick.location=idarray[indexPath.row];
    [self.navigationController pushViewController:loanclick animated:YES];
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
