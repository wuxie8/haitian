//
//  ClassModel.h
//  haitian
//
//  Created by Admin on 2017/8/29.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClassListModel;

@interface ClassModel : NSObject
@property (nonatomic,copy) NSString *cat_icon;

@property (nonatomic,copy) NSString *cat_name;
@property (nonatomic,copy) NSString *id;
@property (nonatomic, strong) NSArray<ClassListModel *> *classListArray;

@end


@interface ClassListModel : NSObject

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


@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *qx_unit;

@property (nonatomic, copy) NSString *qixianfanwei;

@property (nonatomic, copy) NSString *pro_name;

@property (nonatomic, copy) NSString *api_type;

@property (nonatomic, copy) NSString *tiaojian;

@property (nonatomic, copy) NSString *id;

@end
