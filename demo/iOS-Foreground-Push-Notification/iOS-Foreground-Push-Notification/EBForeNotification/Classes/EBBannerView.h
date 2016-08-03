//
//  EBBannerView.h
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BannerStayTime 4.7
#define BannerSwipeUpTime 0.3
#define BannerSwipeDownTime 0.3


@interface EBBannerView : UIWindow
@property (nonatomic, retain)NSDictionary *userInfo;
@property (nonatomic, assign)BOOL isIos10;
-(void)removeWithAnimation;
@end

static EBBannerView *SharedBannerView;
