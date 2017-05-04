//
//  OrderAdvCell.m
//  legend
//
//  Created by heyk on 16/1/26.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "OrderAdvCell.h"
#import "UitlCommon.h"
#import <Masonry/Masonry.h>

@implementation OrderAdvCell{
    
    UILabel *questionLabel;
    
    UIView * enterBackView;
    UITextField *enterTextField;
    UIButton *deleteButton;
    UIView  *selectContentView;
    NSArray *contentArray;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        questionLabel.numberOfLines = 0;
        questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        questionLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:questionLabel];
        enterBackView = [[UIView alloc] initWithFrame:CGRectZero];
        enterBackView.layer.masksToBounds = YES;
        enterBackView.backgroundColor = [UIColor whiteColor];
        [UitlCommon setFlat:enterBackView radius:4];
        [self.contentView addSubview:enterBackView];
        enterTextField  = [[UITextField alloc] initWithFrame:CGRectZero];
        enterTextField.backgroundColor = contentTitleColorStr;
        enterTextField.textColor = contentTitleColorStr;
        enterTextField.enabled = NO;
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 2)];
        leftV.backgroundColor = [UIColor clearColor];
        enterTextField.leftView = leftV;
        enterTextField.leftViewMode = UITextFieldViewModeAlways;
        
        enterTextField.font = [UIFont systemFontOfSize:16];
        [enterBackView addSubview:enterTextField];
        
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.backgroundColor = [UIColor whiteColor];
        deleteButton.titleLabel.font = enterTextField.font;
        [deleteButton setTitleColor:enterTextField.textColor forState:UIControlStateNormal];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
        [enterBackView addSubview:deleteButton];
        [deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(enterBackView.mas_right);
            make.width.equalTo(@52);
            make.top.equalTo(enterBackView.mas_top);
            make.bottom.equalTo(enterBackView.mas_bottom);
        }];
        
        [enterTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(enterBackView.mas_left);
            make.right.equalTo(deleteButton.mas_left);
            make.top.equalTo(enterBackView.mas_top);
            make.bottom.equalTo(enterBackView.mas_bottom);
        }];
        selectContentView = [[UIView alloc] initWithFrame:CGRectZero];
        selectContentView.backgroundColor = [UIColor clearColor];
        [self.contentView  addSubview:selectContentView];
    }
    return  self;
}

-(void)setContent:(NSString*)str selects:(NSArray*)array{
    
    contentArray = array;
    
    for (UIView *view in selectContentView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableAttributedString *str1 = [UitlCommon setString:[NSString stringWithFormat:@"问题：%@",str] keyString:@"问题："
                                                      color:mainColor
                                                 otherColor:contentTitleColorStr];
    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16*widthRate] range:NSMakeRange(0, str1.length)];
    questionLabel.attributedText = str1;
    CGSize size = [questionLabel.attributedText sizeWithWidth:DeviceMaxWidth - 24];
    [questionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.height.equalTo([NSNumber numberWithFloat:size.height]);
    }];
    [enterBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(questionLabel.mas_bottom).offset(20);
        
        make.height.equalTo(@40);
    }];
    float height = 45;
    float w = DeviceMaxWidth - 24;
    int  maxLine = (w - 12)/ (height + 12);
    float space = (w - height * maxLine)*1.0/(maxLine+1);
    float leading = space;
    
    NSInteger currentLine = maxLine;
    if (array.count<maxLine) {
        currentLine = array.count;
        space = 12;
        leading = (w - height *array.count - space*(array.count-1))/2;
    }
    NSInteger currentRow = array.count / currentLine ;
    if (array.count%currentLine>0) {
        currentRow +=1;
    }
    __block UIButton *lastButton = nil;
    __block  UIButton *lastRowButton = nil;
    for (int i = 0; i<array.count; i++) {
        NSString *content = [array objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_order"] forState:UIControlStateNormal];
        button.tag = i+1;
        [button addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:contentTitleColorStr forState:UIControlStateNormal];
        [button setTitle:content forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:28];
        [selectContentView addSubview:button];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            NSInteger wichtRow = i/currentLine;
            
            if (wichtRow == 0) {//第一行
                make.top.equalTo(selectContentView.mas_top);
            }
            else{
                make.top.equalTo(lastRowButton.mas_bottom).offset(20);
            }
            
            NSInteger whitchLine = i-wichtRow*currentLine;
            
            if (whitchLine == 0) {//第一列
                
                make.left.equalTo(selectContentView.mas_left).offset(leading);
            }
            else if(whitchLine == currentLine-1){//最后一列
                make.left.equalTo(lastButton.mas_right).offset(space);
                // make.right.equalTo(selectContentView.mas_right).offset(-leading);
                lastRowButton = button;
            }
            else{
                make.left.equalTo(lastButton.mas_right).offset(space);
            }
            
            if (wichtRow == currentRow - 1) {//最后一行
                make.bottom.equalTo(selectContentView.mas_bottom);
            }
            
            make.height.equalTo([NSNumber numberWithInt:height]);
            make.width.equalTo([NSNumber numberWithInt:height]);
            
            lastButton = button;
            
        }];
        
        [selectContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(12);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.top.equalTo(enterBackView.mas_bottom).offset(20);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    
    
    
}


-(void)clickDelete:(UIButton*)button{
    
    if ([UitlCommon isNull:enterTextField.text]){return;}
    
    NSString *deletStr = nil;
    for (NSString *value in contentArray) {

        if ([enterTextField.text hasSuffix:value]) {
            deletStr = value;
            break;
        }
   
    }
    
    NSMutableString *str = [enterTextField.text mutableCopy];
    
    [str replaceCharactersInRange:NSMakeRange(str.length - deletStr.length, deletStr.length) withString:@""];
    
    enterTextField.text = str;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.delegate valueChanged:enterTextField.text];
    }
}

-(void)clickSelect:(UIButton*)button{
    NSString *str = [contentArray objectAtIndex:button.tag - 1];
    enterTextField.text = [NSString stringWithFormat:@"%@%@",enterTextField.text,str];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.delegate valueChanged:enterTextField.text];
    }
}

-(NSString*)getMyAnswer{
    
    return enterTextField.text;
}

-(void)selectValue:(NSString*)value{
    enterTextField.text = value;
    
}

@end
