//
//  ProductDetailViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "LHRatingView.h"
#import "UIImageView+WebCache.h"
#import "MainRequest.h"
#import "MJExtension.h"
#import "lhSymbolCustumButton.h"
#import "ProudctPropertySelectView.h"
#import "EndorseProtrolController.h"
#import "WZLBadgeImport.h"
#import "SellerShopViewController.h"
#import "ShoppingCartViewController.h"
#import "SelectGoodsAttrView.h"
#import "OrderConfirmViewController.h"
#import "SDCycleScrollView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ImageBrowserView.h"
#import "GoodsAppraiseViewController.h"

@interface ProductDetailViewController ()<SDCycleScrollViewDelegate>

@property(nonatomic,weak)UIScrollView *myScrollView;
@property(nonatomic,weak)UIButton *buyButton;
//@property(nonatomic,weak)UIImageView *headImage;//标题图片
@property(nonatomic,weak)UILabel    *nameLab;//商品名称
@property(nonatomic,weak)UILabel    *nowPrice;//现在的价格
@property(nonatomic,weak)UILabel    *oldPrice;//原价
@property(nonatomic,weak)UIView     *priceLine;//
@property(nonatomic,weak)UILabel    *addressLab;//地址
@property(nonatomic,weak)UILabel    *rewardLab;//评价
@property(nonatomic,assign)NSInteger buyNumber;//购物车
@property(nonatomic,weak)UILabel    *directLab;//直推奖励
@property(nonatomic,weak)lhSymbolCustumButton *gwcBtn;//购物车按钮
@property(nonatomic,weak)UIButton   *collectionBtn;//收藏按钮
@property(nonatomic,weak)SDCycleScrollView *cycleScrollView;
@property(nonatomic,weak)UIView *endorseView;
@property(nonatomic,weak)UIView *directView;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(DeviceMaxWidth-35, 20, 30, 44);
    [collectBtn setImage:imageWithName(@"home_collection_no") forState:UIControlStateNormal];
    [collectBtn setImage:imageWithName(@"home_collection_yes") forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(clickCollectionEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn = collectBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-50-64)];
    myScrollView.backgroundColor = viewColor;
    myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView = myScrollView;
    [self.view addSubview:self.myScrollView];
//    [self initFrameView];
    [self initFootView];
    [self requestData];
}

