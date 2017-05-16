//
//  Serve.h
//  xiaoyixiu
//
//  Created by 柯南 on 16/6/12.
//  Copyright © 2016年 柯南. All rights reserved.
//

#ifndef Serve_h
#define Serve_h

#pragma mark 域名端口

///**
// *  正式域名
// *
// *  @return 正式服务器
// */
#define SERVERE @"http://app.jishiyu11.cn/index.php?g=app"

#define IMG_PATH  @"http://app.jishiyu11.cn/data/upload/"//品牌logo
//贷款
#define loan @"&m=business&a=index"
//换一批
#define exchange @"&m=business&a=change_list"
//登陆验证码
#define verificationCodeLogin  @"&m=login&a=send_code"
//注册验证码
#define verificationCoderegister  @"&m=register&a=send_code"
//注册
#define doregister  @"&m=register&a=doregister"
//登陆
#define dologin  @"&m=login&a=dologin"
//重置密码
#define reset_password  @"&m=register&a=reset_password"
//贷款参数
#define filter_para @"&m=business&a=filter_para"

#define filter @"&m=business&a=filter"
//讯飞id
#define USER_APPID           @"58fffe9f"
//芝麻信用公钥
#define Credit_Sesame_Public_Key           @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCAQ0Lqucs4QEwgVDvAFLQy2GoMfYRQcpHkaNI8uOmbZQ8EILidbZEiEoThb+jKod3zPJJpuH/rUj/+ogXAyevawX7fA6A0DT/s0s1cVHNfr+9snWhWiPK+ZDqEhlK+wMUzeUWvquZ5M0hhOImGC6G5BSbGxGyuBseXWPjbPvrh9wIDAQAB"


//贷款
#define appcode @"jiandanjiekuanmiaojieban"


#endif /* Serve_h */
