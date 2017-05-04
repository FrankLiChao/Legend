//
//  LogisticsModel.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/17.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "LogisticsModel.h"

@implementation LogisticsModel

+ (LogisticsModel *)parseByLogisticsDic:(NSDictionary *)dic {
    LogisticsModel *model = [[LogisticsModel alloc] init];
    model.companyName = [dic objectForKey:@"name"];
    model.type = [dic objectForKey:@"type"];
    model.telephone = [dic objectForKey:@"tel"];
    return model;
}

@end

@implementation LogisticsProcessModel

+ (LogisticsProcessModel *)parseByLogisticsProcessDic:(NSDictionary *)dic {
    LogisticsProcessModel *process = [[LogisticsProcessModel alloc] init];
    process.statusDesc = [dic objectForKey:@"status"];
    process.time = [dic objectForKey:@"time"];
    return process;
}

@end
