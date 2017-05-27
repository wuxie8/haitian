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
#import "UMessage.h"
#import "LMZXSDK.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

#import "AppDelegate+JPush.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //激光推送
    [self registerJPush:application options:launchOptions];
    
    //立木正信
    [LMZXSDK registerLMZXSDK];
    [[LMZXSDK shared] unlockLog];

   //友盟推送
    [self umessageinit:launchOptions];
   //讯飞人脸识别
   [self makeConfiguration];
    
    [self.window makeKeyAndVisible];
    [[ALCreditService sharedService] resgisterApp];

    self.window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    Context.idInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:DOCUMENT_FOLDER(@"iDInfofile")];
   
    self.window.rootViewController=[AppDelegate setTabBarController];
    [self.window  makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

-(void)umessageinit:(NSDictionary *)launchOptions
{
    //标签
    [UMessage addTag:@"男"
            response:^(id responseObject, NSInteger remain, NSError *error) {
                //add your codes
            }];
    [UMessage startWithAppkey:@"5913bac1cae7e74ebe000675" launchOptions:launchOptions httpsEnable:YES ];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    
}
+(UITabBarController *)setTabBarController
{
    
    
    HomePageViewController *homepage = [[HomePageViewController alloc] init]; //未处理
    LoadSupermarketViewController *treatVC = [[LoadSupermarketViewController alloc] init]; //已处理
    FastHandleCardViewController *mine=[[FastHandleCardViewController alloc]init];
    RemindViewController *remind=[RemindViewController new];
    PersonCenterViewController *person=[[PersonCenterViewController alloc]init];
    
    //步骤2：将视图控制器绑定到导航控制器上
 __unused   BaseNC *nav1C = [[BaseNC alloc] initWithRootViewController:homepage];
    BaseNC *nav2C = [[BaseNC alloc] initWithRootViewController:treatVC];
    BaseNC *nav3C=[[BaseNC alloc]initWithRootViewController:mine];
    BaseNC *nav4C=[[BaseNC alloc]initWithRootViewController:person];
    BaseNC *nav5C=[[BaseNC alloc]initWithRootViewController:remind];

    
    
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [tabBarController.tabBar insertSubview:barBgView atIndex:0];
    tabBarController.tabBar.opaque = YES;
    
    tabBarController.viewControllers=@[nav5C,nav2C,nav3C,nav4C];
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
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
    
    //下面这句代码只是在demo中，供页面传值使用。
//    [self postTestParams:[self stringDevicetoken:deviceToken] idfa:[self idfa] openudid:[self openUDID]];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }

//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [ud setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"UMPuserInfoNotification"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10以后接收的方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage didReceiveRemoteNotification:userInfo];
        if([response.actionIdentifier isEqualToString:@"123"])
        {
            
        }else
        {
            
            
        }
        //这个方法用来做action点击的统计
        [UMessage sendClickReportForRemoteNotification:userInfo];
        
        
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
