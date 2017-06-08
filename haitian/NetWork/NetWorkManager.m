//
//  NetWorkManager.m
//  xiaoyixiu
//
//  Created by hanzhanbing on 16/6/14.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "NetWorkManager.h"
#import <AFNetworking.h>
#import "NetWorkUtil.h"

#define TIMEOUT 20

@implementation NetWorkManager

+ (instancetype)sharedManager
{
    static NetWorkManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetWorkManager alloc] initWithBaseURL:nil];
    });
    return _manager;
}

- (NSURLSessionDataTask *)postData:(NSString *)name
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([NetWorkUtil currentNetWorkStatus] == NET_UNKNOWN) {
        [MessageAlertView showErrorMessage:@"请检查您的网络"];
        return nil;
    }
    
   
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    self.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    self.requestSerializer.timeoutInterval = TIMEOUT;
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {
//        [manager.requestSerializer setValue:Context.currentUser.Token forHTTPHeaderField:@"X-EEXUU-Token"];
    }
    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVERE, name];
    
    return [self POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
        __unused   NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        
            success(task, responseObject);
        
        
        DLog(@"参数%@\n%@返回结果：%@",parameters,urlStr,resultDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task, error);
        [MessageAlertView showErrorMessage:@"请求超时，请重试"];
        DLog(@"%@请求失败信息：%@",urlStr,[error localizedDescription]);
        
    }];
}

- (NSURLSessionDataTask *)getData:(NSString *)name
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([NetWorkUtil currentNetWorkStatus] == NET_UNKNOWN) {
        [MessageAlertView showErrorMessage:@"请检查您的网络"];
        return nil;
    }
    
      self.responseSerializer=[AFHTTPResponseSerializer serializer];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {
//        [manager.requestSerializer setValue:Context.currentUser.Token forHTTPHeaderField:@"X-EEXUU-Token"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVERE, name];
    return [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __unused   NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        
        int IsSuccess = [[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"IsSuccess"]] intValue];
        
        if (IsSuccess == 1) { //成功
            success(task, responseObject);
        } else {
            failure(task, nil);
        }
        DLog(@"接口\n%@返回结果：%@",url,resultDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task, error);
        [MessageAlertView showErrorMessage:@"请求超时，请重试"];
        DLog(@"%@请求失败信息：%@",url,[error localizedDescription]);
        
    }];
}

- (NSURLSessionDataTask *)postJSON:(NSString *)name
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([NetWorkUtil currentNetWorkStatus] == NET_UNKNOWN) {
        [MessageAlertView showErrorMessage:@"请检查您的网络"];
        return nil;
    }
    
//    [self configNetManager:name];
    DLog(@"%@",parameters );

    if (! [self checkSomething:name andParameters:parameters]) {
        return nil;
    }
    
    [MessageAlertView showLoading:@""];
    
    NSString *url = [NSString stringWithFormat:@"%@",name];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];    

    return [self POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MessageAlertView dismissHud];
        });

    success(task, responseObject);
                DLog(@"参数%@\n%@返回结果：%@",parameters,url,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MessageAlertView dismissHud];
        });
        failure(task, error);
        [MessageAlertView showErrorMessage:@"请求超时，请重试"];
        DLog(@"%@请求失败信息：%@",url,[error localizedDescription]);
    }];
}

- (NSURLSessionDataTask *)getJSON:(NSString *)name
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([NetWorkUtil currentNetWorkStatus] == NET_UNKNOWN) {
        [MessageAlertView showErrorMessage:@"请连接您的网络"];
        return nil;
    }
    
    [self configNetManager:name];
    
    [MessageAlertView showLoading:@""];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVERE, name];
    
    return [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MessageAlertView dismissHud];
        });
        
        int IsSuccess = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"IsSuccess"]] intValue];
        
        if (IsSuccess == 1) { //成功
            success(task, responseObject);
        } else {
            NSString *message = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"Message"]];
            [MessageAlertView showErrorMessage:message];
            failure(task, nil);
        }
        
        DLog(@"接口\n%@返回结果：%@",url,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MessageAlertView dismissHud];
        });
        failure(task, error);
        [MessageAlertView showErrorMessage:@"请求超时，请重试"];
        DLog(@"%@请求失败信息：%@",url,[error localizedDescription]);
    }];
}

- (NSURLSessionDataTask *)postNoTipJSON:(NSString *)name
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([NetWorkUtil currentNetWorkStatus] == NET_UNKNOWN) {
        return nil;
    }
    
//    [self configNetManager:name];
    
    NSString *url = [NSString stringWithFormat:@"%@", name];
    
    return [self POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            DLog(@"参数%@\n%@返回结果：%@",parameters,url,responseObject);
        
        success(task, responseObject);
        
 
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task, error);
        DLog(@"%@请求失败信息：%@",url,[error localizedDescription]);
        
    }];
}

