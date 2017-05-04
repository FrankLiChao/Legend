//
//  lhMainRequest.h
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainRequest : NSObject

/**检测网路状态**/
+ (void)checkNetworkStatus;

/**
 *JSON方式获取数据
 *urlString:获取数据的url地址
 *parameters:提交的参数内容
 *method:请求方式
 */
+(void)RequestHTTPData:(NSString *)urlString parameters:(NSDictionary *)parameter success:(void (^)(id response))success failed:(void (^)(NSDictionary *errorDic))failed;
//Get方式请求网络数据
+(void)GetHTTPData:(NSString *)urlString success:(void (^)(id responseData))success failed:(void (^)(NSString *erorr))failed;

/**
 *上传图片
 *urlString:上传图片的url地址
 *parameters:提交的参数内容
 *imgArray:UIImage组成的array
 */
+ (void)uploadPhotos:(NSString *)urlString parameters:(NSDictionary *)parameters imageD:(NSArray *)imgArray success:(void (^)(id responseObject))success;
+ (void)uploadPhoto:(NSString *)urlString parameters:(NSDictionary *)parameters imageD:(UIImage *)imageUpload success:(void (^)(id responseObject))success failed:(void (^)(NSError *error))failed;
/**
 *下载文件
 *urlStr:现在文件地址
 */
+ (void)downloadFile:(NSString *)urlStr success:(void (^)(id responseObject))success;


/**
 *请求失败判断并处理
 *errorStr:返回的错误字符串
 */
+ (void)checkRequestFail:(NSString *)errorStr;

@end
