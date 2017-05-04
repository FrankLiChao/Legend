//
//  RecieveAddressModel.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecieveAddressModel : NSObject

@property (nonatomic,strong)NSString *address_id;
@property (nonatomic,strong)NSString *consignee;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *street;
@property (nonatomic,strong)NSString *area_id;
@property (nonatomic,strong)NSString *area;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,assign)NSString *is_default;


@property (nonatomic,strong)NSString *provice;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *distrct;


@property (nonatomic,strong)NSNumber *lng;
@property (nonatomic,strong)NSNumber *lat;

@end


@interface RecieveAddressModel (NetworkParser)

+ (RecieveAddressModel *)parseResponse:(id)response;

+ (NSArray <RecieveAddressModel *> *)parseArrayResponse:(id)response;

@end
