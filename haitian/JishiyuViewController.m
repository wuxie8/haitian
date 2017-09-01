//
//  JishiyuViewController.m
//  jishiyu.com
//
//  Created by Admin on 2017/3/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "JishiyuViewController.h"
#import "WSPageView.h"
#import "WSIndexBanner.h"
#import <QuartzCore/CALayer.h>
#import "WebVC.h"
#import "JishiyuTableViewCell.h"
#import "LoanClasssificationVC.h"
#import "LoginViewController.h"
#import "AmountClassificationViewController.h"
#import "LoanDetailsViewController.h"
#import "AdvertiseViewController.h"
#import "CCPScrollView.h"
#import "HomePageCollectionViewCell.h"
#import "ClassModel.h"
#import "LoanDetaiViewController.h"
#import "ClassListViewController.h"
#define  ScrollviewWeight 50
#define  ScrollviewHeight 180
#define SectionHeight 110
#define SectionHeadHeight 60
#define ccpViewHeadHeight 50

#define kMargin 10

static NSString *const cellId = @"cellId1";
static NSString *const headerId = @"headerId1";
static NSString *const footerId = @"footerId1";
static NSString *const adUrl = @"adUrl";

@interface JishiyuViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,WSPageViewDelegate,WSPageViewDataSource>
@property(strong, nonatomic) UIScrollView *scrollview;
@property(strong, nonatomic)NSMutableArray *productArray;
@property(strong, nonatomic)NSMutableArray *classArray;

@property (nonatomic, strong)UICollectionView *LoadcollectionView;
@property(strong, nonatomic)UIView *headView;
@end

@implementation JishiyuViewController
{
    UITableView*tab;
    int page;
    int page_count;
    UIView *backgroundView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UtilTools isBlankArray:self.productArray]) {
        [self getList];

    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title=@"及时雨贷款";
    [self getCollectionData];
    
    page=1;
    
    self.view.backgroundColor=[UIColor grayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];
    if ([NetWorkUtil currentNetWorkStatus]==NET_UNKNOWN) {
        if (![UtilTools openEventServiceWithBolck]) {
            NSString *title = NSLocalizedString(@"请打开网络权限", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"设置", nil);
            NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            // The text field initially has no text in the text field, so we'll disable it.
            //                otherAction.enabled = NO;
            
            // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
            //                self.secureTextAlertAction = otherAction;
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }

    
    tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-44)];
    tab.delegate=self;
    tab.dataSource=self;
    tab.backgroundColor=[UIColor whiteColor];
    tab.tableHeaderView=self.headView;
    
    [self.view addSubview:tab];
    // Do any additional setup after loading the view.
}
- (void)pushToAd {
    
     NSString * url= [kUserDefaults valueForKey:adUrl];
    
    if (![UtilTools isBlankString:url]) {
        WebVC *vc = [[WebVC alloc] init];
        [vc setNavTitle:@"及时雨贷款"];
        [vc loadFromURLStr:url];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:NO];

    }
    
}
-(void)getCollectionData{
   
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=productcate&a=getList",SERVEREURL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            NSArray *arr=responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                ClassModel *class=[[ClassModel alloc]init];
                class.cat_icon=dic[@"cat_icon"];
                class.cat_name=dic[@"cat_name"];
                NSArray *classArray=dic[@"data"];
                if (![UtilTools isBlankArray:classArray]) {
                    NSMutableArray *classMutableArray=[NSMutableArray array];
                    for (NSDictionary *diction in classArray) {
                        ClassListModel *classList=[[ClassListModel alloc]init];
                        [classList setValuesForKeysWithDictionary:diction];
                        [classMutableArray addObject:classList];
                    }
                    class.classListArray=classMutableArray;
                }
            
                [self.classArray addObject:class];
            }
            ClassModel *class=[[ClassModel alloc]init];
            [self.classArray addObject:class];

            [_LoadcollectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        
        
    }];

}
-(void)getList
{
           self.productArray=nil;
    
    [backgroundView removeFromSuperview];

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"ios",@"os",
                       [NSString stringWithFormat:@"%d",page],@"page",
                        appcode,@"code",
                       nil];
    NSArray *array=@[@"及时雨-社保贷",@"及时雨-公积金贷",@"及时雨-保单贷",@"及时雨-供房贷",@"及时雨-税金贷",@"及时雨-学信贷"];
    [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=product&a=change_list",SERVEREURL] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;

        if ([dic[@"code"]isEqualToString:@"0000"]) {
            NSArray *arr=[dic[@"data"] objectForKey:@"list"];
            page_count=[[dic[@"data"] objectForKey:@"page_count"] intValue];
            ++page;
            if (page>page_count) {
                page=1;
            }
            if ([UtilTools isBlankString:[dic[@"data"] objectForKey:@"review"]]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"review"];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setBool:[[dic[@"data"] objectForKey:@"review"]boolValue] forKey:@"review"];

                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"review"];

            }
            if (![UtilTools isBlankArray:arr]) {
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
                    pro.shenqingtiaojian=diction[@"shenqingtiaojian"];
                    pro.zuikuaifangkuan=diction[@"zuikuaifangkuan"];
                    pro.api_type=diction[@"api_type"];
                    pro.hits=diction[@"hits"];

                    pro.post_hits=diction[@"hits"];
                    pro.feilv=diction[@"feilv"];
                    pro.productID=diction[@"id"];
                    pro.post_excerpt=diction[@"post_excerpt"];
                    NSArray *tags=diction[@"tags"];
                    NSMutableArray *tagsArray=[NSMutableArray array];
                    for (NSDictionary *dic in tags) {
                        [tagsArray addObject:dic[@"tag_name"]];
                    }
                    pro.tagsArray=tagsArray;
                    pro.fv_unit=diction[@"fv_unit"];
                    
                    pro.qx_unit=diction[@"qx_unit"];
                    
                    [self.productArray addObject:pro];
                    
                }
                
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [tab reloadData];
            });
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self LoadFailed];
    }];
    
    
}
-(void)LoadFailed
{
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, ScrollviewHeight+SectionHeight+SectionHeadHeight, WIDTH, HEIGHT-(ScrollviewHeight+SectionHeight+SectionHeadHeight)-64)];
    [self.view addSubview:backgroundView];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, backgroundView.frame.size.height)];
    image.backgroundColor=[UIColor redColor];
    image.image=[UIImage imageNamed:@"Loadunsuccessful"];
    
    
    [backgroundView addSubview:image];
    
   
    
}

