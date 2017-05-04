//
//  SearchHistoryModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchHistory+CoreDataClass.h"

@interface SearchHistoryModel : NSObject

@property (nonatomic, strong) NSString *search_text;
@property (nonatomic, strong) NSDate *search_time;

- (instancetype)initWithSearchText:(NSString *)searchText;


@end


@interface SearchHistoryModel (CoreData)

- (instancetype)initWithEntity:(SearchHistory *)searchHistory;

+ (NSArray<SearchHistoryModel *> *)fetchAll;
+ (NSArray<SearchHistoryModel *> *)fetch:(SearchHistoryModel *)searchHistoryModel;
+ (BOOL)insert:(SearchHistoryModel *)searchHistoryModel;
+ (BOOL)delete:(SearchHistoryModel *)searchHistoryModel;
+ (BOOL)deleteAll;
+ (BOOL)update:(SearchHistoryModel *)oldSearchHistoryModel withNew:(SearchHistoryModel *)newSearchHistoryModel;

@end

