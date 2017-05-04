//
//  UitlCommon.h
//  legend
//
//  Created by msb-ios-dev on 15/10/22.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"


#undef	AS_SINGLETON
#define AS_SINGLETON(class) \
+ (instancetype)sharedInstance; \
+ (void)distroyInstance;


#undef	DEF_SINGLETON
#define DEF_SINGLETON(class) \
static class *sharedInstance##class; \
+ (instancetype)sharedInstance { \
@synchronized (self) { \
if (sharedInstance##class == nil) { \
sharedInstance##class = [[self alloc] init]; \
} \
} \
return sharedInstance##class; \
} \
+ (void)distroyInstance { \
@synchronized (self) { \
sharedInstance##class = nil; \
} \
}



#define  ScreenSize [[UIScreen mainScreen] bounds].size

#define APPDELEGATE             (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define contextDB  [APPDELEGATE managedObjectContext]

typedef NS_ENUM(NSInteger, RedPacketType) {
    RedPacketType_Single = 1,
    RedPacketType_Lucky,
    RedPacketType_Nomal,
    RedPacketType_OnyTip,
};

//红包扩展消息

/** 头像 url */
#define MESSAGE_EX_ATTR_HEAD_URL @"avatar"
/** 昵称 */
#define MESSAGE_EX_ATTR_NICKNAME @"nick"
/** 普通/单人红包金额 */
#define  MESSAGE_EX_ATTR_SINGLE_AMOUNT @"single_amount"
/** 运气红包总金额 */
#define  MESSAGE_EX_ATTR_LUCKY_TOTALAMOUNT  @"lucky_total_amount"
/** 红包总金额 */
#define  MESSAGE_EX_ATTR_TOTALAMOUNT  @"total_amount"

/** 红包金额 */
#define  MESSAGE_EX_ATTR_AMOUNT  @"amount"
/** 红包数量 */
#define  MESSAGE_EX_ATTR_NUM @"num"
/** 红包描述 */
#define  MESSAGE_EX_ATTR_DESC  @"desc"
/** 扩展消息类型 */
#define  MESSAGE_EX_ATTR_IS_RED_ENVELOPE  @"ex_type" //ExtMessageType
/** 红包类型 ，单人/普通(所有人相同金额)/运气(所有人随机金额)*/
#define   MESSAGE_EX_ATTR_RED_ENVELOPE_TYPE @"red_enevlope_type" //RedPacketType
//luck money id
#define MESSAGE_EX_ATTR_LUCKMONEY_ID @"luckymoney_id"

/** 发红包的人 */
#define MESSAGE_EX_ATTR_RED_ENVELOPE_OWNER @"red_envelope_owner"
/** 发红包人的名字*/
#define MESSAGE_EX_ATTR_RED_ENVELOPE_OWNER_NAME @"red_envelope_owner_name"
/** 抢红包的人 */
#define  MESSAGE_EX_ATTR_RED_ENVELOPE_GETTER @"red_envelope_getter"
/** 抢红包人的名字*/
#define MESSAGE_EX_ATTR_RED_ENVELOPE_GETTER_NAME @"red_envelope_getter_name"

typedef NS_ENUM(NSInteger, ExtMessageType){
    
    Red_None =0,
    Red_Packet = 1,
    Red_Packet_Tip = 2,
    Welcome_To_Group = 3,
};

@interface NSAttributedString (XTAttributionSize)

- (CGSize)sizeWithWidth:(CGFloat)width;
- (CGSize)sizeWithHeight:(CGFloat)height;

@end

@interface NSString (XTSize)

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;

@end


@interface UitlCommon : NSObject

+ (void)timerFireMethod:(NSTimer*)theTimer;
+ (void)showAlert:(NSString *)msg;

/*
 *判断是否是空字符串
 */

+(BOOL)isNull:(NSString*)str;


/**
 *  按照UILabel对应的text修改UILabel宽度，高度不会变化
 *  @param lableView  对应的UILabel
 *  @param maxW       如果为0 宽度为text计算对应的宽度
 *  @param isAutoLine 是否自动换行（还没有实现）
 */
