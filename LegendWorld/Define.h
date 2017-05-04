//
//  Define.h
//  legend
//
//  Created by ios-dev-01 on 16/8/2.
//  Copyright © 2016年 e3mo. All rights reserved.
//
#import "BPush.h"
#ifndef Define_h
#define Define_h

//方便调试，可以打印对应的调试方法和行号
#ifdef DEBUG
#   define FLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);

#else
#   define FLLog(...)
#endif

#ifdef DEBUG
#define RELSEASE_SYS_WEB_BASED_URL                  @"http://web03debug.say168.net"
#define RELSEASE_SYS_WEB_BASED_SHOP_URL             @"http://web03shop.say168.net"
#define RELSEASE_SYS_WEB_TO_CARD_URL                @"http://test.to_card.say168.net"

//#define DES_KEY                                     @"88888888"
#define DES_KEY                                     @"qwe45678"
#define SYS_WEB_API_UPLOAD                          @"http://debugimg.say168.net"
#define HUX_API_KEY                                 @"msb360#legendtest"
#define BAIDU_PUSH_API_KEY                          @"WFPbHcPaMfYuXHSVA1xY8vD8"

static BPushMode baiduPushMode = BPushModeDevelopment;
#else

#define RELSEASE_SYS_WEB_BASED_SHOP_URL             @"https://shop.say168.net"
#define RELSEASE_SYS_WEB_BASED_URL                  @"https://api.say168.net"
#define RELSEASE_SYS_WEB_TO_CARD_URL                @"http://to_card.say168.net"
#define DES_KEY                                     @"r2qrwq3*"
#define TOKEN_DES_KEY                               @"!@0182j3"
#define SYS_WEB_API_UPLOAD                          @"http://img.say168.net"
#define HUX_API_KEY                                 @"msb360#legend"
#define BAIDU_PUSH_API_KEY                          @"73Wj3bolhC2AtGsCUeYUezF4"

static BPushMode baiduPushMode = BPushModeProduction;
#endif

//代理商Id
#define AGENT_ID @"1"

#define SHOW_ALERT(_msg_)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_msg_ delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];

//接口路径全拼
#define PATH(_path) [NSString stringWithFormat:@"%@/%@",RELSEASE_SYS_WEB_BASED_URL,_path]
#define PATHShop(_path) [NSString stringWithFormat:@"%@/%@",RELSEASE_SYS_WEB_BASED_SHOP_URL,_path]
#define PATHTOCard(_path) [NSString stringWithFormat:@"%@/%@",RELSEASE_SYS_WEB_TO_CARD_URL,_path]
//#define PATHImg(_path) [NSString stringWithFormat:@"%@%@",webImgUrl,_path]
#define ImagePATH(_path) [NSString stringWithFormat:@"%@/%@",SYS_WEB_API_UPLOAD,_path]

// 屏幕长宽
#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/375

//IOS判断
#define IOS7 ([[UIDevice currentDevice].systemVersion intValue] >= 7 ? YES : NO)
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)
#define IOS9 ([[UIDevice currentDevice].systemVersion intValue] >= 9 ? YES : NO)
#define IOS10 ([[UIDevice currentDevice].systemVersion intValue] >= 10 ? YES : NO)

//设备判断
#define iPhone5 (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO))

#define iPhone6And7 (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO))

#define iPhone6And7plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define ServicePhone @"028-61384228"

//定义APP主要颜色
#define contentTitleColorStr [UIColor titleTextColor] //正文标题色
#define contentTitleColorStr1 [UIColor bodyTextColor] //正文一级灰
#define contentTitleColorStr2 [UIColor noteTextColor] //正文二级灰
#define contentTitleColorStr3 [UIColor colorFromHexRGB:@"9b9b9b"] //正文三级灰
#define tableDefSepLineColor [UIColor seperateColor]//表格线条颜色
#define contentTitleColorGreen [UIColor colorFromHexRGB:@"38be7e"] //正文颜色绿色
#define mainColor [UIColor themeColor] //APP主色橙色e3383e //f0494f
#define viewColor [UIColor colorFromHexRGB:@"f5f5f5"] //背景色 浅灰色
#define adGrayColor [UIColor colorFromHexRGB:@"d5d5d5"] //广告进度条背景灰色
#define redColorStr [UIColor colorFromHexRGB:@"fa752b"] //红色
#define buttonGrayColor [UIColor colorFromHexRGB:@"a0a0a0"] //不可点击按钮的颜色
//本地化关键数据
#define saveLocalTokenFile @"saveLocalTokenFile"//token本地存储
#define havePayPassword @"havePayPassword"//表示是否设置了支付密码
#define userLoginDataToLocal @"userLoginDataToLocal" //保存登录数据
#define kLocal_ChannelID    @"kLocal_ChannelID"

//APP默认图片
#define imageWithName(name) [UIImage imageNamed:name]
#define placeHolderImg [UIImage imageNamed:@"icon_placeHolder"]
#define placeSquareImg [UIImage imageNamed:@"placeSquareImg"]
#define placeSquareBigImg @"placeDetailImage"
#define defaultUserHead [UIImage imageNamed:@"user_avatar"]

//分享的APPID
#define appScheme @"LegendWorld"
#define  ShareSDKID @"91b512aa3854" //注册shareSDK的ID号
#define WeChatKey @"wx934285efe5a87f58" //注册分享的微信APPKey//wx934285efe5a87f58
#define WeChatSecret @"4dd26eb64eaee8e3c621ff645fe876f0" //注册微信分享的WeChatSecret

//通知的Key
#define SYS_NOTI_ADD_WX_ACCOUNT             @"SYS_NOTI_ADD_WX_ACCOUNT"//微信回调返回的用户信息
#define ANSWER_ADV_SUCCESS_NOTIFY           @"ANSWER_ADV_SUCCESS_NOTIFY"//回答广告成功
#define NEED_REFRESH_REQUESTION_VIEW_NOTIFY @"NEED_REFRESH_REQUESTION_VIEW_NOTIFY" //刷新问题与反馈界面
#define SYS_NOTI_NEED_LOGIN                 @"SYS_NOTI_NEED_LOGIN"
#define ANSWER_ADV_SUCCESS_NOTIFY           @"ANSWER_ADV_SUCCESS_NOTIFY"//回答广告成功

//支付宝和微信支付结果通知
static NSString *const NOTIFICATION_ALIPAY_RESULT = @"com.alipay.result";
static NSString *const NOTIFICATION_WECHATPAY_RESULT = @"com.tencent.wechat.result";

#endif /* Define_h */
