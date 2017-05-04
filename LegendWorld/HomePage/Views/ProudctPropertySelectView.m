//
//  ProudctPropertySelectView.m
//  legend
//
//  Created by heyk on 16/1/13.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "ProudctPropertySelectView.h"
//#import "ProductPropertyModel.h"
//#import "UIView+HUD.h"
#import "UIImageView+WebCache.h"
#import "ProductModel.h"

#define SYS_UI_COLOR(r,g,b,a)               [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define SYS_UI_COLOR_TEXT_BLACK          SYS_UI_COLOR(101, 101, 101, 1)
@interface PropertyButton : UIButton

@property (nonatomic,strong)UIColor *normalBackGroudColor;
@property (nonatomic,strong)UIColor *normalTextColor;

@property (nonatomic,strong)UIColor *selectBackGroudColor;
@property (nonatomic,strong)UIColor *selectTextColor;
@property (nonatomic,strong)UIColor *invailedBackGroundColor;

@property (nonatomic,strong)NSString *strKey;
@property (nonatomic,strong)id model;

@end


@implementation PropertyButton

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:_selectBackGroudColor];
        [self setTitleColor:_selectTextColor forState:UIControlStateNormal];
        
        [self setFlat:self radius:1 color:nil borderWith:0];
    }
    else {
        [self setBackgroundColor:_normalBackGroudColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
    }
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        [self setBackgroundColor:_normalBackGroudColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
    }
    else{
        [self setBackgroundColor:_invailedBackGroundColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
    }
}


-(void)setNormalBackGroudColor:(UIColor *)normalBackGroudColor{
    _normalBackGroudColor = normalBackGroudColor;
    [self setBackgroundColor:normalBackGroudColor];
    [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
}

-(void)setNormalTextColor:(UIColor *)normalTextColor{
    
    _normalTextColor = normalTextColor;
    [self setTitleColor:normalTextColor forState:UIControlStateNormal];
}

-(void)setFlat:(UIView*)view radius:(CGFloat)radius color:(UIColor*)color borderWith:(CGFloat)borderWith
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:radius];
    [downButtonLayer setBorderWidth:borderWith];
    [downButtonLayer setBorderColor:[color CGColor]];
}
@end




@interface ProudctPropertySelectView()


@property (nonatomic,strong)UILabel *prountNumLabel;
@property (nonatomic,strong)ProductAttributionModel* selectModel;

@end


@implementation ProudctPropertySelectView{
    
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+(ProudctPropertySelectView*)getInstanceWithNib{
    ProudctPropertySelectView *view = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"ProudctPropertySelectView" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[ProudctPropertySelectView class]]){
            view = (ProudctPropertySelectView *)obj;
            view.frame = [UIScreen mainScreen].bounds;
            break;
        }
    }
    return view;
}


