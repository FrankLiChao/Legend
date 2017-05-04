//
//  EvaluationCell.h
//  LegendWorld
//
//  Created by wenrong on 16/11/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHRatingView.h"
@interface EvaluationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderIDLab;
@property (weak, nonatomic) IBOutlet UILabel *priceTopLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceDownLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UIImageView *orderIconIma;
@property (weak, nonatomic) IBOutlet LHRatingView *starView;
@property (weak, nonatomic) IBOutlet UITextView *evaluationTV;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@end
