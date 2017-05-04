//
//  FrankTools.h
//  SCFinance
//
//  Created by lichao on 16/5/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "LoginViewController.h"
#import "RecieveAddressModel.h"

#import "Order.h"

typedef void(^CompletionBlock)(NSDictionary *resultDic);

@interface FrankTools : NSObject

@end

@interface FrankTools ()

@property (nonatomic, strong)UserModel *userModel;

@end

@interface FrankTools()<MFMessageComposeViewControllerDelegate>{
    
}

+ (instancetype)sharedInstance;
/**
 * 获取用户token
 */
+ (NSString*)getUserToken;

/**
 * 获取用户设备的UUID
 */
+ (NSString*)getDeviceUUID;

/**
 * 进行登录验证
 */
//+ (BOOL)loginIsOrNot;
+ (BOOL)isLogin;
+ (BOOL)loginIsOrNot :(UIViewController *)controller;
+ (BOOL)isPayPassword;
//+ (NSString*)getLoginAccount;
- (NSString *)getMd5_32Bit_String:(NSString *)srcString;
+ (NSArray *)getProvince;
+(NSArray *)getCityWithProvice:(NSString*)provice;
+(NSArray*)getDistrctWithProvice:(NSString*)provice city:(NSString*)city;
+(RecieveAddressModel*)getAddressModelWithDistrctID:(NSString*)areaId;
+(NSString*)getDistrctIDWithModel:(RecieveAddressModel*)model;

//保存用户登录数据
+(void)saveUserDataToLocal:(NSDictionary *)dataDic;
//清除用户本地数据
+(void)clearUserLocalData;
/**
 * 缓存图片
 */
+ (float)cacheLength;
//获取图片名字
- (void)saveImagesOther:(UIImage *)tempImg withName:(NSString *)name;
- (UIImage *)readImageWithNameOther:(NSString *)name;
- (NSString *)imageStr:(NSString *)iStr;

+ (void)setImgWithImgView:(UIImageView *)tempImg withImageUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage;
+ (void)setImgWithImgView:(UIImageView *)tempImg withImageUrl:(NSString *)imageUrl;
+ (void)checkBgViewWithBtn:(UIButton *)tempBtn withUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage;

- (void)removeAllImage;
- (BOOL)isImageWithName:(NSString *)name;

//纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *分享  //nil表示普通分享 1表示分享带收藏 2表示分享取消收藏
 */
+ (void)fxViewAppear:(id)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withTitilStr:(NSString *)titilStr withVc:(UIViewController *)fxVc isAdShare:(NSString *) adShareStatus;
- (void)fxBtnEventOther:(UIButton *)button_ image:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withTitleStr:(NSString *)titleStr;

/**
 *支付宝支付
 */
+(void)aliPay:(Order*)model comple:(void(^)(BOOL bsuccess,NSString *message))comple;

/**
 *微信支付
 */
+(void)weChatPay:(Order*)model :(NSString *)WxAppId :(NSString *)partnerid comple:(void(^)(BOOL bsuccess))comple;

/**
 * 显示一个提示
 *message:提示消息
 *superView:添加父类
 *heih:y坐标
 */
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih;

/*
 *  打电话
 */
+ (void)detailPhone:(NSString *)phone;

/**
 *  判断字符串非空   空返回YES,非空返回NO.
 */
+ (BOOL)isNullOfString:(NSString *)string;

/**
 *  把Json字符串转成字典.
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 * 设置字体的行间距
 */
+(NSMutableAttributedString *)setLineSpaceing:(NSInteger)size WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置字体的大小
 */
+(NSMutableAttributedString *)setFontSize:(UIFont *)fontSize WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置字体的大小和颜色
 */
+(NSMutableAttributedString *)setFontColorSize:(UIFont *)fontSize WithColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置控件文本部分字体颜色
 */
+(NSMutableAttributedString *)setFontColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range;

/**
 * 设置字体的行间距同时修改自定范围字体颜色
 */
+(NSMutableAttributedString *)setLineSpaceingWithString:(NSString *)string WithSize:(NSInteger)size WithColor:(UIColor *)color WithRange:(NSRange)range;

//对时间的处理
+(NSString *)NSDateToString:(NSDate *)dateFromString withFormat:(NSString *)formatestr;

/*
 * 对Long类型的时间（时间戳）进行格式化
 */
+(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr;

/*
 * 对时间进行处理
 */
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

/*
 * 两个时间相差多少秒
 */
+(NSInteger)getSecondsWithBeginDate:(NSString*)currentTime  AndEndDate:(NSString*)deadlineTime;

+(NSNumber *)stringToNSNumber:(NSString *)string;

+ (CGFloat)sizeForString:(NSString *)text withSizeOfFont:(UIFont *)font;

/**
 * 根据宽度、行距、字体计算高度
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)string withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(CGFloat)size;

/*
 *用*号替换手机号码中间4位
 */
+(NSString *)replacePhoneNumber:(NSString *)phoneNumber;

/*
 *验证手机号码是否正确
 */
+(BOOL) isValidateMobile:(NSString *)mobile;

/*
 * 去掉字符串末尾的0
 */
+ (NSString *)floatStringZero:(NSString *)oldStr;

/*
 * 验证是否是身份证
 */
+(BOOL)isValidateIDNum:(NSString *)IDNum;

+(BOOL)isNull:(NSString *)str;
 @end