- (void)requestData
{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"goods_id":[NSString stringWithFormat:@"%@",_goods_id?_goods_id:@""],
                          @"token":[FrankTools getUserToken]
                          };
    if (_is_endorse) {
        dic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [dic setValue:@(_is_endorse) forKey:@"is_endorse"];
    }
    
    [self showHUD];
    [MainRequest RequestHTTPData:PATHShop(@"api/Goods/getGoodsNewDetail") parameters:dic success:^(id responseData) {
        [self hideHUD];
        self.currentModel = [ProductModel mj_objectWithKeyValues:[responseData objectForKey:@"goods_detail"]];
        self.currentModel.seller_info = [SellerInfoModel1 mj_objectWithKeyValues:[responseData objectForKey:@"seller_info"]];
        self.currentModel.attr_list = [ProductAttributionModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"attr_list"]];
        if ([self.currentModel.is_tocard integerValue] == 1) {
            self.isTok = YES;
        }
        [self initFrameView];
        [self refreshUI];
    } failed:^(NSDictionary *errorDic) {
        __weak typeof (self) weakSelf = self;
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

-(void)initFootView
{
//    self.isTok = YES;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxHeight-50-64, DeviceMaxWidth, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    if (self.isTok) {
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake(0, 0, DeviceMaxWidth, 50);
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        buyButton.backgroundColor = mainColor;
        [buyButton addTarget:self action:@selector(clickBuyButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.buyButton = buyButton;
        [footView addSubview:self.buyButton];
    }else{
        lhSymbolCustumButton * shopBtn = [[lhSymbolCustumButton alloc]initWithFrame3:CGRectMake(0, 0, 80, 50)];
        NSString * str = [NSString stringWithFormat:@"detailshop"];
        [shopBtn.imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        shopBtn.tLabel.text = @"商家";
        [shopBtn addTarget:self action:@selector(clickShopButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:shopBtn];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(80-0.5, 0, 0.5, 50)];
        lineV.backgroundColor = tableDefSepLineColor;
        [footView addSubview:lineV];
        
        lhSymbolCustumButton * collectBtn = [[lhSymbolCustumButton alloc]initWithFrame3:CGRectMake(80, 0, 80, 50)];
        [collectBtn.imgBtn setImage:imageWithName(@"home_gwc") forState:UIControlStateNormal];
        [collectBtn addTarget:self action:@selector(clickToGwcPageEvent) forControlEvents:UIControlEventTouchUpInside];
        collectBtn.tLabel.text = @"购物车";
        self.gwcBtn = collectBtn;
        [footView addSubview:collectBtn];
        
        UIButton *shopCar = [UIButton buttonWithType:UIButtonTypeCustom];
        shopCar.frame = CGRectMake(160, 0, (DeviceMaxWidth-160)/2, 50);
        [shopCar setTitle:@"加入购物车" forState:UIControlStateNormal];
        shopCar.titleLabel.font = [UIFont systemFontOfSize:15];
        shopCar.backgroundColor = [UIColor colorFromHexRGB:@"f9a327"];
        [shopCar addTarget:self action:@selector(clickGwcEvent) forControlEvents:UIControlEventTouchUpInside];
        [shopCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footView addSubview:shopCar];
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyButton.frame = CGRectMake(DeviceMaxWidth-(DeviceMaxWidth-160)/2, 0, (DeviceMaxWidth-160)/2, 50);
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        buyButton.backgroundColor = mainColor;
        [buyButton addTarget:self action:@selector(clickBuyButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.buyButton = buyButton;
        [footView addSubview:self.buyButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth-(DeviceMaxWidth-160)/2, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [footView addSubview:lineView];
    }
}

#pragma mark - 初始化UI
-(void)initFrameView
{
//    self.isTok = YES;
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxWidth)];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 分页控件位置
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;// 分页控件风格
    cycleScrollView.delegate = self;
    cycleScrollView.backgroundColor = [UIColor clearColor];
    cycleScrollView.autoScrollTimeInterval = 8;
    cycleScrollView.imageURLStringsGroup = _currentModel.gallery_img;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = imageWithName(placeSquareBigImg);
    self.cycleScrollView = cycleScrollView;
    [self.myScrollView addSubview:cycleScrollView];
    
    UIView *endorseView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxWidth-40, DeviceMaxWidth, 40)];
    endorseView.hidden = YES;
    endorseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.endorseView = endorseView;
    [self.myScrollView addSubview:endorseView];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-30, 40)];
    tipLab.text = @"可代言商品";
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = [UIFont systemFontOfSize:15];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [endorseView addSubview:tipLab];
    
    UIView *goodsView = [UIView new];
    goodsView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:goodsView];
    
    if (!self.isTok) {
        goodsView.sd_layout
        .leftEqualToView(self.myScrollView)
        .rightEqualToView(self.myScrollView)
        .topSpaceToView(cycleScrollView,0)
        .heightIs(110);
    }else{
        goodsView.sd_layout
        .leftEqualToView(self.myScrollView)
        .rightEqualToView(self.myScrollView)
        .topSpaceToView(cycleScrollView,0)
        .heightIs(70);
    }
    
    UILabel *nameL = [UILabel new];
    nameL.text = @"茅台酒";
    nameL.textColor = contentTitleColorStr;
    nameL.font = [UIFont systemFontOfSize:15];
    self.nameLab = nameL;
    [goodsView addSubview:nameL];
    
    nameL.sd_layout
    .leftSpaceToView(goodsView,15*widthRate)
    .topSpaceToView(goodsView,12)
    .rightSpaceToView(goodsView,15*widthRate)
    .heightIs(20);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70-0.5, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [goodsView addSubview:lineView];
    
    UILabel *nowL = [UILabel new];
    nowL.text = @"¥160008.00";
    nowL.textColor = mainColor;
    nowL.font = [UIFont systemFontOfSize:25];
    self.nowPrice = nowL;
    [goodsView addSubview:nowL];
    
