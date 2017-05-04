//
//  VIPGreadeModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPGreadeModel : NSObject

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *user_name;
@property (nonatomic, strong)NSString *telephone;
@property (nonatomic, strong)NSString *grade;
@property (nonatomic, strong)NSString *grade_name;
@property (nonatomic, strong)NSString *photo_url;
@property (nonatomic, strong)NSString *target_number;
@property (nonatomic, strong)NSString *upgrade_desc;
@property (nonatomic, strong)NSString *complete_num;
@property (nonatomic, strong)NSString *vip_grade_rule;

+ (VIPGreadeModel *)parseVIPGreadeResponse:(id)response;

@end