+(void)setWidth:(UILabel*)lableView maxWidth:(CGFloat)maxW isAutoLine:(BOOL)isAutoLine;
/**
 *  按照UILabel对应的text修改UILabel高度，宽度不会变化
 *
 *  @param lableView 对应的UILabel
 *  @param maxH      如果为0 高度为text计算对应的高度
 */
+(void)setHeight:(UILabel*)lableView maxHeight:(CGFloat)maxH;
+(void)setButtonWidth:(UIButton*)buttonView maxWidth:(CGFloat)maxW isAutoLine:(BOOL)isAutoLine
          contentType:(NSString*)type viewX:(CGFloat)viewX;
/**
 *  让正方形的view变成圆形，且没有边框
 *
 *  @param view 对应的view
 */
+(void)setLayImageView:(UIView*)imageView;
/**
 *  给view加灰色的边框
 *
 *  @param view 对应的view
 */
+(void)setGrayLine:(UIView*)view;
/**
 *  获得view对应屏幕的绝对坐标
 *
 *  @param v 对应的view
 *
 *  @return 坐标
 */
+(CGRect)relativeFrameForScreenWithView:(UIView *)v;
/**
 *  让集合转换为用逗号分开的字符串，集合最后一个不加逗号。
 *
 *  @param imageIds 对应的集合
 *
 *  @return 如果集合为空或者为0，返回nill ;如：1,5,5
 */
+(NSString*)spalider:(NSMutableArray*)imageIds;
/**
 *  根据value 获得词典对应key；key必须为NSString类型
 *
 *  @param dic   词典
 *  @param value 需要获得key的值
 *
 *  @return key 字符串
 */
+(NSString*)getKeyForDic:(NSDictionary*)dic value:(NSString*)value;
+(NSString*)getKeyForDic2:(NSArray*)dic value:(NSString*)value;
+(NSString*)getValueForDic:(NSArray*)dic key:(NSString*)key;
/**
 *  呼叫电话
 *
 *  @param phoneNumber 电话号码
 */
+(void)callPhone:(NSString*)phoneNumber;
/**
 *  给view加灰色的边框
 *
 *  @param view   对应的view
 *  @param radius 弧度
 */
+(void)setFlat:(UIView*)view radius:(CGFloat)radius;
/**
 *  设置view 与 view 之间的y轴距离
 *
 *  @param viewBefore 相对的view，坐标系部会变
 *  @param viewAfter  需要设置的view
 *  @param y          相对距离
 */
+(void)setYLoaction:(UIView*)viewBefore viewAfter:(UIView*)viewAfter y:(CGFloat)y;
/**
 *  设置view x坐标
 *
 *  @param view 对应的view
 *  @param x    x坐标值
 */
+(void)setViewXLoaction:(UIView*)view x:(CGFloat)x;
/**
 *  设置view y坐标
 *
 *  @param view 对应的view
 *  @param y    y坐标值
 */
+(void)setViewYLoaction:(UIView*)view y:(CGFloat)y;
/**
 *  设置view 高度
 *
 *  @param view 对应的view
 *  @param h    高度值
 */
+(void)setViewHLoaction:(UIView*)view h:(CGFloat)h;
/**
 *  设置view宽度
 *
 *  @param view 对应的view
 *  @param W    宽度值
 */
+(void)setViewWLoaction:(UIView*)view W:(CGFloat)W;
/**
 *  判断一个字符串是否全是数字
 *
 *  @param number 字符串
 *
 *  @return 如果全是数字yes,则为no
 */
+ (BOOL) trimming :(NSString*)number;


/**
 *  设置view动画，左右震动动画
 *
 *  @param viewToShake view
 */
+(void)shakeView:(UIView*)viewToShake repeatCount:(float)repeatCount delayTime:(float)delayTime;
/**
 *  设置UIImageView 中图片显示居中UIViewContentModeCenter
 *
 *  @param uiImageView
 *  @param imageView
 */
+(void)setImageView:(UIImageView*)uiImageView imageView:(UIImage*)imageView;

/**
 *  时间格式化
 *
 *  @param dateType 格式化类型如：@"yyyy-MM-dd HH:mm:ss" @"yyyy/MM/dd HH:mm" @"yyyy-MM-dd" @"HH:mm"
 *  @param date     时间
 *
 *  @return 格式后的字符串
 */
