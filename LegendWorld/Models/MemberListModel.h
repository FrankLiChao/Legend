//
//  MemberListModel.h
//  LegendWorld
//
//  Created by Frank on 2016/11/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberListModel : NSObject

@property (nonatomic, strong)NSString *user_id;
@property (nonatomic, strong)NSString *photo_url;
@property (nonatomic, strong)NSString *user_name;
@property (nonatomic, strong)NSString *telephone;

+ (NSArray <MemberListModel *> *)parseResponse:(id)response;

+ (NSArray <MemberListModel *> *)parseNoBuyResponse:(id)response;
@end
