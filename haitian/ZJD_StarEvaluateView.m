//
//  ZJD_StarEvaluateView.m
//  KFXX
//
//  Created by aidong on 16/3/19.
//  Copyright © 2016年 aidong. All rights reserved.
//

#import "ZJD_StarEvaluateView.h"

@implementation ZJD_StarEvaluateView

// 默认有五个星星
- (instancetype)initWithFrame:(CGRect)frame
                    starIndex:(NSInteger)index
                    starWidth:(CGFloat)starWidth
                        space:(CGFloat)space
                 defaultImage:(UIImage *)defaultImage
                   lightImage:(UIImage *)lightImage
                     isCanTap:(BOOL)isCanTap{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        if (defaultImage) {
            self.defaultImage = defaultImage;
        } else {
            self.defaultImage = [UIImage imageNamed:@"五星评价_灰"];
        }
        
        if (lightImage) {
            self.lightImage = lightImage;
        } else {
            self.lightImage = [UIImage imageNamed:@"五星评价_黄"];
        }
        
        for (NSInteger j = 0; j < 5; j++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(j* (starWidth + space), 0, starWidth, self.height)];
            
            btn.enabled = isCanTap;
            btn.tag = j + 1;
            [btn addTarget:self action:@selector(starTapBtn:) forControlEvents:UIControlEventTouchUpInside];
            // 上左下右 星星居中
            btn.imageView.contentMode=UIViewContentModeScaleAspectFill;
            btn.imageView.clipsToBounds = YES;

//            [btn setImageEdgeInsets:UIEdgeInsetsMake((self.height - starWidth)/2, 0, (self.height - starWidth)/2, 0)];
            if (j < index) {
//                btn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
                [btn setBackgroundImage:self.lightImage forState:UIControlStateNormal];
            } else {
                [btn setBackgroundImage:self.defaultImage forState:UIControlStateNormal];
            }
            [self addSubview:btn];
            
            // self.width
            self.width = (starWidth + space) * 5;
        }
    }
    return self;
}
-(void)setIndex:(NSInteger)index
{
    for (NSInteger i = 1; i <= 5; i++) {
        UIButton *starBtn = (UIButton *)[self viewWithTag:i];
        if (i <= index) {
            [starBtn setBackgroundImage:self.lightImage forState:UIControlStateNormal];
        } else {
            [starBtn setBackgroundImage:self.defaultImage forState:UIControlStateNormal];
        }
    }
}
- (void)starTapBtn:(UIButton *)btn{
    
    for (NSInteger i = 1; i <= 5; i++) {
        UIButton *starBtn = (UIButton *)[self viewWithTag:i];
        if (i <= btn.tag) {
            [starBtn setBackgroundImage:self.lightImage forState:UIControlStateNormal];
        } else {
            [starBtn setBackgroundImage:self.defaultImage forState:UIControlStateNormal];
        }
    }
    
    if (self.starEvaluateBlock) {
        self.starEvaluateBlock(self,btn.tag);
    }
}

@end

