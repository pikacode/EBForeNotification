查看中文文档 [Chinese README.md](/README_CHS.md)

Email：pikacode@qq.com

# EBForeNotification
Show the `Banners` and `Sounds` as the same as the system notifications on foreground. Get notification content and Handle click event.

Support iOS 7~10 beta, support both simulator & iPhone build.

## New Feature
- swipe down gesture
- iOS 10 banner style，example（iOS 10 style not support `swipe down gesture` and `multi-line` yet）：

  ```objc
  [EBForeNotification handleRemoteNotification:userInfo soundID:soundID isIos10:YES];
  }

  [EBForeNotification handleRemoteNotification:userInfo customSound:soundName isIos10:YES];
  ```

## Display
- The same UI with the system banner & sound
- Auto get App name & App icon
- Auto hide systm Status Bar and show
- `time` & `drag leg` are the same color with current background
- click gesture & handle it with notification info
- swipe up gesture
- swipe down gesture

Actual effect：
- iOS 10 before style

  ![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot01.gif)

- iOS 10 style

  ![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot02.gif)

## Install
### pod
	platform :ios, '7.0'

	target 'YourTargetName' do
		pod 'EBForeNotification'
	end

### manual	
Download and Drag `EBForeNotification` file folder into you Xcode project.

## Native Banner
Call any 1 method below can show a banner on the frontest controller.
```objc
#import "EBForeNotification.h"
{...
//show a system sound banner
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"banner content"}} soundID:1312];

//show a cunstom sound banner
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"banner content"}} customSound:@"my_sound.wav"];

//show a system sound banner with extra keys/values
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"banner content"}, @"key1":@"value1", @"key2":@"value2"} soundID:1312];

//show a cunstom sound banner with extra keys/values
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"banner content"}, @"key1":@"value1", @"key2":@"value2"} customSound:@"my_sound.wav"];
...}
```

## Handle Remote/Local Notification
When received, will show a banner & sound on foreground automatic.

Call method in `AppDelegate.m`

```objc
//AppDelegate.m
#import "EBForeNotification.h"

//ios7 before
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo { 
	...
	//show a system sound banner
	[EBForeNotification handleRemoteNotification:userInfo soundID:1312];

	//show a cunstom sound banner
	[EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    ...
}

//ios7 later  
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
	...
	//show a system sound banner
	[EBForeNotification handleRemoteNotification:userInfo soundID:1312];

	//show a cunstom sound banner
	[EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    ...
    completionHandler(UIBackgroundFetchResultNewData);
}
```

## Parma: soundID
Is iOS system sound id, default push notification sound "Tritone" is 1312

More sound id to see here [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#)
or here [AudioServices sounds](http://www.cocoachina.com/bbs/read.php?tid=134344)

You can download all the system sounds [UISounds.zip](/UISounds.zip) , listen and choose one which you perfer, then check out it's `id` with the form above

## Listen Click
Add observer for `EBBannerViewDidClick`, get extra key/value to handle your custom events, such as: `jump to some page when user clicked`.

Received notification:

```
{
    "aps":
    {
        "alert":"content",
        "sound":"sound",
        "badge":"3"
    },
        "key1":"jump1"  //customed like this to jump
}
```

Add observer:

```objc
#import "EBForeNotification.h"
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
-(void)eBBannerViewDidClick:(NSNotification*)noti{
    if(noti[@"key1" == @"jump1"]){
        //jump to page 1
    }
}
```
