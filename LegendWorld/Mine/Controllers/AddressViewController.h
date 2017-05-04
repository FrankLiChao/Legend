//
//  AddressViewController.h
//  LegendWorld
//
//  Created by Frank on 2016/12/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddressViewControllerDelegate <NSObject>

- (void)didFinishAddOrEditAddress:(RecieveAddressModel *)address;

@end

@interface AddressViewController : BaseViewController
@property (nonatomic, weak)id delegate;

@property (nonatomic)BOOL isEdit; //yes 表示编辑状态
@property (nonatomic, strong)RecieveAddressModel *addressModel;

@end
