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
#import "LoginViewController.h"
#import "WebVC.h"
#define SectionHeight 90
@interface LoanClickViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSMutableArray*productArray;
@end

@implementation LoanClickViewController

{
    UITableView *tab;
    UIImageView *imageView;
    UIView * backgroundView;
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
    
    NSArray *array=@[@"及时雨-社保贷",@"及时雨-公积金贷",@"及时雨-保单贷",@"及时雨-供房贷",@"及时雨-税金贷",@"及时雨-学信贷"];
    
    self.productArray=nil;
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer   serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERE,filter]  parameters:dic2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        if ([dic[@"code"] isEqualToString:@"0000"]) {
            [backgroundView removeFromSuperview];
            NSArray *arr=dic[@"data"];
            for (int i=0; i<arr.count; i++) {
                NSDictionary *diction=arr[i];
                HomeProductModel *pro=[[HomeProductModel alloc]init];
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
                    pro.smeta=@"icon";
                    
                    int location=i%array.count;
                    pro.post_title=array[location];
                }
                else
                {
                 
                    pro.smeta=diction[@"img"];
                    pro.post_title=diction[@"pro_name"];
                }

                pro.link=diction[@"pro_link"];
                pro.edufanwei=diction[@"edufanwei"];
                pro.qixianfanwei=diction[@"qixianfanwei"];
                pro.shenqingtiaojian=diction[@"tiaojian"];
                pro.zuikuaifangkuan=diction[@"zuikuaifangkuan"];
                
                pro.post_hits=diction[@"post_hits"];
                pro.feilv=diction[@"feilv"];
                pro.productID=diction[@"id"];
                pro.post_excerpt=diction[@"post_excerpt"];
                pro.hits=diction[@"hits"];
                pro.api_type=diction[@"api_type"];
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
            if ([UtilTools isBlankArray:self.productArray]) {
               imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
                imageView.image=[UIImage imageNamed:@"blankImage"];
                [self.view addSubview:imageView];
            }
            [tab reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self LoadFailed];
    }];
    
    
    
}
-(void)LoadFailed
{
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:backgroundView];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    image.backgroundColor=[UIColor redColor];
    image.image=[UIImage imageNamed:@"LoadFailedPage"];
    
    
    [backgroundView addSubview:image];
    
    UIImageView *refreshImageView=[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH/2-30)*Context.autoSizeScaleX, 350*Context.autoSizeScaleY, 65*Context.autoSizeScaleX, 65*Context.autoSizeScaleY)];
    refreshImageView.image=[UIImage imageNamed:@"RefreshButton"];
    refreshImageView.userInteractionEnabled=YES;
    [backgroundView addSubview:refreshImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh)];
    [refreshImageView addGestureRecognizer:tap];
    
}
-(void)refresh{
    [self loadData];
    
}

-(void)loadTableView
{
    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.tableFooterView=[UIView new];
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
{
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"])
    {

        HomeProductModel *product=(HomeProductModel *)self.productArray[indexPath.row];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                           product.productID,@"id",
                           Context.currentUser.uid,@"uid",
                           
                           nil];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@&m=product&a=hits",SERVERE];
        [manager GET:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
            
            
        } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
            
        }];
        
        if ([product.api_type isEqualToString:@"1"]) {
            WebVC *vc = [[WebVC alloc] init];
            [vc setNavTitle:product.post_title];
            [vc loadFromURLStr:product.link];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if ([product.api_type isEqualToString:@"2"]) {
            
        }
        
        else if ([product.api_type isEqualToString:@"3"]) {
            LoanDetailsViewController *load=[[LoanDetailsViewController alloc]init];
            load.hidesBottomBarWhenPushed=YES;
            
            load.product=product;
            [self.navigationController pushViewController:load animated:YES];        }
        
        
    }
    else
    {
        LoginViewController *login=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        
    }

   
    
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
