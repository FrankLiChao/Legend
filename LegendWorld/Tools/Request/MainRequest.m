 //
//  lhMainRequest.m
//  SCFinance
//
//  Created by bosheng on 16/5/18.
//  Copyright © 2016年 Frank. All rights reserved.
//

#import "MainRequest.h"
#import "NSObject+PortEncry.h"
#import "CustomAFHTTPRequestOperationManager.h"
#import "AppDelegate.h"

#define TIME_OUT_INTERVAL 20

@interface MainRequest()

@end

@implementation MainRequest

+ (void)checkNetworkStatus {
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"无网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

//数据接口的网络请求
+ (void)RequestHTTPData:(NSString *)urlString parameters:(NSDictionary *)parameter success:(void (^)(id response))success failed:(void (^)(NSDictionary *errorDic))failed {
    CustomAFHTTPRequestOperationManager *manager = [CustomAFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    NSDictionary *dataDic = [self createRequsetData:postDic];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:urlString parameters:dataDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"\n====== Request URL ======\n%@\n", urlString);
        NSLog(@"\n====== Request Parameters ======\n%@\n",postDic);
        NSLog(@"\n====== Response Object ======\n%@\n",responseObject);
        if ([[responseObject objectForKey:@"result"] boolValue]) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            success(dataDic);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAssert(failed, @"请处理错误");
                NSNumber *errorcode = [[responseObject objectForKey:@"data"] objectForKey:@"error_code"];
                NSDictionary *dic = @{@"error_code":errorcode,
                                      @"error_msg":[[responseObject objectForKey:@"data"] objectForKey:@"error_msg"]};
                failed(dic);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"\n====== Request URL ======\n%@\n", urlString);
        NSLog(@"\n====== Request Parameters ======\n%@\n",postDic);
        NSLog(@"\n====== Response Error ======\n%@\n",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAssert(failed, @"请处理错误");
            NSDictionary *dic = @{@"error_msg":@"请检查你的网络",//[error localizedDescription]
                                  @"error_code":@""};
            failed(dic);
        });
    }];
}

+ (void)GetHTTPData:(NSString *)urlString success:(void (^)(id responseData))success failed:(void (^)(NSString *erorr))failed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //获取用户信息
        if (success && responseObject) {
            success(responseObject);
        }
        else{
            FLLog(@"暂无数据");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failed) {
            failed([error localizedDescription]);
        }
    }];
    
}

//上传多张图片
+ (void)uploadPhotos:(NSString *)urlString parameters:(NSDictionary *)parameter imageD:(NSArray *)imgArray success:(void (^)(id))success
{
    NSString * url = [NSString stringWithFormat:@"%@",urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIME_OUT_INTERVAL];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    for (NSString *param in parameters) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    for (int i=0;i<imgArray.count;i++){
        UIImage * img = [imgArray objectAtIndex:i];
        NSData * imageData = UIImageJPEGRepresentation(img, 0.5);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端用file接收
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"\r\n",@"image",[NSString stringWithFormat:@"image%d.png",i+1]];
        
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream\r\n\r\n"]];
        
        [body appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"%ld", (long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionUploadTask * task = [session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        
        if (!error) {
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            FLLog(@"imageData = %@",dataDic);
            if (dataDic) {//请求数据正常
                //判断并去掉最外层数据
                if ([[dataDic objectForKey:@"status"] integerValue] == 1) {
                    NSDictionary * dataDict = [dataDic objectForKey:@"data"];
                    if (!dataDict) {
                        dataDict = dataDic;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(dataDict);
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[dataDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
                
            }
            else{//请求数据为空，服务器返回异常
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [lhHubLoading disAppearActivitiView];
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }
        else{//未连接网络或其他原因，请求报错
            dispatch_async(dispatch_get_main_queue(), ^{
//                [lhHubLoading disAppearActivitiView];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    }];
    [task resume];
}

+ (void)uploadPhoto:(NSString *)urlString parameters:(NSDictionary *)parameters imageD:(UIImage *)imageUpload success:(void (^)(id))success failed:(void (^)(NSError *))failed {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] init];
    NSString *jsonstr = [self getJSONStr:parameters];
    jsonstr = [self URLEncodedString:jsonstr];
    [loginDic setObject:jsonstr forKey:@"data"];
    NSArray *arr = [self getSignArray:parameters];
    NSString *sign = [self getSign:arr];
    [loginDic setObject:sign forKey:@"sign"];
    [manager POST:urlString parameters:loginDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        NSData *imageData = UIImageJPEGRepresentation(imageUpload, 0.5);
        [formData appendPartWithFileData:imageData
                                    name:@"legend_image"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(error);
    }];
}

//下载文件
+ (void)downloadFile:(NSString *)urlStr success:(void (^)(id responseObject))success {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *downloadStr = [NSURL URLWithString:urlStr];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:downloadStr completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (!error) {
            if (location) {//请求数据正常
                if (success) {
                    success(location);
                }
            }
            else{//请求数据为空，服务器返回异常
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [lhHubLoading disAppearActivitiView];
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }
        else{//未连接网络或其他原因，请求报错
            dispatch_async(dispatch_get_main_queue(), ^{
//                [lhHubLoading disAppearActivitiView];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    }];
    [task resume];
}

//获取Documents文件夹的路径
+ (NSString *)getDocumentsPath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = documents[0];
    
    return documentsPath;
}

//生成请求body
+ (NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
//        if ([value isKindOfClass:[NSString class]]) {
            NSString * tempStr = [[NSString stringWithFormat:@"%@=%@",key,value] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
            [parametersArray addObject:tempStr];
//        }
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
}

//判断错误字符串并处理
+ (void)checkRequestFail:(NSString *)errorStr
{
    if([@"-111" isEqualToString:errorStr]){
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"连接异常" message:@"请检查网络或稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

@end
