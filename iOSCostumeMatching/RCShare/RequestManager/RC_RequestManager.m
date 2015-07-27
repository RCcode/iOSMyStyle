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

#define ServerRootURL                @"http://192.168.0.89:8083/MyStyleWeb%@"
//#define ServerRootURL                @"http://192.168.0.194:8080/MyStyleWeb%@"

#define LoginURL                     @"/user/login.do"
#define AddClothingURL               @"/user/addClothing.do"



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

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation RC_RequestManager

static RC_RequestManager *requestManager = nil;

+ (RC_RequestManager *)shareManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        requestManager = [[RC_RequestManager alloc]init];
        requestManager.manager = [AFHTTPRequestOperationManager manager];
    });
    return requestManager;
}

#pragma mark -
#pragma mark 公共请求 （Get）

-(void)requestServiceWithGet:(NSString *)url_Str success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _manager.responseSerializer = responseSerializer;
    
    [_manager GET:url_Str parameters:nil
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

- (void)requestServiceWithPost:(NSString *)url_Str parameters:(id)parameters RequestSerializer:(AFJSONRequestSerializer *)requestSerializer ResponseSerializer:(AFJSONResponseSerializer *)responseSerializer success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if (requestSerializer) {
        _manager.requestSerializer = requestSerializer;
    }
    else
    {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    if (responseSerializer) {
        _manager.responseSerializer = responseSerializer;
    }

    [_manager POST:url_Str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [self requestServiceWithPost:InstagramGetAccess_tokenURL parameters:dictionary RequestSerializer:nil ResponseSerializer:responseSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)loginWith:(UserInfo *)userInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    NSDictionary *params = @{@"uid":userInfo.strUid,
                             @"tplat":userInfo.numTplat,
                             @"token":userInfo.strToken,
                             @"tname":userInfo.strTname,
                             @"plat":userInfo.numPlat};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,LoginURL];
    [self requestServiceWithPost:url parameters:params RequestSerializer:requestSerializer ResponseSerializer:responseSerializer success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)addClothingWithColothesInfo:(ClothesInfo *)clothesInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
//    NSDictionary *params = @{@"id":userInfo.numId,
//                             @"token":userInfo.strToken,
//                             @"cateId":clothesInfo.numCateId,
//                             @"scateId":clothesInfo.numScateId,
//                             @"seaId":clothesInfo.numSeaId,
//                             @"brand":clothesInfo.strBrand};
    NSDictionary *params = @{@"id":@"3",@"token":@"1111111",@"cateId":@"1",@"scateId":@"1",@"seaId":@"1",@"brand":@"1"};

    NSString *url = [NSString stringWithFormat:ServerRootURL,AddClothingURL];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    _manager.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _manager.responseSerializer = responseSerializer;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

//    NSData *imageData = UIImageJPEGRepresentation(clothesInfo.file, 0.3);
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"ball"], 0.3);
    AFHTTPRequestOperation *request = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"File" fileName:fileName mimeType:@"image/jpeg"];
        
        
//        [formData appendPartWithFormData:imageData name:@"file"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
//    [request setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
//    }];
    
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
    [_manager.operationQueue cancelAllOperations];
}


@end
