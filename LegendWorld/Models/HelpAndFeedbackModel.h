//
//  HelpAndFeedbackModel.h
//  LegendWorld
//
//  Created by wenrong on 16/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpAndFeedbackModel : NSObject
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *help_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;
@end

@interface HelpAndFeedbackModel (NetworkParser)
+ (NSArray<HelpAndFeedbackModel *> *)parseResponse:(id)response;
@end
