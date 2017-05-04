//
//  AFHTTPRequestOperationManager+Custom.m
//  legend
//
//  Created by msb-ios-dev on 16/3/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "CustomAFHTTPRequestOperationManager.h"
#import "NSObject+PortEncry.h"
#import "AppDelegate.h"
#import "MainRequest.h"

@implementation CustomAFHTTPRequestOperationManager

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    AFHTTPRequestOperation *operation =  [super POST:URLString parameters:parameters
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 
                                                 NSDictionary *data = [responseObject objectForKey:@"data"];
                                                 if (data && [data isKindOfClass:[NSDictionary class]]) {
                                                     NSNumber *errorcode = [data objectForKey:@"error_code"];
                                                     
                                                     if ([errorcode intValue] >= 1020001 && [errorcode intValue] <= 1020008) {
                                                         FLLog(@"重新登录%d",[errorcode intValue]);
                                                         if (success) {
                                                             success(operation,responseObject);
                                                         }
                                                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:saveLocalTokenFile];
                                                     }
                                                     else{
                                                         if (success) {
                                                             success(operation,responseObject);
                                                         }
                                                     }
                                                     
                                                 }
                                                 else{
                                                     if (success) {
                                                         success(operation,responseObject);
                                                     }
                                                 }
                                                 
                                                 
                                             } failure:failure];
    
    return operation;
}

@end
