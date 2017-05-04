//
//  ChooseReasonCell.h
//  LegendWorld
//
//  Created by wenrong on 16/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseReasonCellDelegate <NSObject>

- (void)clickChooseReasonCell:(UIButton *)chooseBtn;

@end

@interface ChooseReasonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic, weak) id <chooseReasonCellDelegate> delegate;
@end