- (UIView *)headView {
    if (!_headView) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, (WIDTH-kMargin*7)/2+ScrollviewHeight+30)];
        WSPageView *pageView = [[WSPageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,ScrollviewHeight)];
        pageView.delegate = self;
        pageView.dataSource = self;
        pageView.minimumPageAlpha = 0.4;   //非当前页的透明比例
        pageView.minimumPageScale = 0.85;  //非当前页的缩放比例
        pageView.orginPageCount = 1; //原始页数
        pageView.autoTime = 3;    //自动切换视图的时间,默认是5.0
        
        pageView.backgroundColor=[UIColor grayColor];
        //初始化pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageView.frame.size.height - 8 - 10, WIDTH, 8)];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageView.pageControl = pageControl;
        [pageView addSubview:pageControl];
        [pageView startTimer];
        _LoadcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageView.frame), WIDTH, (WIDTH-kMargin*7)/2+20) collectionViewLayout:[UICollectionViewFlowLayout new]];
        [_LoadcollectionView setBackgroundColor:[UIColor whiteColor]];
        _LoadcollectionView.delegate = self;
        _LoadcollectionView.dataSource = self;
        self.LoadcollectionView.alwaysBounceVertical = YES;
        // 注册cell、sectionHeader、sectionFooter
        [_LoadcollectionView registerClass:[HomePageCollectionViewCell class] forCellWithReuseIdentifier:cellId];
        [_LoadcollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        [_LoadcollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        _LoadcollectionView.scrollEnabled=NO;
            UIView *backgroundview1=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_LoadcollectionView.frame), WIDTH, 5)];
            backgroundview1.backgroundColor=kColorFromRGBHex(0xf3f3f3);
            [_headView addSubview:backgroundview1];
        [_headView addSubview:pageView];
        [_headView addSubview:_LoadcollectionView];
    }
    return _headView;
   
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(WSPageView *)flowView {
    return CGSizeMake(WIDTH, ScrollviewHeight);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
        
        switch (subIndex) {
            case 0:
            {
                WebVC *vc = [[WebVC alloc] init];
                [vc setNavTitle:@"融360"];
                [vc loadFromURLStr:@"http://m.rong360.com/express?from=sem21&utm_source=union1&utm_medium=jsy"];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:NO];
                
            }
                break;
            case 1:
            {WebVC *vc = [[WebVC alloc] init];
                [vc setNavTitle:@"现金巴士"];
                [vc loadFromURLStr:@"https://weixin.cashbus.com/#/events/promo/13201"];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:NO];
                
            }
                break;
            case 2:
            {
                WebVC *vc = [[WebVC alloc] init];
                [vc setNavTitle:@"简单借款"];
                [vc loadFromURLStr:@"https://activity.jiandanjiekuan.com/html/register_getNewUser.html?channelCode=98a33dcdc909492b9eb0b5cffb5d7d80"];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:NO];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(WSPageView *)flowView {
    return 1;
}



