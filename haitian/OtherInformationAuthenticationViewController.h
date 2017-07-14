//
//  OtherInformationAuthenticationViewController.h
//  haitian
//
//  Created by Admin on 2017/6/22.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "GestureNavBaseVC.h"
#import "ProductModel.h"

typedef void(^backBlock)();

@interface OtherInformationAuthenticationViewController : GestureNavBaseVC

@property(nonatomic, copy)backBlock clickBlock;

//@property(strong, nonatomic)ProductListModel*product;

@property(strong, nonatomic)NSString*productID;

@property(strong, nonatomic)NSArray *dataArray;
@end
