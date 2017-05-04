//
//  SearchGoodsViewController.h
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@class SearchGoodsViewController;
@protocol SearchGoodsResultDelegate <NSObject>

- (void)searchGoodsViewController:(SearchGoodsViewController *)search didSearchText:(NSString *)text;

@end


@interface SearchGoodsViewController : BaseViewController

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, weak) id delegate;

@end
