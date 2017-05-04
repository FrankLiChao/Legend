//
//  BaiDuPushObject.h
//  legend
//
//  Created by msb-ios-dev on 15/11/2.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaiDuPushObject : NSObject

+ (void)registerBaiDuPush:(NSDictionary *)launchOptions;
+ (void)registerDeviceToken:(NSData*)deviceToken;
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification identifierKey:(NSString *)notificationKey;
+ (void)uploadBaiduChangnelID:(NSString *)channelId;
@end
