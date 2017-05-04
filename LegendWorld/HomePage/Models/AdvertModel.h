//
//  AdvertModel.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdBaseModel : NSObject

@property(nonatomic, strong)NSString *ad_id;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, assign)NSInteger ad_type;
@property(nonatomic, strong)NSString *thumb;
@property(nonatomic, strong)NSString *desc;
@property(nonatomic, strong)NSString *cost;
@property(nonatomic, strong)NSString *income;
@property(nonatomic, strong)NSString *view_times;
@property(nonatomic, strong)NSString *finish_times;
@end
@interface AdvertModel : AdBaseModel
// imcome
@property(nonatomic, strong)NSString *shop_name;

+(void)loadDataWithAdList: (NSInteger) page
                       success:(void (^)(NSArray *adList)) adList
                        failed:(void (^) (NSDictionary *errorDic)) erorrInfo;
+(void)loadDataWithCollectionAdList: (NSInteger) page
                            success:(void (^)(NSArray *adList)) CollectionadList
                             failed:(void (^) (NSDictionary *errorDic)) erorrInfo;
@end

@interface MyAdvertModel : AdBaseModel
+(void)loadDataWithMyAdList: (NSInteger) page
                       success:(void (^)(NSArray *adList)) adList
                        failed:(void (^) (NSDictionary *errorDic)) erorrInfo;

@end
@interface ADPicContentModel : NSObject
@property (nonatomic,strong)NSString *pic_link;
@property (nonatomic,strong)NSString *pic_url;
@end

// 广告详情model
@interface AdDetailInfoModel : NSObject
@property (nonatomic,strong)NSString *ad_id;
@property (nonatomic,strong)NSString *ad_type;
@property (nonatomic,strong)NSString *ad_status;
@property (nonatomic,strong)NSString *ad_title;
@property (nonatomic,strong)NSString *budget;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *number;
@property (nonatomic,strong)NSString *intro;
@property (nonatomic,strong)NSString *link;
@property (nonatomic,strong)NSString *finish_percent;
@property (nonatomic,strong)NSString *recommend;
@property (nonatomic,strong)NSString *share_link;
@property (nonatomic,strong)NSString *share_img;
@property (nonatomic,strong)NSString *limit_grade;
@property (nonatomic,strong)NSString *is_collect;
@property (nonatomic,strong)NSString *extra_desc;
@property (nonatomic,strong)NSString *extra_img;
@property (nonatomic,strong)NSString *extra_url;
@property (nonatomic,strong)NSNumber *force_read;
@property (nonatomic,strong)NSString *question;
@property (nonatomic,strong)NSNumber *question_id;
@property (nonatomic,strong)NSNumber *web_view;
@property (nonatomic,strong)NSNumber *is_read;
@property (nonatomic,strong)NSString *shop_url;
@property (nonatomic,strong)NSNumber *is_seller;//如果是1跳转到商品详情
@property (nonatomic,strong)NSString *goods_id;


@property (nonatomic,strong) NSArray<ADPicContentModel*> *content;
@property (nonatomic,strong) NSArray *question_option;
+(void)loadDataWithAdDetail: (AdvertModel *) aAd
                    success:(void (^)(AdDetailInfoModel *adDetailModel)) adDetailInfo
                     failed:(void (^) (NSDictionary *errorDic)) erorrInfo;
@end
