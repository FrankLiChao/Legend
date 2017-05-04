//
//  ApplyRecordModel.h
//  LegendWorld
//
//  Created by Frank on 2016/12/29.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyRecordModel : NSObject

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *goods_id;
@property (nonatomic, strong)NSString *goods_name;
@property (nonatomic, strong)NSString *goods_thumb;
@property (nonatomic, strong)NSString *number;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *create_time;
@property (nonatomic, strong)NSString *create_date;
@property (nonatomic, strong)NSString *create_month;

+ (NSArray <ApplyRecordModel *> *)parseResponse:(NSArray *)arrayData;

@end
