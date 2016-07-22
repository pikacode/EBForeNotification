# EBForeNotification
Look for [English README](/README_ENGLISH.md)

在 App 处于前台时展示跟系统完全一样的推送`弹窗`和`声音`。获取推送内容，并且处理点击事件。

同时支持`模拟器`及`真机`运行。

## 安装
下载并`在 Xcode 中``拖拽拷贝` `EBForeNotification` 文件夹至 Xcode 工程。

## 处理推送
在前台展示推送弹窗及声音。

```objc
//AppDelegate.m
#import "EBForeNotification.h"

//ios7 before
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo { 
	...
	//添加以下代码
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    ...
}

//ios7 later  
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
	...
	//添加以下代码
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    ...
    completionHandler(UIBackgroundFetchResultNewData);
}
```

## soundID 参数
iOS 系统自带的声音 id，系统级的推送服务默认使用的是`三全音`，id = 1312

其他系统声音 id 可以在这里查询到 [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#)


## 监听并处理点击事件
添加 `Observer` 监听 `EBBannerViewDidClick`，获取推送内容，通过推送时自定义的字段处理自己逻辑，如：跳转到对应页面等。

接收到的推送内容类似以下：

```json
{
    "aps":
    {
        "alert":"推送内容",
        "sound":"sound",
        "badge":"3"
    },
        "key1":"跳转页面1"  //自定义此字段以跳转到相应页面
}
```

添加 `Observer` 获取自定义的字段，并处理：

```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
-(void)eBBannerViewDidClick:(NSNotification*)noti{
    if(noti[@"key1" == @"跳转页面1"]){
        //跳转到页面1
    }
}
```

## 自定义声音
可以添加声音文件诸如 `my_sound.wav` 到 Xcode 工程中，并在弹窗时播放。

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

