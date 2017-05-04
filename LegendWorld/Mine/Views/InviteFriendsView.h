//
//  InviteFriendsView.h
//  LegendWorld
//
//  Created by Frank on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsView : UIView

@property (nonatomic, strong)UIImageView *headIm;
@property (nonatomic, strong)UIImageView *imageTag;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *invateCode;
@property (nonatomic, strong)UIImageView *qrcodeIm;
@property (nonatomic, strong)NSDictionary *dataDic;

-(void)disAppearInvateView;
@end
