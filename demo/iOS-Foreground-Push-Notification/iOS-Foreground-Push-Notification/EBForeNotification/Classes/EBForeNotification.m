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
#import "EBMuteDetector.h"

NSString *const EBBannerViewDidClick = @"EBBannerViewDidClick";
NSString *EBBannerViewTimeText = @"现在";    //默认弹窗时间 default banner time

@interface EBForeNotification ()

@end

@implementation EBForeNotification

#pragma mark - public

+(void)setBannerViewTimeText:(NSString*)timeText {
    EBBannerViewTimeText = timeText;
}

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo soundID:(int)soundID{
    EBBannerView *bannerView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([EBBannerView class]) owner:nil options:nil][0];
    [EBForeNotification showBannerWithUserInfo:userInfo customBanner:bannerView soundID:soundID];
}

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo customSound:(NSString*)soundName{
    EBBannerView *bannerView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([EBBannerView class]) owner:nil options:nil][0];
    [EBForeNotification showBannerWithUserInfo:userInfo customBanner:bannerView customSound:soundName];
}

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo customBanner:(EBBannerView*)banner customSound:(NSString*)soundName{
    if (soundName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        SystemSoundID soundID = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [EBForeNotification showBannerWithUserInfo:userInfo customBanner:banner soundID:soundID];
    }
}

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo customBanner:(EBBannerView*)banner soundID:(int)soundID{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (soundID) {
            [[EBMuteDetector sharedDetecotr] detectComplete:^(BOOL isMute) {
                if (isMute) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }else{
                    AudioServicesPlaySystemSound(soundID);
                }
            }];
        }
        banner.userInfo = userInfo;
    }
}

@end
