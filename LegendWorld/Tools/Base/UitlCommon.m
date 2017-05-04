//
//  UitlCommon.m
//  legend
//
//  Created by msb-ios-dev on 15/10/22.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "UitlCommon.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"


#define IOS7_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

@implementation NSAttributedString (XTAttributionSize)

- (CGSize)sizeWithWidth:(CGFloat)width{

    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}
- (CGSize)sizeWithHeight:(CGFloat)height{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

@end


@implementation NSString (XTSize)

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width{
    

    NSStringDrawingOptions optional = NSStringDrawingUsesLineFragmentOrigin;
    
    CGSize size = CGSizeMake(width,CGFLOAT_MAX);
    
    NSDictionary *dic=@{NSFontAttributeName: font, NSForegroundColorAttributeName : [UIColor blackColor]};
    
    CGRect labelsize =  [self boundingRectWithSize:size
                                           options:optional
                                        attributes:dic
                                           context:nil];
    
    return labelsize.size;
    return CGSizeZero;
    
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height{
    
    
    NSStringDrawingOptions optional = NSStringDrawingUsesLineFragmentOrigin;
    
    CGSize size = CGSizeMake(CGFLOAT_MAX,height);
    NSDictionary *dic=@{NSFontAttributeName:font};
    
    CGRect labelsize =  [self boundingRectWithSize:size
                                           options:optional
                                        attributes:dic
                                           context:nil];
    
    return labelsize.size;
}

@end



@implementation UitlCommon

+ (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
    FLLog(@"fds");
}


+ (void)showAlert:(NSString *)msg

{
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
}


+(BOOL)isNull:(NSString*)str
{
    
    
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

+(NSString*)spalider:(NSMutableArray*)imageIds
{
    NSString *ids ;
    for (int i=0; i<imageIds.count; i++) {
        if (i==0) {
            if (imageIds.count==1) {
                ids = [NSString stringWithFormat:@"%@",[imageIds objectAtIndex:i]];
            }
            else
            {
                ids = [NSString stringWithFormat:@"%@,",[imageIds objectAtIndex:i]];
            }
            
        }
        else if(i+1==imageIds.count)
        {
            ids = [NSString stringWithFormat:@"%@%@",ids,[imageIds objectAtIndex:i]];
        }
        else
        {
            ids = [NSString stringWithFormat:@"%@%@,",ids,[imageIds objectAtIndex:i]];
        }
        
    }
    return ids;
}

+(CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    if (v==nil)
    {
        return CGRectMake(0, 0, 230, 0);
    }
    else
    {
        BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if (!iOS7)
        {
            screenHeight -= 20;
        }
        
        UIView *view = v;
        CGFloat x = .0;
        CGFloat y = .0;
        
        while (view.frame.size.width != 320 || view.frame.size.height != screenHeight)
        {
            x += view.frame.origin.x;
            y += view.frame.origin.y;
            view = view.superview;
            if ([view isKindOfClass:[UIScrollView class]])
            {
                x -= ((UIScrollView *) view).contentOffset.x;
                y -= ((UIScrollView *) view).contentOffset.y;
            }
        }
        
        return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
    }
    
}

+(void)setGrayLine:(UIView*)view
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:1.0];
    [downButtonLayer setBorderWidth:0.5];
    [downButtonLayer setBorderColor:[[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0] CGColor]];
}

+(void)setFlat:(UIView*)view radius:(CGFloat)radius color:(UIColor*)color borderWith:(CGFloat)borderWith
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:radius];
    [downButtonLayer setBorderWidth:borderWith];
    [downButtonLayer setBorderColor:[color CGColor]];
}




+(void)setFlat:(UIView*)view radius:(CGFloat)radius
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:radius];
    [downButtonLayer setBorderWidth:0.1];
    [downButtonLayer setBorderColor:[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] CGColor]];
}

