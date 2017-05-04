//
//  JSONParser.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+ (NSString *)parseToStringWithArray:(NSArray *)array {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (data && error == nil) {
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return resultString;
    }
    return @"";
}

+ (NSArray *)parseToArrayWithString:(NSString *)string {
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (array && error == nil && [array isKindOfClass:[NSArray class]]) {
        return (NSArray *)array;
    }
    return [[NSArray alloc] init];
}

+ (NSString *)parseToStringWithDictionary:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (data && error == nil) {
        NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return resultString;
    }
    return @"";
}

+ (NSDictionary *)parseToDictionaryWithString:(NSString *)string {
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary && error == nil && [dictionary isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)dictionary;
    }
    return [[NSDictionary alloc] init];
}

+ (id)parseJSONObjectWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (json && error == nil) {
        return json;
    }
    return nil;
}

+ (id)parseJSONObjectWithString:(NSString *)string {
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (json && error == nil) {
        return json;
    }
    return nil;
}

@end
