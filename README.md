# EBForeNotification
Show the Banners and Sounds as the same as the system notifications on foreground.

Support both simulator and iPhone build.

# Usage
Drag `EBForeNotification` file folder into you Xcode project just be ok.

## Handle notification
To show banner and sound on foreground.

```objc
//AppDelegate.m
#import "EBForeNotification.h"

//ios7 before
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo { 
	...
	//add this line
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    ...
}

//ios7 later  
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
	...
	//add this line
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    ...
    completionHandler(UIBackgroundFetchResultNewData);
}
```

## Listen Click
Add observer for `EBBannerViewDidClick`, get extra key/value to handle your custom events, such as: `jump to some page when user clicked`.

Received notification:

```json
{
    {
        aps:"alert":"推送内容",
        "sound":"sound",
        "badge":"3"
    },
        "key1":"跳转页面1"  //自定义此字段以跳转到相应页面
}
```

Add observer:

```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
-(void)eBBannerViewDidClick:(NSNotification*)noti{
    if(noti[@"key1" == @"跳转页面1"]){
        //jump to page 1
    }
}
```

# Parameter

## customSound
U can add a sound file and pass a name like "my_sound.wav" to custom the sound, such as:

```objc
//ios7 before
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo { 
	...
	//add this line
	[EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    ...
}

//ios7 later  
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
	...
	//add this line
	[EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    ...
    completionHandler(UIBackgroundFetchResultNewData);
}
```

## soundID
Is iOS system sound id, default push notification sound "Tritone" is 1312

More sound id to see here [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#)