+(void)setLayImageView:(UIView*)imageView
{
    [imageView.layer setCornerRadius:(CGRectGetWidth(imageView.bounds)/2.f)];
    [imageView.layer setMasksToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(10, 10);
    imageView.layer.shadowOpacity = 0.5;
    imageView.layer.shadowRadius = 0;
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 0.0f;
    imageView.backgroundColor = [UIColor whiteColor];
}

+(void)setWidth:(UILabel*)lableView maxWidth:(CGFloat)maxW isAutoLine:(BOOL)isAutoLine
{
    CGRect lableFrame = lableView.frame;
    NSString *text = lableView.text;
    CGSize size = [text sizeWithFont:lableView.font byHeight:lableFrame.size.height];
    if (isAutoLine) {
        
    }
    else
    {
        if (maxW==0) {
            lableFrame.size.width = size.width;
        }
        else
        {
            if (size.width<maxW) {
                lableFrame.size.width = size.width;
            }
            else
            {
                lableFrame.size.width = maxW;
            }
        }
        
    }
    lableView.frame = lableFrame;
}
+(void)setHeight:(UILabel*)lableView maxHeight:(CGFloat)maxH
{
    CGRect lableFrame = lableView.frame;
    NSString *text = lableView.text;
    CGSize size = [text sizeWithFont:lableView.font byWidth:lableFrame.size.width];
    
    if (maxH==0) {
        lableFrame.size.height = size.height;
    }
    else
    {
        if (size.height<maxH) {
            lableFrame.size.height = size.height;
        }
        else
        {
            lableFrame.size.height = maxH;
        }
    }
    
    
    lableView.frame = lableFrame;
}

+(void)setYLoaction:(UIView*)viewBefore viewAfter:(UIView*)viewAfter y:(CGFloat)y
{
    CGRect viewBeforeFrame = viewBefore.frame;
    
    CGRect viewAfterFrame = viewAfter.frame;
    
    viewAfterFrame.origin.y=viewBeforeFrame.origin.y+viewBeforeFrame.size.height+y;
    viewAfter.frame = viewAfterFrame;
    
    
}

+(void)setViewYLoaction:(UIView*)view y:(CGFloat)y
{
    
    
    CGRect viewFrame = view.frame;
    
    viewFrame.origin.y=y;
    view.frame = viewFrame;
    
}

+(void)setViewXLoaction:(UIView*)view x:(CGFloat)x
{
    CGRect viewFrame = view.frame;
    viewFrame.origin.x=x;
    view.frame = viewFrame;
    
}

+(void)setViewHLoaction:(UIView*)view h:(CGFloat)h
{
    CGRect viewFrame = view.frame;
    viewFrame.size.height=h;
    view.frame = viewFrame;
    
}

+(void)setViewWLoaction:(UIView*)view W:(CGFloat)W
{
    CGRect viewFrame = view.frame;
    viewFrame.size.width=W;
    view.frame = viewFrame;
    
}
+(void)setButtonWidth:(UIButton*)buttonView maxWidth:(CGFloat)maxW isAutoLine:(BOOL)isAutoLine
          contentType:(NSString*)type viewX:(CGFloat)viewX
{
    CGRect lableFrame = buttonView.frame;
    NSString *text = buttonView.titleLabel.text;
    CGSize size = [text sizeWithFont:buttonView.titleLabel.font byHeight:lableFrame.size.height];
    if (isAutoLine) {
        
    }
    else
    {
        if (maxW==0) {
            lableFrame.size.width = size.width;
        }
        else
        {
            if (size.width<maxW) {
                lableFrame.size.width = size.width;
            }
            else
            {
                lableFrame.size.width = maxW;
            }
        }
        
        if ([type isEqualToString:@"right"]) {
            
            if (maxW+viewX-lableFrame.origin.x>size.width) {
                CGFloat x =maxW+viewX-lableFrame.origin.x-size.width;
                lableFrame.origin.x +=x ;
            }
            
        }
        if ([type isEqualToString:@"content"]) {
            
            CGFloat x =(maxW-size.width)/2;
            lableFrame.origin.x=x+viewX ;
            
        }
        if ([type isEqualToString:@"left"]) {
            
            lableFrame.origin.x=viewX ;
            
        }
        
    }
    buttonView.frame = lableFrame;
}
+(NSString*)getKeyForDic:(NSDictionary*)dic value:(NSString*)value
{
    NSString *type;
    
    for (int j = 0; j<=[[dic allKeys]count]-1; j++) {
        if ([[dic objectForKey:[[dic allKeys]objectAtIndex:j]] isEqualToString:value])
        {
            type=[[dic allKeys] objectAtIndex:j];
            break;
        }
    }
    return type;
}
+(NSString*)getKeyForDic2:(NSArray*)dic value:(NSString*)value
{
    NSString *type;
    
    for (int j = 0; j<dic.count; j++) {
        NSDictionary *typeDic = (NSDictionary *)[dic objectAtIndex:j];
        NSString *valueKey= [typeDic objectForKey:@"value"] ;
        if ([value isEqualToString:valueKey]) {
            type = [typeDic objectForKey:@"key"];
            break;
        }
    }
    return type;
}
+(NSString*)getValueForDic:(NSArray*)dic key:(NSString*)key
{
    NSString *value;
    for (int j = 0; j<dic.count; j++) {
        NSDictionary *typeDic = (NSDictionary *)[dic objectAtIndex:j];
        NSString *valueDic= [typeDic objectForKey:@"key"];
        if ([valueDic isEqualToString:key]) {
            value = [typeDic objectForKey:@"value"];
            break;
        }
    }
    return value;
}

+(void)callPhone:(NSString*)phoneNumber
{
    NSString *url = [NSString stringWithFormat:@"tel://%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}



+ (BOOL) trimming :(NSString*)number
{
    
    NSString *string = [number stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(string.length > 0)
    {
        
        return NO;
        
    }
    return YES;
}




+(void)setImageView:(UIImageView*)uiImageView imageView:(UIImage*)imageView
{
    uiImageView.contentMode = UIViewContentModeCenter;
    uiImageView.userInteractionEnabled = NO;
    [uiImageView setImage:imageView];
}


+(NSString*)dateFormatter:(NSString*)dateType date:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:dateType];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
+(void)removeData:(NSMutableArray *)datas romveString:(NSString*)romveString
{
    for (NSString *data in datas) {
        if ([data hasPrefix:romveString]) {
            [datas removeObject:data];
            break;
        }
        else
        {
            
        }
    }
}

+(NSDate*)createByString:(NSString*)dateString activityDateFormateLib:(NSString*)activityDateFormateLib
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:activityDateFormateLib];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}
+(void)shakeView:(UIView*)viewToShake repeatCount:(float)repeatCount delayTime:(float)delayTime
{
    CGFloat t =0.5;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:delayTime options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:repeatCount];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:delayTime options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
    
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate  isLow:(BOOL)isLow{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"天", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    if (isLow) {
        weekdays = [NSArray arrayWithObjects: [NSNull null], @"7", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
//+(UserInfoEntity *)createUser:(NSString*)name
//                       userId:(NSString*)userId
//                      headImg:(NSString*)headImg
//                    organNameLib:(NSString*)organNameLib
//{
//    UserInfoEntity *userInfo = [[UserInfoEntity alloc]init];
//    userInfo.headImg = headImg;
//    userInfo.userId = userId;
//    userInfo.name = name;
//    userInfo.year = @"2015";
//    SchoolEntity *school = [[SchoolEntity alloc]init];
//    OrganizationEntity *organ = [[OrganizationEntity alloc]init];
//    organ.name = organNameLib;
//    userInfo.schoolEntity = school;
//    userInfo.organizationEntity = organ;
//    return userInfo;
//}
+(UIImage*)updateSizeImage:(UIImage*)image size:(CGSize)asize
{
    
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
static void completionCallback (SystemSoundID  mySSID, void* data) {
    FLLog(@"completion Callback");
    AudioServicesRemoveSystemSoundCompletion (mySSID);
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PlayAudioMy"];
}

+(void) playSound2:(BOOL)playSound vibrate:(BOOL)vibrate
{
    FLLog(@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayAudioMy"]boolValue]);
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"PlayAudioMy"]boolValue]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PlayAudioMy"];
        static SystemSoundID shake_sound_male_id = 0;
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received1",@"caf"];
        if (path) {
            
            AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]),&shake_sound_male_id);
        }
        AudioServicesAddSystemSoundCompletion (shake_sound_male_id, NULL, NULL,
                                               completionCallback,
                                               NULL);
        if (playSound) {
            AudioServicesPlaySystemSound(shake_sound_male_id);
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PlayAudioMy"];
        }
        if(vibrate)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PlayAudioMy"];
        }
        
    }
}
+(NSInteger)showTime:(NSDate *)startTime andEndTime:(NSDate*)endTime{
    
    long dd = (long)[endTime timeIntervalSince1970] - [startTime timeIntervalSince1970];
    NSInteger timeString=0;
    
    timeString = dd;
    
    return timeString;
    
}
+(NSString*)nilURL:(NSString*)url
{
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}
+(BOOL)isPublic:(NSString*)type key:(NSString*)key
{
    NSArray *urls = [type componentsSeparatedByString:@","];
    BOOL keyBool=false;
    for (int i=0; i<urls.count; i++) {
        NSString *spaiderKey = [urls objectAtIndex:i];
        if ([spaiderKey isEqualToString:key]) {
            keyBool = YES;
            break;
        }
    }
    return keyBool;
}



