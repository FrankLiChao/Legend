//
//  SearchHistory+CoreDataProperties.h
//  XWLife
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SearchHistory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchHistory (CoreDataProperties)

+ (NSFetchRequest<SearchHistory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *search_text;
@property (nullable, nonatomic, copy) NSDate *search_time;

@end

NS_ASSUME_NONNULL_END
