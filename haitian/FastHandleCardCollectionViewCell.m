//
//  FastHandleCardCollectionViewCell.m
//  haitian
//
//  Created by Admin on 2017/4/13.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "FastHandleCardCollectionViewCell.h"

@implementation FastHandleCardCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-30, frame.size.height/4, 60,  frame.size.height/4)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-40, frame.size.height/2, 80, frame.size.height/4)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.text=@"浦发银行";
//        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, frame.size.height/4*3, frame.size.width-20*2, frame.size.height/4)];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.text=@"刷卡地3888元大奖";
        self.detailLabel.adjustsFontSizeToFitWidth=YES;
       
        self.detailLabel.textColor = [UIColor  blackColor];
        
        [self.contentView addSubview:self.detailLabel];
        
    }
    return self;
}


@end
