//
//  NSString+Formatter.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "NSString+Formatter.h"

@implementation NSString (Formatter)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
