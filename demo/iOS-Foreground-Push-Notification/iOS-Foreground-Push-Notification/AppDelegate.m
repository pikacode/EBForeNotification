//
//  AppDelegate.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import "AppDelegate.h"
#import "EBForeNotification.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [EBForeNotification showBannerWithUserInfo:userInfo soundID:1312];
}

//ios7 only
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
    [EBForeNotification showBannerWithUserInfo:userInfo soundID:1312];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerDidClick:) name:EBBannerViewDidClick object:nil];
    
    return YES;
}

-(void)bannerDidClick:(NSNotification*)noti{
    NSLog(@"\nbanner did click,handle userInfo here");
}

@end
