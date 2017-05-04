//
//  CommodityListViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@interface CommodityListViewController : BaseViewController

@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic) NSString *sellerId;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic) BOOL ifFromSearchView;
@property (nonatomic) BOOL ifFromSellerView;
@property (nonatomic) BOOL ifFromShoppingMallView;
@end
