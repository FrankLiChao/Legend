//
//  ShoppingMallModel.h
//  LegendWorld
//
//  Created by wenrong on 16/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainRequest.h"
@interface CategoryModel: NSObject
@property (nonatomic, strong) NSString *cat_id;
@property (nonatomic, strong) NSString *cat_name;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *category_img;
@property (nonatomic, strong) NSString *sell_count;

+(void)loadDataWithOrderDetail: (NSInteger) category_id
                       success:(void (^)(NSMutableArray *shoppingMallArrs)) shoppingMallList
                        failed:(void (^) (NSDictionary *errorDic)) errorInfo;




@end


@interface CategoryModel (NetworkParser)

+ (NSArray<CategoryModel *> *)parseResponse:(id)response;

@end
