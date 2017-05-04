//
//  EvaluationNewViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "LHRatingView.h"

@protocol refreshOrderDetailPro <NSObject>

-(void)refreshOrderDetailAct;

@end

@interface EvaluationNewViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *modelDataArr;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *seller_id;
@property(nonatomic,weak)id<refreshOrderDetailPro>delegate;

@end
