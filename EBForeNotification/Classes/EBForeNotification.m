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

NSString *const EBBannerViewDidClick = @"EBBannerViewDidClick";

@implementation EBForeNotification

#pragma mark - public

+(void)handleRemoteNotification:(NSDictionary*)userInfo soundID:(int)soundID{
    [EBForeNotification handleRemoteNotification:userInfo soundID:soundID isIos10:NO];
}

+(void)handleRemoteNotification:(NSDictionary*)userInfo customSound:(NSString*)soundName{
    [EBForeNotification handleRemoteNotification:userInfo customSound:soundName isIos10:NO];
}

+(void)handleRemoteNotification:(NSDictionary*)userInfo customSound:(NSString*)soundName isIos10:(BOOL)isIos10{
    if (soundName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        SystemSoundID soundID = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [EBForeNotification handleRemoteNotification:userInfo soundID:soundID isIos10:isIos10];
    }
}

+(void)handleRemoteNotification:(NSDictionary*)userInfo soundID:(int)soundID isIos10:(BOOL)isIos10{
    if (userInfo) {
        id aps = [userInfo valueForKey:@"aps"];
        if (aps && [aps isKindOfClass:[NSDictionary class]] && [aps valueForKey:@"alert"] && ![[aps valueForKey:@"alert"] isEqual: @""]) {
            [EBForeNotification showBannerWithUserInfo:userInfo soundID:soundID isIos10:isIos10];
        }
    }
}

#pragma mark - private

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo soundID:(int)soundID isIos10:(BOOL)isIos10{
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
    NSArray *banners = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"EBBannerView" owner:nil options:nil];
    if (isIos10) {
        SharedBannerView = banners[1];
    }else{
        SharedBannerView = banners[0];
    }
    [SharedBannerView makeKeyAndVisible];
    UIViewController *controller = [EBForeNotification appRootViewController];
    SharedBannerView.isIos10 = isIos10;
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
