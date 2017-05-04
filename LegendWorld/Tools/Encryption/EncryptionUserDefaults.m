//
//  EncryptionUserDefaults.m
//  CoolKeyboard
//
//  Created by MEET on 14-3-25.
//  Copyright (c) 2014年 振中 茹. All rights reserved.
//

#import "EncryptionUserDefaults.h"
#import "Encryption.h"
#import <CommonCrypto/CommonDigest.h>
#import "SBJsonParser.h"
#import "SBJsonWriter.h"

@implementation EncryptionUserDefaults
static EncryptionUserDefaults *_standardUserDefaults = nil;

+ (EncryptionUserDefaults *)standardUserDefaults {
    
    if (_standardUserDefaults == nil) {
        _standardUserDefaults = [[EncryptionUserDefaults alloc] init];
    }
    
    return _standardUserDefaults;
}

#pragma mark - 加密&解密
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

- (NSData*)encryptionASEWithValue:(NSString*)value {
    NSString *key = ASE_ENCRYPTION_STRING;
    
    NSData *plain = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cipher = [plain AES256EncryptWithKey:key];
    
    return cipher;
}

- (NSString*)decipheringASEWithData:(NSData*)data {
    NSString *key = ASE_ENCRYPTION_STRING;
    
    NSData *plain = [data AES256DecryptWithKey:key];
    NSString *value = [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding];
    
    return value;
}

#pragma mark - 存储&读取
- (void)synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    key = [self getMd5_32Bit_String:key];
    
    NSString *value_st = [NSString stringWithFormat:@"%d",value];
    NSData *value_data = [self encryptionASEWithValue:value_st];
    
    [[NSUserDefaults standardUserDefaults] setObject:value_data forKey:key];
}

- (void)setObject:(id)value forKey:(NSString *)key {
    key = [self getMd5_32Bit_String:key];
    
    NSString *value_st = value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *key_type = [self getMd5_32Bit_String:[NSString stringWithFormat:@"%@_isString",key]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key_type];
    }
    else {
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        value_st = [writer stringWithObject:value_st];
    }
    
    NSData *value_data = [self encryptionASEWithValue:value_st];
    
    [[NSUserDefaults standardUserDefaults] setObject:value_data forKey:key];
}


- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    key = [self getMd5_32Bit_String:key];
    
    NSString *value_st = [NSString stringWithFormat:@"%ld",(long)value];
    NSData *value_data = [self encryptionASEWithValue:value_st];
    
    [[NSUserDefaults standardUserDefaults] setObject:value_data forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    key = [self getMd5_32Bit_String:key];
    
    NSString *value_st = [NSString stringWithFormat:@"%f",value];
    NSData *value_data = [self encryptionASEWithValue:value_st];
    
    [[NSUserDefaults standardUserDefaults] setObject:value_data forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    key = [self getMd5_32Bit_String:key];
    
    NSString *value_st = [NSString stringWithFormat:@"%f",value];
    NSData *value_data = [self encryptionASEWithValue:value_st];
    
    [[NSUserDefaults standardUserDefaults] setObject:value_data forKey:key];
}

-(void)removeObjectForKey:(NSString*)key{

    key = [self getMd5_32Bit_String:key];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (BOOL)boolForKey:(NSString*)key {
    key = [self getMd5_32Bit_String:key];
    
    NSData *value_data = (NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *value_st = [self decipheringASEWithData:value_data];
    
    if (!value_st || [value_st isEqualToString:@""]) {
        return NO;
    }
    
    return value_st.boolValue;
}

- (id)objectForKey:(NSString*)key {
    key = [self getMd5_32Bit_String:key];
    
    NSData *value_data = (NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *value_st = [self decipheringASEWithData:value_data];
    
    NSString *key_type = [self getMd5_32Bit_String:[NSString stringWithFormat:@"%@_isString",key]];
    BOOL isString = [[NSUserDefaults standardUserDefaults] boolForKey:key_type];
    if (isString) {
        return value_st;
    }
    else {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        id object = [parser objectWithString:value_st];
        return object;
    }
}

- (float)floatForKey:(NSString*)key {
    key = [self getMd5_32Bit_String:key];
    
    NSData *value_data = (NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *value_st = [self decipheringASEWithData:value_data];
    
    if (!value_st || [value_st isEqualToString:@""]) {
        return 0;
    }
    
    return value_st.floatValue;
}

- (NSInteger)integerForKey:(NSString*)key {
    key = [self getMd5_32Bit_String:key];
    
    NSData *value_data = (NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *value_st = [self decipheringASEWithData:value_data];
    
    if (!value_st || [value_st isEqualToString:@""]) {
        return 0;
    }
    
    return value_st.integerValue;
}

- (double)doubleForKey:(NSString*)key {
    key = [self getMd5_32Bit_String:key];
    
    NSData *value_data = (NSData*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *value_st = [self decipheringASEWithData:value_data];
    
    if (!value_st || [value_st isEqualToString:@""]) {
        return 0;
    }
    
    return value_st.doubleValue;
}

@end
