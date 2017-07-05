//
//  LoanClickViewController.m
//  jishi
//
//  Created by Admin on 2017/3/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "LoanClickViewController.h"
#import "HomeProductModel.h"
#import "LoanClassification.h"
#import "LoanDetailsViewController.h"
#define SectionHeight 90
@interface LoanClickViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSMutableArray*productArray;
@end

@implementation LoanClickViewController

{
    UITableView *tab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
    self.title=@"极速微贷";
    
    [self loadData];
    
}
-(void)loadData
{
    
   
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:
                     
                        self.location,@"type",
                        nil];
    
    NSArray *array=@[@"小胖-社保贷",@"小胖-公积金贷",@"小胖-保单贷",@"小胖-供房贷",@"小胖-税金贷",@"小胖-学信贷"];
    
    self.productArray=nil;
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer   serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERE,filter]  parameters:dic2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        if ([dic[@"code"] isEqualToString:@"0000"]) {
            NSArray *arr=dic[@"data"];
            for (int i=0; i<arr.count; i++) {
                NSDictionary *diction=arr[i];
                HomeProductModel *pro=[[HomeProductModel alloc]init];
                
//                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
//                    pro.smeta=@"icon";
//                    
//                    int location=i%array.count;
//                    pro.post_title=array[location];
//                }
//                else
//                {
//                    NSString *jsonString=diction[@"smeta"];
//                    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                    NSError *err;
//                    NSDictionary *imagedic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                             options:NSJSONReadingMutableContainers
//                                                                               error:&err];
                    pro.smeta=diction[@"img"];
                    pro.post_title=diction[@"pro_name"];
//                }
                DLog(@"%@",pro.smeta);

                pro.link=diction[@"pro_link"];
                pro.edufanwei=diction[@"edufanwei"];
                pro.qixianfanwei=diction[@"qixianfanwei"];
                pro.shenqingtiaojian=diction[@"tiaojian"];
                pro.zuikuaifangkuan=diction[@"zuikuaifangkuan"];
                
                pro.post_hits=diction[@"post_hits"];
                pro.feilv=diction[@"feilv"];
                pro.productID=diction[@"id"];
                pro.post_excerpt=diction[@"post_excerpt"];
                
                pro.fv_unit=diction[@"fv_unit"];
                NSArray *tags=diction[@"tags"];
                NSMutableArray *tagsArray=[NSMutableArray array];
                for (NSDictionary *dic in tags) {
                    [tagsArray addObject:dic[@"tag_name"]];
                }
                pro.tagsArray=tagsArray;
                pro.qx_unit=diction[@"qx_unit"];
                [self.productArray addObject:pro];
                
            }
            
            [tab reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}
-(void)loadTableView
{
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    tab.delegate=self;
    tab.dataSource=self;
    [self.view addSubview:tab];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return SectionHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *cell=@"cell";
    HomeProductModel *pro=[self.productArray objectAtIndex:indexPath.row];
    LoanClassification *loancell=[tableView dequeueReusableCellWithIdentifier:cell];
    
    if (!loancell) {
        loancell=[[LoanClassification alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        loancell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    [loancell setProduct:pro];
    return loancell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   HomeProductModel *pro=[self.productArray objectAtIndex:indexPath.row];
    LoanDetailsViewController *load=[[LoanDetailsViewController alloc]init];
    load.hidesBottomBarWhenPushed=YES;
    
    load.product=pro;
    [self.navigationController pushViewController:load animated:YES];
    
}
-(NSMutableArray *)productArray
{
    if (!_productArray) {
        _productArray=[NSMutableArray array];
    }
    return _productArray;
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