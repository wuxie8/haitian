//
//  BorrowingRecordableViewCell.m
//  haitian
//
//  Created by Admin on 2017/8/31.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "BorrowingRecordableViewCell.h"
#define  interval 20
@implementation BorrowingRecordableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatHealthBroadcastCellUI];
    }
    return self;
}
-(void)creatHealthBroadcastCellUI
{
    
    
    _browsingTime_Label=[[UILabel alloc]initWithFrame:CGRectMake(interval , 10, 200, 30  )];
    _browsingTime_Label.font=[UIFont systemFontOfSize:14];
//    [_browsingTime_Label setTextColor:[UIColor redColor]];
    _browsingTime_Label.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_browsingTime_Label];

    UIImageView *dottedLine=[[UIImageView alloc]initWithFrame:CGRectMake(interval, CGRectGetMaxY(_browsingTime_Label.frame), WIDTH-interval, 1)];
    dottedLine.image=[UIImage imageNamed:@"DottedLine"];
    [self.contentView addSubview:dottedLine];

    _image = [[UIImageView alloc] initWithFrame:CGRectMake(interval, CGRectGetMaxY(dottedLine.frame)+10, 60, 60)];
    //    _image.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    
    [self.contentView addSubview:_image];
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+interval, CGRectGetMaxY(dottedLine.frame)+10, 120, 20)];
    _titleLabel.textColor=kColorFromRGBHex(0x323232);
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    _titleLabel.font= [UIFont boldSystemFontOfSize:16 ];
    [self.contentView addSubview:_titleLabel];
    
    _amount_Label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+interval , CGRectGetMaxY(_titleLabel.frame), 200, 20  )];
    _amount_Label.font=[UIFont systemFontOfSize:14];
    [_amount_Label setTextColor:[UIColor grayColor]];
    _amount_Label.textAlignment=NSTextAlignmentLeft;
    
    
    [self.contentView addSubview:_amount_Label];
    
    _timeLimit_Label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+interval ,CGRectGetMaxY(_amount_Label.frame), 200, 20)];
    [_timeLimit_Label setTextColor:[UIColor grayColor]];
//    _timeLimit_Label.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
//    _timeLimit_Label.numberOfLines=0;
    _timeLimit_Label.textAlignment=NSTextAlignmentLeft;
    _timeLimit_Label.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLimit_Label];
    
   _but=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-80-interval, CGRectGetMaxY(dottedLine.frame)+20, 80, 30)];
    [_but setBackgroundImage:[UIImage imageNamed:@"BorrowingImmediately"] forState:0];
    _but.imageView.contentMode=UIViewContentModeScaleAspectFit;
    _but.imageView.clipsToBounds=YES;
    [self.contentView addSubview:_but];
    
    _borrowingTime_Label=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-180-interval,CGRectGetMaxY(_but.frame)+15, 180, 20)];
    [_borrowingTime_Label setTextColor:[UIColor grayColor]];
    //    _borrowingTime_Label.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
    //    _borrowingTime_Label.numberOfLines=0;
    _borrowingTime_Label.textAlignment=NSTextAlignmentRight;
    _borrowingTime_Label.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_borrowingTime_Label];
    UIView *backgroundview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_borrowingTime_Label.frame), WIDTH, 5)];
    backgroundview.backgroundColor=AppPageColor;
    [self.contentView addSubview:backgroundview];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
