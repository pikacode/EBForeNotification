
//  Copyright © 2016年 57380422@qq.com. All rights reserved.

//  version 1.0.7

#import <Foundation/Foundation.h>

extern NSString *const EBBannerViewDidClick;    //监听点击弹窗的事件

@interface EBForeNotification : NSObject
+(void)handleRemoteNotification:(NSDictionary*)userInfo soundID:(int)soundID;
+(void)handleRemoteNotification:(NSDictionary*)userInfo customSound:(NSString*)soundName;
+(void)handleRemoteNotification:(NSDictionary*)userInfo soundID:(int)soundID isIos10:(BOOL)isIos10;
+(void)handleRemoteNotification:(NSDictionary*)userInfo customSound:(NSString*)soundName isIos10:(BOOL)isIos10;
@end

static NSString *const EBBannerViewTimeText = @"现在";    //默认弹窗时间 default banner time


/*

⭐1.在 AppDelegate.m 中，调用示例如下：
    in "AppDelegate.m" call method such as:

    //ios 7 before
    - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    }
     
    //ios 7 later
    - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
        completionHandler(UIBackgroundFetchResultNewData);
    }


⭐2.监听点击弹窗的事件、用户点击以后可以取到推送内容、通过自定义推送中的 extra 字段处理自己的逻辑。如：
    add observer for "EBBannerViewDidClick", handle extra key/value

    {
        {
            aps:"alert":"推送内容",
            "sound":"sound",
            "badge":"3"
        },
            "key1":"跳转页面1"  //自定义此字段以跳转到相应页面
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
    -(void)eBBannerViewDidClick:(NSNotification*)noti{
        if(noti[@"key1" == @"跳转页面1"]){
            //jump to page 1
        }
    }


⭐3.添加自定义的声音文件并在弹窗时播放
    customSound: u can add a sound file and pass a name like "my_sound.wav" to custom the sound


⭐4.使用系统自带声音，默认的推送三全音 id 是 1312
    soundID: is ios system sound id, default push notification sound "Tritone" is 1312

     Sound ID	File name (iPhone)	File name (iPod Touch)	Category	Note
     1000	new-mail.caf	new-mail.caf	MailReceived
     1001	mail-sent.caf	mail-sent.caf	MailSent
     1002	Voicemail.caf	Voicemail.caf	VoicemailReceived
     1003	ReceivedMessage.caf	ReceivedMessage.caf	SMSReceived
     1004	SentMessage.caf	SentMessage.caf	SMSSent
     1005	alarm.caf	sq_alarm.caf	CalendarAlert
     1006	low_power.caf	low_power.caf	LowPower
     1007	sms-received1.caf	sms-received1.caf	SMSReceived_Alert
     1008	sms-received2.caf	sms-received2.caf	SMSReceived_Alert
     1009	sms-received3.caf	sms-received3.caf	SMSReceived_Alert
     1010	sms-received4.caf	sms-received4.caf	SMSReceived_Alert
     1011	-	-	SMSReceived_Vibrate
     1012	sms-received1.caf	sms-received1.caf	SMSReceived_Alert
     1013	sms-received5.caf	sms-received5.caf	SMSReceived_Alert
     1014	sms-received6.caf	sms-received6.caf	SMSReceived_Alert
     1015	Voicemail.caf	Voicemail.caf	-	Available since 2.1
     1016	tweet_sent.caf	tweet_sent.caf	SMSSent	Available since 5.0
     1020	Anticipate.caf	Anticipate.caf	SMSReceived_Alert	Available since 4.2
     1021	Bloom.caf	Bloom.caf	SMSReceived_Alert	Available since 4.2
     1022	Calypso.caf	Calypso.caf	SMSReceived_Alert	Available since 4.2
     1023	Choo_Choo.caf	Choo_Choo.caf	SMSReceived_Alert	Available since 4.2
     1024	Descent.caf	Descent.caf	SMSReceived_Alert	Available since 4.2
     1025	Fanfare.caf	Fanfare.caf	SMSReceived_Alert	Available since 4.2
     1026	Ladder.caf	Ladder.caf	SMSReceived_Alert	Available since 4.2
     1027	Minuet.caf	Minuet.caf	SMSReceived_Alert	Available since 4.2
     1028	News_Flash.caf	News_Flash.caf	SMSReceived_Alert	Available since 4.2
     1029	Noir.caf	Noir.caf	SMSReceived_Alert	Available since 4.2
     1030	Sherwood_Forest.caf	Sherwood_Forest.caf	SMSReceived_Alert	Available since 4.2
     1031	Spell.caf	Spell.caf	SMSReceived_Alert	Available since 4.2
     1032	Suspense.caf	Suspense.caf	SMSReceived_Alert	Available since 4.2
     1033	Telegraph.caf	Telegraph.caf	SMSReceived_Alert	Available since 4.2
     1034	Tiptoes.caf	Tiptoes.caf	SMSReceived_Alert	Available since 4.2
     1035	Typewriters.caf	Typewriters.caf	SMSReceived_Alert	Available since 4.2
     1036	Update.caf	Update.caf	SMSReceived_Alert	Available since 4.2
     1050	ussd.caf	ussd.caf	USSDAlert
     1051	SIMToolkitCallDropped.caf	SIMToolkitCallDropped.caf	SIMToolkitTone
     1052	SIMToolkitGeneralBeep.caf	SIMToolkitGeneralBeep.caf	SIMToolkitTone
     1053	SIMToolkitNegativeACK.caf	SIMToolkitNegativeACK.caf	SIMToolkitTone
     1054	SIMToolkitPositiveACK.caf	SIMToolkitPositiveACK.caf	SIMToolkitTone
     1055	SIMToolkitSMS.caf	SIMToolkitSMS.caf	SIMToolkitTone
     1057	Tink.caf	Tink.caf	PINKeyPressed
     1070	ct-busy.caf	ct-busy.caf	AudioToneBusy	There was no category for this sound before 4.0.
     1071	ct-congestion.caf	ct-congestion.caf	AudioToneCongestion	There was no category for this sound before 4.0.
     1072	ct-path-ack.caf	ct-path-ack.caf	AudioTonePathAcknowledge	There was no category for this sound before 4.0.
     1073	ct-error.caf	ct-error.caf	AudioToneError	There was no category for this sound before 4.0.
     1074	ct-call-waiting.caf	ct-call-waiting.caf	AudioToneCallWaiting	There was no category for this sound before 4.0.
     1075	ct-keytone2.caf	ct-keytone2.caf	AudioToneKey2	There was no category for this sound before 4.0.
     1100	lock.caf	sq_lock.caf	ScreenLocked
     1101	unlock.caf	sq_lock.caf	ScreenUnlocked
     1102	-	-	FailedUnlock
     1103	Tink.caf	sq_tock.caf	KeyPressed
     1104	Tock.caf	sq_tock.caf	KeyPressed
     1105	Tock.caf	sq_tock.caf	KeyPressed
     1106	beep-beep.caf	sq_beep-beep.caf	ConnectedToPower
     1107	RingerChanged.caf	RingerChanged.caf	RingerSwitchIndication
     1108	photoShutter.caf	photoShutter.caf	CameraShutter
     1109	shake.caf	shake.caf	ShakeToShuffle	Available since 3.0
     1110	jbl_begin.caf	jbl_begin.caf	JBL_Begin	Available since 3.0
     1111	jbl_confirm.caf	jbl_confirm.caf	JBL_Confirm	Available since 3.0
     1112	jbl_cancel.caf	jbl_cancel.caf	JBL_Cancel	Available since 3.0
     1113	begin_record.caf	begin_record.caf	BeginRecording	Available since 3.0
     1114	end_record.caf	end_record.caf	EndRecording	Available since 3.0
     1115	jbl_ambiguous.caf	jbl_ambiguous.caf	JBL_Ambiguous	Available since 3.0
     1116	jbl_no_match.caf	jbl_no_match.caf	JBL_NoMatch	Available since 3.0
     1117	begin_video_record.caf	begin_video_record.caf	BeginVideoRecording	Available since 3.0
     1118	end_video_record.caf	end_video_record.caf	EndVideoRecording	Available since 3.0
     1150	vc~invitation-accepted.caf	vc~invitation-accepted.caf	VCInvitationAccepted	Available since 4.0
     1151	vc~ringing.caf	vc~ringing.caf	VCRinging	Available since 4.0
     1152	vc~ended.caf	vc~ended.caf	VCEnded	Available since 4.0
     1153	ct-call-waiting.caf	ct-call-waiting.caf	VCCallWaiting	Available since 4.1
     1154	vc~ringing.caf	vc~ringing.caf	VCCallUpgrade	Available since 4.1
     1200	dtmf-0.caf	dtmf-0.caf	TouchTone
     1201	dtmf-1.caf	dtmf-1.caf	TouchTone
     1202	dtmf-2.caf	dtmf-2.caf	TouchTone
     1203	dtmf-3.caf	dtmf-3.caf	TouchTone
     1204	dtmf-4.caf	dtmf-4.caf	TouchTone
     1205	dtmf-5.caf	dtmf-5.caf	TouchTone
     1206	dtmf-6.caf	dtmf-6.caf	TouchTone
     1207	dtmf-7.caf	dtmf-7.caf	TouchTone
     1208	dtmf-8.caf	dtmf-8.caf	TouchTone
     1209	dtmf-9.caf	dtmf-9.caf	TouchTone
     1210	dtmf-star.caf	dtmf-star.caf	TouchTone
     1211	dtmf-pound.caf	dtmf-pound.caf	TouchTone
     1254	long_low_short_high.caf	long_low_short_high.caf	Headset_StartCall
     1255	short_double_high.caf	short_double_high.caf	Headset_Redial
     1256	short_low_high.caf	short_low_high.caf	Headset_AnswerCall
     1257	short_double_low.caf	short_double_low.caf	Headset_EndCall
     1258	short_double_low.caf	short_double_low.caf	Headset_CallWaitingActions
     1259	middle_9_short_double_low.caf	middle_9_short_double_low.caf	Headset_TransitionEnd
     1300	Voicemail.caf	Voicemail.caf	SystemSoundPreview
     1301	ReceivedMessage.caf	ReceivedMessage.caf	SystemSoundPreview
     1302	new-mail.caf	new-mail.caf	SystemSoundPreview
     1303	mail-sent.caf	mail-sent.caf	SystemSoundPreview
     1304	alarm.caf	sq_alarm.caf	SystemSoundPreview
     1305	lock.caf	sq_lock.caf	SystemSoundPreview
     1306	Tock.caf	sq_tock.caf	KeyPressClickPreview	The category was SystemSoundPreview before 3.2.
     1307	sms-received1.caf	sms-received1.caf	SMSReceived_Selection
     1308	sms-received2.caf	sms-received2.caf	SMSReceived_Selection
     1309	sms-received3.caf	sms-received3.caf	SMSReceived_Selection
     1310	sms-received4.caf	sms-received4.caf	SMSReceived_Selection
     1311	-	-	SMSReceived_Vibrate
     1312	sms-received1.caf	sms-received1.caf	SMSReceived_Selection
     1313	sms-received5.caf	sms-received5.caf	SMSReceived_Selection
     1314	sms-received6.caf	sms-received6.caf	SMSReceived_Selection
     1315	Voicemail.caf	Voicemail.caf	SystemSoundPreview	Available since 2.1
     1320	Anticipate.caf	Anticipate.caf	SMSReceived_Selection	Available since 4.2
     1321	Bloom.caf	Bloom.caf	SMSReceived_Selection	Available since 4.2
     1322	Calypso.caf	Calypso.caf	SMSReceived_Selection	Available since 4.2
     1323	Choo_Choo.caf	Choo_Choo.caf	SMSReceived_Selection	Available since 4.2
     1324	Descent.caf	Descent.caf	SMSReceived_Selection	Available since 4.2
     1325	Fanfare.caf	Fanfare.caf	SMSReceived_Selection	Available since 4.2
     1326	Ladder.caf	Ladder.caf	SMSReceived_Selection	Available since 4.2
     1327	Minuet.caf	Minuet.caf	SMSReceived_Selection	Available since 4.2
     1328	News_Flash.caf	News_Flash.caf	SMSReceived_Selection	Available since 4.2
     1329	Noir.caf	Noir.caf	SMSReceived_Selection	Available since 4.2
     1330	Sherwood_Forest.caf	Sherwood_Forest.caf	SMSReceived_Selection	Available since 4.2
     1331	Spell.caf	Spell.caf	SMSReceived_Selection	Available since 4.2
     1332	Suspense.caf	Suspense.caf	SMSReceived_Selection	Available since 4.2
     1333	Telegraph.caf	Telegraph.caf	SMSReceived_Selection	Available since 4.2
     1334	Tiptoes.caf	Tiptoes.caf	SMSReceived_Selection	Available since 4.2
     1335	Typewriters.caf	Typewriters.caf	SMSReceived_Selection	Available since 4.2
     1336	Update.caf	Update.caf	SMSReceived_Selection	Available since 4.2
     1350	-	-	RingerVibeChanged
     1351	-	-	SilentVibeChanged
     4095	-	-	Vibrate	There was no category for this sound before 2.2.
     In the SDK this is the constant kSystemSoundID_Vibrate.

 */