//
//  AddressManageCell.h
//  LegendWorld
//
//  Created by Frank on 2016/12/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressManageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;//电话
@property (weak, nonatomic) IBOutlet UILabel *addressLab;//省市区
@property (weak, nonatomic) IBOutlet UILabel *detailAddrLab;//详细地址
@property (weak, nonatomic) IBOutlet UIButton *defaulBtn;//默认地址按钮
@property (weak, nonatomic) IBOutlet UIButton *editBtn;//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;//删除按钮

@end
