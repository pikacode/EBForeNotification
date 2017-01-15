//
//  EBBannerView.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 0/7/21.
//  Copyright © 200年 57300022@qq.com. All rights reserved.
//

#import "EBBannerView.h"
#import "EBForeNotification.h"
#import "UILabel+EBCategory.h"

@interface EBBannerView()
@property (weak, nonatomic) IBOutlet UIImageView *icon_image;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *content_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UIView *line_view;
@property (weak, nonatomic) IBOutlet UIView *mask_view;
@property(nonatomic, assign)BOOL isRemoved;
@end

static EBBannerView *SharedBannerView;

@implementation EBBannerView

#define BannerHeight 70
#define BannerHeightIos10 92

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define IsiOS10 [[UIDevice currentDevice].systemVersion floatValue] >= 10.0

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self addGestureRecognizer];
    self.windowLevel = UIWindowLevelAlert;
}

-(void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = userInfo;

    UIWindow * originWindow = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    UIViewController *controller = [EBBannerView appRootViewController];
    [controller.view addSubview:self];

    //icon
    UIImage *appIcon = [UIImage imageNamed:@"AppIcon60x60"];
    if (!appIcon) {
        appIcon = [UIImage imageNamed:@"AppIcon80x80"];
    }
    [self.icon_image setImage:appIcon];

    //app name
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    //appName = @"input a app name here"; //if appName = nil, unsign this line and change it to you'r own app name.
    if (!appName) {
        assert(0);
    }
    self.title_label.text = appName;

    //content
    NSString *alert;
    if ([self.userInfo[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
        alert = self.userInfo[@"aps"][@"alert"];
    }else{
        @try {
            alert = self.userInfo[@"aps"][@"alert"][@"body"];
        } @catch (NSException *exception) {

        } @finally {

            if (!alert) {
                @try {
                    alert = self.userInfo[@"aps"][@"alert"][@"title"];
                } @catch (NSException *exception) {

                } @finally {

                    if (!alert) {
                        @try {
                            alert = self.userInfo[@"aps"][@"alert"][@"subtitle"];
                        } @catch (NSException *exception) {

                        }
                    }
                    
                }
            }
            
        }
    }
    self.content_label.text = alert;
    self.time_label.text    = EBBannerViewTimeText;
    [originWindow makeKeyAndVisible];
    [self appearWithAnimation];
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
    if (!self.line_view.hidden) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
            CGFloat originHeight = 0;
            if (originHeight == 0) {
                originHeight = self.content_label.frame.size.height;
            }
            CGFloat caculatedHeight = [self.content_label caculatedSize].height;
            WEAK_SELF(weakSelf);
            [UIView animateWithDuration:BannerSwipeDownTime animations:^{
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, (IsiOS10 ? BannerHeightIos10 : BannerHeight) + caculatedHeight - originHeight);
            } completion:^(BOOL finished) {
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, (IsiOS10 ? BannerHeightIos10 : BannerHeight) + caculatedHeight - originHeight);
            }];
        }
    }
}

-(void)appearWithAnimation{
    CGFloat originHeight = self.content_label.frame.size.height;
    CGFloat caculatedHeight = [self.content_label caculatedSize].height;
    if (caculatedHeight <= originHeight + 1) {
        self.line_view.hidden = YES;
    }
    self.frame = CGRectMake(0, 0, ScreenWidth, 0);
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:BannerSwipeUpTime animations:^{
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, IsiOS10 ? BannerHeightIos10 : BannerHeight);
    } completion:^(BOOL finished) {
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, IsiOS10 ? BannerHeightIos10 : BannerHeight);
    }];
    [NSTimer scheduledTimerWithTimeInterval:BannerStayTime target:self selector:@selector(removeWithAnimation) userInfo:nil repeats:NO];
}

-(void)removeWithAnimation{
    if (self.isRemoved) {

    } else {
        self.isRemoved = YES;
         [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        WEAK_SELF(weakSelf);
        [UIView animateWithDuration:BannerSwipeUpTime animations:^{
            weakSelf.frame = CGRectMake(0, 0, ScreenWidth, 0);
        } completion:^(BOOL finished) {
            weakSelf.frame = CGRectMake(0, 0, ScreenWidth, 0);
        }];
    }
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
