//
//  FrankTools.m
//  SCFinance
//
//  Created by lichao on 16/5/26.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "FrankTools.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "EncryptionUserDefaults.h"
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "lhSymbolCustumButton.h"
#import "NSObject+SBJson.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import  "MineViewController.h"
static FrankTools *shareTool;
#define pathsOther [NSString stringWithFormat:@"%@/SCFinanceOther",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

#define fxBgViewTag 339
#define fxLowViewTag 340
static UILabel * tempLabel;//alert提示label
//分享图片和描述
static NSString * fxConStr; //分享的内容
static id fxImg;            //分享的图片
static NSString * fxUrlStr; //分享的链接
static NSString * titleString; //分享的标题
UIViewController *tempFxVc; //缓存分享页面传过来的Vc

UIWebView *phoneCallWebView;

@implementation FrankTools

/**
 *  创建单例
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{     //该方法只执行一次，且能保证线程安全
        shareTool = [[FrankTools alloc] init];
    });
    return shareTool;
}

#pragma mark - 获取用户的token
+ (NSString*)getUserToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile];
    return token?token:@"";
}

#pragma mark - 获取用户的UUID
+ (NSString*)getDeviceUUID {
    NSString *uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return uuid?uuid:@"";
}

+ (BOOL)isLogin {
    if ([FrankTools getUserToken].length > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)loginIsOrNot:(UIViewController *)controller{
    if ([FrankTools getUserToken].length > 0) {
        return YES;
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginVC.delegate = (id<RefreshingViewDelegate>)controller;
        [controller presentViewController:nav animated:YES completion:nil];
    }
    return NO;
}

+ (BOOL)isPayPassword {
    BOOL isPayPassword = [[[NSUserDefaults standardUserDefaults] objectForKey:havePayPassword] boolValue];
    return isPayPassword;
}

+ (NSArray *)getProvince{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = [data JSONValue];
    NSArray *province = [[dic objectForKey:@"root"] objectForKey:@"province"];
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *dic in province) {
        NSString *proviceStr = [dic objectForKey:@"-name"];
        [results addObject:proviceStr];
    }
    data = nil;
    dic = nil;
    province = nil;
    return results;
}

+ (NSArray *)getCityWithProvice:(NSString*)provice{
    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data JSONValue];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
        NSMutableArray *results = [NSMutableArray array];
        
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            if ([proviceStr isEqualToString:provice]) {
                
                id citys = [info objectForKey:@"city"];
                if ([citys isKindOfClass:[NSDictionary class]]) {
                    NSString *city = [citys objectForKey:@"-name"];
                    [results addObject:city];
                    return results;
                }
                else if([citys isKindOfClass:[NSArray class]]){
                    
                    for(NSDictionary *cityDic in citys){
                        NSString *city = [cityDic objectForKey:@"-name"];
                        [results addObject:city];
                    }
                    return results;
                }
            }
        }
    }
    return nil;
}

+ (NSString*)getDistrctIDWithModel:(RecieveAddressModel*)model{
    
    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data JSONValue];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
        
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            if ([proviceStr isEqualToString:model.provice]) {
                
                id citys = [info objectForKey:@"city"];
                if ([citys isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *city1 = [citys objectForKey:@"-name"];
                    if ([city1 isEqualToString:model.city]) {
                        
                        NSArray *cityArray = [citys objectForKey:@"district"];
                        for (NSDictionary *areaDic in cityArray) {
                            
                            NSString *areaName = [areaDic objectForKey:@"-name"];
                            if ([areaName isEqualToString:model.distrct]) {
                                return [areaDic objectForKey:@"-zipcode"];
                            }
                        }
                        
                    }
                    
                    
                }
                else if([citys isKindOfClass:[NSArray class]]){
                    
                    for(NSDictionary *cityDic in citys){
                        NSString *city1 = [cityDic objectForKey:@"-name"];
                        
                        if ([city1 isEqualToString:model.city]) {
                            
                            NSArray *cityArray = [cityDic objectForKey:@"district"];
                            for (NSDictionary *areaDic in cityArray) {
                                
                                NSString *areaName = [areaDic objectForKey:@"-name"];
                                if ([areaName isEqualToString:model.distrct]) {
                                    return [areaDic objectForKey:@"-zipcode"];
                                }
                            }
                            
                        }
                        
                    }
                }
                
                
            }
        }
        
    }
    return nil;
}

+(RecieveAddressModel*)getAddressModelWithDistrctID:(NSString*)areaId{
    
    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data JSONValue];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
        
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            
            id citys = [info objectForKey:@"city"];
            if ([citys isKindOfClass:[NSDictionary class]]) {
                
                NSString *citystr = [citys objectForKey:@"-name"];
                
                NSArray *cityArray = [citys objectForKey:@"district"];
                
                for (NSDictionary *areaDic in cityArray) {
                    
                    NSString *zipcode = [areaDic objectForKey:@"-zipcode"];
                    if ([zipcode isEqualToString:areaId]) {
                        RecieveAddressModel *model = [RecieveAddressModel new];
                        model.distrct = [areaDic objectForKey:@"-name"];
                        model.area_id = zipcode;
                        model.provice = proviceStr;
                        model.city = citystr;
                        
                        return model;
                    }
                    
                }
                
                
            }
            else if([citys isKindOfClass:[NSArray class]]){
                
                for(NSDictionary *cityDic in citys){
                    
                    NSString *citystr = [cityDic objectForKey:@"-name"];
                    
                    NSArray *cityArray = [cityDic objectForKey:@"district"];
                    for (NSDictionary *areaDic in cityArray) {
                        
                        NSString *zipcode = [areaDic objectForKey:@"-zipcode"];
                        if ([zipcode isEqualToString:areaId]) {
                            RecieveAddressModel *model = [RecieveAddressModel new];
                            model.distrct = [areaDic objectForKey:@"-name"];
                            model.area_id = zipcode;
                            model.provice = proviceStr;
                            model.city = citystr;
                            
                            return model;
                        }
                        
                    }
                    
                    
                }
            }
            
            
        }
    }
    
    return nil;
}

+(NSArray*)getDistrctWithProvice:(NSString*)provice city:(NSString*)city{
    @autoreleasepool {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:nil];
        NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary *dic = [data JSONValue];
        
        NSArray *provinceArray = [[dic objectForKey:@"root"] objectForKey:@"province"];
        NSMutableArray *results = [NSMutableArray array];
        
        for (NSDictionary *info in provinceArray) {
            
            NSString *proviceStr = [info objectForKey:@"-name"];
            if ([proviceStr isEqualToString:provice]) {
                
                id citys = [info objectForKey:@"city"];
                if ([citys isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *city1 = [citys objectForKey:@"-name"];
                    if ([city1 isEqualToString:city]) {
                        
                        NSArray *cityArray = [citys objectForKey:@"district"];
                        for (NSDictionary *areaDic in cityArray) {
                            
                            [results addObject:[areaDic objectForKey:@"-name"]];
                        }
                        return results;
                    }
                    
                    
                }
                else if([citys isKindOfClass:[NSArray class]]){
                    
                    for(NSDictionary *cityDic in citys){
                        NSString *city1 = [cityDic objectForKey:@"-name"];
                        
                        if ([city1 isEqualToString:city]) {
                            
                            NSArray *cityArray = [cityDic objectForKey:@"district"];
                            for (NSDictionary *areaDic in cityArray) {
                                
                                [results addObject:[areaDic objectForKey:@"-name"]];
                            }
                            return results;
                        }
                        
                    }
                }
                
                
            }
        }
        
    }
    return nil;
}

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

#pragma mark - 缓存图片
#pragma mark - 检测，存储图片
//获取图片名字
- (NSString *)imageStr:(NSString *)iStr
{
    NSRange ra = [iStr rangeOfString:@"-" options:NSLiteralSearch];
    
    if (ra.length > 0) {
        iStr = [iStr substringFromIndex:ra.location+1];
    }
    
    return iStr;
}

+ (float)cacheLength
{
    return [self folderSizeAtPath:pathsOther];
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 分享
//批量处理APP中的分享问题
+ (void)fxViewAppear:(id)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withTitilStr:(NSString *)titilStr withVc:(UIViewController *)fxVc isAdShare:(NSString *) adShareStatus
{
    fxConStr = cStr;
    fxImg = Img;
    fxUrlStr = urlStr;
    tempFxVc = fxVc;
    titleString = titilStr;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:shareTool action:@selector(fxViewDisAppear)];
    UIView * grayV = [[UIView alloc]initWithFrame:fxVc.navigationController.view.bounds];
    grayV.tag = fxBgViewTag;
    grayV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [grayV addGestureRecognizer:tapG];
    [fxVc.view addSubview:grayV];
    
    UIView * fxView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 140*widthRate)];
    fxView.tag = fxLowViewTag;
    fxView.backgroundColor = [UIColor whiteColor];
    [fxVc.view addSubview:fxView];
    
    NSArray * a = @[@"微信好友",@"QQ好友",@"短信"];
    CGFloat fxWith = (DeviceMaxWidth-20*widthRate)/3;
    for (int i = 0; i < 3; i++) {
        lhSymbolCustumButton * fxBtn = [[lhSymbolCustumButton alloc]initWithFrame2:CGRectMake(10*widthRate+fxWith*i, 0, fxWith, 100*widthRate)];
        fxBtn.tag = i;
        NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
        [fxBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        fxBtn.tLabel.text = [a objectAtIndex:i];
        [fxBtn addTarget:[FrankTools sharedInstance] action:@selector(fxBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [fxView addSubview:fxBtn];
    }
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fxView addSubview:cancelBtn];
    
    if ([adShareStatus integerValue] == 1) {
        cancelBtn.backgroundColor = mainColor;
        [cancelBtn setTitle:@"收藏" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 40*widthRate);
        [cancelBtn addTarget:shareTool action:@selector(saveSuceess) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([adShareStatus integerValue] == 2) {
        cancelBtn.backgroundColor = mainColor;
        [cancelBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 40*widthRate);
        [cancelBtn addTarget:shareTool action:@selector(saveSuceess) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        cancelBtn.backgroundColor = viewColor;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 100*widthRate, DeviceMaxWidth, 40*widthRate);
        [cancelBtn addTarget:shareTool action:@selector(fxViewDisAppear) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 1;
        fxView.frame = CGRectMake(0, DeviceMaxHeight-140*widthRate-64, DeviceMaxWidth, 140*widthRate);
    }];
}

- (void)fxBtnEventOther:(UIButton *)button_ image:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr withTitleStr:(NSString *)titleStr;
{
    fxConStr = cStr;
    fxImg = Img;
    fxUrlStr = urlStr;
    titleString = titleStr;
    
    [self fxBtnEvent:button_];
}

- (void)fxBtnEvent:(UIButton *)button_
{
    [[FrankTools sharedInstance] fxViewDisAppear];
    
    SSDKPlatformType type;
    switch (button_.tag) {
        case 0:{
            //微信好友
            type = SSDKPlatformSubTypeWechatSession;
            break;
        }
        case 1:{
            //            QQ好友
            type = SSDKPlatformSubTypeQQFriend;
            break;
        }
        case 2:{
            //短信
            type = SSDKPlatformTypeSMS;
            break;
        }
        default:
            break;
    }
    
    [FrankTools sendMessageToWeiXinSession:type];
    
}

#pragma mark - 分享
+ (void)sendMessageToWeiXinSession:(NSInteger)shareType
{
    
    SSDKPlatformType type = (SSDKPlatformType)shareType;
    if(type == SSDKPlatformSubTypeQQFriend){
        if (![QQApiInterface isQQInstalled]) {
            [FrankTools showAlertWithMessage:@"请先安装QQ客户端~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    else if(type == SSDKPlatformSubTypeWechatSession){
        if (![WXApi isWXAppInstalled]) {
            [FrankTools showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
        if(![WXApi isWXAppSupportApi]){
            [FrankTools showAlertWithMessage:@"微信版本不支持分享~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    else if (type == SSDKPlatformTypeSMS) {
        fxImg = @"";
        NSString *tempContex = fxConStr;
        fxConStr = [NSString stringWithFormat:@"%@  %@",tempContex,fxUrlStr];
    }
    
    NSString * titleStr = titleString;
    FLLog(@"%@",fxImg);
    FLLog(@"%@",fxUrlStr);
    FLLog(@"%@",fxConStr);
    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (fxImg) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:fxConStr
                                         images:@[fxImg]
                                            url:[NSURL URLWithString:fxUrlStr]
                                          title:titleStr
                                           type:SSDKContentTypeAuto];
        
    
    //2.分享
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:{
                    [FrankTools showAlertWithMessage:@"分享成功~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sharedSuccess" object:nil];
                    break;
                }
                case SSDKResponseStateFail:
                    if ([error code] == -22003) {
                        [FrankTools showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
                    }
                    else if([error code] == -22005){
                        [FrankTools showAlertWithMessage:@"取消分享~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
                    }
                    else{
                        if (type == SSDKPlatformTypeSMS) {
                            [FrankTools showAlertWithMessage:@"该设备不支持短信分享~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
                        }else{
                            [FrankTools showAlertWithMessage:@"分享失败~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
                        }
                    }
                    break;
                default:
                    break;
            }
        }];
    }
}

#pragma mark - 发送短信方法
+(void)sendSMS
{
    NSURL *url = [NSURL URLWithString:@"sms://"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - 代理方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [tempFxVc dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [FrankTools showAlertWithMessage:@"分享成功~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [FrankTools showAlertWithMessage:@"分享失败~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [FrankTools showAlertWithMessage:@"分享取消~" withSuperView:tempFxVc.view withHeih:DeviceMaxHeight/2];
            break;
        default:
            break;
    }
}

#pragma mark - 发送短信方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        [tempFxVc presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)fxViewDisAppear
{
    UIView * grayV = [tempFxVc.view viewWithTag:fxBgViewTag];
    UIView * fxView = [tempFxVc.view viewWithTag:fxLowViewTag];
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 0;
        fxView.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 135*widthRate);
    }completion:^(BOOL finished) {
        [grayV removeFromSuperview];
        [fxView removeFromSuperview];
    }];
}
- (void)saveSuceess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"adSaveSuccess" object:nil];
    UIView * grayV = [tempFxVc.view viewWithTag:fxBgViewTag];
    UIView * fxView = [tempFxVc.view viewWithTag:fxLowViewTag];
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 0;
        fxView.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 135*widthRate);
    }completion:^(BOOL finished) {
        [grayV removeFromSuperview];
        [fxView removeFromSuperview];
    }];
}


//遍历文件夹获得文件夹大小，返回多少M
+ (float )folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1000.0*1000.0);
}

+ (void)setImgWithImgView:(UIImageView *)tempImg withImageUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage;
{
    NSString *tempUrl = imageUrl;
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([imageUrl rangeOfString:@"null"].length || [@"" isEqualToString:imageUrl]) {
        tempImg.image = placeholderImage;
        return;
    }
    
    if ([[FrankTools sharedInstance] isImageWithName:imageUrl]) {//图片存在
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * img = [[FrankTools sharedInstance] readImageWithNameOther:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                tempImg.image = img;
            });
        });
    }
    else{
        [tempImg sd_setImageWithURL:[NSURL URLWithString:tempUrl] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType ,NSURL *imageURL) {
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[FrankTools sharedInstance] saveImagesOther:image withName:imageUrl];
                });
            }
        }];
    }
}

//设置button的背景图片并缓存
+ (void)checkBgViewWithBtn:(UIButton *)tempBtn withUrl:(NSString *)imageUrl withPlaceHolderImage:(UIImage *)placeholderImage
{
    NSString *tempUrl = imageUrl;
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([imageUrl rangeOfString:@"null"].length || [@"" isEqualToString:imageUrl]) {
        [tempBtn setBackgroundImage:placeholderImage forState:UIControlStateNormal];
        return;
    }
    
    if ([[FrankTools sharedInstance] isImageWithName:imageUrl]) {//图片存在
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * img = [[FrankTools sharedInstance] readImageWithNameOther:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tempBtn setBackgroundImage:img forState:UIControlStateNormal];
            });
        });
    }
    else{
        [tempBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:tempUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType ,NSURL *imageURL){
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[FrankTools sharedInstance] saveImagesOther:image withName:imageUrl];
                });
            }
        }];
    }
}

#pragma mark - 可清空图片，存储.读取.删除图片
- (void)removeAllImage
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathsOther]) {
        
        [fileManager removeItemAtPath:pathsOther error:nil];
    }
}

//判断图片是否存在
- (BOOL)isImageWithName:(NSString *)name
{
    if(!name || [@"" isEqualToString:name]){
        return NO;
    }
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    
    if (![fileManager fileExistsAtPath:pathStr]) {
        return NO;
    }
    
    return YES;
}

- (void)saveImagesOther:(UIImage *)tempImg withName:(NSString *)name
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pathsOther]) {
        [fileManager createDirectoryAtPath:pathsOther withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:nil];
    }
    
    NSData * imgData;
    imgData = UIImageJPEGRepresentation(tempImg, 0.8);
    
    if(!name || [@"" isEqualToString:name]){
        return;
    }
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    [fileManager createFileAtPath:pathStr contents:imgData attributes:[NSDictionary dictionary]];
    
}

- (UIImage *)readImageWithNameOther:(NSString *)name
{
    if(!name || [@"" isEqualToString:name]){
        return [[UIImage alloc]init];
    }
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString * pathStr = [NSString stringWithFormat:@"%@/%@",pathsOther,name];
    NSData * readData = [NSData dataWithContentsOfFile:pathStr];
    UIImage * tempImg = [UIImage imageWithData:readData scale:1];
    
    return tempImg;
}

+ (void)setImgWithImgView:(UIImageView *)tempImg withImageUrl:(NSString *)imageUrl
{
    NSString *tempUrl = imageUrl;
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if ([[FrankTools sharedInstance] isImageWithName:imageUrl]) {//图片存在
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * img = [[FrankTools sharedInstance] readImageWithNameOther:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                tempImg.image = img;
            });
        });
    }
    else{
        [tempImg sd_setImageWithURL:[NSURL URLWithString:tempUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType ,NSURL *imageURL) {
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[FrankTools sharedInstance] saveImagesOther:image withName:imageUrl];
                });
            }
        }];
    }
}

//纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 支付宝支付
+(void)aliPay:(Order*)model comple:(void(^)(BOOL bsuccess,NSString *message))comple
{
    [[AlipaySDK defaultService] payOrder:model.signature_data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        FLLog(@"%@",resultDic);
        NSInteger code = [[resultDic objectForKey:@"resultStatus"] integerValue];
        switch (code) {//用户中途取消
                case 9000:
            {
                comple(YES,@"支付成功");
                break;
            }
                case 6001:
            {
                comple(NO,@"支付取消");
                break;
            }
            default:{
                comple(NO,@"支付失败");
            }
                break;
        }
    }];
}

+(void)weChatPay:(Order*)model :(NSString *)WxAppId :(NSString *)partnerid comple:(void(^)(BOOL bsuccess))comple{
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    //============================================================
    
    PayReq* wxreq             = [[PayReq alloc] init];
    wxreq.openID              = WxAppId?WxAppId:@"";
    wxreq.partnerId           = partnerid?partnerid:@"";
    wxreq.prepayId            = [NSString stringWithFormat:@"%@",model.sigatureData.prepayid];
    wxreq.nonceStr            = [NSString stringWithFormat:@"%@",model.sigatureData.noncestr];
    wxreq.timeStamp           = [model.sigatureData.timestamp intValue];
    wxreq.package             = [NSString stringWithFormat:@"%@",model.sigatureData.weixin_package];
    wxreq.sign                = [NSString stringWithFormat:@"%@",model.sigatureData.sign];;
    BOOL bOk = [WXApi sendReq:wxreq];
    comple(bOk);
}

#pragma mark - 提示
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih
{
    if (!tempLabel) {
        tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 40)];
        tempLabel.layer.cornerRadius = 5;
        tempLabel.layer.allowsEdgeAntialiasing = YES;
        tempLabel.layer.masksToBounds = YES;
        tempLabel.backgroundColor = [UIColor blackColor];
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.font = [UIFont systemFontOfSize:13];
        tempLabel.text = message;
        tempLabel.textAlignment = NSTextAlignmentCenter;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    else{
        tempLabel.alpha = 1;
        tempLabel.hidden = NO;
        tempLabel.text = message;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    
    [superView addSubview:tempLabel];
    
    [shareTool performSelector:@selector(tempLabelDis) withObject:nil afterDelay:1.0f];
    
}

- (void)tempLabelDis
{
    if (tempLabel) {
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tempLabel.alpha = 0;
        }completion:^(BOOL finished) {
            [tempLabel removeFromSuperview];
            tempLabel = nil;
        }];
    }
}

+ (void)openUserEnable:(UIView *)vie
{
    for (UIView * v in vie.subviews) {
        v.userInteractionEnabled = YES;
    }
}

+ (void)closeUserEnable:(UIView *)viw
{
    for (UIView * v in viw.subviews) {
        v.userInteractionEnabled = NO;
    }
}

#pragma mark - 打电话
+ (void)detailPhone:(NSString *)phone {
    [self dialPhoneNumber:phone];
}

+ (void)dialPhoneNumber:(NSString *)aPhoneNumber {
    NSString *str = [NSString stringWithFormat:@"telprompt://%@",aPhoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark - 字符串非空判断
+ (BOOL)isNullOfString:(NSString *)string
{
    if ([string isEqualToString:@"(nil)"] || string == nil || string == NULL || [string isEqualToString:@"(NULL)" ] || [string isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 设置字体的行间距
+(NSMutableAttributedString *)setLineSpaceing:(NSInteger)size WithString:(NSString *)string WithRange:(NSRange)range
{
    if ([string isEqualToString:@""]) {
        return nil;
    }
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:size];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:range];
    return as;
}

/**
 * 设置范围内字体的大小
 */
