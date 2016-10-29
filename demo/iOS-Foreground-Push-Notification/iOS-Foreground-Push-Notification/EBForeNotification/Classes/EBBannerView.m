//
//  EBBannerView.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 0/7/21.
//  Copyright © 200年 57300022@qq.com. All rights reserved.
//

#import "EBBannerView.h"
#import "EBForeNotification.h"
#import "UIImage+ColorAtPoint.h"
#import "UILabel+ContentSize.h"

@interface EBBannerView()
@property (weak, nonatomic) IBOutlet UIImageView *icon_image;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *content_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UIView *line_view;
@property (weak, nonatomic) IBOutlet UIView *mask_view;
@property (nonatomic, assign)BOOL isDownSwiped;
@end

@implementation EBBannerView

#define BannerHeight 70
#define BannerHeightiOS10 90
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

UIWindow *originWindow;

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self addGestureRecognizer];
    self.windowLevel = UIWindowLevelAlert;
    originWindow = [UIApplication sharedApplication].keyWindow;
    if (self.tag == 2) {
        //corner
        self.mask_view.layer.masksToBounds = YES;
        self.mask_view.layer.cornerRadius  = 10;
        self.mask_view.clipsToBounds       = YES;
        //shadow
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;

        self.mask_view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.mask_view.layer.shadowOffset = CGSizeMake(0,0);
        self.mask_view.layer.shadowOpacity = 1;
        self.mask_view.layer.shadowRadius = 5;
        self.mask_view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.mask_view.bounds cornerRadius:10].CGPath;
    }
}

-(void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = userInfo;
    UIImage *appIcon;
    appIcon = [UIImage imageNamed:@"AppIcon60x60"];
    if (!appIcon) {
        appIcon = [UIImage imageNamed:@"AppIcon80x80"];
    }
    [self.icon_image setImage:appIcon];
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[self class]] infoDictionary];
    // app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    //appName = @"input a app name here"; //if appName = nil, unsign this line and change it to you'r own app name.
    if (!appName) {
        assert(0);
    }
    self.title_label.text   = appName;
    self.content_label.text = self.userInfo[@"aps"][@"alert"];
    self.time_label.text = EBBannerViewTimeText;
    [originWindow makeKeyAndVisible];
    if (!self.isIos10) {
        self.time_label.textColor      = [UIImage colorAtPoint:self.time_label.center];
        self.time_label.alpha = 0.7;
        CGPoint lineCenter = self.line_view.center;
        self.line_view.backgroundColor = [UIImage colorAtPoint:CGPointMake(lineCenter.x, lineCenter.y - 7)];
        self.line_view.alpha = 0.5;
    }
    [self apperWithAnimation];
}

-(void)statusBarOrientationChange:(NSNotification *)notification{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 77);
}

-(void)addGestureRecognizer{
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpGesture:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUpGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];

    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGesture:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDownGesture];
}

-(void)tapGesture:(UITapGestureRecognizer*)tapGesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:EBBannerViewDidClick object:self.userInfo];
    [self removeWithAnimation];
}

-(void)swipeUpGesture:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        [self removeWithAnimation];
    }
}

-(void)swipeDownGesture:(UISwipeGestureRecognizer*)gesture{
    if (!self.isIos10) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
            CGFloat originHeight = 0;
            self.isDownSwiped = YES;
            if (originHeight == 0) {
                originHeight = self.content_label.frame.size.height;
            }
            CGFloat caculatedHeight = [self.content_label caculatedSize].height;
            WEAK_SELF(weakSelf);
            [UIView animateWithDuration:BannerSwipeDownTime animations:^{
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, BannerHeight + caculatedHeight - originHeight);
            } completion:^(BOOL finished) {
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, BannerHeight + caculatedHeight - originHeight);
            }];
        }
    }
}

-(void)apperWithAnimation{
    CGFloat bannerHeight = self.isIos10 ? BannerHeightiOS10 : BannerHeight;
    self.frame = CGRectMake(0, 0, ScreenWidth, 0);
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:BannerSwipeUpTime animations:^{
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, bannerHeight);
    } completion:^(BOOL finished) {
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, bannerHeight);
    }];
    [NSTimer scheduledTimerWithTimeInterval:BannerStayTime target:self selector:@selector(removeWithAnimation) userInfo:nil repeats:NO];
}

-(void)removeWithAnimation{
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:BannerSwipeUpTime animations:^{
        for (UIView *view in weakSelf.subviews) {
            CGRect frame = view.frame;
            [view removeConstraints:view.constraints];
            view.frame = frame;
        }
        [weakSelf removeConstraints:self.constraints];
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, 0);
    } completion:^(BOOL finished) {
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, 0);
        [weakSelf removeFromSuperview];
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            if ([window isKindOfClass:[EBBannerView class]]) {
                window.hidden = YES;
                [window resignKeyWindow];
                [window removeFromSuperview];
            }
        }
        SharedBannerView = nil;
    }];
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
