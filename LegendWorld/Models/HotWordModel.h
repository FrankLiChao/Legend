//
//  HotWordModel.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotWordModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger num;

@end

@interface HotWordModel (NetworkParser)

+ (NSArray<HotWordModel *> *)parseResponse:(id)response;

@end
