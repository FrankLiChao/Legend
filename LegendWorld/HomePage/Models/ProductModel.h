//
//  ProductModel.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductAttributionModel : NSObject //产品规格

@property (nonatomic,strong)NSString *attr_name;//规格名称
@property (nonatomic,strong)NSString *value;
@property (nonatomic,strong)NSString *goods_id;//商品Id
@property (nonatomic,strong)NSString *attr_id;//规格Id
@property (nonatomic,strong)NSString  *price;//当前规格价格
@property (nonatomic,strong)NSString  *goods_number;//规格库存
@property (nonatomic,strong) NSString *recommend_reward;//推荐奖励

@end

@interface ProductGalleryListModel : NSObject

@property (nonatomic,strong)NSString *img_url;//图片地址
@property (nonatomic,strong)NSString *thumb_url;//缩略图地址
@property (nonatomic,strong)NSString *img_desc;//相册描述

@end

@interface ProductNotBuyAttrListModel : NSObject

@property (nonatomic,strong)NSString *attr_name;
@property (nonatomic,strong)NSString *attr_price;
@property (nonatomic,strong)NSString *attr_value;
@property (nonatomic,strong)NSString *goods_attr_id;
@end

@interface SellerInfoModel1 : NSObject

@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *seller_name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic,strong)  NSString *brand_id;

@end

@interface ProductModel : NSObject
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *img;
@property (nonatomic,strong)NSString *goods_id;//商品id"
@property (nonatomic,strong)NSString *brand_id; //品牌Id
@property (nonatomic,strong)NSString *goods_sn;//商品货号
@property (nonatomic, strong)NSString *attr_id;//商品属性
@property (nonatomic,strong)NSString *goods_name;//商品名称
@property (nonatomic,strong)NSString *goods_price;//商品价格
@property (nonatomic,strong)NSString *market_price;//市场价格
@property (nonatomic,strong)NSString *shop_price;//商家价格
@property (nonatomic,strong)NSString *goods_number;//商品库存
@property (nonatomic,strong)NSString *sell_count;//商品销量
@property (nonatomic,strong)NSString *shipping;//商品运费
@property (nonatomic,strong)NSString *shipping_free;//商品满多少免运费
@property (nonatomic,assign) BOOL is_endorse;   //是否是代言产品
@property (nonatomic,assign) BOOL is_exist_brand_endorse;//表示之前是否同意过代言协议
@property (nonatomic,strong)NSString *goods_weight;//商品重量
@property (nonatomic,strong)NSString *goods_thumb;//商品列表图地址
@property (nonatomic,strong)NSString *goods_brief;//商品简短描述
@property (nonatomic,strong)NSArray *goods_desc;//商品详细描述(图文)
@property (nonatomic,strong)NSNumber *goods_type; //ProuductType
@property (nonatomic,strong)NSString *goods_img;
@property (nonatomic,strong) NSString *discount;//商品折扣
@property (nonatomic,strong) NSString *comment_count;//商品评价数量
@property (nonatomic,strong) NSString *seller_addr_info;//商品地址
@property (nonatomic,strong) NSString *goods_fill_give_gift;//满多少减多少的活动
@property (nonatomic,strong) NSArray *two_comment_list;//商品的两条评论
@property (nonatomic,strong) NSString *goods_detail_url;//商品详情的分享链接
@property (nonatomic, strong)NSString *cart_num;//购物车数量
@property (nonatomic, strong)NSString *is_tocard;//标示是否是tok
/** "is_collect":"是否收藏", 1:已收藏 0：未收藏
 */
@property (nonatomic, copy) NSNumber *is_collect;
@property (nonatomic, strong) NSString *goods_tips;//商家提示
@property (nonatomic, strong) NSString *is_prepare;//是否预售商品，0 非预售商品，1预售商品
@property (nonatomic, copy) NSString *prepare_time;//预售商品结束的时间  是具体的秒
@property (nonatomic, copy) NSString *seller_id;//商家id

@property (nonatomic,strong)NSArray *gallery_img;
@property (nonatomic,strong)NSArray<ProductAttributionModel*>  *attr_list;//属性列表
@property (nonatomic, strong) SellerInfoModel1 *seller_info;
@property (nonatomic, strong) NSString *share_money;//购买返点
@property (nonatomic, strong) NSString *share_buy_money;//分享被购买返现
@property (nonatomic, strong) NSString *share_url;//分享链接


@property (nonatomic,strong)NSString *size_img;//商品规格变
@property (nonatomic,strong)NSNumber *lng;
@property (nonatomic,strong)NSNumber *lat;
@property (nonatomic,strong)NSString *distance;
@property (nonatomic,strong)NSNumber *comment_star;


@property (nonatomic,strong)NSString  *exchange_code;


@property (nonatomic,strong)NSArray<ProductGalleryListModel*> *gallery_list;//
//
@property (nonatomic,strong)NSArray<ProductNotBuyAttrListModel*>  *not_buy_attr_list;

@property (nonatomic,strong)NSString    *selectNum;//选择的数量
@property (nonatomic,assign)BOOL        sevenReturnGuarantee;//七天无条件退货保障
@property (nonatomic,assign)BOOL        saleGuarantee;//售后无忧保障

@property (nonatomic,strong)NSArray<ProductAttributionModel*>* selectProperty;//选择的属性



//-- add by jl
@property (nonatomic, strong) NSNumber *total_sell_num;//已售出商品数量
@property (nonatomic, strong) NSArray<SellerInfoModel1 *> *seller_info_list;



@property (nonatomic, strong) NSNumber *comment_rank;//评论几星级
@property (nonatomic, strong) NSNumber *five_comment_num;//五星数量
@property (nonatomic, strong) NSNumber *four_comment_num;
@property (nonatomic, strong) NSNumber *three_comment_num;
@property (nonatomic, strong) NSNumber *two_comment_num;
@property (nonatomic, strong) NSNumber *one_comment_num;
@property (nonatomic, assign) NSInteger buy_num;//用户购买的数量
@property (nonatomic, copy) NSString *total_comment_num;// 总星

@end
