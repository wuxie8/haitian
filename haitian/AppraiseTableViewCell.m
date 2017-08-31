//
//  AppraiseTableViewCell.m
//  haitian
//
//  Created by Admin on 2017/8/30.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AppraiseTableViewCell.h"
#import "ZJD_StarEvaluateView.h"

#define  interval  30

@implementation AppraiseTableViewCell

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
    CGFloat LeftPadding = 20;

    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 5, WIDTH-20, 110)];
    view.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:view];
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 30, 30)];
    //    _image.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    
    [self.contentView addSubview:_image];
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(LeftPadding, 10, WIDTH/2-LeftPadding, 42)];
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    _titleLabel.text=@"138****4566";
    _titleLabel.textColor=kColorFromRGBHex(0x787878);
    _titleLabel.font= [UIFont boldSystemFontOfSize:16 ];
    [self.contentView addSubview:_titleLabel];
    
    _post_hits_Label=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+LeftPadding , 10, WIDTH/2-LeftPadding*2, 42  )];
    _post_hits_Label.font=[UIFont systemFontOfSize:16];
    _post_hits_Label.textColor=kColorFromRGBHex(0x787878);

    _post_hits_Label.text=@"2017-08-29";
//    [_post_hits_Label setTextColor:[UIColor redColor]];
    _post_hits_Label.textAlignment=NSTextAlignmentRight;
    
    
    [self.contentView addSubview:_post_hits_Label];
    NSInteger index = 4;
    CGFloat starWidth = 20;
    CGFloat space = 5;
    
    ZJD_StarEvaluateView *starView = [[ZJD_StarEvaluateView alloc] initWithFrame:CGRectMake(LeftPadding, CGRectGetMaxY(_post_hits_Label.frame), self.contentView.width - LeftPadding, 20) starIndex:index starWidth:starWidth space:space defaultImage:nil lightImage:nil isCanTap:NO];
   
    [self.contentView addSubview:starView];
    starView.index=self.index;
    _feliv_Label=[[UILabel alloc]init];
    [_feliv_Label setTextColor:[UIColor whiteColor]];
    _feliv_Label.backgroundColor=kColorFromRGBHex(0x1786e2);
    _feliv_Label.text=@"以放宽";
    _feliv_Label.clipsToBounds=YES;
    _feliv_Label.layer.cornerRadius = 5;
    CGSize size=(CGSize )[UtilTools getTextHeight:@"以放宽" hight:16 font:[UIFont systemFontOfSize:11]];
    [_feliv_Label setFrame:CGRectMake(LeftPadding ,CGRectGetMaxY(starView.frame)+8, size.width+20, 16)];
    _feliv_Label.textAlignment=NSTextAlignmentCenter;
    _feliv_Label.font=[UIFont systemFontOfSize:11];
    [self.contentView addSubview:_feliv_Label];
    
    _comment_Label=[[UILabel alloc]init];
    [_comment_Label setTextColor:[UIColor grayColor]];
    _comment_Label.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
    _comment_Label.numberOfLines=0;
    _comment_Label.text=@"“共享男友”牌子上写着各种项目的标价，除了陪逛街、陪吃饭、陪看电影、陪去K歌，还有“拉手1元/次”“拥抱3元/次”“接吻7元/次”，甚至还有“在前男友前炫耀77元/次”。从标价中可以看出，“共享男友”不同于正常的男女恋爱，而是满足一部分没有异性朋友的需求，以无感情的近距离接触，甚至是肢体上接触，满足个人的虚荣心，或以不正当交友的方式，满足异性感官上和精神上的愉悦与享受。这其实都是很危险的。“共享男友”牌子上写着各种项目的标价，除了陪逛街、陪吃饭、陪看电影、陪去K歌，还有“拉手1元/次”“拥抱3元/次”“接吻7元/次”，甚至还有“在前男友前炫耀77元/次”。从标价中可以看出，“共享男友”不同于正常的男女恋爱，而是满足一部分没有异性朋友的需求，以无感情的近距离接触，甚至是肢体上接触，满足个人的虚荣心，或以不正当交友的方式，满足异性感官上和精神上的愉悦与享受。这其实都是很危险的。“共享男友”牌子上写着各种项目的标价，除了陪逛街、陪吃饭、陪看电影、陪去K歌，还有“拉手1元/次”“拥抱3元/次”“接吻7元/次”，甚至还有“在前男友前炫耀77元/次”。从标价中可以看出，“共享男友”不同于正常的男女恋爱，而是满足一部分没有异性朋友的需求，以无感情的近距离接触，甚至是肢体上接触，满足个人的虚荣心，或以不正当交友的方式，满足异性感官上和精神上的愉悦与享受。这其实都是很危险的。";
    _comment_Label.frame=CGRectMake(LeftPadding ,CGRectGetMaxY(_feliv_Label.frame)+14, WIDTH-LeftPadding*2, [UtilTools getTextViewHeight:_comment_Label.text font:[UIFont systemFontOfSize:13] width:WIDTH]);
    _comment_Label.textAlignment=NSTextAlignmentLeft;
    _comment_Label.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_comment_Label];
    
    
    
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