//    nowL.sd_layout
//    .leftEqualToView(_nameLab)
//    .bottomSpaceToView(lineView,10)
//    .heightIs(20)
//    .widthIs(120);
//    [nowL setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *oldL = [UILabel new];
    oldL.text = @"¥168.00";
    oldL.textColor = contentTitleColorStr2;
    oldL.font = [UIFont systemFontOfSize:13];
    self.oldPrice = oldL;
    [goodsView addSubview:oldL];
    
//    oldL.sd_layout
//    .leftSpaceToView(nowL,15)
//    .bottomEqualToView(nowL)
//    .heightIs(15)
//    .widthIs(100);
//    [oldL setSingleLineAutoResizeWithMaxWidth:200];
    
    UIView *bline = [UIView new];
    bline.backgroundColor = contentTitleColorStr2;
    self.priceLine = bline;
    [oldL addSubview:bline];
    
    UILabel *addrL = [UILabel new];
    addrL.text = @"四川成都";
    addrL.textColor = contentTitleColorStr2;
    addrL.font = [UIFont systemFontOfSize:14];
    addrL.textAlignment = NSTextAlignmentRight;
    self.addressLab = addrL;
    [goodsView addSubview:addrL];
    
    addrL.sd_layout
    .rightSpaceToView(goodsView,15*widthRate)
    .bottomEqualToView(nowL)
    .heightIs(20)
    .widthIs(150);
    
    NSString *zlabStr = @"㊣100%正品保障";
    UILabel *zlab = [UILabel new];
    zlab.font = [UIFont systemFontOfSize:15];
    zlab.textColor = contentTitleColorStr1;
    [goodsView addSubview:zlab];
    
    NSMutableAttributedString * as = [[NSMutableAttributedString alloc]   initWithString:zlabStr];
    [as addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(0, 1)];
    [as addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(zlabStr.length-4, 2)];
    zlab.attributedText = as;
    
    
    zlab.sd_layout
    .leftSpaceToView(goodsView,15*widthRate)
    .topSpaceToView(lineView,0)
    .heightIs(40)
    .widthIs(DeviceMaxWidth/2-15);
    
    NSString *tlabStr = @"⑦天无理由退换货";
    UILabel *tLab = [UILabel new];
    tLab.textColor = contentTitleColorStr1;
    tLab.textAlignment = NSTextAlignmentRight;
    tLab.font = [UIFont systemFontOfSize:15];
    [goodsView addSubview:tLab];
    NSMutableAttributedString * tLabAs = [[NSMutableAttributedString alloc]   initWithString:tlabStr];
    [tLabAs addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(0, 5)];
    [tLabAs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,1)];
    tLab.attributedText = tLabAs;
    
    tLab.sd_layout
    .rightSpaceToView(goodsView,15*widthRate)
    .topEqualToView(zlab)
    .widthRatioToView(zlab,1)
    .heightRatioToView(zlab,1);
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = tableDefSepLineColor;
    [goodsView addSubview:lineV];
    
    lineV.sd_layout
    .leftSpaceToView(goodsView,0)
    .rightSpaceToView(goodsView,0)
    .topSpaceToView(lineView,40-0.5)
    .heightIs(0.5);
    
    UIView *directView = [UIView new];
    directView.backgroundColor = [UIColor whiteColor];
    self.directView = directView;
    [self.myScrollView addSubview:directView];
    
    directView.sd_layout
    .xIs(0)
    .topSpaceToView(goodsView,0)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UILabel *ztLab = [UILabel new];
    ztLab.text = @"直推奖励：¥12.50";
    ztLab.textColor = contentTitleColorStr;
    self.directLab = ztLab;
    ztLab.font = [UIFont systemFontOfSize:15];
    [directView addSubview:ztLab];
    
    ztLab.sd_layout
    .leftSpaceToView(directView,15*widthRate)
    .rightSpaceToView(directView,100)
    .topSpaceToView(directView,0)
    .heightIs(40);
    
    UIImageView *arrowImage = [UIImageView new];
    [arrowImage setImage:imageWithName(@"rightjiantou")];
    [directView addSubview:arrowImage];
    
    arrowImage.sd_layout
    .rightSpaceToView(directView,10*widthRate)
    .centerYEqualToView(ztLab)
    .widthIs(12)
    .heightEqualToWidth();
    
    UIButton *ztBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ztBtn addTarget:self action:@selector(clickRecommendEvent) forControlEvents:UIControlEventTouchUpInside];
    [directView addSubview:ztBtn];
    
    ztBtn.sd_layout
    .leftSpaceToView(directView,0)
    .rightSpaceToView(directView,0)
    .topSpaceToView(directView,0)
    .heightIs(40);
    
    UIView *lineVV = [UIView new];
    lineVV.backgroundColor = tableDefSepLineColor;
    [directView addSubview:lineVV];
    
    lineVV.sd_layout
    .leftSpaceToView(directView,0)
    .rightSpaceToView(directView,0)
    .topSpaceToView(directView,40-0.5)
    .heightIs(0.5);
    
    UIView *evaluateView = [UIView new];
    evaluateView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:evaluateView];
    
    evaluateView.sd_layout
    .xIs(0)
    .topSpaceToView(directView,10)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UILabel *evaluateLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10, 200*widthRate, 20)];
    evaluateLab.textColor = contentTitleColorStr;
    self.rewardLab = evaluateLab;
    evaluateLab.font = [UIFont systemFontOfSize:15];
    [evaluateView addSubview:evaluateLab];
    
    [self.myScrollView setupAutoContentSizeWithBottomView:evaluateView bottomMargin:10];
}

