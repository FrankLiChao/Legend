//
//  LoginUserManager.m
//  LegendWorld
//
//  Created by Tsz on 2016/12/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "LoginUserManager.h"

@interface LoginUserManager ()

@property (nonatomic) BOOL isLogin;
@property (nonatomic, strong) UserModel *loginUser;
@property (nonatomic, strong) NSString *token;
@property (nonatomic) BOOL haveSetPayPassword;

@end

@implementation LoginUserManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal];
        if (userDic) {
            self.isLogin = YES;
            self.loginUser = [UserModel mj_objectWithKeyValues:userDic];
            self.token = [[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile];
            self.haveSetPayPassword = [[NSUserDefaults standardUserDefaults] boolForKey:havePayPassword];
        }
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static LoginUserManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[LoginUserManager alloc] init];
    });
    return manager;
}


- (void)updateLoginUser:(NSDictionary *)userDic {
    if (userDic) {
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"user_info"] forKey:userLoginDataToLocal];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"access_token"] forKey:saveLocalTokenFile];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *isPayPassworld = [NSString stringWithFormat:@"%@",[[userDic objectForKey:@"user_info"] objectForKey:@"payment_pwd"]];
        [[NSUserDefaults standardUserDefaults] setBool:[isPayPassworld boolValue] forKey:havePayPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.isLogin = YES;
        self.loginUser = [UserModel mj_objectWithKeyValues:[userDic objectForKey:@"user_info"]];
        self.token = [userDic objectForKey:@"access_token"];
        self.haveSetPayPassword = [isPayPassworld boolValue];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:userLoginDataToLocal];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:saveLocalTokenFile];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:havePayPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.isLogin = NO;
        self.loginUser = nil;
        self.token = nil;
        self.haveSetPayPassword = NO;
    }
}

@end
