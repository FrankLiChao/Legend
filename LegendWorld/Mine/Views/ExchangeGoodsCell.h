//
//  ExchangeGoodsCell.h
//  LegendWorld
//
//  Created by Frank on 2016/11/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusIm;//状态图标
@property (weak, nonatomic) IBOutlet UILabel *statusLab;//申请售后的状态
@property (weak, nonatomic) IBOutlet UILabel *contentLab;//问题反馈
@property (weak, nonatomic) IBOutlet UIButton *sureTakeBtn;//确认收货
@property (weak, nonatomic) IBOutlet UIButton *saleAfterBtn;//再次申请售后
@property (weak, nonatomic) IBOutlet UILabel *expressLab;//物流公司
@property (weak, nonatomic) IBOutlet UILabel *expressNumLab;//快递单号

@end
