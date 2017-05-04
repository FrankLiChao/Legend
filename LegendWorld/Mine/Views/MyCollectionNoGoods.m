//
//  MyCollectionNoGoods.m
//  LegendWorld
//
//  Created by wenrong on 16/11/3.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyCollectionNoGoods.h"

@implementation MyCollectionNoGoods

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)turnToBuy:(UIButton *)sender {
    [self.delegate turnToBuy];
}
@end
