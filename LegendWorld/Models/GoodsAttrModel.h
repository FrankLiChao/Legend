//
//  GoodsAttrModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsAttrModel : NSObject

@property (nonatomic) NSInteger attr_id;
@property (nonatomic, strong) NSString *attr_name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic) NSInteger goods_number;

@end