+(NSMutableAttributedString *)setFontSize:(UIFont *)fontSize WithString:(NSString *)string WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    [as addAttribute:NSFontAttributeName value:fontSize range:range];
    return as;
}

/**
 * 设置范围内字体的大小和颜色
 */
+(NSMutableAttributedString *)setFontColorSize:(UIFont *)fontSize WithColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    [as addAttribute:NSFontAttributeName value:fontSize range:range];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
    return as;
}

#pragma mark - 设置控件文本部分字体颜色
+(NSMutableAttributedString *)setFontColor:(UIColor *)color WithString:(NSString *)string WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
    return as;
}

#pragma mark - 设置字体的行间距同时修改自定范围字体颜色
+(NSMutableAttributedString *)setLineSpaceingWithString:(NSString *)string WithSize:(NSInteger)size WithColor:(UIColor *)color WithRange:(NSRange)range
{
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:string];
    //设置字体颜色
    [as addAttribute:NSForegroundColorAttributeName value:color range:range];
    //调整字体间距
    NSMutableParagraphStyle * ps = [[NSMutableParagraphStyle alloc]init];
    [ps setLineSpacing:size];
    [as addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, string.length)];
    return as;
}

#pragma mark - 对时间进行处理
+(NSString *)NSDateToString:(NSDate *)dateFromString withFormat:(NSString *)formatestr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatestr];
    NSString *strDate = [dateFormatter stringFromDate:dateFromString];
    return strDate;
}


