Email：57380422@qq.com
# EBForeNotification
Show the `Banners` and `Sounds` as the same as the system notifications on foreground. Get notification content and Handle click event.

Support iOS 7~10 beta, support both simulator & iPhone build.

## Display
- The same UI with the system banner & sound
- Auto get App name & App icon
- Auto hide systm Status Bar and show
- `time` & `drag leg` are the same color with current background
- click gesture & handle it with notification info
- swipe gesture

Actual effect：

![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot01.gif)

![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot02.gif)

## Install
Download and Drag `EBForeNotification` file folder into you Xcode project  will just be ok.

## Native Banner
Call any 1 method below can show a banner on the frontest controller.
```objc
#import "EBForeNotification.h"
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

 
