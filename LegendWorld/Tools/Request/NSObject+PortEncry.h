//
//  NSObjec+PortEncry.h
//  legend_business_ios
//
//  Created by heyk on 16/2/26.
//  Copyright © 2016年 heyk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(PortEncry)

- (NSString*)getDeviceUUID;
- (NSString*)getTokenString:(NSString*)access_token;

////shal 加密
- (NSString *)getSha1String:(NSString *)srcString;

////des 加密
- (NSMutableDictionary*)createRequsetData:(NSDictionary*)postDic;

- (NSArray*)getSignArray:(NSDictionary*)postDic;

- (NSString*)getSign:(NSArray*)array;
- (NSString *)URLEncodedString: (NSString *)param;
- (NSString*)getJSONStr:(NSDictionary*)dict;

////des 解密
- (NSMutableDictionary *)decodeRequstData:(NSDictionary*)dic;
- (NSString*)decodeData:(NSString*)str;
@end
