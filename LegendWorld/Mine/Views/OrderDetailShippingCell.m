//
//  OrderDetailShippingCell.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "OrderDetailShippingCell.h"

@implementation OrderDetailShippingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithLogistic:(LogisticsModel *)log {
    if (log) {
        LogisticsProcessModel *last = [log.processes lastObject];
        self.statusDesc.text = last.statusDesc;
        self.time.text = last.time;
        
        self.statusDesc.hidden = NO;
        self.time.hidden = NO;
        self.info.hidden = YES;
    } else {
        self.statusDesc.hidden = YES;
        self.time.hidden = YES;
        self.info.hidden = NO;
    }
}

@end
