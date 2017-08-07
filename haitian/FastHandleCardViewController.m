//
//  FastHandleCardViewController.m
//  haitian
//
//  Created by Admin on 2017/4/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "FastHandleCardViewController.h"
#import "WSPageView.h"
#import "WSIndexBanner.h"
#import "FastHandleCardCollectionViewCell.h"
#import "ProductModel.h"
#import "BannerModel.h"
#import "WebVC.h"
#import "UIImageView+AFNetworking.h"

#define pageHeight 150
#define kMargin 10


static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";
@interface FastHandleCardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WSPageViewDelegate,WSPageViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation FastHandleCardViewController

{
    NSMutableArray *bankMutableArray;
    NSMutableArray *bannerMutableArray;
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

    self.title=@"快速办卡";
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,pageHeight, WIDTH, HEIGHT-64-44-pageHeight) collectionViewLayout:[UICollectionViewFlowLayout new]];
    [_collectionView setBackgroundColor:kColorFromRGBHex(0xEBEBEB)];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    // 注册cell、sectionHeader、sectionFooter
    [_collectionView registerClass:[FastHandleCardCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    [self.view addSubview:_collectionView];
    // Do any additional setup after loading the view.
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
-(void)getBannerList
{
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=banner&a=postList",SERVEREURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *diction=dic[@"data"];
            NSArray *array=diction[@"data"];
            bannerMutableArray=[NSMutableArray array];
            for (NSDictionary *dic1 in array) {
                BannerModel *remind=[BannerModel new];
                [remind setValuesForKeysWithDictionary:dic1];
                [bannerMutableArray addObject:remind];
            }
            [self loadBanner];

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self loadBanner];

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

-(void)getList
{
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=bank&a=postList",SERVEREURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        NSDictionary *diction=dic[@"data"];
        NSArray *arr=diction[@"data"];
        bankMutableArray=[NSMutableArray array];
        for (NSDictionary *dic1 in arr) {
            ProductModel *remind=[ProductModel new];
            [remind setValuesForKeysWithDictionary:dic1];
            [bankMutableArray addObject:remind];
        }
        [backgroundView removeFromSuperview];

        [_collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self LoadFailed];
    }];
    
    
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

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return bankMutableArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {

    ProductModel *pro=[bankMutableArray objectAtIndex:indexPath.row];
    
    WebVC *vc = [[WebVC alloc] init];
    [vc setNavTitle:pro.name];
    [vc loadFromURLStr:pro.link];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:NO];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *pro=[bankMutableArray objectAtIndex:indexPath.row];
    FastHandleCardCollectionViewCell *cell = (FastHandleCardCollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell.bankimageView setImage:[UIImage imageNamed:@"iconLoading"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,pro.icon]];
        UIImage * result;
        NSData * data = [NSData dataWithContentsOfURL:url];
//        http://app.jishiyu11.cn/data/upload/20170628/b287f8c5afd21c491a719ced743d1cf4.jpg
        result = [UIImage imageWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [cell.bankimageView  setImage:result];
                          
                      });
    });
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {

    [cell.titleLabel setText:pro.name];
    }
    else
    {
        [cell.titleLabel setText:@"及时雨信用卡"];
    }
    [cell.detailLabel setText:pro.describe];
    return cell;
}
// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        lab.text=@"快速办卡";
        [headerView addSubview:lab];
        return headerView;
    }
    return headerView;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-kMargin*5)/3, (WIDTH-kMargin*5)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
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
    // Dispose of any resources that can be recreated.
}

@end



