//
//  OrderDetailViewController.h
//  LegendWorld
//
//  Created by 文荣 on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@protocol OrderDetailViewControllerDelegate <NSObject>

- (void)refreshParentVC;

@end

@interface OrderDetailViewController : BaseViewController

@property (nonatomic) NSInteger orderId;

@property (nonatomic, weak) id delegate;

@end
