//
//  AddressManagerViewController.h
//  LegendWorld
//
//  Created by Frank on 2016/12/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddressManagerViewControllerDelegate <NSObject>

- (void)modifyAddress:(RecieveAddressModel *)address;

@end

@interface AddressManagerViewController : BaseViewController

@property (nonatomic, weak)id delegate;

@end
