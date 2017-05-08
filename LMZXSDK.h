//
//  MoxieSDK.h
//  MoxieSDK
//
//  Created by shenzw on 6/23/16.
//  Copyright © 2016 shenzw. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 状态栏状态枚举
 */
typedef enum  {
    LMZXStatusBarStyleDefault = 2,
    LMZXStatusBarStyleLightContent ,
    
} LMZXStatusBarStyle;

/*
 * 功能的种类
 */
typedef enum {
    /** 公积金0 */
    LMZXSDKFunctionHousingFund = 0,
    /** 运营商1 */
    LMZXSDKFunctionMobileCarrie,
    /** 京东2 */
    LMZXSDKFunctionJD,
    /** 淘宝3 */
    LMZXSDKFunctionTaoBao,
    /** 学历学籍4 */
    LMZXSDKFunctionEducation,
    /** 社保5 */
    LMZXSDKFunctionSocialSecurity,
    /** 车险6 */
    LMZXSDKFunctionAutoinsurance,
    /** 网银流水7  */
    LMZXSDKFunctionEBankBill,
    /** 央行征信8  */
    LMZXSDKFunctionCentralBank,
    /** 信用卡账单9 */
    LMZXSDKFunctionCreditCardBill,
    
}LMZXSDKFunction;

typedef void(^LMZXResultBlock)(NSInteger code, LMZXSDKFunction function, id obj, NSString * taskId);
typedef void(^LMZXAuthBlock)(NSString * authInfo);



@interface LMZXSDK : NSObject


@property (nonatomic,strong,readonly) NSString *LMZXSDKVersion;


/**********************             *******************************/
/********************** SDK 注册信息 *******************************/
/**********************             *******************************/


/*! @brief 调试地址
 *  用于商户在测试环境下调试用
 *  注意:生产环境下,不要设置 testServiceURL 否则会覆盖 SDK 中的生产 url.
 */
@property (nonatomic,strong) NSString *lmzxTestURL;

/*! @brief ApiKey
 */
@property (nonatomic,strong,readonly) NSString *lmzxApiKey;

/*! @brief 用户 ID
 *  用于回调通知时商户进行用户区分，通常填入用户在商户系统的用户名、提交流水号或其他
 */
@property (nonatomic,strong,readonly) NSString *lmzxUid;

/*! @brief 回调地址
 *  回调状态通知接口只通知查询的最终结果状态给商户，商户收到回调通知后，
 *  如果查询状态是成功的，需要调用”结果查询”接口获取查询结果
 */
@property (nonatomic,strong) NSString *lmzxCallBackUrl;


/**********************                *******************************/
/********************** SDK 任务属性设置 *******************************/
/**********************                *******************************/


/*! @brief 任务模式
 *  1\设置为YES: 查询成功自动退出,此时立木服务器已经获取到全部的数据.商户可直接从立木服务器请求结果数据
 *              获取数据方式1:结果数据出来后,立木服务器会通知商户,此时商户服务器可从立木服务器请求数据
 *              获取数据方式2:APP 将 SDK 回调的 taskId 传至商户服务器,商户服务器根据 taskId 从立木服务器请求结果数据.
 *
 *
 *  2\设置为 NO: 登录成功自动退出,不进入查询数据过程.
 *              优点:查询等待时间短,当登录成功后可继续查询其他数据.商户可在用户将其余各项数据查询完成后,再到立木服务器请求结果数据.
 *              注意:登录成功后,立木服务器仍在处理数据中,需要等待一段时间后,才能生成最终的结果数据.
 *              获取数据方式1:结果数据出来后,立木服务器会通知商户,此时商户服务器可从立木服务器请求数据
 *              获取数据方式2:APP 将 SDK 回调的 taskId 传至商户服务器,商户服务器根据 taskId 不定时从立木服务器请求结果数据.
 *
 * 3\默认 YES.
 */
@property (nonatomic,assign) BOOL lmzxQuitOnSuccess;


/*! @brief 查询失败时,自动退出SDK.
 *  默认 NO,失败后可继续查询
 */
@property (nonatomic,assign) BOOL lmzxQuitOnFail;


