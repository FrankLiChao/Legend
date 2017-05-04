//
//  CoreDataManager.h
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

+ (instancetype)shareManager;

@end
