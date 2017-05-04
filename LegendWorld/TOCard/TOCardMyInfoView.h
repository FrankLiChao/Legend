//
//  TOCardMyInfoView.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOCardMyInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *members;
@property (weak, nonatomic) IBOutlet UIButton *buyCardBtn;//立即购卡
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendsBtn;//邀请好友
@property (weak, nonatomic) IBOutlet UIButton *seeMyBenifitBtn;//pos机申请
@property (weak, nonatomic) IBOutlet UIButton *agentBtn;//代理商
@property (weak, nonatomic) IBOutlet UILabel *todaynewLab;//今日新增

@end
