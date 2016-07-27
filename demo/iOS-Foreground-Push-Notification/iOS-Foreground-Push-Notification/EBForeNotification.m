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
#import "UIViewController+EBForeNotification.h"

NSString *const EBBannerViewDidClick = @"EBBannerViewDidClick";

@implementation EBForeNotification

#pragma mark - public

+(void)handleRemoteNotification:(NSDictionary*)userInfo soundID:(int)soundID{
    if (userInfo) {
        [EBBannerView class];
        id aps = [userInfo valueForKey:@"aps"];
        if (aps && [aps isKindOfClass:[NSDictionary class]] && [aps valueForKey:@"alert"] && ![[aps valueForKey:@"alert"] isEqual: @""]) {
            [EBForeNotification showBannerWithUserInfo:userInfo soundID:soundID];
        }
    }
}

+(void)handleRemoteNotification:(NSDictionary*)userInfo customSound:(NSString*)soundName{
    if (soundName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        SystemSoundID soundID = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [EBForeNotification handleRemoteNotification:userInfo soundID:soundID];
    }
}

#pragma mark - private

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo soundID:(int)soundID{
    if (soundID) {
        AudioServicesPlaySystemSound(soundID);
    }
    if (SharedBannerView) {
        SharedBannerView = nil;
    }
    SharedBannerView = [[NSBundle mainBundle] loadNibNamed:@"EBBannerView" owner:nil options:nil].lastObject;
    UIViewController *controller = [EBForeNotification appRootViewController];
    SharedBannerView.userInfo = userInfo;
    [controller.view addSubview:SharedBannerView];
    [NSTimer scheduledTimerWithTimeInterval:BannerStayTime target:self selector:@selector(deleteBanner) userInfo:nil repeats:NO];
}

+(UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+(void)deleteBanner{
    if (SharedBannerView) {
        [SharedBannerView removeWithAnimation];
    }
}

@end