/*! @brief 查询结果回调,需实现用以监听,查询结果.
 * -6 用户退出
 * -5 商户信息错误
 * -4 用户输入错误
 * -3 网络异常
 * -2 系统异常
 * -1 其他异常
 * 0 查询成功
 * 1 查询中
 * 2 登录成功
 */
@property (nonatomic,strong) LMZXResultBlock lmzxResultBlock;

/**
 * 请求参数回调 ,无须实现.
 */
@property (nonatomic,strong) LMZXAuthBlock lmzxAuthBlock;

/*! @brief 当前启动的 function
 */
@property (assign,nonatomic,readonly) LMZXSDKFunction lmzxFunction;

/**********************              **********************/
/********************** SDK UI 自定义 **********************/
/**********************              **********************/


/// 以下皆有默认设置.可根据需求修改


/*! @brief [A] 查询页面协议文字颜色,查询动画页面的动画/文字颜色,城市选择页面高亮颜色,搜索页面,汽车保险页面选中文字颜色,协议颜色
 */
@property (nonatomic,strong) UIColor *lmzxProtocolTextColor;

/*! @brief [B] 提交按钮颜色,验证码页面确认按钮颜色
 */
@property (nonatomic,strong) UIColor *lmzxSubmitBtnColor;

/*! @brief [C] 所有页面背景颜色
 */
@property (nonatomic,strong) UIColor *lmzxPageBackgroundColor;

/*! @brief [D] 导航条颜色
 */
@property (nonatomic,strong) UIColor *lmzxThemeColor;

/*! @brief [E] 标题栏: 返回按钮文字\图片颜色,标题颜色,刷新按钮颜色,提交按钮文字颜色
 */
@property (nonatomic,strong) UIColor *lmzxTitleColor;

/*! @brief 状态栏样式:默认白色
 */
@property (nonatomic,assign) LMZXStatusBarStyle lmzxStatusBarStyle;

/*! @brief 协议地址:
 */
@property (nonatomic,strong) NSString *lmzxProtocolUrl;

/*! @brief 协议名称:
 *  信用卡邮箱设置多个协议名,需要按照如下顺序,使用**进行拼接
 *  @"《163协议》**《126协议》**《qq协议》**《sina协议》**《139协议》"
 *  否则使用统一的 lmzxProtocolTitle
 */
@property (nonatomic,strong) NSString *lmzxProtocolTitle;

/*! @brief 提交按钮标题颜色.默认白色
 */
@property (nonatomic,strong) UIColor *lmzxSubmitBtnTitleColor;


/**********************     *******************************/
/********************** 方法 *******************************/
/**********************     *******************************/


/*! @brief SDK单例
 *
 */
+(LMZXSDK*)shared;


/*! @brief 1-> 注册 SDK
 *  注册 SDK , 在 application:  didFinishLaunchingWithOptions 中调用.
 */
+(void)registerLMZXSDK;

/*! @brief 2-> 初始化 SDK
 *  @param lmApikey 商户 apiKey
 *  @param lmUid 用户 ID
 *  @param callBackUrl 回调地址
 */
+(LMZXSDK *)initLMZXSDKWithApikey:(NSString *)lmApikey
                              uid:(NSString *)lmUid
                      callBackUrl:(NSString *)callBackUrl;



/*! @brief 3-> 启动 SDK 功能
 *  @param function 启动的某个功能
 *  @param lmzxAuthBlock 授权回调
 */
-(void)startFunction:(LMZXSDKFunction)function authCallBack:(LMZXAuthBlock)lmzxAuthBlock;


/*! @brief 4-> 启动某个查询服务
 *  将签名信息传入 SDK.
 */
- (void)sendReqWithSign:(NSString *)sign;


/*! @brief 启动 SDK 功能
 *  @param function 启动的某个功能
 *  @param lmzxAuthBlock 加签，授权
 *  @param lmzxResultBlock 查询结果回调
 */
-(void)startFunction:(LMZXSDKFunction)function authCallBack:(LMZXAuthBlock)lmzxAuthBlock resultCallBack:(LMZXResultBlock)lmzxResultBlock;


/*! @brief 开启立木 SDK 日志
 *  默认为关闭
 */
- (void)unlockLog;

@end





