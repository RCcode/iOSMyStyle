//
//  Public.h
//  InstaShot
//
//  Created by TCH on 14-8-5.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#ifndef InstaShot_Public_h
#define InstaShot_Public_h

#define kMoreAppID 22019
#define kMoreAppBaseURL @"http://moreapp.rcplatformhk.net/pbweb/app/getIOSAppListNew.do"

#define kAdColonyAppID @"app70e0943dbd23435288"
#define kZoonId @"vza041e606e3eb4282b3"
#define kZoonId1 @"vz7c1dd5ea679f44668f"

#define kVungleAppID @"558055ffb2addf5a5a000120"

#define UmengAPPKey @"5575172c67e58e2bd4001874"
#define FlurryAppKey @"XK7DKPDSN5ZRX6FKSRMF"

#define kAppID @"1002299125"
#define kAppStoreURLPre @"itms-apps://itunes.apple.com/app/id"
#define kAppStoreURL [NSString stringWithFormat:@"%@%@", kAppStoreURLPre, kAppID]

#define kAppStoreScoreURLPre @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
#define kAppStoreScoreURL [NSString stringWithFormat:@"%@%@", kAppStoreScoreURLPre, kAppID]








#define AdMobID @""
//#define AdMobID @"ca-app-pub-3747943735238482/9860250656"
#define AdUrl @"http://ads.rcplatformhk.com/AdlayoutBossWeb/platform/getRcAppAdmob.do"

#define kFeedbackEmail @"rcplatform.help@gmail.com"

#define kPushURL @"http://iospush.rcplatformhk.net/IOSPushWeb/userinfo/regiUserInfo.do"

#define kShareHotTags @"A fast and free app to get 10000s of real Instagram followers.In the App Store search F4F download !#follow#followme#follow4follow#f4f#followforfollow#like4like#like#likeforlike"

//key


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define NavBarHeight 44.0
#define Height5 568
#define ScreenHeightHaveNavBar [[UIScreen mainScreen] bounds].size.height - NavBarHeight

#define iPhone6plus ([[UIScreen mainScreen] bounds].size.height ==736)
#define iPhone6 ([[UIScreen mainScreen] bounds].size.height ==667)
#define iPhone5 ([[UIScreen mainScreen] bounds].size.height ==568)
#define iPhone4 ([[UIScreen mainScreen] bounds].size.height ==480)
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
//判断是否为iPhone5
#define IS_IPHONE_5_SCREEN [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f
#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?1:0)
#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0)
#define IS_IOS_6 (([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)?1:0)
#define IS_IOS_5 (([[[UIDevice currentDevice] systemVersion] floatValue]<6.0)?1:0)

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)

#define ISFIRSTLAUNCH @"isFirstLaunch"

#define INSTAGRAM_CLIENT_ID	@"814a781de7eb4d359e7f306a7b265a20"
#define INSTAGRAM_CLIENT_SECRET	@"c2f7e6bdf9934b80bcd96b45d227cd06"
#define INSTAGRAM_WEBSITE_URL	@"http://www.facebook.com/rcplatform2014"
#define INSTAGRAM_REDIRECT_URI	@"http://www.facebook.com/rcplatform2014"

#define MY_USERINFO_KEY @"my_userInfo"
#define HEADIMAGE @"headImage"
#define ACCESSTOKEN_KEY @"accessToken"
#define ICONS_KEY @"icons"
#define FIVESTART_KEY @"fiveStart"
#define SHAREIG_KEY @"shareIg"
#define SUCCESSLOGINSERVER_KEY @"successLoginServer"


#define APPDELEGATE (AppDelegate *)([UIApplication sharedApplication].delegate)

//typedef enum ControllerIndex ControllerIndex;
//
//enum ControllerIndex
//{
//    CIEarnCoinsViewController,
//    CIGetFollowersViewController,
//    CIGiftViewController
//};
//
//typedef enum InstagramRequestType InstagramRequestType;
//
//enum InstagramRequestType
//{
//    IRTGetUserProfile,
//    IRTGetOtherUserProfile,
//    IRTGetUserRecentMedia,
//    IRTGetOtherUserRecentMedia,
//    IRTChangeRelationship
//};

#endif
