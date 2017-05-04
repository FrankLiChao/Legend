//
//  JSONParser.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+ (NSString *)parseToStringWithArray:(NSArray *)array;
+ (NSArray *)parseToArrayWithString:(NSString *)string;

+ (NSString *)parseToStringWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)parseToDictionaryWithString:(NSString *)string;

+ (id)parseJSONObjectWithData:(NSData *)data;
+ (id)parseJSONObjectWithString:(NSString *)string;

@end
