//
//  FillShippingInfoViewController.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@protocol FillShippingInfoViewControllerDelegate <NSObject>

- (void)refreshPreviousVC;

@end


@interface FillShippingInfoViewController : BaseViewController

@property (nonatomic, strong) NSString *after_id;//售后id

@property (nonatomic, weak) id delegate;

@end
