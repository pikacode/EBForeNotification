//
//  EBBannerView.h
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BannerStayTime 4.7
#define BannerAnimationTime 0.3

@interface EBBannerView : UIWindow
@property (nonatomic, retain)NSDictionary *userInfo;
-(void)removeWithAnimation;
@end

static EBBannerView *SharedBannerView;
