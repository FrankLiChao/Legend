//
//  ShoppingMallCell.m
//  legend
//
//  Created by ios-dev-01 on 16/8/19.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ShoppingMallCell.h"

@implementation ShoppingMallCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _productImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 180*widthRate)];
        [_productImage setImage:imageWithName(@"a5.jpg")];
        [self addSubview:_productImage];
        
        _name = [UILabel new];
        _name.font = [UIFont systemFontOfSize:15];
        _name.textColor = contentTitleColorStr;
        _name.text = @"国粹纯粮酒6瓶480（买6赠1）好酒好酒好酒好酒好酒好酒好酒好酒";
        _name.numberOfLines = 2;
        [self addSubview:_name];
        
        _name.sd_layout
        .leftSpaceToView(self,10*widthRate)
        .topSpaceToView(_productImage,8*widthRate)
        .rightSpaceToView(self,10*widthRate)
        .heightIs(42*widthRate);
        
        _price = [UILabel new];
        _price.text = @"￥594.00";
        _price.textColor = mainColor;
        _price.font = [UIFont systemFontOfSize:16];
        _price.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_price];
        
        _price.sd_layout
        .leftEqualToView(_name)
        .bottomSpaceToView(self,10*widthRate)
        .widthIs(100)
        .heightIs(17*widthRate);
        
        _saleNumber = [UILabel new];
        _saleNumber.text = @"销量：999";
        _saleNumber.textColor = contentTitleColorStr1;
        _saleNumber.font = [UIFont systemFontOfSize:12];
        _saleNumber.textAlignment = NSTextAlignmentRight;
//        [self addSubview:_saleNumber];
        
        _saleNumber.sd_layout
        .rightSpaceToView(self,10*widthRate)
        .bottomSpaceToView(self,10*widthRate)
        .heightIs(17*widthRate);
        [_saleNumber setSingleLineAutoResizeWithMaxWidth:100];
        
//        _markImage = [UIImageView new];
//        [_markImage setImage:imageWithName(@"endorsemark")];
//        _markImage.hidden = YES;
//        [self addSubview:_markImage];
//        
//        _markImage.sd_layout
//        .rightSpaceToView(self,0)
//        .topSpaceToView(self,0)
//        .widthIs(53*widthRate)
//        .heightIs(50*widthRate);
        
        _markLable = [UILabel new];
        _markLable.text = @"推荐代言";
        _markLable.textColor = mainColor;
        _markLable.textAlignment = NSTextAlignmentCenter;
        _markLable.font = [UIFont systemFontOfSize:10];
        _markLable.layer.cornerRadius = 3;
        _markLable.layer.masksToBounds = YES;
        _markLable.layer.borderWidth = 0.7;
        _markLable.layer.borderColor = mainColor.CGColor;
        _markLable.hidden = YES;
        [self addSubview:_markLable];
        
        _markLable.sd_layout
        .rightSpaceToView(self,10*widthRate)
        .topSpaceToView(self,8*widthRate)
        .widthIs(50)
        .heightIs(15);
        
        _markView = [UIView new];
        _markView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_productImage addSubview:_markView];
        
        _markView.sd_layout
        .leftEqualToView(_productImage)
        .rightEqualToView(_productImage)
        .bottomSpaceToView(_productImage,0)
        .heightIs(30*widthRate);
        
        UILabel *tagL = [UILabel new];
        tagL.text = @"可代言商品";
        tagL.textColor = [UIColor whiteColor];
        tagL.font = [UIFont systemFontOfSize:14];
        tagL.textAlignment = NSTextAlignmentCenter;
        [_markView addSubview:tagL];
        
        tagL.sd_layout
        .centerXEqualToView(_markView)
        .centerYEqualToView(_markView)
        .widthIs(150)
        .heightIs(30*widthRate);
    }
    return self;
}

@end