+(void)stretchableeView:(id)view withImage:(UIImage*)image{
    
    if ([view isKindOfClass:[UIButton class]]) {
        [((UIButton*)view) setBackgroundImage:[image stretchableImageWithLeftCapWidth:image.size.width topCapHeight:image.size.height] forState:UIControlStateNormal ];
        
    }
    else if([view isKindOfClass:[UIImageView class]]){
        
        [((UIImageView*)view ) setImage:[image stretchableImageWithLeftCapWidth:image.size.width topCapHeight:image.size.height]];
    }
    
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


#define USER_APP_PATH                 @"/User/Applications/"
+ (BOOL)isJailBreak
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        FLLog(@"The device is jail broken!");
        return YES;
    }
    FLLog(@"The device is NOT jail broken!");
    return NO;
}


+(NSString*)removeLastChara:(NSString*)str{

    if ([UitlCommon isNull:str]) {
        return @"";
    }
    
  return  [str stringByReplacingCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
    
}
+(NSMutableAttributedString*)setString:(NSString*)str keyString:(NSString*)keyStr color:(UIColor*)keyColor otherColor:(UIColor*)color{

    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:keyStr options:NSRegularExpressionCaseInsensitive error:&error ];
    
    NSArray* matches = [regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:str attributes:nil ];
    
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [str length])];
    
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [match range];
        [string addAttribute:NSForegroundColorAttributeName value:keyColor range:matchRange];
    }
    
    return string;
}

