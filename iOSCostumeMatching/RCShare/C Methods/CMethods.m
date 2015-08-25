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

//    return NSLocalizedString(translation_key, none);
    NSString *language = @"en";
    
    //只适配这么些种语言，其余一律用en
    if([CURR_LANG isEqualToString:@"zh-Hans"] ){
        language = CURR_LANG;
    }
//    if([CURR_LANG isEqualToString:@"zh-Hans"] ||
//       [CURR_LANG isEqualToString:@"zh-Hant"] ||
//       [CURR_LANG isEqualToString:@"de"] ||
//       [CURR_LANG isEqualToString:@"es"] ||
//       [CURR_LANG isEqualToString:@"fr"] ||
//       [CURR_LANG isEqualToString:@"it"] ||
//       [CURR_LANG isEqualToString:@"ko"] ||
//       [CURR_LANG isEqualToString:@"ja"] ||
//       [CURR_LANG isEqualToString:@"pt"] ||
//       [CURR_LANG isEqualToString:@"pt-PT"] ||
//       [CURR_LANG isEqualToString:@"ru"] ||
//       [CURR_LANG isEqualToString:@"ar"] ||
//       [CURR_LANG isEqualToString:@"id"] ||
//       [CURR_LANG isEqualToString:@"th"] ){
//        language = CURR_LANG;
//    }
    if (IS_IOS_9) {
        return NSLocalizedString(translation_key, nil);
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
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], LocalizedString(@"Sunday", nil), LocalizedString(@"Monday", nil), LocalizedString(@"Tuesday", nil), LocalizedString(@"Wednesday", nil), LocalizedString(@"Thursday", nil),LocalizedString(@"Friday", nil), LocalizedString(@"Saturday", nil), nil];
    
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
            str = LocalizedString(@"ALL", nil);
            break;
        }
        case WTUpper:
        {
            str = LocalizedString(@"Top/Dresses", nil);
            break;
        }
        case WTBottoms:
        {
            str = LocalizedString(@"Bottoms", nil);
            break;
        }
        case WTShoes:
        {
            str = LocalizedString(@"Shoes", nil);
            break;
        }
        case WTBag:
        {
            str = LocalizedString(@"Bags", nil);
            break;
        }
        case WTAccessory:
        {
            str = LocalizedString(@"Accessories", nil);
            break;
        }
        case WTJewelry:
        {
            str = LocalizedString(@"Jewelry", nil);
            break;
        }
        case WTUnderwear:
        {
            str = LocalizedString(@"Intimates", nil);
            break;
        }
        default:
            break;
    }
    return str;
}

NSArray *getAllWardrobeType()
{
    NSArray *arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Top/Dresses",nil),LocalizedString(@"Bottoms", nil),LocalizedString(@"Shoes", nil),LocalizedString(@"Bags", nil),LocalizedString(@"Accessories", nil),LocalizedString(@"Jewelry", nil),LocalizedString(@"Intimates",nil)];
    
    return arr;
}

