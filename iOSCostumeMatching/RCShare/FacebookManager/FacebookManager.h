//
//  FacebookManager.h
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/15.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookManager : NSObject

@property (nonatomic) BOOL isLogined;

+ (FacebookManager *)shareManager;
-(void)loginSuccess:(void(^)(NSString *token))success andFailed:(void (^)(NSError *error))failure
- (void)logOut;
-(void)getUserInfoSuccess:(void(^)(NSDictionary *userInfo))success andFailed:(void (^)(NSError *error))failure;

-(void)loadfriendsSuccess:(void(^)(NSArray* friends))success andFailed:(void (^)(NSError *error))failure;
-(void)getCoverGraphPathSuccess:(void(^)(NSDictionary *dic))success andFailed:(void (^)(NSError *error))failure;
-(void)getHeadPicturePathSuccess:(void(^)(NSDictionary *dic))success andFailed:(void (^)(NSError *error))failure;
-(void)shareToFacebookWithName:(NSString *)name caption:(NSString *)caption desc:(NSString *)desc link:(NSString *)link picture:(NSString *)picture;

//void FacebookProxyShare(const char * name,const char * caption, const char * desc, const char * link, const char * picture);
//- (void)postStatusToFacebook: (NSString*)status withImage: (UIImage*)image;
- (void)postStatusToFacebookWithName:(NSString *)name caption:(NSString *)caption desc:(NSString *)desc link:(NSString *)link image: (UIImage*)image;
@end
