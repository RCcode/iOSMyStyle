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


//衣橱季节
typedef enum WardrobeSeason WardrobeSeason;

enum WardrobeSeason
{
    WSAll,
    WSSpringAndSummer,
    WSAutumnAndWinter
};

//衣橱类型
typedef enum WardrobeType WardrobeType;

enum WardrobeType
{
    WTAll,
    WTUpper,
    WTBottoms,
    WTShoes,
    WTBag,
    WTAccessory,
    WTJewelry,
    WTUnderwear
};

//衣橱类别
typedef enum WardrobeCategory WardrobeCategory;

enum WardrobeCategory
{
    WCAll,
    
    //上装
    
    WCJacket,                           //夹克
    WCShirt,                            //衬衫
    WCT_shirt,                          //T恤
    WCBusiness_suit,                    //西装
    WCWoollen_sweater,                  //羊毛衫
    WCKnitwear,                         //针织衫
    WCOne_piece_dress,                  //连衣裙
    WCOutdoor_clothing,                 //户外服装
    WCSport_suit,                       //运动服
    WCWind_coat,                        //风衣
    WCJeans_wear,                       //牛仔
    WCUnderwaist,                       //背心
    
    //下装
    
    WCLong_dress,                       //长裙
    WCShort_skirt,                      //短裙
    WCTrousers,                         //长裤
    WCShorts,                           //短裤
    WCJean,                             //牛仔
    WCLeggings,                         //打底裤
    
    //鞋
    
    WCFlattie,                          //平底鞋
    WCDress_shoes,                      //晚装鞋
    WCHigh_heel_shoe,                   //高跟鞋
    WCBoots,                            //靴子
    WCPlatform_shoes,                   //松糕鞋
    WCSandal,                           //凉鞋
    WCWedge_heel,                       //坡跟鞋
    WCSneaker,                          //运动鞋
    WCSlippers,                         //拖鞋
    
    //包
    WCEvening_bag,                      //晚装包
    WCBackpack,                         //双肩包
    WCParty_package,                    //宴会包
    WCSide_shoulder_bag,                //侧肩包
    WCSatchel,                          //小背包
    WCVanity,                           //手袋
    WCWallet,                           //钱包
    
    //配饰
    
    WCBelt,                             //腰带
    WCHat,                              //帽子
    WCSunglass,                         //太阳镜
    WCScarf,                            //围巾
    WCGlove,                            //手套
    WCWatch,                            //手表
    WCCosmetic,                         //化妆品
    WCPerfume,                          //香水
    
    //首饰
    
    WCBracelet,                         //手镯
    WCNecklace,                         //项链
    WCRing,                             //戒指
    WCChain_bracelet,                   //手链
    WCEarrings,                         //耳环
    WCEar_stud,                         //耳钉
    
    //内衣
    
    WCBra,                              //胸罩
    WCSun_top,                          //吊带衫
    WCUnderdress,                       //衬裙
    WCNight_robe,                       //睡袍
    WCSilk_stockings,                   //丝袜
    WCNight_suit,                       //睡衣
    WCBriefs,                           //内裤
    WCSocks,                            //袜子
    WCBathrobe,                         //浴袍
};

//搭配风格
typedef enum CollocationStyle CollocationStyle;

enum CollocationStyle
{
    CSAll,
    CSFormal_wear,                      //正装
    CSCasual_Wear,                      //休闲
    CSSportswear                        //运动
};

//搭配场合
typedef enum CollocationOccasion CollocationOccasion;

enum CollocationOccasion
{
    COAll,
    COWorking,                          //工作
    COHome,                             //家居
    CODinner,                           //晚宴
    COParty,                            //聚会
    COFitness,                          //健身
    COJourney                           //出游
};


#endif
