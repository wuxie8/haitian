//
//  LoadSupermarketCollectionViewCell.m
//  haitian
//
//  Created by Admin on 2017/4/13.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "LoadSupermarketCollectionViewCell.h"

@implementation LoadSupermarketCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 20, 40, 40)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, 20, 80, 40)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.text=@"仓鼠贷";
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.imageView.frame), frame.size.width-30*2,40)];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.text=@"有身份证可借5000元\n最快3分钟下款";
        self.detailLabel.adjustsFontSizeToFitWidth=YES;
        self.detailLabel.numberOfLines=2;
        self.detailLabel.textColor = [UIColor  blackColor];
       
        [self.contentView addSubview:self.detailLabel];
        
    }
    return self;
}

@end
