//
//  ProudctPropertySelectView.h
//  legend
//
//  Created by heyk on 16/1/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"


typedef void (^ProudctPropertySelectBuyBlock)(ProductModel *model);


@interface ProudctPropertySelectView : UIView

@property (nonatomic,strong) ProductModel          *currentModel;
@property (nonatomic,weak)IBOutlet UIView          *contentView;
@property (nonatomic,weak)IBOutlet UIButton        *buyButton;
@property (nonatomic,weak)IBOutlet UIScrollView    *scrollView;
@property (nonatomic,weak)IBOutlet UIView          *scrollContentView;
@property (nonatomic,weak)IBOutlet UILabel         *titleLabel;//修改为单价
@property (nonatomic,weak)IBOutlet UILabel         *priceLabel;//修改为库存
@property (nonatomic,weak)IBOutlet UIImageView     *imageView;

@property (nonatomic,weak)IBOutlet NSLayoutConstraint *contentBottom;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *scrollContentHeight;

@property (nonatomic,copy)ProudctPropertySelectBuyBlock buyBlock;


-(void)showWithProudctID:(ProductModel*)model withCheck:(BOOL)isCarShop selectBuy:(ProudctPropertySelectBuyBlock)block;
+(ProudctPropertySelectView*)getInstanceWithNib;


/** 服务类商品购买*/
//- (void)showServerProductWithModel:(ProductModel *)model selectBuy:(ProudctPropertySelectBuyBlock)block;

@end
