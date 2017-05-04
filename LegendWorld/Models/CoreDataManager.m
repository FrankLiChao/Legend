//
//  CoreDataManager.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager()


@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;

@end


static NSString *const DataBase = @"LegendWorld";

@implementation CoreDataManager


+ (instancetype)shareManager {
    static dispatch_once_t once;
    static CoreDataManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[CoreDataManager alloc] init];
    });
    return manager;
}


- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = self.coordinator;
    }
    return _context;
}

- (NSManagedObjectModel *)model {
    if (!_model) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _model;
}

- (NSPersistentStoreCoordinator *)coordinator {
    if (!_coordinator) {
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[docPath stringByAppendingPathComponent:DataBase]];
        NSError *error = nil;
        NSPersistentStore *store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        if (store == nil) {
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
            return nil;
        }
    }
    return _coordinator;
}

@end
