//
//  QuestionAnswerCell.h
//  legend
//
//  Created by heyk on 16/1/25.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvBaseCell.h"

@interface QuestionAnswerCell : AdvBaseCell<UITextViewDelegate>

@property (nonatomic,strong)UILabel *questionLabel;
@property (nonatomic,strong)UITextView *enterTextView;


-(void)setContent:(NSString*)str;

@end
