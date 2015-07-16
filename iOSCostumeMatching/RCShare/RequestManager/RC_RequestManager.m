//
//  RC_RequestManager.m
//  FacebookHealth
//
//  Created by TCH on 15/5/13.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RC_RequestManager.h"
#import "AFNetworking.h"
#import "Reachability.h"

#define InstagramGetAccess_tokenURL  @"https://api.instagram.com/oauth/access_token?scope=likes+relationships"

#define ServerRootURL                @"http://f4f.rcplatformhk.net/RcGetFollowsWeb/V2%@"
//#define ServerRootURL                @"http://192.168.0.86:8084/RcGetFollowsWeb/V2%@"
#define RegisteUseInfoURL            @"/user/registeUseInfo.do"
#define UpdateClassifyURL            @"/user/updateClassify.do"
#define GetFollowsURL                @"/user/getFollows.do"
#define PostFollowsURL               @"/user/postFollows.do"
#define UpdateShareIgURL             @"/user/updateShareIg.do"
#define UpdateFiveStartURL           @"/user/updateFiveStart.do"
#define GetUserInfoURL               @"/user/getUserInfo.do"
#define PostOrdersURL                @"/user/postOrders.do"
#define ReportUserURL                @"/user/reportUser.do"
#define UpdateAdvCoin                @"/user/updateAdvCoin.do"


@interface RC_RequestManager()

@property (nonatomic,strong) AFHTTPRequestOperationManager *operation;

@end

@implementation RC_RequestManager

static RC_RequestManager *requestManager = nil;

+ (RC_RequestManager *)shareManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        requestManager = [[RC_RequestManager alloc]init];
        requestManager.operation = [AFHTTPRequestOperationManager manager];
    });
    return requestManager;
}

#pragma mark -
#pragma mark 公共请求 （Get）

-(void)requestServiceWithGet:(NSString *)url_Str success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    _operation.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _operation.responseSerializer = responseSerializer;
    
    [_operation GET:url_Str parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //解析数据
                if (success) {
                    success(responseObject);
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
    
}

#pragma mark -
#pragma mark 公共请求 （Post）

- (void)requestServiceWithPost:(NSString *)url_Str parameters:(id)parameters jsonRequestSerializer:(AFJSONRequestSerializer *)requestSerializer success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if (requestSerializer) {
        _operation.requestSerializer = requestSerializer;
    }
    else
    {
        _operation.requestSerializer = [AFHTTPRequestSerializer serializer];
    }

    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _operation.responseSerializer = responseSerializer;
    [_operation POST:url_Str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析数据
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark -
#pragma mark 注册设备

- (void)registerToken:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
//    [self requestServiceWithPost:kPushURL parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
}

#pragma mark -
#pragma mark 获取Instagramtoken

-(void)getInstagramToken:(NSDictionary *)dictionary success:(void (^)(id))success andFailed:(void (^)(NSError *))failure
{
    if (![self checkNetWorking])
        return;
    
    [self requestServiceWithPost:InstagramGetAccess_tokenURL parameters:dictionary jsonRequestSerializer:nil success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/**
 *  注册更新用户信息
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)registeUseInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,RegisteUseInfoURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  更新用户兴趣分类
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateClassify:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateClassifyURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取follow用户列表
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)getFollows:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,GetFollowsURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  上报follow用户列表
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)postFollows:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,PostFollowsURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  更新用户分享IG
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateShareIg:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateShareIgURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  更新用户评论五星状态
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateFiveStart:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateFiveStartURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  点击广告增加金币
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)updateAdvCoin:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,UpdateAdvCoin];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取用户基本信息状态
 *
 *  @param dictionary <#dictionary description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

-(void)getUserInfo:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,GetUserInfoURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)postOrders:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,PostOrdersURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/////

-(void)reportUser:(NSDictionary *)dictionary success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,ReportUserURL];
    [self requestServiceWithPost:url parameters:dictionary jsonRequestSerializer:requestSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -
#pragma mark 检测网络状态

- (BOOL)checkNetWorking
{
    BOOL connected = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO;
    
    return connected;
}

- (void)cancleAllRequests
{
    [_operation.operationQueue cancelAllOperations];
}


@end
