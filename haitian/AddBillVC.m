
//
//  AddBillVC.m
//  haitian
//
//  Created by Admin on 2017/5/24.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AddBillVC.h"
#import "NewRemindViewController.h"
#import "AccumulationFundViewController.h"
#import "LMZXSDK.h"

#define  APIKEY         @"9073253582026649"
#define  UID            @"u123456"
//#define  CALLBACKURL    @"http://192.168.117.239:8080/credit_callback.php"


#define  APISECRET @"wTCzqpY30jF9DHd8saT3E2tQU0q7aUhK"
#define  lm_url @"https://api.limuzhengxin.com"
// UID: 区分不同的用户
#define  UID            @"u123456"
#define  CALLBACKURL    @"http://www.baidu.com"
#define kMargin 10
static NSString *const cellId = @"cellId1";
static NSString *const headerId = @"headerId1";
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface AddBillVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *LoadcollectionView;

@end

@implementation AddBillVC
{NSArray *arr;
    NSArray *imageArr;
    NSArray *titleArr;
    LMZXSDK *_lmzxSDK;
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSArray *arr1=@[@"支付宝",@"京东白条",@"信用卡",@"公积金"];
    NSArray *arr2=@[@"宜人贷",@"我来贷",@"现金贷",@"简单借款"];
    NSArray *arr3=@[@"水电费",@"车贷",@"房贷",@"社保",@"房租",@"自定义"];
    
    arr=@[arr1,arr2,arr3];
    imageArr=@[@"mortgage",@"CarLoans",@"ElectricityAndWater",@"CreditCard"
               ,@"Rent",@"Custom"];
    titleArr=@[@"常用账单",@"网贷账单",@"生活账单"];
    _LoadcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
    [_LoadcollectionView setBackgroundColor:kColorFromRGBHex(0xEBEBEB)];
    _LoadcollectionView.delegate = self;
    _LoadcollectionView.dataSource = self;
    // 注册cell、sectionHeader、sectionFooter
    [_LoadcollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [_LoadcollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
//    self.LoadcollectionView.alwaysBounceVertical = YES;
    self.LoadcollectionView.showsVerticalScrollIndicator = NO;
    self.LoadcollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, 64)];
    view.backgroundColor=AppButtonbackgroundColor;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-100, 30, 200, 24)];
    label.text=@"添加我的账单";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [view addSubview:label];
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(10, 25, 25, 34);
    [backButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [backButton addTarget: self action: @selector(backAction) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview:backButton];

    [self.LoadcollectionView addSubview:view];
    [self.view addSubview:_LoadcollectionView];

    // Do any additional setup after loading the view.
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return arr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[arr objectAtIndex:section] count];
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
        
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        lab.text=titleArr[indexPath.section];
        [headerView addSubview:lab];
    }
    
    return headerView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =[_LoadcollectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArr[indexPath.row]]];
    //    [cell.imageView setImage:[UIImage imageNamed:[[arr4 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
    //    [cell.titleLabel setText:[[arr2 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    //    [cell.detailLabel setText:[[arr3 objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-kMargin*3)/2, HEIGHT/8);
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
    return (CGSize){WIDTH,40};
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            
            [self initSDK];
            [self startFunction:indexPath.row];
        }
            break;
        case 2:
        { NewRemindViewController *newRemind=[[NewRemindViewController alloc]init];
            newRemind.remindTitle=[[arr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:newRemind animated:YES];}
            break;
        default:
            break;
    }
    
    
}
#pragma mark 自定义全局通用的 SDK
- (void)initSDK {
    
    _lmzxSDK = [LMZXSDK lmzxSDKWithApikey:APIKEY uid:UID callBackUrl:CALLBACKURL];
    // 导航条颜色
    _lmzxSDK.lmzxThemeColor = AppButtonbackgroundColor;
    // 返回按钮文字\图片颜色,标题颜色
    _lmzxSDK.lmzxTitleColor = [UIColor whiteColor];
    // 查询页面协议文字颜色,和查询动画页面的动画颜色,文字颜色相同
    _lmzxSDK.lmzxProtocolTextColor = RGB(48, 113, 242) ;
    // 提交按钮颜色
    _lmzxSDK.lmzxSubmitBtnColor = RGB(57, 179, 27);
    // 页面背景颜色
    _lmzxSDK.lmzxPageBackgroundColor = BaseColor;
    
    // 调试地址,如果是正式的生产环境, 禁止设置此属性
    _lmzxSDK.lmzxTestURL = lm_url;
    
    ////     自定义失败时,是否需要退出   默认为NO 不退出
    //     _lmzxSDK.lmzxQuitOnFail = YES;
    ////     自定义查询成功时,是否需要退出   默认为 YES  退出
    //     _lmzxSDK.lmzxQuitOnSuccess = YES;
    
}
-(void)startFunction:(NSUInteger )lmzxSDKFunction
{
    __weak typeof(self) wself = self;
    
    switch (lmzxSDKFunction) {
        case 0:
        {
            [_lmzxSDK startFunction:LMZXSDKFunctionTaoBao
                       authCallBack:^(NSString *authInfo) {
                           [wself sign:authInfo];
                       }];}
            break;
        case 1:
        {
            [_lmzxSDK startFunction:LMZXSDKFunctionJD
                       authCallBack:^(NSString *authInfo) {
                           [wself sign:authInfo];
                       }];}
            break;
        case 2:
        {self.title=@"信用卡";
            [_lmzxSDK startFunction:LMZXSDKFunctionCreditCardBill
                       authCallBack:^(NSString *authInfo) {
                           [wself sign:authInfo];
                       }];}
            break;
        case 3:
        {self.title=@"公积金 ";
            [_lmzxSDK startFunction:LMZXSDKFunctionHousingFund
                       authCallBack:^(NSString *authInfo) {
                           [wself sign:authInfo];
                       }];}
            break;
        default:
            break;
    }
    
    
    [self handleResult];
}
#pragma mark - 监听结果回调
- (void)handleResult {
    
    __block typeof(self) weakSelf = self;
    _lmzxSDK.lmzxResultBlock = ^(NSInteger code, LMZXSDKFunction function, id obj, NSString * token){
        
        
        if (code >=0) {
            // 结果获取建议放在商户服务端,不建议在 APP 端直接获取立木服务器数据!
            // 仅给出获取查询退出结果数据的代码.
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *bizType = @"";
                switch (function) {
                    case LMZXSDKFunctionTaoBao:
                        bizType = @"taobao";
                        break;
                    case LMZXSDKFunctionJD:
                        bizType = @"jd";
                        break;
                    case LMZXSDKFunctionHousingFund:
                        bizType = @"housefund";
                        break;
                    case LMZXSDKFunctionMobileCarrie:
                        bizType = @"mobile";
                        break;
                    case LMZXSDKFunctionEducation:
                        bizType = @"education";
                        break;
                    case LMZXSDKFunctionSocialSecurity:
                        bizType = @"socialsecurity";
                        break;
                    case LMZXSDKFunctionAutoinsurance:
                        bizType = @"autoinsurance";
                        break;
                    case LMZXSDKFunctionEBankBill:
                        bizType = @"ebank";
                        break;
                    case LMZXSDKFunctionCentralBank:
                        bizType = @"credit";
                        break;
                    case LMZXSDKFunctionCreditCardBill:
                        bizType = @"bill";
                        break;
                    default:
                        break;
                }
                
                NSDictionary *dict = @{@"method":@"api.common.getResult",
                                       @"apiKey":[LMZXSDK shared].lmzxApiKey,
                                       @"version":@"1.2.0",
                                       @"token":token,
                                       @"bizType":bizType
                                       };
                
                NSDictionary *dic = [weakSelf signdic:dict];
                [weakSelf post:[lm_url stringByAppendingString:@"/api/gateway"] params:dic success:^(id obj) {
                    
                    if (obj) {
                        NSString * txt = @"有数据";
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            NSData *data= [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
                            txt = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            
                        }
                        
                        [MessageAlertView showSuccessMessage:txt];
                        
                    } else{
                        
                    }
                    
                    
                } failure:^(NSError *error) {
                    
                }];
                
                
            });
        }else{
            // 失败
        }
    };
}
//签名算法如下：
//1. 将立木回调参数 authInfo 和 APISECRET 直接拼接；
//2. 将上述拼接后的字符串进行SHA-1计算，并转换成16进制编码；
//3. 将上述字符串转换为全小写形式后即获得签名串
- (void )sign:(NSString*)string
{
    
    NSString *sign = [string stringByAppendingString:APISECRET];
    //    sign = @"2940e64f55bc4c72f5e3e643d570f8384728c6d1r3qUEj6PhkTz8odjHC0OYTXbtlSxqWyQ";
    NSMutableString *mString = [NSMutableString stringWithString:sign];
    NSString *newsign ;
    // 3、对该字符串进行SHA-1计算，得到签名，并转换成16进制小写编码,得到签名串
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [mString dataUsingEncoding: NSUTF8StringEncoding];
    
    if (CC_SHA1([stringBytes bytes],(CC_LONG) [stringBytes length], digest)) {
        NSMutableString *digestString = [NSMutableString stringWithCapacity:
                                         CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        newsign =[digestString lowercaseString];
        
    }
    [[LMZXSDK shared] sendReqWithSign:newsign];
    
}
//签名算法如下：
//1. 对除sign以外的所有请求参数进行字典升序排列；
//2. 将以上排序后的参数表进行字符串连接，如key1=value1&key2=value2&key3=value3...keyNvalueN；
//3. 将api secret作为后缀，拼接字符串并对该字符串进行SHA-1计算；
//4. 转换成16进制小写编码即获得签名串.
- (NSDictionary *)signdic:(NSDictionary*)ddic
{
    NSMutableDictionary *restultDic = [NSMutableDictionary dictionaryWithDictionary:ddic];
    
    // 签名串
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:ddic];
    
    // 1、对所有请求参数除sign外进行字典升序排列；
    
    //dic排序后的key 数组
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    //遍历key，将dic的  value 按照顺序存放在value数组中
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *key in sortedKeys) {
        [valueArray addObject:[paramsDic objectForKey:key]];
    }
    
    //  2、将排序后的参数表进行字符串连接，如key1=value1&key2=value2&...keyN=valueN；
    //key1=value1 key2=value2 key3=value3 ；
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortedKeys[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    //key1=value1&key2=value2&key3=value3 ；
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    NSMutableString *signString = [NSMutableString stringWithString:sign];
    
    // 3、 将api secret作为后缀，对该字符串进行SHA-1计算，得到签名，并转换成16进制小写编码，如： key1=value1&key2=value2&...keyN=valueNapi secret，得到签名串
    //后缀
    [signString appendString:APISECRET];
    //对该字符串进行SHA-1计算，并转换成16进制编码；
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], (unsigned int)[stringBytes length], digest)) {
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        NSString *value =[digestString lowercaseString];
        [restultDic  setValue:value forKey:@"sign"];
        return restultDic;
    }
    
    return restultDic;
}
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableArray *array = [NSMutableArray array];
    if (params) {
        for (NSString *key in params) {
            NSString *value = [params objectForKey:key];
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
        NSString *body = [array componentsJoinedByString:@"&"];
        request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        request.HTTPBody = nil;
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
                if (dict) {
                    if (success) {
                        success(dict);
                    }
                } else {
                    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if (success) {
                        success(jsonStr);
                    }
                    
                }
            }
        });
        
    }];
    [dataTask resume];
    
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
