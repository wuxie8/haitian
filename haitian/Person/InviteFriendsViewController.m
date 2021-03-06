//
//  InviteFriendsViewController.m
//  haitian
//
//  Created by Admin on 2017/7/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
@interface InviteFriendsViewController ()<UMSocialShareMenuViewDelegate>


@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"邀请好友";
    self.view.backgroundColor=kColorFromRGBHex(0x3ea2e5);
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 500)];
    [image setImage:[UIImage imageNamed:@"backgroundImageView"]];
    [self.view addSubview:image];
    
    UIButton *but=[[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(image.frame)+40, WIDTH-20, 60)];
    [but setImage:[UIImage imageNamed:@"ImmediatelyInvited"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(ShareFriendsClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    // Do any additional setup after loading the view.
}
-(void)ShareFriendsClick
{
    NSMutableArray *array=[NSMutableArray array];
    if (  [[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]) {
        [array addObject:@(UMSocialPlatformType_QQ)];
    }
    if (  [[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_Qzone]) {
        [array addObject:@(UMSocialPlatformType_Qzone)];
    }
    if (  [[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession]) {
        [array addObject:@(UMSocialPlatformType_WechatSession)];
    }
    if (  [[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatTimeLine]) {
        [array addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
    [UMSocialUIManager setPreDefinePlatforms:array];
    
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
#ifdef UM_Swift
    [UMSocialSwiftInterface showShareMenuViewInWindowWithPlatformSelectionBlockWithSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary* userInfo) {
#else
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
#endif
            
            [self shareTextToPlatformType:platformType];
            
        }];
    }
     - (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
     {
         [[NetWorkManager sharedManager]postNoTipJSON:[NSString stringWithFormat:@"%@&m=userinfo&a=share",SERVERE] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             if([responseObject[@"code"] isEqualToString:@"0000"])
             {
                 NSDictionary *dic=responseObject[@"data"];
                 //创建分享消息对象
                 UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                 NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMG_PATH,dic[@"bg_img"]]];
                 UIImage * result;
                 NSData * data = [NSData dataWithContentsOfURL:url];
                 
                 result = [UIImage imageWithData:data];
                 
                                  //创建网页内容对象
                 UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dic[@"share_title"] descr:dic[@"share_content"] thumImage:result];
                 if([[NSUserDefaults standardUserDefaults] boolForKey:@"review"])
                 {
                     //设置网页地址
                     shareObject.webpageUrl =@"http://app.jishiyu11.cn:88/download/?id=1239285391";
                 }
                 shareObject.webpageUrl =@"http://app.jishiyu11.cn:88/download/?id=1261291024";
                 
                 //分享消息对象设置分享内容对象
                 messageObject.shareObject = shareObject;
                 
                 //调用分享接口
                 [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                     if (error) {
                         DLog(@"%@",error);
                     }else{
                         [MessageAlertView showSuccessMessage:@"分享成功"];
                     }
                 }];

             }
            
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             DLog(@"%@",error);
             
         }];

             }
     - (void)didReceiveMemoryWarning {
         [super didReceiveMemoryWarning];
         // Dispose of any resources that can be recreated.
     }
     
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
     
     @end
