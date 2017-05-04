//
//  SellerShopHeaderView.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/2.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchView.h"

@interface SellerShopHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *sellerImageView;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sellerBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectionCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightInfoLabel;
@property (weak, nonatomic) IBOutlet SwitchView *switchView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