-(void)refreshUI{
    if (_currentModel.is_endorse) {
        self.endorseView.hidden = NO;
    }else{
        self.endorseView.hidden = YES;
    }
    self.buyNumber = [_currentModel.cart_num integerValue];
    FLLog(@"%ld",self.buyNumber);
    _gwcBtn.badgeCenterOffset = CGPointMake(-30, 12);
    [_gwcBtn showBadgeWithStyle:WBadgeStyleNumber value:self.buyNumber animationType:WBadgeAnimTypeNone];
    self.collectionBtn.selected = [_currentModel.is_collect boolValue];
    self.cycleScrollView.imageURLStringsGroup = _currentModel.gallery_img;
    self.nameLab.text = _currentModel.goods_name;
    NSString *priceNowStr = [NSString stringWithFormat:@"￥%@",_currentModel.shop_price];
    self.nowPrice.attributedText = [FrankTools setFontSize:[UIFont systemFontOfSize:13] WithString:priceNowStr WithRange:NSMakeRange(0, 1)];
    self.nowPrice.frame = CGRectMake(15*widthRate, 32, 100, 40*widthRate);
    [self.nowPrice sizeToFit];
    
    self.oldPrice.text = [NSString stringWithFormat:@"￥%@",_currentModel.market_price];
    
    CGFloat dwidth = [FrankTools sizeForString:self.oldPrice.text withSizeOfFont:[UIFont systemFontOfSize:13]];
    self.oldPrice.frame = CGRectMake(CGRectGetMaxX(self.nowPrice.frame)+10*widthRate, 32, dwidth, 40*widthRate);
    
    self.priceLine.sd_layout
    .leftSpaceToView(self.oldPrice,-2)
    .rightSpaceToView(self.oldPrice,-2)
    .centerYEqualToView(self.oldPrice)
    .heightIs(0.5);
    
    self.addressLab.text = _currentModel.seller_addr_info;
    
    NSString *recommend_reward = nil;
    if (_currentModel.attr_list.count == 1) {
        ProductAttributionModel *recommendModel = _currentModel.attr_list[0];
        if ([recommendModel.recommend_reward floatValue] == 0) {
            self.directView.hidden = YES;
            self.directView.sd_layout
            .heightIs(0);
            [self.directView updateLayout];
        }else{
            self.directView.hidden = NO;
            self.directView.sd_layout
            .heightIs(40);
            [self.directView updateLayout];
        }
        NSString *rewardLabStr = [NSString stringWithFormat:@"直推奖励：¥%.2f",[recommendModel.recommend_reward floatValue]];
        self.directLab.attributedText = [FrankTools setFontColor:mainColor WithString:rewardLabStr WithRange:NSMakeRange(5, rewardLabStr.length-5)];
    }else if (_currentModel.attr_list.count >1) {
        ProductAttributionModel *recommendModelStart = _currentModel.attr_list[0];
        ProductAttributionModel *recommendModelEnd = _currentModel.attr_list[_currentModel.attr_list.count-1];
        if (recommendModelStart.recommend_reward != recommendModelEnd.recommend_reward) {
            recommend_reward = [NSString stringWithFormat:@"¥%@ - ¥%@",recommendModelEnd.recommend_reward,recommendModelStart.recommend_reward];
            NSString *rewardLabStr = [NSString stringWithFormat:@"直推奖励：%@",recommend_reward];
            self.directLab.attributedText = [FrankTools setFontColor:mainColor WithString:rewardLabStr WithRange:NSMakeRange(5, rewardLabStr.length-5)];
        }else{
            recommend_reward = [NSString stringWithFormat:@"¥%@",recommendModelStart.recommend_reward];
            NSString *rewardLabStr = [NSString stringWithFormat:@"直推奖励：%@",recommend_reward];
            self.directLab.attributedText = [FrankTools setFontColor:mainColor WithString:rewardLabStr WithRange:NSMakeRange(5, rewardLabStr.length-5)];
            if ([recommend_reward floatValue] == 0) {
                self.directView.hidden = YES;
                self.directView.sd_layout
                .heightIs(0);
                [self.directView updateLayout];
            }
        }
    }
    
    self.rewardLab.text = [NSString stringWithFormat:@"商品评价 (%@)",_currentModel.comment_count];
    NSArray *two_comment_list = _currentModel.two_comment_list;
    CGFloat hight = 200;
    if (self.directView.isHidden) {
        hight -= 40;
    }
    if (self.isTok) {
        hight -= 40;
    }
    if (two_comment_list.count>0) {
        NSDictionary *dataDic = two_comment_list[0];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = tableDefSepLineColor;
        [self.myScrollView addSubview:lineView];
        lineView.sd_layout
        .topSpaceToView(self.cycleScrollView,hight)
        .leftSpaceToView(self.myScrollView,0)
        .rightSpaceToView(self.myScrollView,0)
        .heightIs(1);
        
        UIView *evaluationView = [UIView new];
        evaluationView.backgroundColor = [UIColor whiteColor];
        [self.myScrollView addSubview:evaluationView];
        
        evaluationView.sd_layout
        .leftSpaceToView(self.myScrollView,0)
        .rightSpaceToView(self.myScrollView,0)
        .topSpaceToView(lineView,0)
        .heightIs(180);
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 15, 30, 30)];
        headImage.layer.cornerRadius = 15;
        headImage.layer.masksToBounds = YES;
        [FrankTools setImgWithImgView:headImage withImageUrl:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_avatar"]]withPlaceHolderImage:defaultUserHead];
        [evaluationView addSubview:headImage];
        
        UILabel *name = [UILabel new];
        name.font = [UIFont systemFontOfSize:12];
        name.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_name"]];
        name.textColor = contentTitleColorStr1;
        [evaluationView addSubview: name];
        
        name.sd_layout
        .centerYEqualToView(headImage)
        .leftSpaceToView(headImage,15)
        .rightSpaceToView(evaluationView,15*widthRate)
        .heightIs(20*widthRate);
        
        NSString *contentStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content"]];
        
        CGFloat contentHight = [FrankTools getSpaceLabelHeight:contentStr withFont:[UIFont systemFontOfSize:15] withWidth:DeviceMaxWidth-20*widthRate withLineSpacing:4];
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 55, DeviceMaxWidth-20*widthRate, contentHight)];
        content.font = [UIFont systemFontOfSize:15];
        content.numberOfLines = 0;
        content.textColor = contentTitleColorStr;
        content.attributedText = [FrankTools setLineSpaceing:4 WithString:contentStr WithRange:NSMakeRange(0, contentStr.length)];
        [evaluationView addSubview: content];
        
        UILabel *data = [UILabel new];
        data.font = [UIFont systemFontOfSize:12];
        data.text = [FrankTools LongTimeToString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"create_time"]] withFormat:@"YYYY-MM-dd HH:mm:ss"];
        data.textColor = contentTitleColorStr2;
        [evaluationView addSubview:data];
        
        data.sd_layout
        .leftEqualToView(headImage)
        .topSpaceToView(content,10)
        .rightSpaceToView(evaluationView,15)
        .heightIs(20);
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setTitle:@"查看全部评价" forState:UIControlStateNormal];
        [checkBtn setTitleColor:mainColor forState:UIControlStateNormal];
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        checkBtn.layer.borderWidth = 1;
        [checkBtn addTarget:self action:@selector(clickProductAppraiseEvent) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.layer.borderColor = mainColor.CGColor;
        [evaluationView addSubview:checkBtn];
        
        checkBtn.sd_layout
        .centerXEqualToView(evaluationView)
        .topSpaceToView(data,20*widthRate)
        .widthIs(120*widthRate)
        .heightIs(32*widthRate);
        
        UIView *lineV = [UIView new];
        lineV.backgroundColor = tableDefSepLineColor;
        [evaluationView addSubview: lineV];
        
        lineV.sd_layout
        .leftSpaceToView(evaluationView,0)
        .rightSpaceToView(evaluationView,0)
        .topSpaceToView(evaluationView,175)
        .heightIs(1);
        
        hight += 180;
    }
    
    UIView *laView = [UIView new];
    laView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:laView];
    
    laView.sd_layout
    .xIs(0)
    .topSpaceToView(self.cycleScrollView,hight)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UIView *lineVVV = [[UIView alloc] initWithFrame:CGRectMake(40*widthRate, (40-1)/2, DeviceMaxWidth-80*widthRate, 1)];
    lineVVV.backgroundColor = tableDefSepLineColor;
    [laView addSubview:lineVVV];
    UIView *aall = [[UIView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-160)/2, 0*widthRate, 160, 40)];
    aall.backgroundColor = [UIColor whiteColor];
    [laView addSubview:aall];
    
    UILabel *ladong = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 160, 20)];
    ladong.text = @"继续拖动，查看图文详情";
    ladong.textColor = contentTitleColorStr;
    ladong.textAlignment = NSTextAlignmentCenter;
    ladong.font = [UIFont systemFontOfSize:13];
    [aall addSubview:ladong];
    
    NSArray *picArray = _currentModel.goods_desc;
    UIView *imageDeteil = [UIView new];
    if (picArray && picArray.count) {
        __block CGFloat hight = 0;
        [self.myScrollView addSubview:imageDeteil];
        for (int i=0; i<picArray.count; i++) {
            UIImageView *picture = [UIImageView new];
            [picture sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:placeSquareBigImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    CGFloat height = DeviceMaxWidth/image.size.width * image.size.height;
                    picture.frame = CGRectMake(0, hight, DeviceMaxWidth, height);
                    hight += height;
                    [imageDeteil addSubview:picture];
                    imageDeteil.sd_layout
                    .xIs(0)
                    .topSpaceToView(laView,0)
                    .widthIs(DeviceMaxWidth)
                    .heightIs(hight);
                    FLLog(@"hight = %f",hight);
                    [self.myScrollView setupAutoContentSizeWithBottomView:laView bottomMargin:hight];
                }
                if (error) {
                    [self.myScrollView setupAutoContentSizeWithBottomView:laView bottomMargin:hight];
                    return;
                }
            }];
        }
    }else{
        [self.myScrollView setupAutoContentSizeWithBottomView:laView bottomMargin:0];
    }
    [self.myScrollView layoutSubviews];
}

