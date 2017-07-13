//
//  PhoneCarrierViewController.h
//  haitian
//
//  Created by Admin on 2017/7/10.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "GestureNavBaseVC.h"

typedef void(^backBlock)();

@interface PhoneCarrierViewController : GestureNavBaseVC


@property(nonatomic, copy)backBlock clickBlock;
@end
