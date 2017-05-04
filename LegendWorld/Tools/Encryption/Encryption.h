//
//  Encryption.h
//  PathIntro
//
//  Created by MEET on 14-3-25.
//  Copyright (c) 2014年 Dmitry Kondratyev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
