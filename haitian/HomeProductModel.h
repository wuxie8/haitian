//
//  HomeProductModel.h
//  haitian
//
//  Created by Admin on 2017/6/27.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeProductModel : NSObject
//产品名字
@property (nonatomic, copy) NSString *post_title;

@property (nonatomic, copy) NSString *hits;

//产品图标
@property (nonatomic, copy) NSString *smeta;
//申请人数
@property (nonatomic, copy) NSString *post_hits;
//链接
@property(strong, nonatomic)NSString * link;
//利率
@property(strong, nonatomic)NSString *feilv;
//额度范围
@property(strong, nonatomic)NSString *edufanwei;
//期限范围
@property(strong, nonatomic)NSString* qixianfanwei;
//申请条件
@property(strong, nonatomic)NSString * shenqingtiaojian ;
//最快放款
@property(strong, nonatomic)NSString*  zuikuaifangkuan;
//业务ID
@property(strong, nonatomic)NSString*  productID;
//单位
@property(strong, nonatomic)NSString*  fv_unit;

@property(strong, nonatomic)NSString*  api_type;
@property(strong, nonatomic)NSString*  type;


//天／月
@property(strong, nonatomic)NSString*  qx_unit;
//介绍
@property(strong, nonatomic)NSString*  post_excerpt;
@property(strong, nonatomic)NSString*  data_id;
@property(strong, nonatomic)NSString*  order;

@property(strong, nonatomic)NSString*  other_auth;

@property(strong, nonatomic)NSString*  is_activity;

@property(strong, nonatomic)NSString*  other_id;
@property(strong, nonatomic)NSString*  pro_describe;
@property(strong, nonatomic)NSString*  pro_hits;
@property(strong, nonatomic)NSString*  pro_link;

@property(strong, nonatomic)NSString*  pro_name;

@property(strong, nonatomic)NSString*  is_new;

//标签数组
@property(strong, nonatomic)NSArray*  tagsArray;

@end
