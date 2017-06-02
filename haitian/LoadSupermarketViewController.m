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

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <CoreTelephony/CTCarrier.h>
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
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
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
    [self loadBanner];
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
    return 3;
}

- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0,  WIDTH , pageHeight)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    [bannerView.mainImageView setImage:[UIImage imageNamed:@"WechatIMG2"]];
    //    bannerView.mainImageView.image = self.imageArray[index];
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:ImgURLArray[index]]];
    
    return bannerView;
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return arr2.count;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [[arr2 objectAtIndex:section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   LoadSupermarketCollectionViewCell *cell =(LoadSupermarketCollectionViewCell *) [_LoadcollectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:[[arr4 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
    [cell.titleLabel setText:[[arr2 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [cell.detailLabel setText:[[arr3 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    return cell;
}
// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView;
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        headerView = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        headerView.backgroundColor = AppPageColor;
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        image.image=[UIImage imageNamed:arr1[indexPath.section]];
        [headerView addSubview:image];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, 10, 100, 20)];
        lab.text=arr[indexPath.section];
        [headerView addSubview:lab];
        return headerView;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
