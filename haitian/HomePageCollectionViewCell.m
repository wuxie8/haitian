//
//  HomePageCollectionViewCell.m
//  haitian
//
//  Created by Admin on 2017/8/29.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "HomePageCollectionViewCell.h"

@implementation HomePageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.bankimageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/4, 10, frame.size.width/2,  frame.size.height/3*2-10)];
        self.bankimageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.bankimageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-50, frame.size.height/3*2, 100, frame.size.height/3)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, frame.size.height/4*3-10, frame.size.width-20*2, frame.size.height/4)];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        //        self.detailLabel.adjustsFontSizeToFitWidth=YES;
        self.detailLabel.font=[UIFont systemFontOfSize:8];
        self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.detailLabel.numberOfLines=2;
        self.detailLabel.textColor = [UIColor  blackColor];
        
        [self.contentView addSubview:self.detailLabel];
        
    }
    return self;
}


@end
