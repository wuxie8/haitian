//
//  AccumulationFundViewController.m
//  haitian
//
//  Created by Admin on 2017/5/23.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AccumulationFundViewController.h"
#import "LMZXSDK.h"
//// 商户调试需替换为最新的 APIKEY
//#define  APIKEY    @"1070360724921868"
//// 不建议放在 APP 端,这里演示用.商户调试需替换为新的 APISECRET
//#define  APISECRET @"LFR1YZWLaj4q2BZ54GdrqHovAbaa074E"
//// 对接调试URL
//#define  lm_url    @"https://t.limuzhengxin.cn:3443/api/gateway"
//// 生产环境URL:
//#define  lm_url  @"https://api.limuzhengxin.com"

#define  APIKEY         @"9073253582026649"
#define  UID            @"u123456"
//#define  CALLBACKURL    @"http://192.168.117.239:8080/credit_callback.php"


#define  APISECRET @"wTCzqpY30jF9DHd8saT3E2tQU0q7aUhK"
#define  lm_url @"https://api.limuzhengxin.com"
// UID: 区分不同的用户
#define  UID            @"u123456"
#define  CALLBACKURL    @"http://www.baidu.com"
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGB_navBar      RGB(48, 113, 242)
@interface AccumulationFundViewController ()

@end

@implementation AccumulationFundViewController
{
    LMZXSDK *_lmzxSDK;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initSDK];
    [self startFunction];
    // Do any additional setup after loading the view.
}
#pragma mark 自定义全局通用的 SDK
- (void)initSDK {
    
    _lmzxSDK = [LMZXSDK lmzxSDKWithApikey:APIKEY uid:UID callBackUrl:CALLBACKURL];
    
    // 导航条颜色
    _lmzxSDK.lmzxThemeColor =  RGB(48, 113, 242);
    // 返回按钮文字\图片颜色,标题颜色
    _lmzxSDK.lmzxTitleColor = [UIColor whiteColor];
    // 查询页面协议文字颜色,和查询动画页面的动画颜色,文字颜色相同
    _lmzxSDK.lmzxProtocolTextColor = RGB(48, 113, 242) ;
    // 提交按钮颜色
    _lmzxSDK.lmzxSubmitBtnColor = RGB(57, 179, 27);
    // 页面背景颜色
    _lmzxSDK.lmzxPageBackgroundColor = RGB(245, 245, 245);
    
    // 调试地址,如果是正式的生产环境, 禁止设置此属性
//    _lmzxSDK.lmzxTestURL = lm_url;
    
    // 自定义失败时,是否需要退出   默认为NO 不退出
    // _lmzxSDK.lmzxQuitOnFail = NO;
    // 自定义查询成功时,是否需要退出   默认为 YES  退出
    // _lmzxSDK.lmzxQuitOnSuccess = YES;
   
}
-(void)startFunction
{
    __weak typeof(self) wself = self;

    switch (self.lmzxSDKFunction) {
        case 0:
        {self.title=@"支付宝";
            [_lmzxSDK startFunction:LMZXSDKFunctionTaoBao
                       authCallBack:^(NSString *authInfo) {
                           [wself sign:authInfo];
                       }];}
            break;
        case 1:
        {self.title=@"京东白条";
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
    NSLog(@"====2.newsign:%@",newsign);
    [[LMZXSDK shared] sendReqWithSign:newsign];
    
}
#pragma mark - 监听结果回调
- (void)handleResult {
    
    __block typeof(self) weakSelf = self;
    _lmzxSDK.lmzxResultBlock = ^(NSInteger code, LMZXSDKFunction function, id obj, NSString * token){
        
        NSLog(@"SDK回调结果==%ld,%d,%@,%@",(long)code,function,obj,token);
        
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
                
                NSLog(@"%@",dict);
                NSDictionary *dic = [weakSelf signdic:dict];
                NSLog(@"%@",dic);
                [weakSelf post:[lm_url stringByAppendingString:@"/api/gateway"] params:dic success:^(id obj) {
                    
                    if (obj) {
                        NSString * txt = @"有数据";
                        if ([obj isKindOfClass:[NSDictionary class]]) {
                            NSData *data= [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
                            txt = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                            
                        }
                        DLog(@"%@",obj);

                        DLog(@"%@",txt);
                        [MessageAlertView showSuccessMessage:txt];

                    } else{
                        DLog(@"wushuju ");

                    }
                
                    
                } failure:^(NSError *error) {
                    DLog(@"%@",error);

                }];
                

                           });
        }else{
            // 失败
        }
    };
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
