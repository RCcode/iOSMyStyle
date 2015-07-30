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
#define AddCollocationURL            @"/user/addCollocation.do"
#define ReportCollocationURL         @"/user/reportCollocation.do"
#define SearchCollocationURL         @"/user/searchCollocation.do"
#define GetCollocationDetailURL      @"/user/getCollocation.do"
#define LikeCollocationURL           @"/user/likeCollocation.do"
#define GetLikedCollocationListURL   @"/user/getLikedCollocation.do"

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

/**
 *  登陆服务器
 *
 *  @param userInfo <#userInfo description#>
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */

-(void)loginWith:(UserInfo *)userInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    NSDictionary *params = @{@"uid":userInfo.strUid,
                             @"tplat":userInfo.numTplat,
                             @"token":userInfo.strToken,
                             @"tname":userInfo.strTname,
                             @"plat":userInfo.numPlat,
                             @"pic":userInfo.strPicURL};
    
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

/**
 *  添加衣服
 *
 *  @param clothesInfo <#clothesInfo description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */

-(void)addClothingWithColothesInfo:(ClothesInfo *)clothesInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    NSDictionary *params;
    if (clothesInfo.strBrand) {
        params = @{@"id":userInfo.numId,
                                 @"token":userInfo.strToken,
                                 @"cateId":clothesInfo.numCateId,
                                 @"scateId":clothesInfo.numScateId,
                                 @"seaId":clothesInfo.numSeaId,
                                 @"brand":clothesInfo.strBrand};
    }
    else
    {
        params = @{@"id":userInfo.numId,
                                 @"token":userInfo.strToken,
                                 @"cateId":clothesInfo.numCateId,
                                 @"scateId":clothesInfo.numScateId,
                                 @"seaId":clothesInfo.numSeaId};
    }

    NSString *url = [NSString stringWithFormat:ServerRootURL,AddClothingURL];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    _manager.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    _manager.responseSerializer = responseSerializer;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSData *imageData = UIImageJPEGRepresentation(clothesInfo.file, 0.8);
    AFHTTPRequestOperation *request = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [request setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
    }];
    
}

/**
 *  添加搭配
 *
 *  @param collocationInfo <#collocationInfo description#>
 *  @param success         <#success description#>
 *  @param failure         <#failure description#>
 */

-(void)addCollocationWithCollocationInfo:(CollocationInfo *)collocationInfo success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Accept"];
//    manager.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    manager.responseSerializer = responseSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userInfo.numId forKeyPath:@"id"];
    [params setValue:userInfo.strToken forKeyPath:@"token"];
    [params setValue:collocationInfo.numStyleId forKeyPath:@"styleId"];
    [params setValue:collocationInfo.numOccId forKey:@"occId"];
    [params setValue:collocationInfo.strDescription forKeyPath:@"description"];
    
    for(int i = 0 ;i<collocationInfo.arrList.count;i++)
    {
        ClothesInfo *info = [collocationInfo.arrList objectAtIndex:i];
        if (info.strBrand && (![info.strBrand isEqualToString:@""])) {
            if (info.numClId) {
                [params setValue:info.numClId forKey:[NSString stringWithFormat:@"list[%d].clId",i]];
                [params setValue:info.strBrand forKey:[NSString stringWithFormat:@"list[%d].brand",i]];
                [params setValue:info.numScateId forKey:[NSString stringWithFormat:@"list[%d].scateId",i]];
                [params setValue:info.numScateId forKey:[NSString stringWithFormat:@"list[%d].cateId",i]];
                [params setValue:info.numSeaId forKey:[NSString stringWithFormat:@"list[%d].seaId",i]];
            }
            else
            {
                [params setValue:info.strBrand forKey:[NSString stringWithFormat:@"list[%d].brand",i]];
                [params setValue:info.numScateId forKey:[NSString stringWithFormat:@"list[%d].scateId",i]];
                [params setValue:info.numScateId forKey:[NSString stringWithFormat:@"list[%d].cateId",i]];
                [params setValue:info.numSeaId forKey:[NSString stringWithFormat:@"list[%d].seaId",i]];
            }
        }
    }
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,AddCollocationURL];
    NSData *imageData = UIImageJPEGRepresentation(collocationInfo.file, 0.8);
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
//    UserInfo *userInfo = [UserInfo unarchiverUserData];
//    NSMutableArray *arrList = [[NSMutableArray alloc]init];
//    for (ClothesInfo *info in collocationInfo.arrList) {
//        if (info.strBrand && (![info.strBrand isEqualToString:@""])) {
//            NSDictionary *dic;
//            if (info.numClId) {
//                 dic = @{@"clId":info.numClId,
//                         @"cateId":info.numCateId,
//                         @"scateId":info.numScateId,
//                         @"seaId":info.numSeaId,
//                         @"brand":info.strBrand};
//            }
//            else
//            {
//                dic = @{@"cateId":info.numCateId,
//                        @"scateId":info.numScateId,
//                        @"seaId":info.numSeaId,
//                        @"brand":info.strBrand};
//            }
//            [arrList addObject:dic];
//        }
//    }
//    NSDictionary *params = @{@"id":userInfo.numId,
//                             @"token":userInfo.strToken,
//                             @"styleId":collocationInfo.numStyleId,
//                             @"occId":collocationInfo.numOccId,
//                             @"description":collocationInfo.strDescription,
//                             @"list":arrList};
//    NSString *url = [NSString stringWithFormat:ServerRootURL,AddCollocationURL];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];
//    CLog(@"%@",jsonString);
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    [requestSerializer setTimeoutInterval:30];
//    _manager.requestSerializer = requestSerializer;
//    
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
//    _manager.responseSerializer = responseSerializer;
////    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    NSData *imageData = UIImageJPEGRepresentation(collocationInfo.file, 0.8);
//    AFHTTPRequestOperation *request = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        
//        // 上传图片，以文件流的格式
//        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
//
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//    [request setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
//    }];
}

