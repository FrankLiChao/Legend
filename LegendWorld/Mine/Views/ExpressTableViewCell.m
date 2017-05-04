//
//  ExpressTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ExpressTableViewCell.h"

@implementation ExpressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.statusIm setImage:imageWithName(@"mine_afteragree")];
    [self.expressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.expressBtn.backgroundColor = mainColor;
    self.addressNameLab.textColor = contentTitleColorStr2;
    self.addressLab.textColor = contentTitleColorStr2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
