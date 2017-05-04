//
//  AdvertTableViewCell.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AdvertTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface AdvertTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *ad_name;
@property (weak, nonatomic) IBOutlet UILabel *ad_company;
@property (weak, nonatomic) IBOutlet UILabel *ad_makemoney;
@property (weak, nonatomic) IBOutlet UIImageView *desImage;

@end
@implementation AdvertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)configWithModel:(AdvertModel *)model {
    self.ad_name.text = model.title;
    self.ad_company.layer.cornerRadius = 5;
    self.ad_company.layer.borderWidth = 1;
    self.ad_company.layer.masksToBounds = YES;
    self.ad_company.layer.borderColor = [UIColor redColor].CGColor;
    self.ad_company.text = [NSString stringWithFormat:@" %@  ",model.title];
    self.ad_makemoney.text = model.cost;
    [self.desImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
}
@end
