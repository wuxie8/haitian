//
//  ProductDetailViewController.h
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "GestureNavBaseVC.h"
#import "HomeProductModel.h"
typedef void (^back)();

@interface ProductDetailViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property(strong, nonatomic)HomeProductModel*productModel;

@property(strong, nonatomic)back backblock;

@end
