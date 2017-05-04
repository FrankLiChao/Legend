//
//  AfterSaleModel.h
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterSaleListModel : NSObject
@property (nonatomic, retain) NSString *after_id;
@property (nonatomic, retain) NSString *after_num;
@property (nonatomic, retain) NSString *after_status;
@property (nonatomic, retain) NSString *after_type;
@property (nonatomic, retain) NSString *apply_time;
@property (nonatomic, retain) NSString *goods_id;
@property (nonatomic, retain) NSString *goods_name;
@property (nonatomic, retain) NSString *goods_sn;
@property (nonatomic, retain) NSArray *goods_thumb;
@property (nonatomic, retain) NSString *modifi_time;
@property (nonatomic, retain) NSString *order_id;
@property (nonatomic, retain) NSString *seller_id;
@end

@interface AfterSaleModel : NSObject

@property (nonatomic, retain) NSArray<AfterSaleListModel*> *listArr;
@end