/*
 *  @"YYYY-MM-dd HH:mm:ss" //对时间戳进行格式化处理
 */
+(NSString *)LongTimeToString:(NSString *)time withFormat:(NSString *)formatestr
{
    NSDate * date = nil;
    time = [NSString stringWithFormat:@"%@",time];
    if (time.length == 10) { //10位
        date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    }else //13位
    {
        date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
    }
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:formatestr];
    return [df stringFromDate:date];
}

+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = nil;
    NSString *beTimeStr = [NSString stringWithFormat:@"%.0f",beTime];
    if (beTimeStr.length == 10) { //10位
        beDate = [NSDate dateWithTimeIntervalSince1970:[beTimeStr doubleValue]];
    }else //13位
    {
        beDate = [NSDate dateWithTimeIntervalSince1970:[beTimeStr longLongValue]/1000];
    }
    [NSDate dateWithTimeIntervalSince1970:beTime/1000];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
//    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime < 60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
//        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
        distanceStr = [NSString stringWithFormat:@"今天"];
    }
    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){//时间小于两天
        
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
//            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
            distanceStr = [NSString stringWithFormat:@"昨天"];
        }
        else{
//            [df setDateFormat:@"MM-dd HH:mm"];
            [df setDateFormat:@"yyyy-MM-dd"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime < 24*60*60*365){
        [df setDateFormat:@"yyyy-MM-dd"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

//返回两个时段相差的秒数
+(NSInteger)getSecondsWithBeginDate:(NSString*)currentTime  AndEndDate:(NSString*)deadlineTime{
    NSTimeInterval deadline = [deadlineTime longLongValue]/1000;
    NSTimeInterval current = [currentTime longLongValue]/1000;
    return deadline-current;
}

+(NSNumber *)stringToNSNumber:(NSString *)string
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [numberFormatter numberFromString:string];
}

+ (CGFloat)sizeForString:(NSString *)text withSizeOfFont:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [text sizeWithAttributes:dict];
    return size.width;
}

//根据文字和字体，计算文字的特定高度SpecificWidth内的显示高度
+(CGFloat)getSpaceLabelHeight:(NSString*)string withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpacing:(CGFloat)size
{
    if ([string isEqualToString:@""]) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = size;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize sizeHeight = [string boundingRectWithSize:CGSizeMake(width, DeviceMaxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return sizeHeight.height;
}

#pragma mark - 手机号码处理
+(NSString *)replacePhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length != 11) {
        return @"";
    }
    return [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

#pragma mark - 手机号验证
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    if (mobile && mobile.length == 11 && [mobile characterAtIndex:0] == '1') {
        return YES;
    }
    return NO;
}
//验证是否是身份证
+(BOOL)isValidateIDNum:(NSString *)IDNum
{
    if (IDNum.length >= 15 && IDNum.length <= 18) {
        return YES;
    }
    return NO;
}
//去掉浮点数字符串末尾的0
+ (NSString *)floatStringZero:(NSString *)oldStr
{
    NSString *nowStr = [oldStr stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    const char * str = [nowStr UTF8String];
    
    int zeroLength = 0;
    for (int i = (int)nowStr.length-1; i > 0; i--) {
        if (str[i] == '0') {
            zeroLength++;
        }
        else if (str[i] == '.'){
            zeroLength++;
            break;
        }
        else{
            break;
        }
    }
    
    return [oldStr substringToIndex:oldStr.length-zeroLength];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(BOOL)isNull:(NSString *)str{
    if (!str ) {
        return YES;
    }
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@",str];
    }
    
    NSString *clearSpace = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *clearSpace1 = [clearSpace stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([str length] == 0||[clearSpace1 isEqualToString:@""]||!str){
        return YES;
    }
    return NO;
}

+ (void)saveUserDataToLocal:(NSDictionary *)dataDic
{
    //保存token到本地
    [[NSUserDefaults standardUserDefaults] setObject:[dataDic objectForKey:@"access_token"] forKey:saveLocalTokenFile];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //保存是否设置过支付密码
    NSString *isPayPassworld = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"user_info"] objectForKey:@"payment_pwd"]];
    [[NSUserDefaults standardUserDefaults] setBool:[isPayPassworld boolValue] forKey:havePayPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //保存用户数据
    NSDictionary *dataD = [dataDic objectForKey:@"user_info"];
    if (dataD) {
        [[NSUserDefaults standardUserDefaults] setObject:dataD forKey:userLoginDataToLocal];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)clearUserLocalData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:saveLocalTokenFile];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userLoginDataToLocal];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:havePayPassword];
}

@end
