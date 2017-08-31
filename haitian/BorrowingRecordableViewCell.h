//
//  BorrowingRecordableViewCell.h
//  haitian
//
//  Created by Admin on 2017/8/31.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowingRecordableViewCell : UITableViewCell


@property(strong, nonatomic)UIImageView *image;

@property(strong, nonatomic) UIButton *but;
@property (nonatomic, copy) UILabel *titleLabel;
//申请人数
@property (nonatomic, copy) UILabel *amount_Label;

//利率
@property(strong, nonatomic)UILabel *timeLimit_Label;

@property(strong, nonatomic)UILabel *browsingTime_Label;

@property(strong, nonatomic)UILabel *borrowingTime_Label;


@end
