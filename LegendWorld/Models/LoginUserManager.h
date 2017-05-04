//
//  LoginUserManager.h
//  LegendWorld
//
//  Created by Tsz on 2016/12/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUserManager : NSObject

@property (nonatomic, readonly) BOOL isLogin;
@property (nonatomic, strong, readonly) UserModel *loginUser;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, readonly) BOOL haveSetPayPassword;

+ (instancetype)sharedManager;

- (void)updateLoginUser:(NSDictionary *)userDic;

@end
