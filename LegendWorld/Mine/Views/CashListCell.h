//
//  CashListCell.h
//  legend
//
//  Created by heyk on 15/11/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashListModel.h"

typedef void (^CashListCellClickBlock)(UITableViewCell *cell);

@interface CashListCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UILabel *typeNameLabel;

@property (nonatomic,weak)IBOutlet UILabel *statusLabel;
@property (nonatomic,weak)IBOutlet UILabel *dateLabel;
@property (nonatomic,weak)IBOutlet UILabel *amountLabel;
@property (nonatomic,weak)IBOutlet UILabel *typeNameDetailLabel;

@property (nonatomic,weak)IBOutlet UILabel *statusLabel1;
@property (nonatomic,weak)IBOutlet UIView *line1_left;
@property (nonatomic,weak)IBOutlet UIView *line1_right;
@property (nonatomic,weak)IBOutlet UILabel *statusDateLabel1;
@property (nonatomic,weak)IBOutlet UIView *statusImage1;

@property (nonatomic,weak)IBOutlet UILabel *statusLabel2;
@property (nonatomic,weak)IBOutlet UIView *line2_left;
@property (nonatomic,weak)IBOutlet UIView *line2_right;
@property (nonatomic,weak)IBOutlet UILabel *statusDateLabel2;
@property (nonatomic,weak)IBOutlet UIView *statusImage2;


@property (nonatomic,weak)IBOutlet UILabel *statusLabel3;
@property (nonatomic,weak)IBOutlet UILabel *statusDateLabel3;
@property (nonatomic,weak)IBOutlet UIView *statusImage3;

@property (nonatomic,weak)IBOutlet UIButton *detailBackButton;
@property (nonatomic,weak)IBOutlet UIView *spearateLine;

@property (nonatomic,weak)IBOutlet NSLayoutConstraint *detailHeight;

@property (nonatomic,copy)CashListCellClickBlock clickBlock;

+(CashListCell*)getInstanceWithReuseIdentifier:(NSString*)reuseIdentifier;

-(void)setUIWithModel:(CashListModel*)model clickResponse:(CashListCellClickBlock)block;

@end
