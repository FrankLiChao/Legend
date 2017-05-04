//
//  TOCardMemberHeaderView.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOCardMemberHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *infoBtn;
@property (nonatomic, weak) UILabel *infoLabel;

- (void)setInfoLabelRemainCount:(NSInteger)count;
- (void)setInfoLabelBenifitLayer:(NSInteger)count;
@end
