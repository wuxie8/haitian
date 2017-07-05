//
//  BasicInformationViewController.h
//  haitian
//
//  Created by Admin on 2017/6/21.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "GestureNavBaseVC.h"
#import "ProductModel.h"
typedef void(^backBlock)();

@interface BasicInformationViewController : GestureNavBaseVC


@property(nonatomic, copy)backBlock clickBlock;
@property(strong, nonatomic)ProductListModel*product;


@end
