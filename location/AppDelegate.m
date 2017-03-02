//
//  AppDelegate.m
//  location
//
//  Created by 腾实信 on 2017/2/10.
//  Copyright © 2017年 ida. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "BNCoreServices.h"

#define ak @"KYSsHYGGjEq3MTfwxac85Yo8rIIRzWUQ"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
     // 如果要关注网络及授权验证事件，请设定
    BOOL ret = [_mapManager start:@"KYSsHYGGjEq3MTfwxac85Yo8rIIRzWUQ" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    [[BNCoreServices GetInstance]initServices:@"KYSsHYGGjEq3MTfwxac85Yo8rIIRzWUQ"];
    [[BNCoreServices GetInstance] startServicesAsyn:^{
        NSLog(@"导航授权成功");
    } fail:^{
        NSLog(@"导航授权失败");
    }];

    [self.window makeKeyAndVisible];
    return YES;
    
   
}

    //网络检查
- (void)onGetNetworkState:(int)iError
    {
        if (iError) {
            NSLog(@"%d", iError);
        } else {
            NSLog(@"网络连接成功");
        }
    }
    
- (void)onGetPermissionState:(int)iError
    {
        if (iError) {
            NSLog(@"授权错误%d", iError);
        } else {
            NSLog(@"授权状态");
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
