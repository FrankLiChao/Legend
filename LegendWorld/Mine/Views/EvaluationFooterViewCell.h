//
//  EvaluationFooterViewCell.h
//  LegendWorld
//
//  Created by wenrong on 16/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EvaluationFooterViewDelegate <NSObject>

- (void)clickEvaluationSubmitAct;

@end


@interface EvaluationFooterViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;
@property (nonatomic, weak) id <EvaluationFooterViewDelegate> delegate;
@end
