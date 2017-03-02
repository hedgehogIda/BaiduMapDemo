//
//  AppDelegate.h
//  location
//
//  Created by 腾实信 on 2017/2/10.
//  Copyright © 2017年 ida. All rights reserved.
//   KYSsHYGGjEq3MTfwxac85Yo8rIIRzWUQ

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件



@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
    {
        UINavigationController *navigationController;
        BMKMapManager* _mapManager;
    }
@property (strong, nonatomic) UIWindow *window;
@end

