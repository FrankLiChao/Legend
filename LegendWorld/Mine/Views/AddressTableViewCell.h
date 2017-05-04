//
//  AddressTableViewCell.h
//  LegendWorld
//
//  Created by Frank on 2016/12/21.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *textValueTF;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
