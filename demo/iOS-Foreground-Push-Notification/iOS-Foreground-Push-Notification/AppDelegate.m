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
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:YES];
}

//ios7 only
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:YES];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dddd:) name:EBBannerViewDidClick object:nil];
    
    return YES;
}

-(void)dddd:(NSNotification*)noti{
    NSLog(@"ddd,%@",noti);
}

@end
