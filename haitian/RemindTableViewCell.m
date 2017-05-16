//
//  RemindTableViewCell.m
//  haitian
//
//  Created by Admin on 2017/5/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "RemindTableViewCell.h"
#define  margen 80
@implementation RemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
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
    
   
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        _image.backgroundColor = [UIColor blueColor];
    
    [self.contentView addSubview:_image];
    self.imageNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_image.frame)+5, 60, 20)];
    self.imageNameLabel.text=@"chedai";
    self.imageNameLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.imageNameLabel];
    
   self.dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+margen , 5, 100, 40 )];
     self.dateLabel.font=[UIFont boldSystemFontOfSize:30];
    self.dateLabel.text=@"今天";
    [ self.dateLabel setTextColor:[UIColor redColor]];
     self.dateLabel.textAlignment=NSTextAlignmentCenter;
    
    
    [self.contentView addSubview: self.dateLabel];
    
    self.dateDetailsLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel.frame) ,5, 100, 20)];
    self.dateDetailsLabel.text=@"天内还款";
    [self.dateDetailsLabel setTextColor:[UIColor redColor]];
   
    self.dateDetailsLabel.textAlignment=NSTextAlignmentLeft;
    self.dateDetailsLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.dateDetailsLabel];
    self.duetoLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel.frame) ,CGRectGetMaxY(self.dateDetailsLabel.frame), 100, 20)];
    [self.duetoLabel setTextColor:[UIColor redColor]];
    self.duetoLabel.text=@"06月10日到期";
    self.duetoLabel.textAlignment=NSTextAlignmentLeft;
    self.duetoLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.duetoLabel];
    
    
    self.reimbursementLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+margen  ,CGRectGetMaxY(self.dateLabel.frame), 100, 20)];
    [self.reimbursementLabel setTextColor:[UIColor redColor]];
    self.reimbursementLabel.text=@"应还款";
    self.reimbursementLabel.textAlignment=NSTextAlignmentLeft;
    self.reimbursementLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.reimbursementLabel];
    
    
    self.amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_image.frame)+margen ,CGRectGetMaxY(self.reimbursementLabel.frame)+5, 100, 20)];
    [self.amountLabel setTextColor:[UIColor redColor]];
    self.amountLabel.text=@"600.00";
    self.amountLabel.textAlignment=NSTextAlignmentLeft;
    self.amountLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.amountLabel];
    
    self.thenameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-30  ,50, 30, 20)];
    [self.thenameLabel setTextColor:[UIColor redColor]];
    self.thenameLabel.text=@"姓名";
    self.thenameLabel.textAlignment=NSTextAlignmentLeft;
    self.thenameLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.thenameLabel];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-30,CGRectGetMaxY(self.thenameLabel.frame)+10, 30, 20)];
    [self.nameLabel setTextColor:[UIColor redColor]];
    self.nameLabel.text=@"李**";
    self.nameLabel.textAlignment=NSTextAlignmentLeft;
    self.nameLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nameLabel];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