-(void)setUI{
    
    
    _buyButton.backgroundColor = mainColor;
    
    if ([self.currentModel.goods_number intValue]>0) {
        _currentModel.selectNum = @"1";
    }
    else{
        _buyButton.enabled = NO;
        _buyButton.backgroundColor = buttonGrayColor;
    }
    float height = 0;
    
    // for (int i = 0;i<_currentModel.buy_attr_list.count;i++) {
    
    //        ProductAttributionModel *model =  [_currentModel.buy_attr_list objectAtIndex:i];
    //
    //
    //        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, height, DeviceMaxWidth - 24, 50)];
    //        titleLabel.textColor = UIColorFromRGB(0x444444);
    //        titleLabel.text = model.attr_name;
    //        titleLabel.font = [UIFont fontWithName:SYS_UI_FONT_BASE size:14];
    //        [_scrollContentView addSubview:titleLabel];
    //
    //        height+=titleLabel.frame.size.height;
    
    
    NSArray *array = _currentModel.attr_list;
    
    float leading = 12;
    float h = 35;
    
    PropertyButton *lastButton = nil;
    
    for (int j = 0; j<array.count; j++) {
        
        PropertyButton *button = [PropertyButton buttonWithType:UIButtonTypeCustom];
        button.normalBackGroudColor = [UIColor  whiteColor];
        button.normalTextColor = SYS_UI_COLOR_TEXT_BLACK;
        button.selectBackGroudColor = mainColor;
        button.selectTextColor = [UIColor whiteColor];
        button.invailedBackGroundColor = contentTitleColorStr;
        
        ProductAttributionModel *attrModel = [array objectAtIndex:j];
        
        // button.strKey = titleLabel.text;
        button.model = attrModel;
        
        NSString *content = attrModel.attr_name;
        [button setTitle:content forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scrollContentView addSubview:button];
        
//        CGSize size = [content sizeWithFont:button.titleLabel.font byHeight:h];
        NSStringDrawingOptions optional = NSStringDrawingUsesLineFragmentOrigin;
        CGSize sizex = CGSizeMake(CGFLOAT_MAX,h);
        
        NSDictionary *dic=@{NSFontAttributeName:button.titleLabel.font, NSForegroundColorAttributeName : SYS_UI_COLOR_TEXT_BLACK};
        
        CGRect labelsize =  [content boundingRectWithSize:sizex
                                               options:optional
                                            attributes:dic
                                               context:nil];
        CGSize size = labelsize.size;
        size.width += leading*2;//24为按钮内容边距
        
        if (size.width>DeviceMaxWidth - leading*2) {
            size.width = DeviceMaxWidth -leading*2;
        }
        
        if (lastButton) {
            if (size.width> DeviceMaxWidth  - lastButton.frame.origin.x - lastButton.frame.size.width - leading) {
                height=height + h + leading;
                button.frame = CGRectMake(leading, lastButton.frame.origin.y+ h + leading, size.width, h);
            }
            else{
                button.frame =  CGRectMake(lastButton.frame.origin.x + lastButton.frame.size.width + leading, lastButton.frame.origin.y , size.width, h);
            }
        }
        else{
            button.frame = CGRectMake(leading,  height+ leading, size.width, h);
            height = height + h + leading;
        }
        
        lastButton = button;
        
        
        [button addTarget:self action:@selector(selectProperty:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    height +=leading;
    
    UIView *spearteLine = [[UIView alloc] initWithFrame:CGRectMake(12, height, DeviceMaxWidth-24, 1)];
    spearteLine.backgroundColor = viewColor;
    [_scrollContentView addSubview:spearteLine];
    
    height+=1;
    //  }
    
    height+=10;
    
    UILabel *buyCountLabel =  [[UILabel alloc] initWithFrame:CGRectMake(12, height, DeviceMaxWidth-24, 50)];
    buyCountLabel.textColor = [UIColor colorFromHexRGB:@"444444"];
    buyCountLabel.text = @"购买数量";
    buyCountLabel.font = [UIFont systemFontOfSize:14];
    [_scrollContentView addSubview:buyCountLabel];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"add_count"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(DeviceMaxWidth - 44 , height, 44, 50);
    [addButton addTarget:self action:@selector(addPrountCount:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContentView addSubview:addButton];
    
    
    UIView *spearte1 = [[UIView alloc] initWithFrame:CGRectMake(addButton.frame.origin.x - 1, addButton.frame.origin.y + 10, 1, 30)];
    spearte1.backgroundColor = viewColor;
    [_scrollContentView addSubview:spearte1];
    
    self.prountNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(spearte1.frame.origin.x - 44, addButton.frame.origin.y, 44, 50)];
    self.prountNumLabel.textAlignment = NSTextAlignmentCenter;
    self.prountNumLabel.text = @"1";
    _prountNumLabel.font = [UIFont systemFontOfSize:14];
    [_scrollContentView addSubview:_prountNumLabel];
    
    UIView *spearte2 = [[UIView alloc] initWithFrame:CGRectMake(_prountNumLabel.frame.origin.x - 1, buyCountLabel.frame.origin.y + 10, 1, 30)];
    spearte2.backgroundColor = viewColor;
    [_scrollContentView addSubview:spearte2];
    
    
    UIButton *decressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [decressButton setImage:[UIImage imageNamed:@"decrease_count"] forState:UIControlStateNormal];
    decressButton.frame = CGRectMake(spearte2.frame.origin.x - 44 , height, 44, 50);
    [decressButton addTarget:self action:@selector(decresePrountCount:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContentView addSubview:decressButton];
    
    height +=50;
    
    _scrollContentHeight.constant = height -  275;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_currentModel.goods_thumb] placeholderImage:placeSquareImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

-(void)showWithProudctID:(ProductModel*)model withCheck:(BOOL)isCarShop selectBuy:(ProudctPropertySelectBuyBlock)block{
    
    self.buyBlock = block;
    self.currentModel = model;
    self.titleLabel.text = [NSString stringWithFormat:@"¥%@",model.shop_price];//model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"库存：%@",model.goods_number];
    
//    if (_currentModel.is_endorse && is_checkEndorse == NO && _currentModel.is_exist_brand_endorse == NO) {
//        [self.buyButton setTitle:@"我要代言" forState:UIControlStateNormal];
//    }else{
//        [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
//    }
    //self.priceLabel.text = @"¥0.00";
    if (isCarShop) {
        [self.buyButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    }else{
        [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    [self setUI];
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [view addSubview:self];
    [_contentView layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _contentBottom.constant = 0;
                         [_contentView layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
}

-(void)dismiss{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _contentBottom.constant = -440;
                         [_contentView layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}


-(IBAction)clickBuy:(id)sender{
    if ([self checkAllSelect]) {
        
        if (self.buyBlock) {
           
            
            if (self.selectModel) {//有选择属性
                _currentModel.selectProperty = @[self.selectModel];
                 _currentModel.attr_id = self.selectModel.attr_id;
            }
            
            self.buyBlock(_currentModel);
        }
        [self dismiss];
    }
}

-(IBAction)clickClose:(id)sender{
    [self dismiss];
}



-(void)selectProperty:(PropertyButton*)button{
    
    
    button.selected = !button.selected;
    [self checkSelectStatus:button];
    
    if (button.selected) {
        self.selectModel = button.model;
    }
    else{
        self.selectModel = nil;
    }
    
}

-(void)addPrountCount:(UIButton*)button{
    
    int maxCount = [_currentModel.goods_number intValue];
    if (_selectModel) {
        maxCount = [_selectModel.goods_number intValue];
    }
    if([self.prountNumLabel.text intValue] < maxCount){
        self.prountNumLabel.text = [NSString stringWithFormat:@"%d",[self.prountNumLabel.text intValue] + 1];
        
        _currentModel.selectNum = self.prountNumLabel.text;
        
        self.titleLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_selectModel.price floatValue] * [_currentModel.selectNum intValue]];
        
        if (!_selectModel.price)
        {
            self.titleLabel.text = [NSString stringWithFormat:@"¥%0.2f", [_currentModel.shop_price floatValue] * [_currentModel.selectNum intValue]];
        }
    }
    
    if([_currentModel.selectNum intValue] <= 0){
        
        _buyButton.enabled = NO;
        _buyButton.backgroundColor = buttonGrayColor;
    }
    else{
        _buyButton.enabled = YES;
        _buyButton.backgroundColor = mainColor;
    }
}

-(void)decresePrountCount:(UIButton*)button{
    

    if ([self.prountNumLabel.text intValue]>1) {
        self.prountNumLabel.text = [NSString stringWithFormat:@"%d",[self.prountNumLabel.text intValue] - 1];
        _currentModel.selectNum = self.prountNumLabel.text;
        
        self.titleLabel.text = [NSString stringWithFormat:@"¥%0.2f",[_selectModel.price floatValue] * [_currentModel.selectNum intValue]];
    }
    
    if (!_selectModel.price)
    {
        self.titleLabel.text = [NSString stringWithFormat:@"¥%0.2f", [_currentModel.shop_price floatValue] * [_currentModel.selectNum intValue]];
    }
    
    if([_currentModel.selectNum intValue] <= 0){
        
        _buyButton.enabled = NO;
        _buyButton.backgroundColor = buttonGrayColor;
    }
    else{
        _buyButton.enabled = YES;
        _buyButton.backgroundColor = mainColor;
    }
    
}

//取消同类别中已经选择的状态
-(void)checkSelectStatus:(PropertyButton*)button{
    NSArray *views = _scrollContentView.subviews;
    for (UIView *view in views) {
        
        if ([view isKindOfClass:[PropertyButton class]] && ![button isEqual:view]) {
            
            PropertyButton *temp = (PropertyButton*)view;
            
            if(view != button){
               // ProductAttributionModel *attrModel = temp.model;
                
                if (temp.selected) {
                   // price = price - [attrModel.price floatValue];
                    temp.selected = NO;
                }
            }
        }
    }
    
    if (button.selected) {
        
        ProductAttributionModel *attrModel = button.model;
        
        
        if ([_currentModel.selectNum intValue]>[attrModel.goods_number intValue]) {
            _currentModel.selectNum = [NSString stringWithFormat:@"%@",attrModel.goods_number];
        }
        else if([_currentModel.selectNum intValue] == 0 && [attrModel.goods_number intValue]>0 ){
            _currentModel.selectNum = @"1";
        }
        self.prountNumLabel.text = [NSString stringWithFormat:@"%d",[_currentModel.selectNum intValue]];
        self.titleLabel.text = [NSString stringWithFormat:@"¥%0.2f",[attrModel.price floatValue] * [_prountNumLabel.text intValue]];
        self.priceLabel.text = [NSString stringWithFormat:@"库存：%@",attrModel.goods_number];
    }
    if([_currentModel.selectNum intValue] <= 0){
        
        _buyButton.enabled = NO;
        _buyButton.backgroundColor = buttonGrayColor;
    }
    else{
        _buyButton.enabled = YES;
        _buyButton.backgroundColor = mainColor;
    }

    
}

-(BOOL)checkAllSelect{
    
    if(_currentModel.attr_list && _currentModel.attr_list.count > 0 && !self.selectModel) {
        
//        [self showHint :@"请选择要购买的产品属性"];
        
        return NO;
        
    }
    return YES;
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
