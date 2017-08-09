//
//  AppDelegate.m
//  haitian
//
//  Created by Admin on 2017/4/12.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "LoadSupermarketViewController.h"
#import "FastHandleCardViewController.h"
#import "PersonCenterViewController.h"
#import "BaseNC.h"
#import "RemindViewController.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import <ZMCreditSDK/ALCreditService.h>
#import "LMZXSDK.h"
#import "JishiyuViewController.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#import "AppDelegate+JPush.h"

#import <UMSocialCore/UMSocialCore.h>
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "AdvertiseView.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end
static NSString *USHARE_DEMO_APPKEY = @"5913bac1cae7e74ebe000675";
static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
       self.window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.window.rootViewController=[AppDelegate setTabBarController];

    [self.window makeKeyAndVisible];
#pragma mark 启动广告
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
        
    }
    else
    {
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.image = [UIImage imageNamed:@"LaunchImageDefault"];
        [advertiseView show];
    }
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
    [[ALCreditService sharedService] resgisterApp];
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:NO];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    
    
    //激光推送
    [self registerJPush:application options:launchOptions];
    
    //讯飞人脸识别
    [self makeConfiguration];

    Context.idInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_FOLDER(@"iDInfofile")];
    Context.currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_FOLDER(@"loginedUser")];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLG"]){

            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                               [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],@"idfa",
                               @"1.0.0",@"mac",
                               appNO,@"channel",
                               nil];
            [[NetWorkManager sharedManager]postJSON:[NSString stringWithFormat:@"%@&m=toutiao&a=activate",SERVERE] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                
               
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                
                
            }];

        }
    // Override point for customization after application launch.
    return YES;
}
- (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),
                           *(ptr+3), *(ptr+4), *(ptr+5)];
    
    
    free(buf);
    
    return [outstring uppercaseString];
}

-(void)configUSharePlatforms
{
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105546421"/*设置QQ平台的appID*/  appSecret:@"RNcK0FZOllBAy1bb" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:@"1105546421"/*设置QQ平台的appID*/  appSecret:@"RNcK0FZOllBAy1bb" redirectURL:@"http://mobile.umeng.com/social"];
    //http://www.jishiyu007.com
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
//        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置微信的appKey和appSecret */
    /* 设置微信的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx43b913bd07fb3715" appSecret:@"89d50c49ce0e58ee0d32a66c9b149970" redirectURL:@"http://mobile.umeng.com/social"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
+(UITabBarController *)setTabBarController
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FirstLG"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    HomePageViewController *homepage = [[HomePageViewController alloc] init]; //未处理
    LoadSupermarketViewController *treatVC = [[LoadSupermarketViewController alloc] init]; //已处理
    FastHandleCardViewController *mine=[[FastHandleCardViewController alloc]init];
    RemindViewController *remind=[RemindViewController new];
    PersonCenterViewController *person=[[PersonCenterViewController alloc]init];
    JishiyuViewController *jishiyu=[JishiyuViewController new];
    //步骤2：将视图控制器绑定到导航控制器上
  __unused   BaseNC *nav1C = [[BaseNC alloc] initWithRootViewController:homepage];
    BaseNC *nav2C = [[BaseNC alloc] initWithRootViewController:treatVC];
    BaseNC *nav3C=[[BaseNC alloc]initWithRootViewController:mine];
    BaseNC *nav4C=[[BaseNC alloc]initWithRootViewController:person];
  __unused   BaseNC *nav5C=[[BaseNC alloc]initWithRootViewController:remind];
    BaseNC *nav6C=[[BaseNC alloc]initWithRootViewController:jishiyu];

    
    
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [tabBarController.tabBar insertSubview:barBgView atIndex:0];
    tabBarController.tabBar.opaque = YES;
    
    tabBarController.viewControllers=@[nav6C,nav2C,nav3C,nav4C];
    tabBarController.selectedIndex = 0; //默认选中第几个图标（此步操作在绑定viewControllers数据源之后）
    NSArray *titles = @[@"首页",@"贷款超市",@"快速办卡",@"个人中心"];
    NSArray *images=@[@"HomePage",@"LoadSupermarket",@"FastHandleCard",@"PersonCenter"];
    NSArray *selectedImages=@[@"HomePageHeight",@"LoadSupermarketHeight",@"FastHandleCardHeight",@"PersonCenterHeight"];
    //               NSArray *titles = @[@"简单借款秒借版",@"个人中心",@"设置"];
    //        NSArray *images=@[@"lending",@"Mineing"];
    //         NSArray *selectedImages=@[@"lendingBlue",@"MineingBlue"];
    
    //绑定TabBar数据源
    for (int i = 0; i<tabBarController.tabBar.items.count; i++) {
        UITabBarItem *item = (UITabBarItem *)tabBarController.tabBar.items[i];
        item.title = titles[i];
        item.image = [[UIImage imageNamed:[images objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:[selectedImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabBarController.tabBar.tintColor = kColorFromRGBHex(0xed6c3e);
    }
    return  tabBarController;
}

#pragma mark --- 配置文件
-(void)makeConfiguration
{
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_NONE];
    
    //输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}
#pragma mark 启动广告
/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{
    
    // TODO 请求广告接口
  
    [[NetWorkManager sharedManager]postNoTipJSON:@"http://app.jishiyu11.cn/index.php?g=app&m=app&a=boot" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            NSDictionary *diction=responseObject[@"data"];
            NSString *imageUrl=[NSString stringWithFormat:@"%@%@",IMG_PATH,diction[@"boot_img"]];
            NSString *boot_url=diction[@"boot_url"];
            
            // 获取图片名:43-130P5122Z60-50.jpg
            NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
            NSString *imageName = stringArr.lastObject;
            
            // 拼接沙盒路径
            NSString *filePath = [self getFilePathWithImageName:imageName];
            BOOL isExist = [self isFileExistWithFilePath:filePath];
            if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
                
                [self downloadAdImageWithUrl:imageUrl imageName:imageName];
                
            }

            [kUserDefaults setValue:boot_url forKey:adUrl];
            [kUserDefaults synchronize];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];


    
}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}
/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