- (UIView *)flowView:(WSPageView *)flowView cellForPageAtIndex:(NSInteger)index{
    WSIndexBanner *bannerView = (WSIndexBanner *)[flowView dequeueReusableCell];
    if (!bannerView) {
        
        bannerView = [[WSIndexBanner alloc] initWithFrame:CGRectMake(0, 0,  WIDTH , ScrollviewHeight)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    [bannerView.mainImageView setImage:[UIImage imageNamed:@"WechatIMG2"]];
    //    bannerView.mainImageView.image = self.imageArray[index];
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:ImgURLArray[index]]];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(WSPageView *)flowView {
    
}


#pragma mark


//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//返回标题数组中元素的个数来确定分区的个数
    
}

//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    switch (section) {
//            
//        case 0:
//            
//            return  1;//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
//            
//            break;
//            
//        case 1:
    
            return  [self.productArray count];
//            
//            break;
//            
//        default:
//            
//            return 0;
//            
//            break;
            
//    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH,  SectionHeadHeight+ccpViewHeadHeight)] ;
    
    [view setBackgroundColor:[UIColor whiteColor]];//改变标题的颜色，也可用图片
    view .backgroundColor=AppPageColor;
    
    CCPScrollView *ccpView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ccpViewHeadHeight)];
    
    ccpView.titleArray = self.productArray;
    
    ccpView.titleFont = 10;
    
