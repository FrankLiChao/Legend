//
//  SelectAdvCell.m
//  legend
//
//  Created by heyk on 16/1/26.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "SelectAdvCell.h"
#import "UitlCommon.h"
#import "Masonry.h"


@interface CustomButton : UIButton

@property (nonatomic,strong)NSString *content;

@end
@implementation CustomButton
@end


@implementation SelectAdvCell{

     NSInteger selectIndex;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _questionLabel.numberOfLines = 0;
        _questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _questionLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:_questionLabel];
        
        
        self.selectContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectContentView.backgroundColor = [UIColor clearColor];
        [self.contentView   addSubview:_selectContentView];
        
    }
    return  self;
}


-(void)updateConstraints{
    [super updateConstraints];
}




-(void)setContent:(NSString*)str selects:(NSArray*)array{
  
    
    for (UIView *view in _selectContentView.subviews) {
        [view removeFromSuperview];
    }

    
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
    
        float rowHeight = 40;
        float space= 4;

    UIButton *lastButton = nil;
    
    float selectHeight = 0;
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    NSArray *leterArray = [theCollation sectionTitles];
    
    
    for (int i =0; i<array.count; i++) {
        
        NSString *selectStr = [array objectAtIndex:i];
        
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:16*widthRate];
        button.backgroundColor = [UIColor whiteColor];
        
        NSInteger index = i%leterArray.count;
        
        NSString *tiltle = [NSString stringWithFormat:@"%@. %@",[leterArray objectAtIndex:index],selectStr];
        [button setTitle:tiltle forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.content = selectStr;
        
        button.tag = i+1;
        [button addTarget:self action:@selector(selectAnswer:) forControlEvents:UIControlEventTouchUpInside];
        if (selectIndex == i+1) {
            [UitlCommon setFlat:button radius:4 color:mainColor borderWith:1];
            [button setTitleColor:mainColor forState:UIControlStateNormal];
        }
        else{
            [UitlCommon setFlat:button radius:4 color:tableDefSepLineColor borderWith:1];
            [button setTitleColor:contentTitleColorStr forState:UIControlStateNormal];
        }
        [_selectContentView addSubview:button];
        
        CGSize size = [selectStr sizeWithFont:button.titleLabel.font byWidth:DeviceMaxWidth - 48];
        float height = size.height + 16;
        if (height<rowHeight) {
            height = rowHeight;
        }
    
        selectHeight = selectHeight + height + space;
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectContentView.mas_left);
            make.right.equalTo(self.selectContentView.mas_right);
            if (i == 0) {
                make.top.equalTo(self.selectContentView.mas_top);
            }
            else{
                make.top.equalTo(lastButton.mas_bottom).offset(space);
            }
            make.height.equalTo([NSNumber numberWithFloat:height]);
        }];
        
        lastButton = button;
    }
    
    [self.selectContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.questionLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo([NSNumber numberWithFloat:selectHeight]);
    }];
 
}

-(void)selectAnswer:(CustomButton*)button{

    selectIndex = button.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.delegate valueChanged:button.content];
    }
    
    for (UIButton *button in _selectContentView.subviews) {
        
        if ([button isKindOfClass:[UIButton class]]) {
            
            if (button.tag == selectIndex) {
                [UitlCommon setFlat:button radius:4 color:mainColor borderWith:1];
                [button setTitleColor:mainColor forState:UIControlStateNormal];
            }
            else{
                [UitlCommon setFlat:button radius:4 color:tableDefSepLineColor borderWith:1];
                [button setTitleColor:contentTitleColorStr forState:UIControlStateNormal];
            }
        }
    }
}


-(NSString*)getMyAnswer{
    
    UIButton *button = [_selectContentView viewWithTag:selectIndex];
    
    return button.titleLabel.text;
}

-(void)selectValue:(NSString*)value{

    
    for (CustomButton *button in _selectContentView.subviews) {
        
        if ([button isKindOfClass:[UIButton class]]) {
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                if ([button.content isEqualToString:value ]) {
                    [UitlCommon setFlat:button radius:4 color:mainColor borderWith:1];
                    [button setTitleColor:mainColor forState:UIControlStateNormal];
                    
                    selectIndex = button.tag;
                }
                else{
                    [UitlCommon setFlat:button radius:4 color:tableDefSepLineColor borderWith:1];
                    [button setTitleColor:contentTitleColorStr forState:UIControlStateNormal];
                }
            }
        }
    }
}


@end
