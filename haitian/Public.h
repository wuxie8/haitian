//
//  Public.h
//  xiaoyixiu
//
//  Created by 柯南 on 16/6/12.
//  Copyright © 2016年 柯南. All rights reserved.
//

#ifndef Public_h
#define Public_h

#pragma mark Log

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"%s <第%d行> %@",__FUNCTION__,  __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif
#ifndef __OPTIMIZE__
#define NSLog(...) printf(" %s\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif
#pragma mark ScreenWH

#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define Rect(x,y,w,h)  CGRectMake(x*WIDTH/1242, y*HEIGHT/2208, w*WIDTH/1242, h*HEIGHT/2208)

#pragma mark Color

#define kColorFromARGBHex(value,a) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:a] //a:透明度
#define kColorFromRGBHex(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
#define kColorFromRGB(r,g,b) [UIColor colorWithRed:(float)r /255.0 green:(float)g /255.0 blue:(float)b /255.0 alpha:1.0]

#define AppPageColor kColorFromRGB(235,235,241)  //灰色
#define AppThemeBackColor [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1]
#define AppBackColor [UIColor colorWithRed:10.0/255 green:96.0/255 blue:254.0/255 alpha:1]
#define AppButtonbackgroundColor kColorFromRGBHex(0x4e72a5)//app  按钮颜色
#define AppThemeColor kColorFromRGBHex(0xFCAA1B)//
#define BaseColor kColorFromRGBHex(0xF3F3F3)  //app  底色
#define PageColor kColorFromRGB(186,186,186)
#define LineColor kColorFromRGBHex(0xafafaf)
#define fontLightGray kColorFromRGBHex(0xc6c6c6)
#define TableViewBGcolor kColorFromRGBHex(0xECECEC)
#define FontBlack kColorFromRGBHex(0x646464)
#define RedBackGround kColorFromRGBHex(0xFF4D4D)

#define SettlementButtonColor kColorFromRGBHex(0xFA822E)//结算栏按钮
#define SettlementBackgroundColor kColorFromRGBHex(0xF8F8F8)//结算栏背景

#define CouponBackgroundColor kColorFromRGBHex(0xBA0711)//优惠券背景
#define CouponTitleFontColor kColorFromRGBHex(0x363636) //优惠券标题
#define CouponContentFontColor kColorFromRGBHex(0x959595)//优惠券内容
#define CouponAmountFontColor kColorFromRGBHex(0xD9112E)//优惠券金额

#pragma mark 系统文件位置

#define DOCUMENT_FOLDER(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName]
#define CACHE_FOLDER(fileName) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]

#define WS(weakSelf) __weak typeof(self) weakSelf = self


#pragma mark 其它

#define Context [UserInfoContext sharedContext]

#endif /* Public_h */