//
//  AdvInfoCell.m
//  legend
//
//  Created by heyk on 16/1/27.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "AdvInfoCell.h"
#import "UitlCommon.h"
#import "Masonry.h"

@implementation AdvInfoCell{

    UILabel *questionLabel;
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        questionLabel.numberOfLines = 0;
        questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        questionLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:questionLabel];
      
        [questionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(12);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return  self;
}

+(float)cellHeight:(NSString*)str{
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] byWidth:DeviceMaxWidth - 24];
    return size.height;

}
-(void)setContent:(NSString*)str{

    questionLabel.text = str;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