#pragma mark - 点击轮播图片
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    FLLog(@"%ld",index);
    ImageBrowserView *showImage = [[ImageBrowserView alloc] init];
    showImage.currentIndex = index;
    showImage.fetchDataSource = ^{
        return _currentModel.gallery_img;
    };
    [showImage show];
}

#pragma mark - 点击事件
-(void)clickCollectionEvent:(UIButton *)button_{
    if ([FrankTools loginIsOrNot:self]) {
        button_.selected = !button_.selected;
        NSString *httpUrl = @"";
        NSString *tipStr = @"";
        if (button_.selected) {
            httpUrl = PATHShop(@"api/GoodsCollect/addCollect");
            tipStr = @"收藏成功";
        }else {
            httpUrl = PATHShop(@"api/GoodsCollect/cancelCollect");
            tipStr = @"取消成功";
        }
        NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                              @"device_id":[FrankTools getDeviceUUID],
                              @"goods_id":_currentModel.goods_id?_currentModel.goods_id:@""};
        [MainRequest RequestHTTPData:httpUrl parameters:dic success:^(id responseData) {
            [self showHUDWithResult:YES message:tipStr];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

-(void)clickRecommendEvent{
    FLLog(@"点击直推奖励");
    [self clickMoreButtonEvent];
}

-(void)clickToGwcPageEvent{
    if ([FrankTools loginIsOrNot:self]) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *root = (UITabBarController *)app.window.rootViewController;
        NSInteger goToIndex = ModelIndexShoppingCart;
        UINavigationController *nav = [root.viewControllers objectAtIndex:goToIndex];
        [nav popToRootViewControllerAnimated:NO];
        root.selectedIndex = goToIndex;
    }
}

-(void)clickGwcEvent{
    [[ProudctPropertySelectView getInstanceWithNib] showWithProudctID:self.currentModel withCheck:YES selectBuy:^( ProductModel *model) {
            if ([FrankTools loginIsOrNot:self]) {
                [self addGwcCarEvent:model];
        }
    }];
}

-(void)addGwcCarEvent:(ProductModel *)model{
    FLLog(@"%@",model);
    ProductAttributionModel *selectAttModel = model.selectProperty[0];
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"goods_id":[NSString stringWithFormat:@"%@",_currentModel.goods_id],
                          @"seller_id":[NSString stringWithFormat:@"%@",_currentModel.seller_id],
                          @"goods_number":model.selectNum,
                          @"goods_price":[NSString stringWithFormat:@"%f",[selectAttModel.price floatValue]*[model.selectNum integerValue]],
                          @"attr_id":selectAttModel.attr_id};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/addShoppingCart") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        [self showHUDWithResult:YES message:@"添加成功，在购物车中等你"];
        self.buyNumber++;
        [_gwcBtn showBadgeWithStyle:WBadgeStyleNumber value:self.buyNumber animationType:WBadgeAnimTypeNone];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"添加失败，请检查你的网络"];
    }];
}

