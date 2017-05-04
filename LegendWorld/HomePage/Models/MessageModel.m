//
//  MessageModel.m
//  LegendWorld
//
//  Created by wenrong on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"notice_list" : [NoticeListModel class],
             };
}
@end
@implementation NoticeListModel

@end
