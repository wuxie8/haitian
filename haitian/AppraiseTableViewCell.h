//
//  AppraiseTableViewCell.h
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppraiseTableViewCell : UITableViewCell

@property(strong, nonatomic)UIImageView *image;


@property (nonatomic, copy) UILabel *titleLabel;
//申请人数
@property (nonatomic, copy) UILabel *post_hits_Label;

//利率
@property(strong, nonatomic)UILabel *feliv_Label;

@property(strong, nonatomic)UILabel *comment_Label;

@property (nonatomic, assign) NSInteger index;


@end
