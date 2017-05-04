//
//  HomePageModel.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HomePageModel.h"

@implementation BannerGoodsModel
@end

@implementation GoodsListModel
@end

@implementation HomePageModel


+ (NSDictionary *)objectClassInArray
{
    return @{
             @"banner_goods_list" : [BannerGoodsModel class],
             @"guess_like_goods_list" : [GoodsListModel class]
             };
}

@end
