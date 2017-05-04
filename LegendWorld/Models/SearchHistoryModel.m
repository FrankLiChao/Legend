//
//  SearchHistoryModel.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SearchHistoryModel.h"

@implementation SearchHistoryModel

- (instancetype)initWithSearchText:(NSString *)searchText {
    self = [super init];
    if (self) {
        self.search_text = searchText;
        self.search_time = [NSDate date];
    }
    return self;
}

@end

static NSString *const entityName = @"SearchHistory";
@implementation SearchHistoryModel (CoreData)

- (instancetype)initWithEntity:(SearchHistory *)searchHistory {
    self = [super init];
    if (self) {
        self.search_text = searchHistory.search_text;
        self.search_time = searchHistory.search_time;
    }
    return self;
}

#pragma mark - 查询
+ (NSArray<SearchHistoryModel *> *)fetchAll {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[CoreDataManager shareManager].context];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"search_time" ascending:NO]];
    
    NSError *error = nil;
    NSArray *result = [[CoreDataManager shareManager].context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        return nil;
    }
    return [result copy];
}

+ (NSArray *)fetch:(SearchHistoryModel *)searchHistoryModel {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[CoreDataManager shareManager].context];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"search_time" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"search_text = %@", searchHistoryModel.search_text];
    
    NSError *error = nil;
    NSArray *result = [[CoreDataManager shareManager].context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        return nil;
    }
    return [result copy];
}

#pragma mark - 新增
+ (BOOL)insert:(SearchHistoryModel *)searchHistoryModel {
    SearchHistory *entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[CoreDataManager shareManager].context];
    entity.search_text = searchHistoryModel.search_text;
    entity.search_time = searchHistoryModel.search_time;
    
    NSError *error = nil;
    BOOL success = [[CoreDataManager shareManager].context save:&error];
    if (!success || error) {
        [NSException raise:@"新增错误" format:@"%@", [error localizedDescription]];
        return NO;
    }
    return success;
}

#pragma mark - 删除
+ (BOOL)deleteAll {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[CoreDataManager shareManager].context];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"search_time" ascending:NO]];
    
    NSError *error = nil;
    NSArray *result = [[CoreDataManager shareManager].context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        return NO;
    }
    
    for (SearchHistory *searchHistory in result) {
        [[CoreDataManager shareManager].context deleteObject:searchHistory];
    }
    
    BOOL success = [[CoreDataManager shareManager].context save:&error];
    if (!success || error) {
        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
        return NO;
    }
    return success;
}

+ (BOOL)delete:(SearchHistoryModel *)searchHistoryModel {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[CoreDataManager shareManager].context];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"search_time" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"search_text = %@", searchHistoryModel.search_text];
    
    NSError *error = nil;
    NSArray *result = [[CoreDataManager shareManager].context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        return NO;
    }
    
    for (SearchHistory *searchHistory in result) {
        [[CoreDataManager shareManager].context deleteObject:searchHistory];
    }
    
    BOOL success = [[CoreDataManager shareManager].context save:&error];
    if (!success || error) {
        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
        return NO;
    }
    return success;
}

#pragma mark - 修改
+ (BOOL)update:(SearchHistoryModel *)oldSearchHistoryModel withNew:(SearchHistoryModel *)newSearchHistoryModel {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[CoreDataManager shareManager].context];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"search_time" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"search_text = %@", oldSearchHistoryModel.search_text];
    
    NSError *error = nil;
    NSArray *result = [[CoreDataManager shareManager].context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        return NO;
    }
    
    for (SearchHistory *searchHistory in result) {
        searchHistory.search_text = newSearchHistoryModel.search_text;
        searchHistory.search_time = newSearchHistoryModel.search_time;
    }
    
    BOOL success = [[CoreDataManager shareManager].context save:&error];
    if (!success || error) {
        [NSException raise:@"修改错误" format:@"%@", [error localizedDescription]];
        return NO;
    }
    return success;
}

@end
