//
//  AFHTTPRequestOperationManager+Cache.m
//  legend
//
//  Created by heyk on 16/2/2.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "AFHTTPClient.h"
#import "SDURLCache.h"
#import "UIImageView+WebCache.h"
@implementation AFHTTPClient


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))failure{
    
    NSMutableURLRequest *modifiedRequest = request.mutableCopy;
    AFNetworkReachabilityManager *reachability = self.reachabilityManager;
    
    if (!reachability.isReachable){
        modifiedRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }else{
        modifiedRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    
    


    
    return [self customHTTPRequestOperationWithRequest:modifiedRequest
                                          success:success
                                          failure:failure];
}

- (AFHTTPRequestOperation*)customHTTPRequestOperationWithRequest:(NSURLRequest *)request
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    id responseObject =   [self cachedResponseObject:operation];
    if (responseObject) {
        
        if (success) {
            success(operation,responseObject);
        }
        return nil;
    }
    
       __weak __typeof(self)weakSelf = self;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSCachedURLResponse *cachedURLresponse = [[NSCachedURLResponse alloc] initWithResponse:operation.response data:operation.responseData];
        [[NSURLCache sharedURLCache]storeCachedResponse:cachedURLresponse forRequest:operation.request];
        
        if (success) {
            success(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        id responseObject =   [weakSelf cachedResponseObject:operation];
        if (responseObject) {
            if (success) {
                  success(operation,responseObject);
            }
            
        }
        else{
            if (failure) {
                failure(operation,error);
            }
        }
    }];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;
    
    return operation;
    
}

//
//- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
//                                                    success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success
//                                                    failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))failure{
//    
//    NSMutableURLRequest *modifiedRequest = request.mutableCopy;
//    AFNetworkReachabilityManager *reachability = self.reachabilityManager;
//    
//    if (!reachability.isReachable){
//        modifiedRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    }else{
//        modifiedRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
//    }
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    if ([request.HTTPMethod isEqualToString:@"POST"]){
//        
//        
//        NSString *name = [[[request.URL absoluteString] componentsSeparatedByString:@"/"] lastObject];
//        
//        NSString* filename= [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
//        NSString* etag = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
//        if (etag != nil){
//            
//            NSMutableDictionary* mDict = [modifiedRequest.allHTTPHeaderFields mutableCopy];
//            [mDict setObject:etag forKey:@"If-None-Match"];
//            modifiedRequest.allHTTPHeaderFields = mDict;
//        }
//    }
//
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = self.responseSerializer;
//    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
//    operation.credential = self.credential;
//    operation.securityPolicy = self.securityPolicy;
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        if (success) {
//            success(operation,responseObject);
//        }
//    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//      id responseObject =   [self cachedResponseObject:operation];
//      success(nil,responseObject);
//        
//    }];
//    operation.completionQueue = self.completionQueue;
//    operation.completionGroup = self.completionGroup;
//    
//    return operation;
//    
////    return [super HTTPRequestOperationWithRequest:modifiedRequest
////                                          success:success
////                                          failure:failure];
//}

- (id)cachedResponseObject:(AFHTTPRequestOperation *)operation{
    
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:operation.request];
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    return responseObject;
}


//- (void)storeResponseObject:(AFHTTPRequestOperation *)operation{
//    
//    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] storeCachedResponse:<#(nonnull NSCachedURLResponse *)#> forRequest:operation.request];
//    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
//    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
//    return responseObject;
//}

//- (AFHTTPRequestOperation *)HTTPRequestOperationWithHTTPMethod:(NSString *)method
//                                                     URLString:(NSString *)URLString
//                                                    parameters:(id)parameters
//                                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    NSError *serializationError = nil;
//    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
//    request.timeoutInterval = 30;
//    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
//    
//    if (serializationError) {
//        if (failure) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wgnu"
//            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
//                failure(nil, serializationError);
//            });
//#pragma clang diagnostic pop
//        }
//        
//        return nil;
//    }
//    
//    NSCachedURLResponse *response = [[SDURLCache sharedURLCache] cachedResponseForRequest:request];
//    
//    if (response) {
//        
//        if (success) {
//            success(nil,response.data);
//        
//        }
//        return nil;
//    }
//    
//    return [self HTTPRequestOperationWithRequest:request success:success failure:failure];
//}
//
//
//
//- ( AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
//                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    
//
//
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = self.responseSerializer;
//    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
//    operation.credential = self.credential;
//    operation.securityPolicy = self.securityPolicy;
//    
//    NSCachedURLResponse *response = [[SDURLCache sharedURLCache] cachedResponseForRequest:request];
//    
//    if (response) {
//        
//    }
//    
//    
//    __weak __typeof(self)weakSelf = self;
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        
//    
//      [[SDURLCache sharedURLCache] storeCachedResponse:<#(nonnull NSCachedURLResponse *)#> forDataTask:<#(nonnull NSURLSessionDataTask *)#>]
//        
//    }
//                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (error.code == kCFURLErrorNotConnectedToInternet) {
//            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
//            if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
//                id JSON = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:0 error:&error];
//                success(operation, JSON);
//            } else {
//                failure(operation, error);
//            }
//        } else {
//            failure(operation, error);
//        }
//    }];
//    operation.completionQueue = self.completionQueue;
//    operation.completionGroup = self.completionGroup;
//    
//    return operation;
//}

@end
