//
//  AdvertModel.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AdvertModel.h"
#import "MainRequest.h"

@implementation AdBaseModel


@end
@implementation AdvertModel

+(void)loadDataWithAdList: (NSInteger) page
                       success:(void (^)(NSArray *adList)) adList
                        failed:(void (^) (NSDictionary *errorDic)) erorrInfo {
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:[FrankTools getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[FrankTools getUserToken] forKey:@"token"];
    [postDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [MainRequest RequestHTTPData:PATH(@"/api/ad/getAdList") parameters:postDic success:^(id response) {
        NSDictionary *dic = response;
        NSArray *list = [AdvertModel mj_objectArrayWithKeyValuesArray:dic[@"ad_list"]];
        if (adList) {
            adList(list);
        }
    } failed:^(NSDictionary *errorDic) {
        erorrInfo(errorDic);
    }];
}
+(void)loadDataWithCollectionAdList: (NSInteger) page
                  success:(void (^)(NSArray *adList)) CollectionadList
                   failed:(void (^) (NSDictionary *errorDic)) erorrInfo {
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:[FrankTools getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[FrankTools getUserToken] forKey:@"token"];
    [postDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [MainRequest RequestHTTPData:PATH(@"/api/ad/adCollectList") parameters:postDic success:^(id response) {
        NSDictionary *dic = response;
        NSArray *list = [AdvertModel mj_objectArrayWithKeyValuesArray:dic[@"collect_list"]];
        if (CollectionadList) {
            CollectionadList(list);
        }
        FLLog(@"广告详情数据%@",list);
    } failed:^(NSDictionary *errorDic) {
        erorrInfo(errorDic);
    }];
}

@end

@implementation ADPicContentModel
@end

@implementation MyAdvertModel

+(void)loadDataWithMyAdList: (NSInteger) page
                       success:(void (^)(NSArray *adList)) myAdList
                        failed:(void (^) (NSDictionary *errorDic)) erorrInfo {
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:[FrankTools getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[FrankTools getUserToken] forKey:@"token"];
    [postDic setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [MainRequest RequestHTTPData:PATH(@"/api/ad/getMyAd") parameters:postDic success:^(id response) {
        NSDictionary *dic = response;
        NSArray *list = [AdBaseModel mj_objectArrayWithKeyValuesArray:dic[@"ad_list"]];
        if (myAdList) {
            myAdList(list);
        }
        FLLog(@"广告详情数据%@",list);
    } failed:^(NSDictionary *errorDic) {
        erorrInfo(errorDic);
    }];
}

@end

@implementation AdDetailInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content": [ADPicContentModel class]};
}
+(void)loadDataWithAdDetail: (AdvertModel *) aAd
                    success:(void (^)(AdDetailInfoModel *adDetailModel)) adDetailInfo
                     failed:(void (^) (NSDictionary *errorDic)) erorrInfo {
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:[FrankTools getDeviceUUID] forKey:@"device_id"];
    [postDic setObject:[FrankTools getUserToken] forKey:@"token"];
    [postDic setObject:aAd.ad_id forKey:@"ad_id"];
    [postDic setObject:@(aAd.ad_type) forKey:@"ad_type"];
    [MainRequest RequestHTTPData:PATH(@"/api/ad/getAdInfo") parameters:postDic success:^(id response) {
        NSDictionary *dic = response;
        AdDetailInfoModel *model = [AdDetailInfoModel mj_objectWithKeyValues:dic[@"ad_info"]];
        if (adDetailInfo) {
            adDetailInfo(model);
        }
    } failed:^(NSDictionary *errorDic) {
        erorrInfo(errorDic);
    }];
}


@end




