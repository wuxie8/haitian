//
//  LMResultShowVC.m
//  LMZX_SDKDemo_OC
//
//  Created by yj on 2017/4/1.
//  Copyright © 2017年 99baozi. All rights reserved.
//

#import "LMResultShowVC.h"

#import <CommonCrypto/CommonDigest.h>
#define  lm_url @"https://api.limuzhengxin.com"
#define  APISECRET @"wTCzqpY30jF9DHd8saT3E2tQU0q7aUhK"



@interface LMResultShowVC ()
@property (strong, nonatomic) UITextView *resultView;

@end

@implementation LMResultShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:(UIBarButtonItemStyleDone) target:self action:@selector(back:)];
    
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _resultView = textview;
    [self.view addSubview:textview];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([LMZXSDK shared].lmzxQuitOnSuccess==NO) {
        
        self.resultView.text = @"登录成功! 需从服务器端获取最终数据..";
        
    }else {
        self.resultView.text = @"查询结果,请稍等..";
        [self queryResultWithFunction:_function token:_token];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- **3.查询结果**
- (void)queryResultWithFunction:(LMZXSDKFunction)function token:(NSString*)token {
    __weak typeof(self) weakSelf = self;
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
    NSDictionary *dic = [self sign:dict];
    NSLog(@"%@",dic);
    [self post:[lm_url stringByAppendingString:@"/api/gateway"] params:dic success:^(id obj) {
        
        if (obj) {
            NSString * txt = @"有数据";
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSData *data= [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
                txt = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
            }
            
            weakSelf.resultView.text = [[@"token:\n" stringByAppendingString:token] stringByAppendingString:[NSString stringWithFormat: @"\n\n 结果:\n%@", txt]];
        } else{
            weakSelf.resultView.text = [[@"token:\n\n"stringByAppendingString:token]  stringByAppendingString: @"\n\n 结果:无数据"];
        }
        
        
    } failure:^(NSError *error) {
        weakSelf.resultView.text = [[@"token:\n\n"stringByAppendingString:token]  stringByAppendingString:[NSString stringWithFormat: @"\n\n  error:\n%@",error.description]];
    }];
    
}
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




//签名算法如下：
//1. 对除sign以外的所有请求参数进行字典升序排列；
//2. 将以上排序后的参数表进行字符串连接，如key1=value1&key2=value2&key3=value3...keyNvalueN；
//3. 将api secret作为后缀，拼接字符串并对该字符串进行SHA-1计算；
//4. 转换成16进制小写编码即获得签名串.
- (NSDictionary *)sign:(NSDictionary*)ddic
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

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


#pragma mark-- 私有
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



@end
