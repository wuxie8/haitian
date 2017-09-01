//
//  ClassListTableViewCell.h
//  haitian
//
//  Created by Admin on 2017/9/1.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
@interface ClassListTableViewCell : UITableViewCell


@property(strong, nonatomic)UIImageView *image;


@property (nonatomic, copy) UILabel *titleLabel;
//申请人数
@property (nonatomic, copy) UILabel *post_hits_Label;

//利率
@property(strong, nonatomic)UILabel *feliv_Label;

@property (nonatomic, strong)ClassListModel *model;

@property(strong, nonatomic)UIImageView *labellingImage;


@property(strong, nonatomic)UIImageView *activityImage;

@end