/**
 *  举报搭配
 *
 *  @param coId    <#coId description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

-(void)ReportCollocationWithCoId:(int)coId success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
     UserInfo *userInfo = [UserInfo unarchiverUserData];
    NSDictionary *params = @{@"id":userInfo.numId,
                             @"token":userInfo.strToken,
                             @"coId":[NSNumber numberWithInt:coId]};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,ReportCollocationURL];
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

/**
 *  获取搭配列表
 *
 *  @param styleId <#styleId description#>
 *  @param occId   <#occId description#>
 *  @param type    <#type description#>
 *  @param mId     <#mId description#>
 *  @param count   <#count description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

-(void)searchCollocationWithStyleId:(int)styleId OccId:(int)occId MinId:(int)mId Count:(int)count success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    NSDictionary *params = @{@"id":userInfo.numId,
                             @"token":userInfo.strToken,
                             @"styleId":[NSNumber numberWithInt:styleId],
                             @"occId":[NSNumber numberWithInt:occId],
                             @"type":[NSNumber numberWithInt:0],
                             @"mId":[NSNumber numberWithInt:mId],
                             @"count":[NSNumber numberWithInt:count]};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,SearchCollocationURL];
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

-(void)GetCollocationDetailWithCoId:(int)coId success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    NSDictionary *params = @{@"id":userInfo.numId,
                             @"token":userInfo.strToken,
                             @"coId":[NSNumber numberWithInt:coId]};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,GetCollocationDetailURL];
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

/**
 *  赞搭配
 *
 *  @param coId    <#coId description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

-(void)LikeCollocationWithCoId:(int)coId success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    NSDictionary *params = @{@"id":userInfo.numId,
                             @"token":userInfo.strToken,
                             @"coId":[NSNumber numberWithInt:coId]};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,LikeCollocationURL];
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

-(void)GetLikedCollocationWithStyleId:(NSString *)styleId OccId:(NSString *)occId Type:(NSString *)type MinId:(NSString *)mId Count:(NSString *)count success:(void(^)(id responseObject))success andFailed:(void (^)(NSError *error))failure
{
    if (![self checkNetWorking])
        return;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    NSDictionary *params = @{@"id":userInfo.numId,
                             @"token":userInfo.strToken,
                             @"styleId":styleId,
                             @"occId":occId,
                             @"type":type,
                             @"mId":mId,
                             @"count":count};
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *url = [NSString stringWithFormat:ServerRootURL,GetLikedCollocationListURL];
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