+(NSMutableAttributedString*)setString:(NSString*)str keyString:(NSString*)keyStr keyColor:(UIColor*)keyColor otherColor:(UIColor*)color keyFont:(UIFont*)keyFont otherFont:(UIFont*)font
{
    
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:keyStr options:NSRegularExpressionCaseInsensitive error:&error ];
    
    NSArray* matches = [regex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:str attributes:nil ];
    
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [str length])];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length])];
    
    
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [match range];
        [string addAttribute:NSForegroundColorAttributeName value:keyColor range:matchRange];
        [string addAttribute:NSFontAttributeName value:keyFont range:matchRange];
    }
    
    return string;
}

+ (NSString*)transferLevel:(NSString*)level{
    
    switch ([level intValue]) {
        case 0:
            return @"所有";
            break;
        case 1:
            return @"小白";
            break;
        case 2:
            return @"新秀";
            break;
        case 3:
            return @"学霸";
            break;
        case 4:
            return @"土豪";
            break;
        case 5:
            return @"掌门";
            break;
        case 6:
            return @"盟主";
            break;
        case 7:
            return @"诸侯";
            break;
        case 8:
            return @"公爵";
            break;
        case 9:
            return @"一星公爵";
            break;
        case 10:
            return @"二星公爵";
            break;
        case 11:
            return @"三星公爵";
            break;
        case 12:
            return @"四星公爵";
            break;
        case 13:
            return @"五星公爵";
            break;
        default:
            break;
    }
    return @"";
}

+(BOOL)judageTextIsVaild:(NSString*)str newText:(NSString*)str1{

    if ([str1 isEqualToString:@""]) {
        if (!str || [str isEqualToString:@""]) {
            return NO;
        }
        else{
            NSMutableString *newStr = [NSMutableString stringWithString:str];
            [newStr replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
            if ([UitlCommon isNull:newStr]) {
                return NO;
            }
            else return YES;
        }
    }
    return YES;
}
+(NSString*)getCurrentTextFiledText:(NSString*)str newText:(NSString*)str1{

    NSMutableString *newStr = [NSMutableString stringWithString:str];
    if ([str1 isEqualToString:@""]) {
        
        if ([UitlCommon isNull:str]) {
            return newStr;
        }
        else {
            [newStr replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
            return newStr;
        }
        
    }
    else{
    
        [newStr appendString:str1];
    }
    
    return newStr;
    
}
+(BOOL)checkMoneyVaild:(NSString*)str{

    NSArray *array = [str componentsSeparatedByString:@"."];
    if (array.count>2) {
        return NO;
    }
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (NSInteger i = str.length-1; i>=0; i--) {
        
        if ([str characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}

+(BOOL)checkPerPacktMoney:(NSString*)allMony count:(NSString*)count{

    float perMoney = [allMony doubleValue]/[count intValue];
    
    if (perMoney<0.00999999977) {
        return NO;
    }
    return YES;
}


+(BOOL)isVaildePhoneNum:(NSString*)phoneNum{

    NSString *mobileRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    
    BOOL n = [mobileTest evaluateWithObject:phoneNum];
    
    return n;
}

+(BOOL)isVaildeLandlineNum:(NSString*)landlineNum{

    NSString *mobileRegex = @"^([0-9]{3,4})[0-9]{7,8}$";
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    
    BOOL n = [mobileTest evaluateWithObject:landlineNum];
    
    return n;
}

+(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

@end





