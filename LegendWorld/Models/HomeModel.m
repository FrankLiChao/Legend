//
//  HomeModel.m
//  LegendWorld
//
//  Created by Frank on 2016/11/3.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HomeModel.h"
#import "MJExtension.h"

@implementation HomeModel

+(void)loadDataWithHomePage: (NSDictionary *) parameter
                    success:(void (^)(HomeModel *)) homeModel
                     failed:(void (^) (NSDictionary *errorDic)) errorInfo{
    [MainRequest RequestHTTPData:PATHShop(@"api/Goods/getHomeInfo") parameters:parameter success:^(id responseData) {
        FLLog(@"%@",responseData);
        HomeModel *returnModel = [HomeModel mj_objectWithKeyValues:responseData];
        returnModel.banner_goods_list = [BannerModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"banner_goods_list"]];
        returnModel.goods_category_list = [responseData objectForKey:@"goods_category_list"];
        returnModel.goods_recommend_list = [GoodsRecommendModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"goods_recommend_list"]];
        homeModel(returnModel);
    } failed:^(NSDictionary *errorDic) {
        errorInfo(errorDic);
    }];
}

@end

@implementation BannerModel

@end

@implementation GoodsCategoryModel

@end

@implementation GoodsRecommendModel

@end
