//
//  UserFixInforViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/9/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChangeUserInforDelegate <NSObject>

-(void)changeUserInforProAct:(NSString *)changeStr andWhichTF:(NSString *)whichTF;

@end



@interface UserFixInforViewController : BaseViewController
@property(nonatomic,retain)NSString *whichToFixStr;
@property(nonatomic,weak)id<ChangeUserInforDelegate>delegate;
@end
