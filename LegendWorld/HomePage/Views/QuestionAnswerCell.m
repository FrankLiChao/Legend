//
//  QuestionAnswerCell.m
//  legend
//
//  Created by heyk on 16/1/25.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "QuestionAnswerCell.h"
#import "Masonry.h"
#import "UitlCommon.h"

@implementation QuestionAnswerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _questionLabel.numberOfLines = 0;
        _questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _questionLabel.font = [UIFont systemFontOfSize:16];

        [self.contentView addSubview:_questionLabel];
        
        
        self.enterTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        [UitlCommon setFlat:_enterTextView radius:4 color:tableDefSepLineColor borderWith:1];
        self.enterTextView.backgroundColor = [UIColor whiteColor];
        self.enterTextView.font = [UIFont systemFontOfSize:16];
        self.enterTextView.textColor = contentTitleColorStr;
        [self.contentView addSubview:_enterTextView];
        


        
    }
    return  self;
}




-(void)setContent:(NSString*)str {

    NSMutableAttributedString *str1 = [UitlCommon setString:[NSString stringWithFormat:@"问题：%@",str] keyString:@"问题："
                                              color:mainColor
                                         otherColor:contentTitleColorStr];
    
    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*widthRate] range:NSMakeRange(0, str1.length)];
    
    _questionLabel.attributedText = str1;
    
    CGSize size = [self.questionLabel.attributedText sizeWithWidth:DeviceMaxWidth - 24];
    
    [self.questionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.height.equalTo([NSNumber numberWithFloat:size.height]);
        
        
    }];
    [self.enterTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.questionLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@110);
        
    }];
    self.enterTextView.delegate = self;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)getMyAnswer{
    
    return _enterTextView.text;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.delegate valueChanged:textView.text];
    }
}


-(void)selectValue:(NSString*)value{
    _enterTextView.text = value;
    
}
@end
