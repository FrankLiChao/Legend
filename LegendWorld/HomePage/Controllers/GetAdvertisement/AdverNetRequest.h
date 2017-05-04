//
//  AdverNetRequest.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvertModel.h"

@interface AdverNetRequest : NSObject

+(void)advFinish:(AdDetailInfoModel*)model
          answer:(NSString*)anser
         success:(void (^)(BOOL bSuccess,NSString *message))success
          failed:(void (^)(NSDictionary *errorDic))failed;
@end
