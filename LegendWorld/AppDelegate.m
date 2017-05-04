//
//  AppDelegate.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MainRequest.h"
#import "MJExtension.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
#import "CustomAlterView.h"
#import "WxAccountModel.h"
#import "BaiDuPushObject.h"
#import <UserNotifications/UserNotifications.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "TabBarController.h"
#import "UMMobClick/MobClick.h"

#import "NoticeViewController.h"
#import "MyWalletViewController.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MainRequest checkNetworkStatus];
    
    //注册通知 改为注册成功时再来注册推送
    [BaiDuPushObject registerBaiDuPush:launchOptions];
    //检测版本更新
    [self checkAPPVersion];
    //注册微信支付
    [WXApi registerApp:WeChatKey];
    //注册分享
    [self initShare];
    //注册友盟
    [self initUM];

    // 全局处理键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[TabBarController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 远程通知
//消息推送
//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =
    [[[[deviceToken description]
       stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">" withString:@""]
     stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token=%@",token);
    [BaiDuPushObject registerDeviceToken:deviceToken];
}

//注册消息推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString * error_str = [NSString stringWithFormat:@"%@",error];
    FLLog(@"%@",error_str);
}

//IOS8 系统使用该方法注册推送
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber += 1;
    [self analysisNotify:userInfo];
}


-(void)analysisNotify:(NSDictionary*)dic{
    NSInteger msgType = [[dic objectForKey:@"msg_type"] integerValue];
    if (!dic) {
        msgType = 1;
    }
    switch (msgType) {
        case 1:{
            NSString *url = [dic objectForKey:@"ios_url"];
            NSString *descrip = [dic objectForKey:@"description"];
            [[CustomAlterView getInstanceWithTitle:@"有版本更新"
                                           message:descrip?descrip:@""
                                        leftButton:@"取消"
                                 rightButtonTitles:@"前往更新" click:^(NSInteger index,id customAlterView) {
                                     if (index == 2) {
                                         [[SDImageCache sharedImageCache] clearDisk];
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url?url:@""]];
                                     }
                                     else {
                                         [(CustomAlterView*)customAlterView dismiss];
                                     }
                                 }] show];
        }
            break;
        case 2://系统通知
        {
            NoticeViewController *noticeVc = [NoticeViewController new];
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UITabBarController *root = (UITabBarController *)app.window.rootViewController;
            NSInteger mainIndex = ModelIndexHome;
            root.selectedIndex = ModelIndexHome;
            UINavigationController *nav = [root.viewControllers objectAtIndex:mainIndex];
            noticeVc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:noticeVc animated:YES];
        }
            break;
        case 6://提现
        {
            FLLog(@"跳转到提现");
            MyWalletViewController *myWalletVc = [MyWalletViewController new];
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UITabBarController *root = (UITabBarController *)app.window.rootViewController;
            NSInteger mineIndex = ModelIndexMine;
            root.selectedIndex = ModelIndexMine;
            UINavigationController *nav = [root.viewControllers objectAtIndex:mineIndex];
            myWalletVc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:myWalletVc animated:YES];
        }
            break;
        default:
            
            break;
    }
}

#pragma mark - 初始化分享
-(void)initShare
{
    [ShareSDK registerApp:ShareSDKID
     
          activePlatforms:@[@(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSMS:
                 
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType){
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeChatKey
                                       appSecret:WeChatSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105531533"
                                      appKey:@"oMgHmYhJWGdoJCdf"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - 初始化友盟
- (void)initUM {
    UMConfigInstance.appKey = @"563702d567e58e75b400046f";
    UMConfigInstance.channelId = nil;
    UMConfigInstance.eSType = E_UM_NORMAL; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

#pragma mark - 检测版本更新
-(void)checkAPPVersion
{
    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger localVerison = [[versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"device_type":[NSNumber numberWithInt:4]};
    [MainRequest RequestHTTPData:PATH(@"api/init/index") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        NSDictionary* app_data = [responseData objectForKey:@"version_info"];
        
        if (app_data && app_data.count > 0) {
            NSString *verison_no = [app_data objectForKey:@"version_no"];
            NSString *version_info = [app_data objectForKey:@"desc"];
            NSInteger onlineVerison = [[verison_no stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
            if (onlineVerison != localVerison) {
                
                BOOL isForce = [[app_data objectForKey:@"force"] boolValue];
                NSString *title = [NSString stringWithFormat:@"有新版本：%@",verison_no];
                NSString *leftTitle = @"稍后更新";
                if (isForce) {
                    leftTitle = nil;
                }
                [[CustomAlterView getInstanceWithTitle:title
                                               message:version_info
                                            leftButton:leftTitle
                                     rightButtonTitles:@"前往更新" click:^(NSInteger index,id customAlterView) {
                                         if (index == 2) {
                                             NSString *down_url = [app_data objectForKey:@"down_url"];
                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:down_url]];
                                             if (!isForce) {
                                                 [(CustomAlterView*)customAlterView dismiss];
                                             }
                                         }
                                         else [(CustomAlterView*)customAlterView dismiss];
                                         
                                     }] show];
            }
        }
    } failed:^(NSDictionary *errorDic) {
        FLLog(@"%@",[errorDic objectForKey:@"error_msg"]);
    }];
}

#pragma mark - 微信回调
-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])//分享
    {
        SendAuthResp *response = (SendAuthResp *)resp;
        if (!response.code) {
            return;
        }
        NSString *httpUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatKey,WeChatSecret,response.code];
        [MainRequest GetHTTPData:httpUrl success:^(id responseData) {
            NSString *access_token = [responseData objectForKey:@"access_token"];
            NSString *openid = [responseData objectForKey:@"openid"];
            NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
            [MainRequest GetHTTPData:url success:^(id responseData) {
                WxAccountModel *model = [WxAccountModel mj_objectWithKeyValues:responseData];
                [[NSNotificationCenter defaultCenter] postNotificationName:SYS_NOTI_ADD_WX_ACCOUNT object:[NSDictionary dictionaryWithObject:model forKey:@"model"]];
            } failed:^(NSString *erorr) {
                FLLog(@"Error: %@", erorr);
            }];
        } failed:^(NSString *erorr) {
            FLLog(@"Error: %@", erorr);
        }];
    } else if ([resp isKindOfClass:[PayResp class]]){//微信支付
        PayResp *response = (PayResp *)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WECHATPAY_RESULT object:response];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
   
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            FLLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALIPAY_RESULT object:resultDic];
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
