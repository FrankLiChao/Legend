//
//  HelpAndFeedbackModel.m
//  LegendWorld
//
//  Created by wenrong on 16/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HelpAndFeedbackModel.h"

@implementation HelpAndFeedbackModel

@end

@implementation HelpAndFeedbackModel (NetworkParser)

+(NSArray<HelpAndFeedbackModel *> *)parseResponse:(id)response
{
    NSArray *arr = [HelpAndFeedbackModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"help_list"]];
    return arr;
}

@end
