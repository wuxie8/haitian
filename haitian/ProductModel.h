//
//  ProductModel.h
//  haitian
//
//  Created by Admin on 2017/6/7.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, copy) NSString *id;

@end
@interface ProductListModel : NSObject

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, copy) NSString *data_id;

@property (nonatomic, copy) NSString *data_name;

@property (nonatomic, copy) NSString *zuikuaifangkuan;

@property (nonatomic, copy) NSString *edufanwei;
@property (nonatomic, copy) NSString *feilv;
@property (nonatomic, copy) NSString *cat_id;

@property (nonatomic, copy) NSString *fv_unit;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *pro_link;

@property (nonatomic, copy) NSString *pro_describe;

@property (nonatomic, copy) NSString *other_id;

@property (nonatomic, copy) NSString *pro_hits;

@property (nonatomic, copy) NSString *hits;
@property (nonatomic, copy) NSString *is_new;

@property (nonatomic, copy) NSString *is_activity;


@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *qx_unit;

@property (nonatomic, copy) NSString *qixianfanwei;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, copy) NSString *api_type;

@property (nonatomic, copy) NSString *tiaojian;

@property (nonatomic, copy) NSString *id;

@end
