//
//  Public.h
//  InstaShot
//
//  Created by TCH on 14-8-5.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#ifndef InstaShot_Public_h
#define InstaShot_Public_h

#define kMoreAppID 24004

#define UmengAPPKey @"55c8870267e58e8d1a0002b1"
#define FlurryAppKey @"J463JJ72NFBPNW75DTQY"

#define kAppID @"1029295878"
#define kAppStoreURLPre @"itms-apps://itunes.apple.com/app/id"
#define kAppStoreURL [NSString stringWithFormat:@"%@%@", kAppStoreURLPre, kAppID]

#define kAppStoreScoreURLPre @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
#define kAppStoreScoreURL [NSString stringWithFormat:@"%@%@", kAppStoreScoreURLPre, kAppID]

#define AdMobID @""
//#define AdMobID @"ca-app-pub-3747943735238482/9860250656"

#define kFeedbackEmail @"rcplatform.help@gmail.com"

#define kPushURL @"http://iospush.rcplatformhk.net/IOSPushWeb/userinfo/regiUserInfo.do"

#define AppName @"MyStyle"

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
#define IS_IOS_9 (([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0)?1:0)
#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)?1:0)
#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0)
#define IS_IOS_6 (([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)?1:0)
#define IS_IOS_5 (([[[UIDevice currentDevice] systemVersion] floatValue]<6.0)?1:0)

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f)
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)

#define ISFIRSTLAUNCH @"isFirstLaunch"

#define INSTAGRAM_CLIENT_ID	@"66cad5da8ade455cb862cc9582c590d0"
#define INSTAGRAM_CLIENT_SECRET	@"3e529647a8be4eb38d2404a81cfff79b"
#define INSTAGRAM_WEBSITE_URL	@"https://www.facebook.com/pages/Mystyleapp/1475494706097839"
#define INSTAGRAM_REDIRECT_URI	@"https://www.facebook.com/pages/Mystyleapp/1475494706097839"

#define MY_USERINFO_KEY @"my_userInfo"
#define HEADIMAGE @"headImage"
#define ACCESSTOKEN_KEY @"accessToken"
#define ICONS_KEY @"icons"
#define FIVESTART_KEY @"fiveStart"
#define SHAREIG_KEY @"shareIg"
#define SUCCESSLOGINSERVER_KEY @"successLoginServer"

#define NOTIFICATION_UPDATEVIEW @"notificationUpdateView"

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kToMorePath [kDocumentPath stringByAppendingPathComponent:@"iOSCostumeMatching_Share_Image.jpg"]

static NSString *TOUCH_PHOTOMARK = @"touchPhotoMark";

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
    WTAll = 0,
    WTUpper = 10,               //上装
    WTBottoms = 11,             //下装
    WTShoes = 12,               //鞋
    WTBag = 13,                 //包
    WTAccessory = 14,           //配饰
    WTJewelry = 15,             //首饰
    WTUnderwear = 16            //内衣
};

//衣橱类别
typedef enum WardrobeCategory WardrobeCategory;

enum WardrobeCategory
{
    WCAll = 0,
    
    //上装
    
    WCJacket = 1001,                           //夹克
    WCShirt = 1002,                            //衬衫
    WCT_shirt = 1003,                          //T恤
    WCBusiness_suit = 1004,                    //西装
    WCWoollen_sweater = 1005,                  //羊毛衫
    WCKnitwear = 1006,                         //针织衫
    WCOne_piece_dress = 1007,                  //连衣裙
    WCOutdoor_clothing = 1008,                 //户外服装
    WCSport_suit = 1009,                       //运动服
    WCWind_coat = 1010,                        //风衣
    WCJeans_wear = 1011,                       //牛仔
    WCUnderwaist = 1012,                       //背心
    
    //下装
    
    WCLong_dress = 1101,                       //长裙
    WCShort_skirt = 1102,                      //短裙
    WCTrousers = 1103,                         //长裤
    WCShorts = 1104,                           //短裤
    WCJean = 1105,                             //牛仔
    WCLeggings = 1106,                         //打底裤
    
    //鞋
    
    WCFlattie = 1201,                          //平底鞋
    WCDress_shoes = 1202,                      //晚装鞋
    WCHigh_heel_shoe = 1203,                   //高跟鞋
    WCBoots = 1204,                            //靴子
    WCPlatform_shoes = 1205,                   //松糕鞋
    WCSandal = 1206,                           //凉鞋
    WCWedge_heel = 1207,                       //坡跟鞋
    WCSneaker = 1208,                          //运动鞋
    WCSlippers = 1209,                         //拖鞋
    
    //包
    WCEvening_bag = 1301,                      //晚装包
    WCBackpack = 1302,                         //双肩包
    WCParty_package = 1303,                    //宴会包
    WCSide_shoulder_bag = 1304,                //手提包
    WCSatchel = 1305,                          //小背包
    WCVanity = 1306,                           //手袋
    WCWallet = 1307,                           //钱包
    
    //配饰
    
    WCBelt = 1401,                             //腰带
    WCHat = 1402,                              //帽子
    WCSunglass = 1403,                         //太阳镜
    WCScarf = 1404,                            //围巾
    WCGlove = 1405,                            //手套
    WCWatch = 1406,                            //手表
    WCCosmetic = 1407,                         //化妆品
    WCPerfume = 1408,                          //香水
    
    //首饰
    
    WCBracelet = 1501,                         //手镯
    WCNecklace = 1502,                         //项链
    WCRing = 1503,                             //戒指
//    WCChain_bracelet = 1504,                   //手链
    WCEarrings = 1505,                         //耳环
    WCEar_Pins = 1506,                         //胸针
    
    //内衣
    
    WCBra = 1601,                              //胸罩
    WCSun_top = 1602,                          //吊带衫
    WCUnderdress = 1603,                       //衬裙
    WCNight_robe = 1604,                       //睡袍
    WCSilk_stockings = 1605,                   //丝袜
    WCNight_suit = 1606,                       //睡衣
    WCBriefs = 1607,                           //内裤
    WCSocks = 1608,                            //袜子
    WCBathrobe = 1609,                         //浴袍
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

//非全天通知
typedef enum NotAllDayRemind NotAllDayRemind;

enum NotAllDayRemind
{
    NADR_none,
    NADR_before1hour,
    NADR_before2hour,
    NADR_before3hour,
    NADR_before5hour,
    NADR_before1day,
    NADR_before2day,
    NADR_before1week,
};

//全天通知
typedef enum AllDayRemind AllDayRemind;

enum AllDayRemind
{
    ADR_none,
    ADR_intraday,
    ADR_before1day,
    ADR_before2day,
    ADR_before3day,
    ADR_before1week,
};

//颜色
typedef enum ActivityColor ActivityColor;

enum ActivityColor
{
    AC0,
    AC1,
    AC2,
    AC3,
    AC4,
    AC5,
    AC6,
    AC7,
    AC8,
    AC9,
    AC10,
    AC11
};

#endif
