//
//  TOCardMemberTableViewCell.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOCardMemberTableViewCell;
@protocol TOCardMemberTableViewCellDelegate <NSObject>

- (void)didTapCallPhoneBtn:(TOCardMemberTableViewCell *)cell;

@end

@interface TOCardMemberTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *memberImg;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImage;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *memberLevel;
@property (weak, nonatomic) IBOutlet UILabel *memberDownLineTitle;
@property (weak, nonatomic) IBOutlet UILabel *memberDownLine;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIView *exchangeTag;//置换标志

@property (weak, nonatomic) id delegate;

@end
