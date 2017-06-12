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

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *pro_link;

@property (nonatomic, copy) NSString *pro_hits;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *type;


@property (nonatomic, copy) NSString *pro_describe;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, copy) NSString *id;

@end
