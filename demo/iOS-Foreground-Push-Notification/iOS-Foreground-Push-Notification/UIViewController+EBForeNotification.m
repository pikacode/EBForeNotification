//
//  UIViewController+EBForeNotification.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import "UIViewController+EBForeNotification.h"
#import <objc/runtime.h>

@implementation UIViewController (EBForeNotification)

static BOOL _EBForegroundNotificationStatusBarHidden;

- (void)setEBForegroundNotificationStatusBarHidden:(BOOL)EBForegroundNotificationStatusBarHidden{
    NSNumber *t = @(EBForegroundNotificationStatusBarHidden);
    objc_setAssociatedObject(self, &_EBForegroundNotificationStatusBarHidden, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)EBForegroundNotificationStatusBarHidden{
    NSNumber *t = objc_getAssociatedObject(self, &_EBForegroundNotificationStatusBarHidden);
    return [t boolValue];
}

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
-(BOOL)prefersStatusBarHidden{
    return self.EBForegroundNotificationStatusBarHidden;
}

@end
 
