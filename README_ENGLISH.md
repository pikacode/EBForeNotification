# EBForeNotification
Show the `Banners` and `Sounds` as the same as the system notifications on foreground. Get notification content and Handle click event.

Support both simulator and iPhone build.

## Display
- The same UI with the system banner & sound
- Auto get App name & App icon
- Auto hide systm Status Bar and show
- `time` & `drag leg` are the same color with current background
- click gesture, and handle
- swipe gesture

Actual effect：

![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot01.gif)

![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot02.gif)

- 跟系统推送弹窗 UI 效果完全相同
- 可以自动获取 App 的`应用名称`，`应用图标`
- 弹窗时会自动隐藏系统状态栏、收起后自动显示系统状态栏
- 自带推送声音
- `时间`及下方`收拉条`的颜色跟当前页面的背景颜色相同
- 自带`点击事件`，点击可获取推送内容，进行相应页面跳转
- 自带`上滑手势`，快速收起

## Install
Download and Drag `EBForeNotification` file folder into you Xcode project  will just be ok.

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

## Parma: soundID
Is iOS system sound id, default push notification sound "Tritone" is 1312

More sound id to see here [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#)


## Listen Click
Add observer for `EBBannerViewDidClick`, get extra key/value to handle your custom events, such as: `jump to some page when user clicked`.

Received notification:

```json
{
    "aps":
    {
        "alert":"推送内容",
        "sound":"sound",
        "badge":"3"
    },
        "key1":"jump1"  //custom define like this to jump
}
```

Add observer:

```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
-(void)eBBannerViewDidClick:(NSNotification*)noti{
    if(noti[@"key1" == @"jump1"]){
        //jump to page 1
    }
}
```

## Parma: customSound
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

