//
//  UserInfo.m
//  iOSGetFollow
//
//  Created by TCH on 15/6/4.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSString *)userDataPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserData.data"];
}

+ (void)archiverUserInfo:(UserInfo *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:[UserInfo userDataPath]];
}

+ (UserInfo *)unarchiverUserData
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self userDataPath]])
    {
        return nil;
    }
    
    UserInfo *info = [NSKeyedUnarchiver unarchiveObjectWithFile:[UserInfo userDataPath]];
    
    return info;
}

+ (void)deleteArchieveData
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self userDataPath]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self userDataPath] error:nil];
    }
}

//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.numId = nil;
    self.numGender = nil;
    self.numPlat = nil;
    self.numTplat = nil;
    self.strUid = nil;
    self.strToken = nil;
    self.strTname = nil;
    self.strEmail = nil;
    self.strBirth = nil;
    self.strPicURL = nil;
    self.strCountry = nil;
    self.numLocalId = nil;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.numId forKey:@"numId"];
    [encoder encodeObject:self.numGender forKey:@"numGender"];
    [encoder encodeObject:self.numPlat forKey:@"numPlat"];
    [encoder encodeObject:self.numTplat forKey:@"numTplat"];
    [encoder encodeObject:self.strUid forKey:@"strUid"];
    [encoder encodeObject:self.strToken forKey:@"strToken"];
    [encoder encodeObject:self.strTname forKey:@"strTname"];
    [encoder encodeObject:self.strEmail forKey:@"strEmail"];
    [encoder encodeObject:self.strBirth forKey:@"strBirth"];
    [encoder encodeObject:self.strPicURL forKey:@"strPicURL"];
    [encoder encodeObject:self.strCountry forKey:@"strCountry"];
    [encoder encodeObject:self.numLocalId forKey:@"numLocalId"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.numId  = [decoder decodeObjectForKey:@"numId"];
        self.numGender  = [decoder decodeObjectForKey:@"numGender"];
        self.numPlat  = [decoder decodeObjectForKey:@"numPlat"];
        self.numTplat  = [decoder decodeObjectForKey:@"numTplat"];
        self.strUid  = [decoder decodeObjectForKey:@"strUid"];
        self.strToken  = [decoder decodeObjectForKey:@"strToken"];
        self.strTname  = [decoder decodeObjectForKey:@"strTname"];
        self.strEmail  = [decoder decodeObjectForKey:@"strEmail"];
        self.strBirth  = [decoder decodeObjectForKey:@"strBirth"];
        self.strPicURL  = [decoder decodeObjectForKey:@"strPicURL"];
        self.strCountry  = [decoder decodeObjectForKey:@"strCountry"];
        self.numLocalId = [decoder decodeObjectForKey:@"numLocalId"];
    }
    return self;
}

@end
