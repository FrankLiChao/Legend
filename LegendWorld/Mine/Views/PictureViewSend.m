//
//  PictureViewSend.m
//  LegendWorld
//
//  Created by wenrong on 16/10/12.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "PictureViewSend.h"

@implementation PictureViewSend
- (void)awakeFromNib {
    [super awakeFromNib];
    _pictureImage.layer.cornerRadius = 6;
    _pictureImage.layer.masksToBounds = YES;
    // Initialization code
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)deleteAct:(UIButton *)sender {
    [self.delegate deleteImageAct:sender.tag andCell:self.tag];
}
@end
