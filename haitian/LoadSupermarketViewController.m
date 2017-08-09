//
//  LoadSupermarketViewController.m
//  haitian
//
//  Created by Admin on 2017/4/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "LoadSupermarketViewController.h"
#import "ASValueTrackingSlider.h"
#import "LoadSupermarketCollectionViewCell.h"
#import "WSPageView.h"
#import "WSIndexBanner.h"
#import "BannerModel.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "UIImageView+AFNetworking.h"
#import "WebVC.h"
#import <UIKit+AFNetworking.h>
#import <CoreTelephony/CTCarrier.h>
#import "ProductModel.h"
#import "LoadDetailViewController.h"
#import "LoginViewController.h"
#define kMargin 10
#define pageHeight 150
static NSString *const cellId = @"cellId1";
static NSString *const headerId = @"headerId1";
static NSString *const footerId = @"footerId1";
@interface LoadSupermarketViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WSPageViewDelegate,WSPageViewDataSource>

@property (nonatomic, strong)UICollectionView *LoadcollectionView;
@end

@implementation LoadSupermarketViewController

{
    NSArray *arr;
      NSArray *arr1;
     NSArray *arr2;
     NSArray *arr3;
     NSArray *arr4;
    NSMutableArray *bannerMutableArray;
    NSMutableArray *productMutableArray;
    UIView *backgroundView;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getList];
    [self getBannerList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
 self.view.backgroundColor=BaseColor;
  self.title=@"贷款超市";
    arr=@[@"好评推荐",@"极速放款"];
      arr1=@[@"HighPraise",@"FastLoan"];
    NSArray *imageArray=@[@"HamsterBorrow",@"WinCardLoanBorrow",@"pleasantBorrow"];
     NSArray *imageArray1=@[@"lightBorrow",@"FlyingSquirreBorrow"];
    NSArray *titleArray=@[@"仓鼠贷",@"小赢卡贷",@"宜人贷"];
    NSArray *titleArray1=@[@"闪电借款",@"飞鼠贷"];
    NSArray *detailTitleArray=@[@"有身份证可借5000元\n最快三分钟下款",@"借款只需三分钟\n30秒极速放款",@"有手机就能贷\n最快三分钟放款"];
     NSArray *detailTitleArray1=@[@"额度高\n最快三分钟下款",@"有身份证就能贷\n1分钟审核，56秒到账"];
    arr2=@[titleArray,titleArray1];
    arr3=@[detailTitleArray,detailTitleArray1];
    arr4=@[imageArray,imageArray1];
    _LoadcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, pageHeight, WIDTH, HEIGHT-64-44-pageHeight) collectionViewLayout:[UICollectionViewFlowLayout new]];
    [_LoadcollectionView setBackgroundColor:kColorFromRGBHex(0xEBEBEB)];
     _LoadcollectionView.delegate = self;
    _LoadcollectionView.dataSource = self;
    self.LoadcollectionView.alwaysBounceVertical = YES;
    // 注册cell、sectionHeader、sectionFooter
    [_LoadcollectionView registerClass:[LoadSupermarketCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [_LoadcollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_LoadcollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    [self.view addSubview:_LoadcollectionView];
    // Do any additional setup after loading the view.
}
-(void)getList
{
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=product&a=postList",SERVEREURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            [backgroundView removeFromSuperview];
            productMutableArray=nil;
            NSDictionary *dic=(NSDictionary *)responseObject;
            NSDictionary *diction=dic[@"data"];
            NSArray *recommendarr=diction[@"recommend"];
            NSArray *quickarr=diction[@"quick"];
            
            productMutableArray=[NSMutableArray array];
            NSMutableArray *recommendMutableArray=[NSMutableArray array];
            NSMutableArray *quickMutableArray=[NSMutableArray array];
            
            for (NSDictionary *dic1 in recommendarr) {
                ProductListModel *remind=[ProductListModel new];
                [remind setValuesForKeysWithDictionary:dic1];
                [recommendMutableArray addObject:remind];
            }
            for (NSDictionary *dic1 in quickarr) {
                ProductListModel *remind=[ProductListModel new];
                [remind setValuesForKeysWithDictionary:dic1];
                [quickMutableArray addObject:remind];
            }
            productMutableArray =[NSMutableArray arrayWithObjects:recommendMutableArray,quickMutableArray, nil];
            [backgroundView removeFromSuperview];

            [_LoadcollectionView reloadData];
        }
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self LoadFailed];
    }];
    
    
}
-(void)LoadFailed
{
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, pageHeight, WIDTH, HEIGHT-pageHeight-64)];
    [self.view addSubview:backgroundView];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, backgroundView.frame.size.height)];
    image.backgroundColor=[UIColor redColor];
    image.image=[UIImage imageNamed:@"Loadunsuccessful"];
    
    
    [backgroundView addSubview:image];
}
-(void)getBannerList
{
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=banner&a=postList",SERVEREURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSDictionary *diction=dic[@"data"];
        NSArray *array=diction[@"data"];
        bannerMutableArray=[NSMutableArray array];
        for (NSDictionary *dic1 in array) {
            BannerModel *remind=[BannerModel new];
            [remind setValuesForKeysWithDictionary:dic1];
            [bannerMutableArray addObject:remind];
        }
        [self loadBanner];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self loadBanner];

    }];
    


}

