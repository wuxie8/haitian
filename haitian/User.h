//
//  User.h
//  jishi
//
//  Created by Admin on 2017/3/14.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong, nonatomic)NSString*token;

@property(strong, nonatomic)NSString*uid;

@property(strong, nonatomic)NSString*username;

@property(strong, nonatomic)NSString*name;

@property(strong, nonatomic)NSString*IDNum;

@property(assign, nonatomic)BOOL base_auth;

@property(assign, nonatomic)BOOL idcard_auth;

@property(assign, nonatomic)BOOL mobile_auth;

@property(assign, nonatomic)BOOL zhima_auth;
@property(assign, nonatomic)BOOL other_auth;


@end
