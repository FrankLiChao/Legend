//
//  IncomeDetailViewController.h
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@interface IncomeDetailViewController : BaseViewController

@property (nonatomic, strong)NSString *income_id;//收益ID
@property (nonatomic)BOOL isProcessPage; //表示进行中的收益详情为Yes
@property (nonatomic)BOOL isCansole;//表示是否已取消
@property (nonatomic)BOOL isTok;//Yes 表示Tok的分润和奖励收益详情。 其他情况可不传

@end