-(void)loadBanner
{

    WSPageView *pageView = [[WSPageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,pageHeight)];
    pageView.delegate = self;
    pageView.dataSource = self;
    pageView.minimumPageAlpha = 0.4;   //非当前页的透明比例
    pageView.minimumPageScale = 0.85;  //非当前页的缩放比例
    pageView.orginPageCount = 3; //原始页数
    
    pageView.backgroundColor=[UIColor grayColor];
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageView.frame.size.height - 8 - 10, WIDTH, 8)];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageView.pageControl = pageControl;
    [pageView addSubview:pageControl];
    [pageView stopTimer];
    [self.view addSubview:pageView];

}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(WSPageView *)flowView {
    return CGSizeMake(WIDTH, pageHeight);
}
#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView {
    return  [UtilTools isBlankArray:bannerMutableArray]?1:bannerMutableArray.count;
}

- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0,  WIDTH , pageHeight)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    if ([UtilTools isBlankArray:bannerMutableArray]) {
        [bannerView.mainImageView setImage:[UIImage imageNamed:@"LoadFailed"]];
    }
    else{
      
    BannerModel *banner=[bannerMutableArray objectAtIndex:index];
   NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,banner.img]];
    [bannerView.mainImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"LoadFailed"]];
    }

    return bannerView;
}
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
  
    if (![UtilTools isBlankArray:bannerMutableArray]) {
        BannerModel *banner=[bannerMutableArray objectAtIndex:subIndex];
        WebVC *vc = [[WebVC alloc] init];
        [vc setNavTitle:banner.title];
        [vc loadFromURLStr:banner.img_url];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
   
    
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return productMutableArray.count;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [[productMutableArray objectAtIndex:section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListModel *productList=[[productMutableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    LoadSupermarketCollectionViewCell *cell =(LoadSupermarketCollectionViewCell *) [_LoadcollectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"iconLoading"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,productList.img]];
            UIImage * result;
            NSData * data = [NSData dataWithContentsOfURL:url];
            
            result = [UIImage imageWithData:data];
            dispatch_sync(dispatch_get_main_queue(), ^
                          {
                              [cell.imageView  setImage:result];
                              
                          });
        });
        

        [cell.titleLabel setText:productList.pro_name];
    }
    else{
        NSArray *array=@[@"及时雨-社保贷",@"及时雨-公积金贷",@"及时雨-保单贷",@"及时雨-供房贷",@"及时雨-税金贷",@"及时雨-学信贷"];
        int row=(int)indexPath.row;
        int location=row%array.count;
        [cell.titleLabel setText:array[location]];
        [cell.imageView setImage:[UIImage imageNamed:@"icon"]];
    }
  
    [cell.detailLabel setText:productList.pro_describe];
    return cell;
}
// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * headerView = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
       
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = AppPageColor;
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        image.image=[UIImage imageNamed:arr1[indexPath.section]];
        [headerView addSubview:image];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, 10, 100, 20)];
        lab.text=arr[indexPath.section];
        [headerView addSubview:lab];
        
        }
    
    return headerView;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-kMargin*3)/2, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{        ProductListModel *product=[[productMutableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    LoadDetailViewController *detail=[[LoadDetailViewController alloc]init];
    detail.product=product;
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];

    
    }
    else{
        ProductListModel *product=[[productMutableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                           product.id,@"id",
                           Context.currentUser.uid,@"uid",
                           appNO,@"channel",

                           nil];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@&m=product&a=hits",SERVERE];
        [manager GET:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
            
            
        } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
            
        }];

        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {

        if ([product.api_type isEqualToString:@"1"]) {
            WebVC *vc = [[WebVC alloc] init];
            [vc setNavTitle:product.pro_name];
            [vc loadFromURLStr:product.pro_link];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if ([product.api_type isEqualToString:@"2"]) {
            NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:
                                Context.currentUser.uid,@"uid",
                                product.id,@"id",
                                
                                nil];
            [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=product&a=postDetail",SERVERE] parameters:dic1 success:^(NSURLSessionDataTask *task, id responseObject) {
                
                if ([responseObject[@"code"]isEqualToString:@"0000"]) {
                    NSDictionary *dic=responseObject[@"data"];
                    WebVC *vc = [[WebVC alloc] init];
                    [vc setNavTitle:product.pro_name];
                    [vc loadFromURLStr:dic[@"pro_link"]];
                    vc.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:vc animated:NO];
                    
                }
                else
                {}
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                
                
            }];
  
        }
        
        else if ([product.api_type isEqualToString:@"3"]) {
            LoadDetailViewController *detail=[[LoadDetailViewController alloc]init];
            detail.product=product;
            detail.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:detail animated:YES];
        }

        }
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){WIDTH,44};
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
