//
//  RC_RequestManager.h
//  FacebookHealth
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RC_RequestManager : NSObject

+ (RC_RequestManager *)shareManager;

- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)getInstagramToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)loginWith:(UserInfo *)userInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)addClothingWithColothesInfo:(ClothesInfo *)clothesInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)addCollocationWithCollocationInfo:(CollocationInfo *)collocationInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)searchCollocationWithStyleId:(int)styleId OccId:(int)occId MinId:(int)mId Count:(int)count success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)GetCollocationDetailWithCoId:(int)coId success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)ReportCollocationWithCoId:(int)coId success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)LikeCollocationWithCoId:(int)coId success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

-(void)getLikedCollocationWithStyleId:(int)styleId OccId:(int)occId MinId:(int)mId Count:(int)count success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure;

- (void)cancleAllRequests;

@end
