//
//  ViewController.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import "ViewController.h"
#import "EBForeNotification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aaaaaa) userInfo:nil repeats:NO];
}

-(void)aaaaaa{
    [EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"皮卡丘:Hi 小智，一起去冒险吧！"}} soundID:1312];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
