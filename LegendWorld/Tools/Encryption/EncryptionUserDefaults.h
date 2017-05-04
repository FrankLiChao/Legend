//
//  EncryptionUserDefaults.h
//  CoolKeyboard
//
//  Created by MEET on 14-3-25.
//  Copyright (c) 2014年 振中 茹. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ASE_ENCRYPTION_STRING       @"motoalarm_ase"

@interface EncryptionUserDefaults : NSObject {
    
}

+ (EncryptionUserDefaults *)standardUserDefaults;

- (void)synchronize;

- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString*)key;

- (BOOL)boolForKey:(NSString*)key;
- (id)objectForKey:(NSString*)key;
- (float)floatForKey:(NSString*)key;
- (NSInteger)integerForKey:(NSString*)key;
- (double)doubleForKey:(NSString*)key;

- (NSString *)getMd5_32Bit_String:(NSString *)srcString;
@end
