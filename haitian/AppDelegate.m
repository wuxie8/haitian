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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self.window makeKeyAndVisible];
    
    self.window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    
    self.window.rootViewController=[AppDelegate setTabBarController];
    // Override point for customization after application launch.
    return YES;
}
+(UITabBarController *)setTabBarController
{
    
    
    HomePageViewController *homepage = [[HomePageViewController alloc] init]; //未处理
    LoadSupermarketViewController *treatVC = [[LoadSupermarketViewController alloc] init]; //已处理
    FastHandleCardViewController *mine=[[FastHandleCardViewController alloc]init];
    PersonCenterViewController *person=[[PersonCenterViewController alloc]init];
    
    //步骤2：将视图控制器绑定到导航控制器上
    BaseNC *nav1C = [[BaseNC alloc] initWithRootViewController:homepage];
    BaseNC *nav2C = [[BaseNC alloc] initWithRootViewController:treatVC];
    BaseNC *nav3C=[[BaseNC alloc]initWithRootViewController:mine];
    BaseNC *nav4C=[[BaseNC alloc]initWithRootViewController:person];

    
    
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [tabBarController.tabBar insertSubview:barBgView atIndex:0];
    tabBarController.tabBar.opaque = YES;
    
    tabBarController.viewControllers=@[nav1C,nav2C,nav3C,nav4C];
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
