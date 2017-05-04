//
//  SearchHistory+CoreDataProperties.m
//  XWLife
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SearchHistory+CoreDataProperties.h"

@implementation SearchHistory (CoreDataProperties)

+ (NSFetchRequest<SearchHistory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SearchHistory"];
}

@dynamic search_text;
@dynamic search_time;

@end