NSString *getWardrobeCategoryeName(WardrobeCategory type)
{
    NSString *str;
    switch (type) {
        case WCAll:{str = LocalizedString(@"ALL", nil);break;}
            
        case WCJacket:{str = LocalizedString(@"Jackets", nil);break;}
        case WCShirt:{str = LocalizedString(@"Shirts", nil);break;}
        case WCT_shirt:{str = LocalizedString(@"T-Shirt", nil);break;}
        case WCBusiness_suit:{str = LocalizedString(@"Suits", nil);break;}
        case WCWoollen_sweater:{str = LocalizedString(@"Cardigan", nil);break;}
        case WCKnitwear:{str = LocalizedString(@"Sweaters", nil);break;}
        case WCOne_piece_dress:{str = LocalizedString(@"Dresses", nil);break;}
        case WCOutdoor_clothing:{str = LocalizedString(@"Outdoor", nil);break;}
        case WCSport_suit:{str = LocalizedString(@"Sportswear", nil);break;}
        case WCWind_coat:{str = LocalizedString(@"Windbreaker", nil);break;}
        case WCJeans_wear:{str = LocalizedString(@"Jeans", nil);break;}
        case WCUnderwaist:{str = LocalizedString(@"Tank_Top", nil);break;}
            //下装
        case WCLong_dress:{str = LocalizedString(@"Long_Dress", nil);break;}
        case WCShort_skirt:{str = LocalizedString(@"Skirts", nil);break;}
        case WCTrousers:{str = LocalizedString(@"Trousers", nil);break;}
        case WCShorts:{str = LocalizedString(@"Shorts", nil);break;}
        case WCJean:{str = LocalizedString(@"Jeans", nil);break;}
        case WCLeggings:{str = LocalizedString(@"Leggings", nil);break;}
            //鞋
        case WCFlattie:{str = LocalizedString(@"Flats", nil);break;}
        case WCDress_shoes:{str = LocalizedString(@"EveningBoot", nil);break;}
        case WCHigh_heel_shoe:{str = LocalizedString(@"High_Heels", nil);break;}
        case WCBoots:{str = LocalizedString(@"Boots", nil);break;}
        case WCPlatform_shoes:{str = LocalizedString(@"Platforms", nil);break;}
        case WCSandal:{str = LocalizedString(@"Sandals", nil);break;}
        case WCWedge_heel:{str = LocalizedString(@"Wedges", nil);break;}
        case WCSneaker:{str = LocalizedString(@"Sneakers", nil);break;}
        case WCSlippers:{str = LocalizedString(@"Slippers", nil);break;}
            //包
        case WCEvening_bag:{str = LocalizedString(@"EveningBag", nil);break;}
        case WCBackpack:{str = LocalizedString(@"Backpacks", nil);break;}
        case WCParty_package:{str = LocalizedString(@"PartyBag", nil);break;}
        case WCSide_shoulder_bag:{str = LocalizedString(@"Handbags", nil);break;}
        case WCSatchel:{str = LocalizedString(@"Satchels", nil);break;}
        case WCVanity:{str = LocalizedString(@"Clutches", nil);break;}
        case WCWallet:{str = LocalizedString(@"Wallets", nil);break;}
            //配饰
        case WCBelt:{str = LocalizedString(@"Belts", nil);break;}
        case WCHat:{str = LocalizedString(@"Hats", nil);break;}
        case WCSunglass:{str = LocalizedString(@"Sunglasses", nil);break;}
        case WCScarf:{str = LocalizedString(@"Scarves", nil);break;}
        case WCGlove:{str = LocalizedString(@"Gloves", nil);break;}
        case WCWatch:{str = LocalizedString(@"Watches", nil);break;}
        case WCCosmetic:{str = LocalizedString(@"Makeup", nil);break;}
        case WCPerfume:{str = LocalizedString(@"Perfume", nil);break;}
            //首饰
        case WCBracelet:{str = LocalizedString(@"Bracelets", nil);break;}
        case WCNecklace:{str = LocalizedString(@"Necklaces", nil);break;}
        case WCRing:{str = LocalizedString(@"Rings", nil);break;}
        case WCEarrings:{str = LocalizedString(@"Earrings", nil);break;}
        case WCEar_Pins:{str = LocalizedString(@"Pins", nil);break;}
            //内衣
        case WCBra:{str = LocalizedString(@"Bras", nil);break;}
        case WCSun_top:{str = LocalizedString(@"Vest", nil);break;}
        case WCUnderdress:{str = LocalizedString(@"Petticoats", nil);break;}
        case WCNight_robe:{str = LocalizedString(@"Gowns", nil);break;}
        case WCSilk_stockings:{str = LocalizedString(@"Stockings", nil);break;}
        case WCNight_suit:{str = LocalizedString(@"Pajamas", nil);break;}
        case WCBriefs:{str = LocalizedString(@"Underwear", nil);break;}
        case WCSocks:{str = LocalizedString(@"Socks", nil);break;}
        case WCBathrobe:{str = LocalizedString(@"Bathrobes", nil);break;}
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
            arr = @[LocalizedString(@"ALL", nil),
                    
                    LocalizedString(@"Jackets", nil),LocalizedString(@"Shirts", nil),LocalizedString(@"T-Shirt", nil),LocalizedString(@"Suits", nil),LocalizedString(@"Cardigan", nil),LocalizedString(@"Sweaters", nil),LocalizedString(@"Dresses", nil),LocalizedString(@"Outdoor", nil),LocalizedString(@"Sportswear", nil),LocalizedString(@"Windbreaker", nil),LocalizedString(@"Jeans", nil),LocalizedString(@"Tank_Top", nil),
                    
                    LocalizedString(@"Long_Dress", nil),LocalizedString(@"Skirts", nil),LocalizedString(@"Trousers", nil),LocalizedString(@"Shorts", nil),LocalizedString(@"Jeans", nil),LocalizedString(@"Leggings", nil),

                    LocalizedString(@"Flats", nil),LocalizedString(@"EveningBoot", nil),LocalizedString(@"High_Heels", nil),LocalizedString(@"Boots", nil),LocalizedString(@"Platforms", nil),LocalizedString(@"Sandals", nil),LocalizedString(@"Wedges", nil),LocalizedString(@"Sneakers", nil),LocalizedString(@"Slippers", nil),
                    
                    LocalizedString(@"EveningBag", nil),LocalizedString(@"Backpacks", nil),LocalizedString(@"PartyBag", nil),LocalizedString(@"Handbags", nil),LocalizedString(@"Satchels", nil),LocalizedString(@"Clutches", nil),LocalizedString(@"Wallets", nil),
                    
                    LocalizedString(@"Belts", nil),LocalizedString(@"Hats", nil),LocalizedString(@"Sunglasses", nil),LocalizedString(@"Scarves", nil),LocalizedString(@"Gloves", nil),LocalizedString(@"Watches", nil),LocalizedString(@"Makeup", nil),LocalizedString(@"Perfume", nil),
                    
                    LocalizedString(@"Bracelets", nil),LocalizedString(@"Necklaces", nil),LocalizedString(@"Rings", nil),LocalizedString(@"Earrings", nil),LocalizedString(@"Pins", nil),
                    
                    LocalizedString(@"Bras", nil),LocalizedString(@"Vest", nil),LocalizedString(@"Petticoats", nil),LocalizedString(@"Gowns", nil),LocalizedString(@"Stockings", nil),LocalizedString(@"Pajamas", nil),LocalizedString(@"Underwear", nil),LocalizedString(@"Socks", nil),LocalizedString(@"Bathrobes", nil)];
            break;
        }
        case WTUpper:
        {
            arr = @[LocalizedString(@"ALL", nil),
                    LocalizedString(@"Jackets", nil),LocalizedString(@"Shirts", nil),LocalizedString(@"T-Shirt", nil),LocalizedString(@"Suits", nil),LocalizedString(@"Cardigan", nil),LocalizedString(@"Sweaters", nil),LocalizedString(@"Dresses", nil),LocalizedString(@"Outdoor", nil),LocalizedString(@"Sportswear", nil),LocalizedString(@"Windbreaker", nil),LocalizedString(@"Jeans", nil),LocalizedString(@"Tank_Top", nil)];
            break;
        }
        case WTBottoms:
        {
            arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Long_Dress", nil),LocalizedString(@"Skirts", nil),LocalizedString(@"Trousers", nil),LocalizedString(@"Shorts", nil),LocalizedString(@"Jeans", nil),LocalizedString(@"Leggings", nil)];
            break;
        }
        case WTShoes:
        {
            arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Flats", nil),LocalizedString(@"EveningBoot", nil),LocalizedString(@"High_Heels", nil),LocalizedString(@"Boots", nil),LocalizedString(@"Platforms", nil),LocalizedString(@"Sandals", nil),LocalizedString(@"Wedges", nil),LocalizedString(@"Sneakers", nil),LocalizedString(@"Slippers", nil)];
            break;
        }
        case WTBag:
        {
            arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"EveningBag", nil),LocalizedString(@"Backpacks", nil),LocalizedString(@"PartyBag", nil),LocalizedString(@"Handbags", nil),LocalizedString(@"Satchels", nil),LocalizedString(@"Clutches", nil),LocalizedString(@"Wallets", nil)];
            break;
        }
        case WTAccessory:
        {
            arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Belts", nil),LocalizedString(@"Hats", nil),LocalizedString(@"Sunglasses", nil),LocalizedString(@"Scarves", nil),LocalizedString(@"Gloves", nil),LocalizedString(@"Watches", nil),LocalizedString(@"Makeup", nil),LocalizedString(@"Perfume", nil)];
            break;
        }
        case WTJewelry:
        {
            arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Bracelets", nil),LocalizedString(@"Necklaces", nil),LocalizedString(@"Rings", nil),LocalizedString(@"Earrings", nil),LocalizedString(@"Pins", nil)];
            break;
        }
        case WTUnderwear:
        {
            arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Bras", nil),LocalizedString(@"Vest", nil),LocalizedString(@"Petticoats", nil),LocalizedString(@"Gowns", nil),LocalizedString(@"Stockings", nil),LocalizedString(@"Pajamas", nil),LocalizedString(@"Underwear", nil),LocalizedString(@"Socks", nil),LocalizedString(@"Bathrobes", nil)];
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
        case WSAll:{str = LocalizedString(@"ALL", nil);break;}
            
        case WSSpringAndSummer:{str = LocalizedString(@"Spring/Summer", nil);break;}
            
        case WSAutumnAndWinter:{str = LocalizedString(@"Fall/Winter", nil);break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllWardrobeSeason()
{
    NSArray *arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Spring/Summer", nil),LocalizedString(@"Fall/Winter", nil)];
    
    return arr;
}

NSString *getCollocationStyleName(CollocationStyle type)
{
    NSString *str;
    switch (type) {
        case CSAll:{str = LocalizedString(@"ALL", nil);break;}
            
        case CSFormal_wear:{str = LocalizedString(@"Dreesy", nil);break;}
            
        case CSCasual_Wear:{str = LocalizedString(@"Casual", nil);break;}
            
        case CSSportswear:{str = LocalizedString(@"Sport", nil);break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllCollocationStyle()
{
    NSArray *arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Dreesy", nil),LocalizedString(@"Casual", nil),LocalizedString(@"Sport", nil)];
    
    return arr;
}

NSString *getCollocationOccasionName(CollocationOccasion type)
{
    NSString *str;
    switch (type) {
        case COAll:{str = LocalizedString(@"ALL", nil);break;}
            
        case COWorking:{str = LocalizedString(@"Work", nil);break;}
            
        case COHome:{str = LocalizedString(@"Home", nil);break;}
            
        case CODinner:{str = LocalizedString(@"Evening", nil);break;}
            
        case COParty:{str = LocalizedString(@"Party", nil);break;}
            
        case COFitness:{str = LocalizedString(@"GYM", nil);break;}
            
        case COJourney:{str = LocalizedString(@"Outing", nil);break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllCollocationOccasion()
{
    NSArray *arr = @[LocalizedString(@"ALL", nil),LocalizedString(@"Work", nil),LocalizedString(@"Home", nil),LocalizedString(@"Evening", nil),LocalizedString(@"Party", nil),LocalizedString(@"GYM", nil),LocalizedString(@"Outing", nil)];
    
    return arr;
}

NSString *getNotAllDayRemindName(NotAllDayRemind notAllDayRemind)
{
    NSString *str;
    switch (notAllDayRemind) {
        case NADR_none:{str = LocalizedString(@"No_notification", nil);break;}
            
        case NADR_before1hour:{str = LocalizedString(@"1_hour_before", nil);break;}
            
        case NADR_before2hour:{str = LocalizedString(@"2_hour_before", nil);break;}
            
        case NADR_before3hour:{str = LocalizedString(@"3_hour_before", nil);break;}
            
        case NADR_before5hour:{str = LocalizedString(@"5_hour_before", nil);break;}
            
        case NADR_before1day:{str = LocalizedString(@"NotAllDay_1_day_before", nil);break;}
            
        case NADR_before2day:{str = LocalizedString(@"NotAllDay_2_day_before", nil);break;}
            
        case NADR_before1week:{str = LocalizedString(@"NotAllDay_1_week_before", nil);break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getNotAllDayRemind()
{
    NSArray *arr = @[LocalizedString(@"No_notification", nil),LocalizedString(@"1_hour_before", nil),LocalizedString(@"2_hour_before", nil),LocalizedString(@"3_hour_before", nil),LocalizedString(@"5_hour_before", nil),LocalizedString(@"NotAllDay_1_day_before", nil),LocalizedString(@"NotAllDay_2_day_before", nil),LocalizedString(@"NotAllDay_1_week_before", nil)];
    
    return arr;
}

NSString *getAllDayRemindName(AllDayRemind allDayRemind)
{
    NSString *str;
    switch (allDayRemind) {
        case ADR_none:{str = LocalizedString(@"No_notification", nil);break;}
            
        case ADR_intraday:{str = LocalizedString(@"On_the_day", nil);break;}
            
        case ADR_before1day:{str = LocalizedString(@"1_day_before", nil);break;}
            
        case ADR_before2day:{str = LocalizedString(@"2_day_before", nil);break;}
            
        case ADR_before3day:{str = LocalizedString(@"3_day_before", nil);break;}
            
        case ADR_before1week:{str = LocalizedString(@"1_week_before", nil);break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllDayRemind()
{
    NSArray *arr = @[LocalizedString(@"No_notification", nil),LocalizedString(@"On_the_day", nil),LocalizedString(@"1_day_before", nil),LocalizedString(@"2_day_before", nil),LocalizedString(@"3_day_before",nil),LocalizedString(@"1_week_before", nil)];
    
    return arr;
}

NSString *getColorName(ActivityColor color)
{
    NSString *str;
    switch (color) {
        case AC0:{str = LocalizedString(@"Default_color", nil);break;}
            
        case AC1:{str = LocalizedString(@"Tomato", nil);break;}
            
        case AC2:{str = LocalizedString(@"Tangerine", nil);break;}
            
        case AC3:{str = LocalizedString(@"Banana", nil);break;}
            
        case AC4:{str = LocalizedString(@"Basil", nil);break;}
            
        case AC5:{str = LocalizedString(@"Sage", nil);break;}
            
        case AC6:{str = LocalizedString(@"Peacock", nil);break;}
            
        case AC7:{str = LocalizedString(@"Blueberry", nil);break;}
            
        case AC8:{str = LocalizedString(@"Lavender", nil);break;}
            
        case AC9:{str = LocalizedString(@"Grape", nil);break;}
            
        case AC10:{str = LocalizedString(@"Flamingo", nil);break;}
            
        case AC11:{str = LocalizedString(@"Graphite", nil);break;}
            
        default:
            break;
    }
    return str;
}

NSArray *getAllColor()
{
    NSArray *arr = @[LocalizedString(@"Default_color", nil),
                     LocalizedString(@"Tomato", nil),
                     LocalizedString(@"Tangerine", nil),
                     LocalizedString(@"Banana", nil),
                     LocalizedString(@"Basil", nil),
                     LocalizedString(@"Sage", nil),
                     LocalizedString(@"Peacock", nil),
                     LocalizedString(@"Blueberry", nil),
                     LocalizedString(@"Lavender", nil),
                     LocalizedString(@"Grape", nil),
                     LocalizedString(@"Flamingo", nil),
                     LocalizedString(@"Graphite", nil)];
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