//    ccpView.titleColor = [UIColor greenColor];
    
    ccpView.BGColor = [UIColor whiteColor];
    
    [ccpView clickTitleLabel:^(NSInteger index) {
        
        NSLog(@"%ld",index);
        
        
    }];
    
    [view addSubview:ccpView];

    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-100, CGRectGetMaxY(ccpView.frame)+10, 200, 40)];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setClipsToBounds:YES];
    
    [image setImage:[UIImage imageNamed:@"PopularFastloan"]];
    [view addSubview:image];
    
    
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-60, CGRectGetMaxY(ccpView.frame)+30, 50, 25)];
    [but setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    
    [but.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [but.imageView setClipsToBounds:YES];
    
    but.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    
    but.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [but addTarget:self action:@selector(getList) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
    
    
//    UIView *backgroundview1=[[UIView alloc]initWithFrame:CGRectMake(0, 58, WIDTH, 2)];
//    backgroundview1.backgroundColor=kColorFromRGB(245, 245, 243);
//    [view addSubview:backgroundview1];
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==1) {
//        return  SectionHeadHeight;
//    }
//    else
//    {
//        return 0;
//    }
    return  SectionHeadHeight+ccpViewHeadHeight;

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (indexPath.section==0 ) {
//        return SectionHeight;
//    }
//    else
        return 80;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([tab respondsToSelector:@selector(setSeparatorInset:)]) {
        [tab setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tab respondsToSelector:@selector(setLayoutMargins:)]) {
        [tab setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (indexPath.section==1) {
        static NSString *HealthBroadcastCellID=@"HealthBroadcastCellID";
        JishiyuTableViewCell *jishiyu=[tableView dequeueReusableCellWithIdentifier:HealthBroadcastCellID];
        if (!jishiyu) {
            jishiyu=[[JishiyuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HealthBroadcastCellID];
            //取消选中状态
            jishiyu.selectionStyle = UITableViewCellSelectionStyleNone;
            jishiyu.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }
        

        if (![UtilTools isBlankArray:self.productArray]) {
            HomeProductModel *pro=(HomeProductModel *)[self.productArray objectAtIndex: indexPath.row];
            
            
            [jishiyu setModel:pro];
        }
        return jishiyu;

        
//    }
//    else
//    {
//        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (!cell) {
//            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        NSArray *images=@[@"Fastloan",@"recommend",@"Creditcardreport"];
//        for (int i=0; i<images.count; i++) {
//            UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH/images.count*i, 10, WIDTH/images.count, SectionHeight-20)];
//            [but setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
//            
//            [but.imageView setContentMode:UIViewContentModeScaleAspectFit];
//            [but.imageView setClipsToBounds:YES];
//            
//            but.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
//            
//            but.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//            [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
//            but.tag=i;
//            
//            [cell.contentView addSubview:but];
//        }
//  
//        return cell;
//    }
}
-(void)butClick:(UIButton *)sender
{
    
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {
    switch (sender.tag) {
        case 0:
        {
            AmountClassificationViewController *amount=[[AmountClassificationViewController alloc]init];
            amount.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:amount animated:YES];
        }
            break;
        case 1:
            
        { LoanClasssificationVC *loanClass=[[ LoanClasssificationVC alloc]init];
            loanClass.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loanClass animated:YES];
        }
            break;
        case 2:
        {
            //                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"review"]) {
            WebVC *vc = [[WebVC alloc] init];
            [vc setNavTitle:@"信用卡查询"];
            [vc loadFromURLStr:@"http://www.kuaicha.info/mobile/credit/credit.html"];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:NO];
            //                }
            //                else
            //                {
            //                    [MessageAlertView showErrorMessage:@"服务器维护中"];
            //                }
            
            
            
        }
            break;
        default:
            break;
    }
        }
        else
        {
            LoginViewController *login=[[LoginViewController alloc]init];
            login.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:login animated:YES];
        }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeProductModel *product=(HomeProductModel *)self.productArray[indexPath.row];

    LoanDetaiViewController *load=[[LoanDetaiViewController alloc]init];
    load.hidesBottomBarWhenPushed=YES;
    
    load.product=product;
    [self.navigationController pushViewController:load animated:YES];
    return;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"])
    {

            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                               product.productID,@"id",
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
                    [vc setNavTitle:product.post_title];
                    [vc loadFromURLStr:product.link];
                    vc.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:vc animated:NO];
                }
                else if ([product.api_type isEqualToString:@"2"]) {
                    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:
                                        Context.currentUser.uid,@"uid",
                                        product.productID,@"id",
                                        
                                        nil];
                    [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=product&a=postDetail",SERVERE] parameters:dic1 success:^(NSURLSessionDataTask *task, id responseObject) {
                        
                        if ([responseObject[@"code"]isEqualToString:@"0000"]) {
                            NSDictionary *dic=responseObject[@"data"];
                            WebVC *vc = [[WebVC alloc] init];
                            [vc setNavTitle:product.post_title];
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
                    LoanDetailsViewController *load=[[LoanDetailsViewController alloc]init];
                    load.hidesBottomBarWhenPushed=YES;
                    
                    load.product=product;
                    [self.navigationController pushViewController:load animated:YES];
                }
            }

        
    }
    else
    {
        LoginViewController *login=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        
    }
}
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.classArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassModel*class=self.classArray[indexPath.row];
    HomePageCollectionViewCell *cell =(HomePageCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (indexPath.row==self.classArray.count-1) {
        [cell.titleLabel setText:@"征信查询"];
        [cell.bankimageView  setImage:[UIImage imageNamed:@"Creditcardreport"]];

    }
    else{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,class.cat_icon]];
        UIImage * result;
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        result = [UIImage imageWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [cell.bankimageView  setImage:result];
                          
                      });
    });
    [cell.titleLabel setText:class.cat_name];
    }
    [cell.backgroundView setClipsToBounds:YES];
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-kMargin*7)/4, (WIDTH-kMargin*7)/4);
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
{
    ClassModel *class=self.classArray[indexPath.row];
    NSArray *array=class.classListArray;
    ClassListViewController *classList=[ClassListViewController new];
    classList.hidesBottomBarWhenPushed=YES;
    classList.productArray=[NSMutableArray arrayWithArray:array];
    [self.navigationController pushViewController:classList animated:YES];
    if (indexPath.row==7) {
        WebVC *vc = [[WebVC alloc] init];
        [vc setNavTitle:@"信用卡查询"];
        [vc loadFromURLStr:@"http://www.kuaicha.info/mobile/credit/credit.html"];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMargin;
}



-(NSMutableArray *)productArray
{
    if (!_productArray) {
        _productArray=[NSMutableArray array];
        
    }
    return _productArray;
}
-(NSMutableArray *)classArray
{
    if (!_classArray) {
        _classArray=[NSMutableArray array];
        
    }
    return _classArray;
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