-(void)clickMoreButtonEvent{
    if ([FrankTools loginIsOrNot:self]) {
        NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                              @"device_id":[FrankTools getDeviceUUID],
                              @"goods_id":self.goods_id?self.goods_id:@""};
        [MainRequest RequestHTTPData:PATHShop(@"api/GoodsShare/createShareLink") parameters:dic success:^(id responseData) {
            FLLog(@"%@",responseData);
            FLLog(@"imageStr=%@ ,urlStr = %@",_currentModel.goods_thumb,_currentModel.goods_detail_url);
            NSString * imageStr = _currentModel.goods_thumb;
            NSString * urlStr = [NSString stringWithFormat:@"%@",[responseData objectForKey:@"goods_detail_url"]];
            NSString * conStr = @"传说，是互联网+时代给大众带来的创富机遇。带朋友看广告，就能赚大钱！";
            NSString * titilStr = _currentModel.goods_name;
            [FrankTools sharedInstance];
            [FrankTools fxViewAppear:imageStr conStr:conStr withUrlStr:urlStr withTitilStr:titilStr withVc:self isAdShare:nil];
        } failed:^(NSDictionary *errorDic) {
        }];
    }
}

-(void)clickShopButtonEvent
{
    SellerShopViewController *sellerShop = [SellerShopViewController new];
    sellerShop.sellerId = [_currentModel.seller_id integerValue];
    [self.navigationController pushViewController:sellerShop animated:YES];
}


