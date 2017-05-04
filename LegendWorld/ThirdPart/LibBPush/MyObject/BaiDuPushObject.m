//
//  BaiDuPushObject.m
//  legend
//
//  Created by msb-ios-dev on 15/11/2.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "BaiDuPushObject.h"
#import "BPush.h"
#import "MainRequest.h"
#import <UserNotifications/UserNotifications.h>

@implementation BaiDuPushObject

+ (void)registerBaiDuPush:(NSDictionary *)launchOptions{
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BAIDU_PUSH_API_KEY pushMode:baiduPushMode withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        FLLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    [BaiDuPushObject registerRemoteNotification];
}

+ (void)registerRemoteNotification{
    if (IOS10) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }
                              }];
    } else if (IOS8) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

+ (void)registerDeviceToken:(NSData *)deviceToken{
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        //需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (result) {
            NSString *channelId = [result objectForKey:@"channel_id"];
            if(channelId){
                [[NSUserDefaults standardUserDefaults] setObject:channelId forKey:kLocal_ChannelID];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            FLLog(@"%@",channelId);
            if ([self cheeckChannelIDChaned:channelId] && channelId) {
                [self uploadBaiduChangnelID:channelId];
            }
        }
    }];
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification identifierKey:(NSString *)notificationKey{
    [BPush showLocalNotificationAtFront:notification identifierKey:notificationKey];
}

            
+ (void)uploadBaiduChangnelID:(NSString *)channelId
{
    NSString *httpUrlStr = nil;
    if ([FrankTools getUserToken].length > 0) {
        httpUrlStr = PATH(@"api/push/setBdAccount");
    } else {
        httpUrlStr = PATH(@"api/push/userBdAccount");
    }
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"device_type":@"4",
                          @"channel_id":channelId};
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if ([FrankTools getUserToken].length > 0) {
        [muDic setObject:[FrankTools getUserToken] forKey:@"token"];
    }
    [MainRequest RequestHTTPData:httpUrlStr parameters:muDic success:^(id responseData) {
    } failed:^(NSDictionary *errorDic) {
        FLLog(@"上传channel id失败 ");
    }];
}

+(BOOL)cheeckChannelIDChaned:(NSString*)chaneId{
    
    NSString *oldChannedID =  [[NSUserDefaults standardUserDefaults] objectForKey:kLocal_ChannelID];
    
    if ([FrankTools isNull:oldChannedID] ||![chaneId isEqualToString:oldChannedID]) {
        
        return YES;
    }
    
    return NO;
}

@end