+(NSString*)dateFormatter:(NSString*)dateType date:(NSDate*)date;
/**
 *  字符串转换为日期格式
 *
 *  @param dateString             需要转换的字符串
 *  @param activityDateFormateLib 转换后的日期格式
 *
 *  @return 日期
 */
+(NSDate*)createByString:(NSString*)dateString activityDateFormateLib:(NSString*)activityDateFormateLib;
/**
 *  移除字符串集合中的某个字符串
 *
 *  @param datas       字符串集合
 *  @param romveString 需要移除的字符串 如：@“全部”
 */
+(void)removeData:(NSMutableArray *)datas romveString:(NSString*)romveString;
//+(NSString*)formatterUp:(NSInteger)number;
/**
 *  计算出日期对应星期几
 *
 *  @param inputDate 日期
 *  @param isLow     返回的星期几为大写还是小写
 *
 *  @return 1，2，3，4，5，6,7或者一，二...,天
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate  isLow:(BOOL)isLow;
/**
 *  改变图片的尺寸
 *
 *  @param image 图片
 *  @param asize 需要改变的长宽 如：CGSizeMake(image.size.width/4, image.size.height/4)
 *
 *  @return 修改后的图片
 */
+(UIImage*)updateSizeImage:(UIImage*)image size:(CGSize)asize;
/**
 *  播放消息声音
 *
 *  @param playSound 声音
 *  @param vibrate   震动
 */
+(void) playSound2:(BOOL)playSound vibrate:(BOOL)vibrate;
/**
 *  计算2个时间相差的间隔
 *
 *  @param startTime 开始时间
 *  @param endTime   结束时间
 *
 *  @return 时间间隔秒
 */
+(NSInteger)showTime:(NSDate *)startTime andEndTime:(NSDate*)endTime;
/**
 *  防止地址URL 转换时候为nil
 *
 *  @param url url 字符串
 *
 *  @return 转换后的URL字符串
 */
+(NSString*)nilURL:(NSString*)url;
/**
 *  判断一个字符串中是否包含某个字符串
 *
 *  @param type 判断的字符串，字符串必须是逗号隔开
 *  @param key  包含字符串
 *
 *  @return 包含yes,否则no
 */
+(BOOL)isPublic:(NSString*)type key:(NSString*)key;
/**
 *  给view加边框
 *
 *  @param view       对应的view
 *  @param radius     弧度
 *  @param color      边框颜色
 *  @param borderWith 边框宽度
 */
+(void)setFlat:(UIView*)view radius:(CGFloat)radius color:(UIColor*)color borderWith:(CGFloat)borderWith;


/*
 *以中心点拉伸图片到整个view上
 */
+(void)stretchableeView:(id)view withImage:(UIImage*)image;

/*根据颜色生成背景图*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//判断是否越狱
+ (BOOL)isJailBreak;

//移除最后一个字符
+(NSString*)removeLastChara:(NSString*)str;


//设置关键字颜色
+(NSMutableAttributedString*)setString:(NSString*)str keyString:(NSString*)keyStr color:(UIColor*)keyColor otherColor:(UIColor*)color;

//设置关键字颜色和字体
+(NSMutableAttributedString*)setString:(NSString*)str keyString:(NSString*)keyStr keyColor:(UIColor*)keyColor otherColor:(UIColor*)color keyFont:(UIFont*)keyFont otherFont:(UIFont*)font;

//等级转换
+ (NSString*)transferLevel:(NSString*)level;


//判断uitextField ,textView输入内容变化时，判断当前内容是不是空
+(BOOL)judageTextIsVaild:(NSString*)str newText:(NSString*)str1;

+(NSString*)getCurrentTextFiledText:(NSString*)str newText:(NSString*)str1;


//判断小数点位数是否为两位
+(BOOL)checkMoneyVaild:(NSString*)str;

+(BOOL)checkPerPacktMoney:(NSString*)allMony count:(NSString*)count;
//判读是否是有效的手机号
+(BOOL)isVaildePhoneNum:(NSString*)phoneNum;

//判读是否是有效的座机号
+(BOOL)isVaildeLandlineNum:(NSString*)landlineNum;

//是否是正确的 邮箱格式
+(BOOL)isValidateEmail:(NSString *)email;

@end




