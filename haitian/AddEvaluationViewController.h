//
//  AddEvaluationViewController.h
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "GestureNavBaseVC.h"
#import "HomeProductModel.h"
typedef void (^refresh)();

@interface AddEvaluationViewController : GestureNavBaseVC
@property(strong, nonatomic)HomeProductModel*productModel;
@property(strong, nonatomic)refresh refreshblock;

@end
