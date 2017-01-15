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
#define IsiOS10 (int)([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)

@implementation EBForeNotification

+(void)setBannerViewTimeText:(NSString*)timeText {
    EBBannerViewTimeText = timeText;
}

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo soundID:(int)soundID{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [[EBMuteDetector sharedDetecotr] detectCompletion:^(BOOL isMute) {
            if (isMute) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }else{
                if (SharedSoundName) {
                    NSURL *url = [[NSBundle mainBundle] URLForResource:SharedSoundName withExtension:nil];
                    SystemSoundID newSoundID;
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &newSoundID);
                    AudioServicesPlaySystemSound(newSoundID);
                    SharedSoundName = nil;
                }else{
                    AudioServicesPlaySystemSound(soundID);
                }
            }
        }];
        EBBannerView *bannerView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([EBBannerView class]) owner:nil options:nil][IsiOS10];
        bannerView.userInfo = userInfo;
    }
}

static NSString *SharedSoundName;

+(void)showBannerWithUserInfo:(NSDictionary*)userInfo customSound:(NSString*)soundName{
    SharedSoundName = soundName;
    [EBForeNotification showBannerWithUserInfo:userInfo soundID:1312];
}

@end
