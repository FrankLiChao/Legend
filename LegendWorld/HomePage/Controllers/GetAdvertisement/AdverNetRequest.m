//
//  AdverNetRequest.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AdverNetRequest.h"
#import "FrankTools.h"
#import "MainRequest.h"

@implementation AdverNetRequest

+(void)advFinish:(AdDetailInfoModel*)model
          answer:(NSString*)anser
         success:(void (^)(BOOL bSuccess,NSString *message))success
          failed:(void (^)(NSDictionary *errorDic))failed{
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:[FrankTools getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[FrankTools getUserToken] forKey:@"token"];
    [postDic setObject:model.ad_id forKey:@"ad_id"];
    [postDic setObject:model.ad_type forKey:@"ad_type"];
    [postDic setObject:model.question_id?model.question_id:@"" forKey:@"question_id"];
    [postDic setObject:anser?anser:@"" forKey:@"keyword"];
    [MainRequest RequestHTTPData:PATH(@"/api/ad/adFinish") parameters:postDic success:^(id response) {
        NSDictionary *dic = response;
        if (success) {
            success(YES, dic[@"msg"]);
        }
    } failed:^(NSDictionary *errorDic) {
        if (failed) {
            failed(errorDic);
        }
    }];

}

@end
