//
//  UserInfo.h
//  iOSGetFollow
//
//  Created by TCH on 15/6/4.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/**
 id         平台用户唯一标识            int		N
 uid        用户id(第三方用户标识)       String		N
 tplat      第三方平台id                byte		N
 (1:ig;   2:fb;   3:google;   4:twitter   5:微信    6:QQ    7:微博）
 token      第三方token                String		N
 tname      第三方用户名                String		N
 plat       平台id:0.android;1.ios     byte		N
 email      用户邮箱                    String	Y
 ikey       ios推送key                 String	Y
 akey       android推送key             String	Y
 gender     性别:0.女;1.男              int		Y
 birth      生日(yyyy-MM-dd)           datetime	Y
 picURL        头像                       String	Y
 country	国家                       String	Y
 
 localId    本地自增标识
 */

@property (nonatomic, copy) NSNumber *numId;
@property (nonatomic, copy) NSString *strUid;
@property (nonatomic, copy) NSNumber *numTplat;
@property (nonatomic, copy) NSString *strToken;
@property (nonatomic, copy) NSString *strTname;
@property (nonatomic, copy) NSNumber *numPlat;
@property (nonatomic, copy) NSString *strEmail;
@property (nonatomic, copy) NSNumber *numGender;
@property (nonatomic, copy) NSString *strBirth;
@property (nonatomic, copy) NSString *strPicURL;
@property (nonatomic, copy) NSString *strCountry;

@property (nonatomic, copy) NSNumber *numLocalId;

+ (void)archiverUserInfo:(UserInfo *)userInfo;
+ (UserInfo *)unarchiverUserData;
+ (void)deleteArchieveData;

@end
