//
//  MyAdListTableViewCell.m
//  LegendWorld
//
//  Created by 文荣 on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyAdListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyAdListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *descImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *saveMoney;

@end
@implementation MyAdListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)configWithModel:(AdvertModel *)model {
    [self.descImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.title.text = model.title;
    NSString *text = [NSString stringWithFormat:@"收益：¥%@",model.income];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, 3)];
    self.saveMoney.attributedText = attributeString;
}
@end
