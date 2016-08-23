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
    [EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"皮卡丘: Hi 小智，一起去冒险吧! 住在森林中的它们通常以树果为食。它们用小小的电击把树果从树上打下来，这样就不必爬树，还可以顺带将其烤熟。作为宠物，它可以用各种各样的加工食物来喂养。此外，与大多数神奇宝贝一样，皮卡丘可以忍受大多数人造的食品，有时还会喜欢它们胜过自然的食品，如果这些人造食品是针对它的口味设计的话。一个很好的例子就是小智的皮卡丘特别喜欢番茄酱。皮卡丘偶尔也会吃苹果。"}} soundID:1312 isIos10:NO];

//[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"皮卡丘: Hi 小智，一起去冒险吧!"}} soundID:1312 isIos10:NO];



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
