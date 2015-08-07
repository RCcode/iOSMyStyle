//
//  CMethods.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "CMethods.h"
//#import <stdlib.h>
//#import <time.h>
#import "sys/sysctl.h"
//#include <mach/mach.h>



@implementation CMethods

UIColor* colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

NSString *appVersion(){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NSString *LocalizedString(NSString *translation_key, id none){

    NSString *language = @"en";
    
    //只适配这么些种语言，其余一律用en
    if([CURR_LANG isEqualToString:@"zh-Hans"] ||
       [CURR_LANG isEqualToString:@"zh-Hant"] ||
       [CURR_LANG isEqualToString:@"de"] ||
       [CURR_LANG isEqualToString:@"es"] ||
       [CURR_LANG isEqualToString:@"fr"] ||
       [CURR_LANG isEqualToString:@"it"] ||
       [CURR_LANG isEqualToString:@"ko"] ||
       [CURR_LANG isEqualToString:@"ja"] ||
       [CURR_LANG isEqualToString:@"pt"] ||
       [CURR_LANG isEqualToString:@"pt-PT"] ||
       [CURR_LANG isEqualToString:@"ru"] ||
       [CURR_LANG isEqualToString:@"ar"] ||
       [CURR_LANG isEqualToString:@"id"] ||
       [CURR_LANG isEqualToString:@"th"] ){
        language = CURR_LANG;
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    NSBundle * languageBundle = [NSBundle bundleWithPath:path];
    return [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
}

NSString *doDevicePlatform()
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSDictionary *devModeMappingMap = @{
        @"x86_64"    :@"Simulator",
        @"iPod1,1"   :@"iPod Touch",      // (Original)
        @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
        @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
        @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
        @"iPod5,1"   :@"iPod Touch",
        @"iPhone1,1" :@"iPhone",          // (Original)
        @"iPhone1,2" :@"iPhone",          // (3G)
        @"iPhone2,1" :@"iPhone",          // (3GS)
        @"iPhone3,1" :@"iPhone 4",        //
        @"iPhone4,1" :@"iPhone 4S",       //
        @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
        @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
        @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
        @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
        @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
        @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
        @"iPad1,1"   :@"iPad",            // (Original)
        @"iPad2,1"   :@"iPad 2",          //
        @"iPad2,2"   :@"iPad 2",
        @"iPad2,3"   :@"iPad 2",
        @"iPad2,4"   :@"iPad 2",
        @"iPad2,5"   :@"iPad Mini",       // (Original)
        @"iPad2,6"   :@"iPad Mini",
        @"iPad2,7"   :@"iPad Mini",
        @"iPad3,1"   :@"iPad 3",          // (3rd Generation)
        @"iPad3,2"   :@"iPad 3",
        @"iPad3,3"   :@"iPad 3",
        @"iPad3,4"   :@"iPad 4",          // (4th Generation)
        @"iPad3,5"   :@"iPad 4",
        @"iPad3,6"   :@"iPad 4",
        @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
        @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
        @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
        @"iPad4,5"   :@"iPad Mini 2"      // (2nd Generation iPad Mini - Cellular)
    };

    NSString *devModel = [devModeMappingMap valueForKeyPath:platform];
    return (devModel) ? devModel : platform;
}

NSString *stringAllDayFromDate(NSDate *date)
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd EEEE"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

NSString *stringNotAllDayFromDate(NSDate *date)
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd EEEE HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

NSString *yearFromDate(NSDate *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

NSString *monthFromDate(NSDate *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

NSString *dayFromDate(NSDate *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

NSString *stringFromDate(NSDate *date)
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

NSString *weekdayStringFromDate(NSDate *inputDate)
{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

MBProgressHUD *HUD;
void showLabelHUD(NSString *content)
{
    //显示LoadView
    if (HUD==nil) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        HUD = [[MBProgressHUD alloc] initWithView:window];
        HUD.mode = MBProgressHUDModeText;
        [window addSubview:HUD];
        //如果设置此属性则当前的view置于后台
    }
    HUD.labelText = content;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

MBProgressHUD *mb;
MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView)
{
    if(mb){
        hideMBProgressHUD();
    }
    
    //显示LoadView
    if (mb==nil) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        mb = [[MBProgressHUD alloc] initWithView:window];
        mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
        mb.userInteractionEnabled = NO;
        [window addSubview:mb];
        //如果设置此属性则当前的view置于后台
        mb.dimBackground = YES;
        mb.labelText = content;
    }else{
        
        mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
        mb.labelText = content;
    }
    
    [mb show:YES];
    return mb;
}

void hideMBProgressHUD()
{
    [mb hide:YES];
    [mb removeFromSuperview];
    mb = nil;
}

UIImage *getViewImage(UIView *view)
{
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

void ViewAnimation(UIView *view ,CGRect frame)
{
    __weak UIView *v = view;
    [UIView animateWithDuration:0.3 animations:^{
        v.frame = frame;
    } completion:nil];
    
}

CGRect getTextLabelRectWithContentAndFont(NSString *content ,UIFont *font)
{
    CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    CGRect returnRect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil];
    
    return returnRect;
}

NSString *getWardrobeTypeName(WardrobeType type)
{
    NSString *str;
    switch (type) {
        case WTAll:
        {
            str = @"ALL";
            break;
        }
        case WTUpper:
        {
            str = @"上装";
            break;
        }
        case WTBottoms:
        {
            str = @"下装";
            break;
        }
        case WTShoes:
        {
            str = @"鞋";
            break;
        }
        case WTBag:
        {
            str = @"包";
            break;
        }
        case WTAccessory:
        {
            str = @"配饰";
            break;
        }
        case WTJewelry:
        {
            str = @"首饰";
            break;
        }
        case WTUnderwear:
        {
            str = @"内衣";
            break;
        }
        default:
            break;
    }
    return str;
}

NSArray *getAllWardrobeType()
{
    NSArray *arr = @[@"ALL",@"上装",@"下装",@"鞋",@"包",@"配饰",@"首饰",@"内衣"];
    
    return arr;
}

NSString *getWardrobeCategoryeName(WardrobeCategory type)
{
    NSString *str;
    switch (type) {
        case WCAll:{str = @"ALL";break;}
            
        case WCJacket:{str = @"夹克";break;}
        case WCShirt:{str = @"衬衫";break;}
        case WCT_shirt:{str = @"T恤";break;}
        case WCBusiness_suit:{str = @"西装";break;}
        case WCWoollen_sweater:{str = @"羊毛衫";break;}
        case WCKnitwear:{str = @"针织衫";break;}
        case WCOne_piece_dress:{str = @"连衣裙";break;}
        case WCOutdoor_clothing:{str = @"户外服装";break;}
        case WCSport_suit:{str = @"运动服";break;}
        case WCWind_coat:{str = @"风衣";break;}
        case WCJeans_wear:{str = @"牛仔";break;}
        case WCUnderwaist:{str = @"背心";break;}
            //下装
        case WCLong_dress:{str = @"长裙";break;}
        case WCShort_skirt:{str = @"短裙";break;}
        case WCTrousers:{str = @"长裤";break;}
        case WCShorts:{str = @"短裤";break;}
        case WCJean:{str = @"牛仔";break;}
        case WCLeggings:{str = @"打底裤";break;}
            //鞋
        case WCFlattie:{str = @"平底鞋";break;}
        case WCDress_shoes:{str = @"晚装鞋";break;}
        case WCHigh_heel_shoe:{str = @"高跟鞋";break;}
        case WCBoots:{str = @"靴子";break;}
        case WCPlatform_shoes:{str = @"松糕鞋";break;}
        case WCSandal:{str = @"凉鞋";break;}
        case WCWedge_heel:{str = @"坡跟鞋";break;}
        case WCSneaker:{str = @"运动鞋";break;}
        case WCSlippers:{str = @"拖鞋";break;}
            //包
        case WCEvening_bag:{str = @"晚装包";break;}
        case WCBackpack:{str = @"双肩包";break;}
        case WCParty_package:{str = @"宴会包";break;}
        case WCSide_shoulder_bag:{str = @"侧肩包";break;}
        case WCSatchel:{str = @"小背包";break;}
        case WCVanity:{str = @"手袋";break;}
        case WCWallet:{str = @"钱包";break;}
            //配饰
        case WCBelt:{str = @"腰带";break;}
        case WCHat:{str = @"帽子";break;}
        case WCSunglass:{str = @"太阳镜";break;}
        case WCScarf:{str = @"围巾";break;}
        case WCGlove:{str = @"手套";break;}
        case WCWatch:{str = @"手表";break;}
        case WCCosmetic:{str = @"化妆品";break;}
        case WCPerfume:{str = @"香水";break;}
            //首饰
        case WCBracelet:{str = @"手镯";break;}
        case WCNecklace:{str = @"项链";break;}
        case WCRing:{str = @"戒指";break;}
        case WCChain_bracelet:{str = @"手链";break;}
        case WCEarrings:{str = @"耳环";break;}
        case WCEar_stud:{str = @"耳钉";break;}
            //内衣
        case WCBra:{str = @"胸罩";break;}
        case WCSun_top:{str = @"吊带衫";break;}
        case WCUnderdress:{str = @"衬裙";break;}
        case WCNight_robe:{str = @"睡袍";break;}
        case WCSilk_stockings:{str = @"丝袜";break;}
        case WCNight_suit:{str = @"睡衣";break;}
        case WCBriefs:{str = @"内裤";break;}
        case WCSocks:{str = @"袜子";break;}
        case WCBathrobe:{str = @"浴袍";break;}
        default:
            break;
    }
    return str;
}

NSArray *getAllWardrobeCategorye(WardrobeType type)
{
    NSArray *arr;
    switch (type) {
        case WTAll:
        {
            arr = @[@"ALL",
                     @"夹克",@"衬衫",@"T恤",@"西装",@"羊毛衫",@"针织衫",@"连衣裙",@"户外服装",@"运动服",@"风衣",@"牛仔",@"背心",
                     
                     @"长裙",@"短裙",@"长裤",@"短裤",@"牛仔",@"打底裤",
                     
                     @"平底鞋",@"晚装鞋",@"高跟鞋",@"靴子",@"松糕鞋",@"凉鞋",@"坡跟鞋",@"运动鞋",@"拖鞋",
                     
                     @"晚装包",@"双肩包",@"宴会包",@"侧肩包",@"小背包",@"手袋",@"钱包",
                     
                     @"腰带",@"帽子",@"太阳镜",@"围巾",@"手套",@"手表",@"化妆品",@"香水",
                     
                     @"手镯",@"项链",@"戒指",@"手链",@"耳环",@"耳钉",
                     
                     @"胸罩",@"吊带衫",@"衬裙",@"睡袍",@"丝袜",@"睡衣",@"内裤",@"袜子",@"浴袍"];
            break;
        }
        case WTUpper:
        {
            arr = @[@"夹克",@"衬衫",@"T恤",@"西装",@"羊毛衫",@"针织衫",@"连衣裙",@"户外服装",@"运动服",@"风衣",@"牛仔",@"背心"];
            break;
        }
        case WTBottoms:
        {
            arr = @[@"长裙",@"短裙",@"长裤",@"短裤",@"牛仔",@"打底裤"];
            break;
        }
        case WTShoes:
        {
            arr = @[@"平底鞋",@"晚装鞋",@"高跟鞋",@"靴子",@"松糕鞋",@"凉鞋",@"坡跟鞋",@"运动鞋",@"拖鞋"];
            break;
        }
        case WTBag:
        {
            arr = @[@"晚装包",@"双肩包",@"宴会包",@"侧肩包",@"小背包",@"手袋",@"钱包"];
            break;
        }
        case WTAccessory:
        {
            arr = @[@"腰带",@"帽子",@"太阳镜",@"围巾",@"手套",@"手表",@"化妆品",@"香水"];
            break;
        }
        case WTJewelry:
        {
            arr = @[@"手镯",@"项链",@"戒指",@"手链",@"耳环",@"耳钉"];
            break;
        }
        case WTUnderwear:
        {
            arr = @[@"胸罩",@"吊带衫",@"衬裙",@"睡袍",@"丝袜",@"睡衣",@"内裤",@"袜子",@"浴袍"];
            break;
        }
        default:
            break;
    }
    
    return arr;
}

NSString *getWardrobeSeasonName(WardrobeSeason type)
{
    NSString *str;
    switch (type) {
        case WSAll:{str = @"ALL";break;}
            
        case WSSpringAndSummer:{str = @"春夏";break;}
            
        case WSAutumnAndWinter:{str = @"秋冬";break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllWardrobeSeason()
{
    NSArray *arr = @[@"ALL",@"春夏",@"秋冬"];
    
    return arr;
}

NSString *getCollocationStyleName(CollocationStyle type)
{
    NSString *str;
    switch (type) {
        case CSAll:{str = @"ALL";break;}
            
        case CSFormal_wear:{str = @"正装";break;}
            
        case CSCasual_Wear:{str = @"休闲";break;}
            
        case CSSportswear:{str = @"运动";break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllCollocationStyle()
{
    NSArray *arr = @[@"ALL",@"正装",@"休闲",@"运动"];
    
    return arr;
}

NSString *getCollocationOccasionName(CollocationOccasion type)
{
    NSString *str;
    switch (type) {
        case COAll:{str = @"ALL";break;}
            
        case COWorking:{str = @"工作";break;}
            
        case COHome:{str = @"家居";break;}
            
        case CODinner:{str = @"晚宴";break;}
            
        case COParty:{str = @"聚会";break;}
            
        case COFitness:{str = @"健身";break;}
            
        case COJourney:{str = @"出游";break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllCollocationOccasion()
{
    NSArray *arr = @[@"ALL",@"工作",@"家居",@"晚宴",@"聚会",@"健身",@"出游"];
    
    return arr;
}

NSString *getNotAllDayRemindName(NotAllDayRemind notAllDayRemind)
{
    NSString *str;
    switch (notAllDayRemind) {
        case NADR_none:{str = @"无通知";break;}
            
        case NADR_before1hour:{str = @"提前一小时";break;}
            
        case NADR_before2hour:{str = @"提前两小时";break;}
            
        case NADR_before3hour:{str = @"提前三小时";break;}
            
        case NADR_before5hour:{str = @"提前五小时";break;}
            
        case NADR_before1day:{str = @"提前一天";break;}
            
        case NADR_before2day:{str = @"提前两天";break;}
            
        case NADR_before1week:{str = @"提前一周";break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getNotAllDayRemind()
{
    NSArray *arr = @[@"无通知",@"提前一小时",@"提前两小时",@"提前三小时",@"提前五小时",@"提前一天",@"提前两天",@"提前一周"];
    
    return arr;
}

NSString *getAllDayRemindName(AllDayRemind allDayRemind)
{
    NSString *str;
    switch (allDayRemind) {
        case ADR_none:{str = @"无通知";break;}
            
        case ADR_before1day:{str = @"提前一天";break;}
            
        case ADR_before2day:{str = @"提前两天";break;}
            
        case ADR_before3day:{str = @"提前三天";break;}
            
        case ADR_before1week:{str = @"提前一周";break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllDayRemind()
{
    NSArray *arr = @[@"无通知",@"提前一天",@"提前两天",@"提前三天",@"提前一周"];
    
    return arr;
}

NSString *getColorName(ActivityColor color)
{
    NSString *str;
    switch (color) {
        case AC0:{str = @"默认";break;}
            
        case AC1:{str = @"番茄红";break;}
            
        case AC2:{str = @"橘红";break;}
            
        case AC3:{str = @"香蕉黄";break;}
            
        case AC4:{str = @"罗勒绿";break;}
            
        case AC5:{str = @"鼠尾草绿";break;}
            
        case AC6:{str = @"孔雀蓝";break;}
            
        case AC7:{str = @"蓝莓色";break;}
            
        case AC8:{str = @"薰衣草色";break;}
            
        case AC9:{str = @"葡萄紫";break;}
            
        case AC10:{str = @"红鹤色";break;}
            
        case AC11:{str = @"石墨黑";break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllColor()
{
    NSArray *arr = @[@"默认",
                     @"番茄红",
                     @"橘红",
                     @"香蕉黄",
                     @"罗勒绿",
                     @"鼠尾草绿",
                     @"孔雀蓝",
                     @"蓝莓色",
                     @"薰衣草色",
                     @"葡萄紫",
                     @"红鹤色",
                     @"石墨黑"];
    return arr;
}

UIColor *getColor(ActivityColor activityColor)
{
    UIColor *color;
    switch (activityColor) {
        case AC0:
        {
            color = colorWithHexString(@"#45ddcb");
            break;
        }
        case AC1:
        {
            color = colorWithHexString(@"#d30100");
            break;
        }
        case AC2:
        {
            color = colorWithHexString(@"#f3511d");
            break;
        }
        case AC3:
        {
            color = colorWithHexString(@"#f5bf24");
            break;
        }
        case AC4:
        {
            color = colorWithHexString(@"#0a7f41");
            break;
        }
        case AC5:
        {
            color = colorWithHexString(@"#33b679");
            break;
        }
        case AC6:
        {
            color = colorWithHexString(@"#029be4");
            break;
        }
        case AC7:
        {
            color = colorWithHexString(@"#3b5aad");
            break;
        }
        case AC8:
        {
            color = colorWithHexString(@"#7886ca");
            break;
        }
        case AC9:
        {
            color = colorWithHexString(@"#8c25a8");
            break;
        }
        case AC10:
        {
            color = colorWithHexString(@"#ec7e72");
            break;
        }
        case AC11:
        {
            color = colorWithHexString(@"#636363");
            break;
        }
        default:
            break;
    }
    return color;
}

@end
