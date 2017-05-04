//
//  CloseRefundTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CloseRefundTableViewCell.h"

@implementation CloseRefundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.statusIm setImage: imageWithName(@"mine_ afterrefuse")];
    self.statusLab.text = @"退款已关闭";
    self.otherLab.text = [NSString stringWithFormat:@"需要其它帮助请联系客服\n\n电话：%@",ServicePhone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