-(void)dealBuy:(ProductModel*)model{
    ProductAttributionModel *selectAttModel = model.selectProperty[0];
    NSDictionary *goods = @{@"goods_id":model.goods_id,
                            @"seller_id":model.seller_id,
                            @"goods_number":model.selectNum,
                            @"attr_id":selectAttModel.attr_id};
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[goods] options:NSJSONWritingPrettyPrinted | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"goods_list":resultString};
    [self showHUDWithMessage:@""];
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/sureOrderCart") parameters:dic success:^(id responseData) {
        [self hideHUD];
        NSArray *orderItems = [OrderItemModel parseResponse:responseData];
        RecieveAddressModel *address = nil;
        if ([[responseData objectForKey:@"address_flag"] boolValue]) {
            address = [RecieveAddressModel parseResponse:responseData];
        }
        BOOL addressFlag = [[responseData objectForKey:@"address_flag"] boolValue];
        OrderConfirmViewController *orderConfirm = [[OrderConfirmViewController alloc] init];
        NSString *orderPrice = [NSString stringWithFormat:@"%@",[responseData objectForKey:@"order_money"]];
        orderConfirm.orderItems = [orderItems copy];
        orderConfirm.hidesBottomBarWhenPushed = YES;
        orderConfirm.address = address;
        orderConfirm.orderPrice = orderPrice;
        orderConfirm.addressFlag = addressFlag;
        [self.navigationController pushViewController:orderConfirm animated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
    
    
//    SubmitOrderViewController *orderView = [SubmitOrderViewController new];
//    orderView.product = model;
//    orderView.is_endorse = self.is_endorse;
//    [self.navigationController pushViewController:orderView animated:YES];
}

-(void)clickBuyButtonEvent
{
    if ([FrankTools loginIsOrNot:self]) {
        [self attriButionSelect];
    }
}

-(void)attriButionSelect{
    [[ProudctPropertySelectView getInstanceWithNib] showWithProudctID:self.currentModel withCheck:NO selectBuy:^( ProductModel *model) {
        if ([FrankTools loginIsOrNot:self]) {
            [self dealBuy:model];
        }
    }];
}

-(void)continueDealBuy
{
    [self dealBuy:_currentModel];
}

-(void)clickProductAppraiseEvent
{
    FLLog(@"商品评价");
    /*
    ProductAppraiseView *productView = [ProductAppraiseView new];
    productView.currentModel = _currentModel;
    [self.navigationController pushViewController:productView animated:YES];
    */
    GoodsAppraiseViewController *praiseVc = [GoodsAppraiseViewController new];
    praiseVc.currentModel = self.currentModel;
    [self.navigationController pushViewController:praiseVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
