//
//  CommentariesViewController.h
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "GestureNavBaseVC.h"
#import "HomeProductModel.h"

typedef void (^back)();

@interface CommentariesViewController : UIViewController
@property(strong, nonatomic)back backblock;

@property(strong, nonatomic)HomeProductModel*productModel;
@property (nonatomic,retain) UITableView *tableView;

@end
