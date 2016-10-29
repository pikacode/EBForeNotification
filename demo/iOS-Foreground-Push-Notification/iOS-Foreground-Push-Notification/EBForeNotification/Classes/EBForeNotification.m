//
//  EBForeNotification.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import "EBForeNotification.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "EBBannerView.h"
#import "UIImage+ColorAtPoint.h"
#import "EBMuteDetector.h"
#import <UserNotifications/UserNotifications.h>

NSString *const EBBannerViewDidClick = @"EBBannerViewDidClick";

static BOOL ShowBannerInIos10 = NO;

#define IsiOS10 [[UIDevice currentDevice].systemVersion floatValue] >= 10.0

@interface EBForeNotification ()<UNUserNotificationCenterDelegate>

@end

@implementation EBForeNotification

#pragma mark - public

+(void)handleRemoteNotification:(NSDictionary*)userInfo customSound:(NSString*)soundName{
    if (soundName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        SystemSoundID soundID = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [EBForeNotification handleRemoteNotification:userInfo soundID:soundID];
    }
}

+(void)handleRemoteNotification:(NSDictionary*)userInfo soundID:(int)soundID{
    if (userInfo) {
        id aps = [userInfo valueForKey:@"aps"];
        if (aps && [aps isKindOfClass:[NSDictionary class]] && [aps valueForKey:@"alert"] && ![[aps valueForKey:@"alert"] isEqual: @""]) {
            //判断程序在前台
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                if (IsiOS10) {
                    ShowBannerInIos10 = YES;
                    [EBForeNotification showBannerWhenIos10];
                }else{
                    [EBForeNotification showBannerWithUserInfo:userInfo soundID:soundID];
                }
            }
        }
    }
}

#pragma mark - private

+(void)showBannerWhenIos10{
    ShowBannerInIos10 = YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    if (ShowBannerInIos10) {
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
        ShowBannerInIos10 = NO;
    }else{
        completionHandler(-1);
    }
}

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo soundID:(int)soundID{
    if (soundID) {
        [[EBMuteDetector sharedDetecotr] detectComplete:^(BOOL isMute) {
            if (isMute) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }else{
                AudioServicesPlaySystemSound(soundID);
            }
        }];
    }
    if (SharedBannerView) {
        SharedBannerView = nil;
    }
    SharedBannerView = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"EBBannerView" owner:nil options:nil][0];
    [SharedBannerView makeKeyAndVisible];
    UIViewController *controller = [EBForeNotification appRootViewController];
    SharedBannerView.userInfo = userInfo;
    [controller.view addSubview:SharedBannerView];
}

+(UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