- (NSURLSessionDataTask *)getNoTipJSON:(NSString *)name
                            parameters:(NSDictionary *)parameters
                               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if ([NetWorkUtil currentNetWorkStatus] == NET_UNKNOWN) {
        return nil;
    }
    
    [self configNetManager:name];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVERE, name];
    
    return [self GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int IsSuccess = [[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"IsSuccess"]] intValue];
        
        if (IsSuccess == 1) { //成功
            success(task, responseObject);
        } else {
            failure(task, nil);
        }
        
        DLog(@"参数%@\n%@返回结果：%@",parameters,url,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
        DLog(@"%@请求失败信息：%@",url,[error localizedDescription]);
    }];
}


//配置请求头
- (void)configNetManager:(NSString *)name
{
//    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    AFJSONResponseSerializer *response = [[AFJSONResponseSerializer alloc] init];
    response.removesKeysWithNullValues = YES;
    self.responseSerializer = response;
    self.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    self.requestSerializer.timeoutInterval = TIMEOUT;
//    [self.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kIsLogin"]) {

    }
}

//检查条件
- (BOOL)checkSomething:(NSString *)name andParameters:(NSDictionary *)parameters
{
    BOOL isChecked = YES;
    NSString *message = nil;
    //登录
    if ([name isEqualToString:dologin]) {
        if ( [UtilTools isBlankString:[parameters objectForKey:@"username"]] ) {
            message = @"请输入手机号";
            isChecked = NO;
        }
      
        else if (((NSString *)[parameters objectForKey:@"username"]).length != 11) {
            message = @"请输入正确的手机号";
            isChecked = NO;
        }
        
       else  if ([[parameters objectForKey:@"logintype"] isEqualToString:@"1"]) {
            if ([UtilTools isBlankString:[parameters objectForKey:@"password"]])
            {
                message=@"请输入密码";
                isChecked=NO;
            }
        }
        else
        {
            if ([UtilTools isBlankString:[parameters objectForKey:@"code"]])
        {
            message=@"请输入验证码";
            isChecked=NO;
        }
        
        }
        
    }
    //注册
    else if ([name isEqualToString:doregister] )
    {
        if ( [UtilTools isBlankString:[parameters objectForKey:@"mobile"]] ) {
            message = @"请输入手机号";

            isChecked = NO;
        }
        else if ([UtilTools isBlankString:[parameters objectForKey:@"password"]]) {
            message = @"请输入密码";
            isChecked = NO;
        }
        else if (((NSString *)[parameters objectForKey:@"mobile"]).length != 11) {
            message = @"请输入正确的手机号";
            isChecked = NO;
        }
        else if ([UtilTools isBlankString:[parameters objectForKey:@"code"]]) {
            message = @"请输入验证码";
            isChecked = NO;
        }
    }
    

    //获取验证码
    else if ([name isEqualToString:@"UserManage/GetVerifyCode"])
    {
        if ( ((NSString *)[parameters objectForKey:@"MobilePhone"]).length == 0 ) {
            message = @"请输入手机号";
            isChecked = NO;
        }
      
    }
    //获取验证码
    else if ([name containsString:@"/message/add"])
    {
        if ([UtilTools isBlankString:[parameters objectForKey:@"name"]]) {
            message = @"请输入名字";
            isChecked = NO;
        }
        else if ([UtilTools isBlankString:[parameters objectForKey:@"amount"]]) {
            message = @"请输入还款金额";
            isChecked = NO;
        }
        else if ([UtilTools isBlankString:[parameters objectForKey:@"date"]]) {
            message = @"请输入还款日期";
            isChecked = NO;
        }
        else if ([UtilTools isBlankString:[parameters objectForKey:@"rep_id"]]) {
            message = @"请选择重复方式";
            isChecked = NO;
        }
        else if ([UtilTools isBlankString:[parameters objectForKey:@"rem_id"]]) {
            message = @"请选择提醒方式";
            isChecked = NO;
        }
    }
    if ([name containsString:@"/feedback/add"]) {
        if ([UtilTools isBlankString:[parameters objectForKey:@"problem"]])
        {
            message = @"请输入问题";
            isChecked = NO;
        }
    }
    if ([name containsString:@"/message/add"]) {
        if ([[parameters objectForKey:@"type_id"] isEqualToString:@"5"])
        {
            if ([UtilTools isBlankString:[parameters objectForKey:@"msg_name"]]) {
                message = @"请输入自定义类型";
                isChecked = NO;
            }
           
        }
    }
    if ([name containsString:@"/userinfo/add"]) {

        if ([UtilTools isBlankString:[parameters objectForKey:@"realname"]])
        {
                message = @"请输入姓名";
                isChecked = NO;
           
        }
        else if ([UtilTools isBlankString:[parameters objectForKey:@"idcard"]]) {
            
            message = @"请输入身份证";
            isChecked = NO;
        }
        else if (![UtilTools validateIdentityCard:[parameters objectForKey:@"idcard"]]) {
            
            message = @"请输入正确的身份证";
            isChecked = NO;
        }
        
    }
    if (![UtilTools isBlankString:message]) {
        [MessageAlertView showErrorMessage:message];
    }

    
    return isChecked;
}




@end
