//
//  ProductDetailViewController.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductModel.h"

@interface ProductDetailViewController : BaseViewController

@property (nonatomic,strong) NSString *goods_id;//商品Id
@property (nonatomic,assign) BOOL is_endorse;//是否代言
@property (nonatomic,strong) NSString *ad_id;//广告Id
@property (nonatomic,strong) ProductModel *currentModel;
@property (nonatomic)BOOL isTok;//是否是tok

//-(void)attriButionSelect;//点击我要代言按钮，完成代言协议检测时回调该方法
-(void)continueDealBuy;//点击产品规格里面的我要代言，完成代言协议检测时回调该方法

@end
