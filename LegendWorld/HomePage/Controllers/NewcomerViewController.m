//
//  NewcomerViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/13.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "NewcomerViewController.h"

@interface NewcomerViewController ()<UIScrollViewDelegate>

@property(weak,nonatomic)UIScrollView *myScrollView;
@property(weak,nonatomic)UIView *titleLine; //标题下得线
@property(assign,nonatomic)NSInteger nowPage; //当前页

@end

@implementation NewcomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新手教程";
    [self initTitleView];
    [self initFrameView];
}

-(void)initFrameView
{
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth, DeviceMaxHeight-64-40*widthRate)];
    myScrollView.showsVerticalScrollIndicator = YES;
    myScrollView.backgroundColor = viewColor;
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView = myScrollView;
    [self.view addSubview:self.myScrollView];
    
    self.myScrollView.contentSize = CGSizeMake(DeviceMaxWidth*3, CGRectGetHeight(myScrollView.frame));
    [self initContentViewForDo];
    [self initContentViewForWhat];
    [self initContentViewForHow];
}

-(void)initContentViewForWhat
{
    UIScrollView *whatScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DeviceMaxWidth, 0, DeviceMaxWidth, CGRectGetHeight(self.myScrollView.frame))];
    whatScrollView.showsVerticalScrollIndicator = NO;
    whatScrollView.backgroundColor = viewColor;
    [self.myScrollView addSubview:whatScrollView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 15*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"四大收益 轻松赚";
    titleLab.textColor = contentTitleColorStr1;
    [whatScrollView addSubview:titleLab];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setImage:imageWithName(@"main_two_image")];
    [whatScrollView addSubview:imageView];
    
    imageView.sd_layout
    .leftSpaceToView(whatScrollView,0)
    .rightSpaceToView(whatScrollView,0)
    .topSpaceToView(titleLab,10*widthRate)
    .heightIs(205*widthRate);
    
    UILabel *titleText = [UILabel new];
    titleText.textAlignment = NSTextAlignmentLeft;
    titleText.font = [UIFont systemFontOfSize:15];
    titleText.text = @"一、直推广告费";
    titleText.textColor = contentTitleColorStr;
    [whatScrollView addSubview:titleText];
    
    titleText.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(imageView,15*widthRate)
    .heightIs(20*widthRate);
    
    NSString *textLabStr = @"当你用自己的编码推荐朋友下载APP并注册的会员在传说商城购买产品可获得直接广告收益（每个商品奖励额度不等）。";
    UILabel *textLab = [UILabel new];
    textLab.textAlignment = NSTextAlignmentLeft;
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.isAttributedContent = YES;
    textLab.textColor = contentTitleColorStr1;
    [whatScrollView addSubview:textLab];
    textLab.attributedText = [FrankTools setLineSpaceing:4 WithString:textLabStr WithRange:NSMakeRange(0, textLabStr.length)];
    
    textLab.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(titleText,5*widthRate)
    .autoHeightRatio(0);
    
    NSString *ruleLabStr = @"规则：\n1、只要你在当月内购买该商品就能享受该商品的当月及期限内的直推广告费。\n2、当月未购买该商品，不能享受当月的直推广告费，并作废。";
    UILabel *ruleLab = [UILabel new];
    ruleLab.textAlignment = NSTextAlignmentLeft;
    ruleLab.font = [UIFont systemFontOfSize:15];
    ruleLab.isAttributedContent = YES;
    ruleLab.textColor = contentTitleColorStr;
    [whatScrollView addSubview:ruleLab];
    ruleLab.attributedText = [FrankTools setLineSpaceing:4 WithString:ruleLabStr WithRange:NSMakeRange(0, ruleLabStr.length)];
    
    ruleLab.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(textLab,15*widthRate)
    .autoHeightRatio(0);
    
    UILabel *titleConnect = [UILabel new];
    titleConnect.textAlignment = NSTextAlignmentLeft;
    titleConnect.font = [UIFont systemFontOfSize:15];
    titleConnect.text = @"二、关联收益";
    titleConnect.textColor = contentTitleColorStr;
    [whatScrollView addSubview:titleConnect];
    
    titleConnect.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(ruleLab,15*widthRate)
    .heightIs(20*widthRate);
    
    NSString *connectLabStr = @"你只需推荐6人注册传说，根据队列规则，你最多可享受队列里33.5922万人消费的广告费。";
    UILabel *connectLab = [UILabel new];
    connectLab.textAlignment = NSTextAlignmentLeft;
    connectLab.font = [UIFont systemFontOfSize:13];
    connectLab.isAttributedContent = YES;
    connectLab.textColor = contentTitleColorStr1;
    [whatScrollView addSubview:connectLab];
    connectLab.attributedText = [FrankTools setLineSpaceing:4 WithString:connectLabStr WithRange:NSMakeRange(0, connectLabStr.length)];
    
    connectLab.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(titleConnect,5*widthRate)
    .autoHeightRatio(0);
    
    NSString *ruleLabOneStr = @"规则：\n1、传说商城每个产品，商家会提出利润的一部分，用于队列推广收益的分配。\n2、只要你在当月内购买某一类别商品就能享受该类别商品的队列推广收益。";
    UILabel *ruleLabOne = [UILabel new];
    ruleLabOne.textAlignment = NSTextAlignmentLeft;
    ruleLabOne.font = [UIFont systemFontOfSize:15];
    ruleLabOne.isAttributedContent = YES;
    ruleLabOne.textColor = contentTitleColorStr;
    [whatScrollView addSubview:ruleLabOne];
    ruleLabOne.attributedText = [FrankTools setLineSpaceing:4 WithString:ruleLabOneStr WithRange:NSMakeRange(0, ruleLabOneStr.length)];
    
    ruleLabOne.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(connectLab,15*widthRate)
    .autoHeightRatio(0);
    
    UILabel *titleThreeText = [UILabel new];
    titleThreeText.textAlignment = NSTextAlignmentLeft;
    titleThreeText.font = [UIFont systemFontOfSize:15];
    titleThreeText.text = @"三、周分红收益";
    titleThreeText.textColor = contentTitleColorStr;
    [whatScrollView addSubview:titleThreeText];
    
    titleThreeText.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(ruleLabOne,15*widthRate)
    .heightIs(20*widthRate);
    
    NSString *thirdTextLabLabStr = @"购买该类别产品成为品牌代言人，享受该类别产品每周一的广告费收益。";
    UILabel *thirdTextLab = [UILabel new];
    thirdTextLab.textAlignment = NSTextAlignmentLeft;
    thirdTextLab.font = [UIFont systemFontOfSize:13];
    thirdTextLab.isAttributedContent = YES;
    thirdTextLab.textColor = contentTitleColorStr1;
    [whatScrollView addSubview:thirdTextLab];
    thirdTextLab.attributedText = [FrankTools setLineSpaceing:4 WithString:thirdTextLabLabStr WithRange:NSMakeRange(0, thirdTextLabLabStr.length)];
    
    thirdTextLab.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(titleThreeText,5*widthRate)
    .autoHeightRatio(0);
    
    NSString *thirdRuleLabStr = @"规则：\n1、获得每周一的广告费收益必须要购买（代言）产品，才能享受获得。\n2、会员购买（代言）产品占位，以购买时间先后排序，由左至右，系统自动排序，占位越前获广告费时间越早。\n3、每个类别产品必须在代言周期内才能获得广告费，在代言周期内续购产品，代言周期自动延长。举例：A产品代言周期为30天，你在8月1日首次购买（代言）A产品，当你在8月15日再次购买该产品，你的代言周期自动延长至45天。\n4、会员每推荐一位购买，享受一层广告收益.......推荐六位购买，享受六层广告收益。";
    UILabel *thirdRuleLab = [UILabel new];
    thirdRuleLab.textAlignment = NSTextAlignmentLeft;
    thirdRuleLab.font = [UIFont systemFontOfSize:15];
    thirdRuleLab.isAttributedContent = YES;
    thirdRuleLab.textColor = contentTitleColorStr;
    [whatScrollView addSubview:thirdRuleLab];
    thirdRuleLab.attributedText = [FrankTools setLineSpaceing:4 WithString:thirdRuleLabStr WithRange:NSMakeRange(0, thirdRuleLabStr.length)];
    
    thirdRuleLab.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(thirdTextLab,15*widthRate)
    .autoHeightRatio(0);
    
    UILabel *titleFourText = [UILabel new];
    titleFourText.textAlignment = NSTextAlignmentLeft;
    titleFourText.font = [UIFont systemFontOfSize:15];
    titleFourText.text = @"四、看广告收益";
    titleFourText.textColor = contentTitleColorStr;
    [whatScrollView addSubview:titleFourText];
    
    titleFourText.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(thirdRuleLab,15*widthRate)
    .heightIs(20*widthRate);
    
    NSString *fourTextStr = @"看平台福利广告，获取主动收益和被动收益。";
    UILabel *fourTextLab = [UILabel new];
    fourTextLab.textAlignment = NSTextAlignmentLeft;
    fourTextLab.font = [UIFont systemFontOfSize:13];
    fourTextLab.isAttributedContent = YES;
    fourTextLab.textColor = contentTitleColorStr1;
    [whatScrollView addSubview:fourTextLab];
    fourTextLab.attributedText = [FrankTools setLineSpaceing:4 WithString:fourTextStr WithRange:NSMakeRange(0, fourTextStr.length)];
    
    fourTextLab.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(titleFourText,5*widthRate)
    .autoHeightRatio(0);
    
    NSString *ruleLabThreeStr = @"规则：\n1、当你购买（代言），即可看福利广告，获取主动广告费收益。\n2、当你六层关联会员购买（代言）后看福利广告，你可获得被动广告收益。";
    UILabel *ruleLabThree = [UILabel new];
    ruleLabThree.textAlignment = NSTextAlignmentLeft;
    ruleLabThree.font = [UIFont systemFontOfSize:15];
    ruleLabThree.isAttributedContent = YES;
    ruleLabThree.textColor = contentTitleColorStr;
    [whatScrollView addSubview:ruleLabThree];
    ruleLabThree.attributedText = [FrankTools setLineSpaceing:4 WithString:ruleLabThreeStr WithRange:NSMakeRange(0, ruleLabThreeStr.length)];
    
    ruleLabThree.sd_layout
    .leftSpaceToView(whatScrollView,10*widthRate)
    .rightSpaceToView(whatScrollView,10*widthRate)
    .topSpaceToView(fourTextLab,15*widthRate)
    .autoHeightRatio(0);
    
    [whatScrollView setupAutoContentSizeWithBottomView:ruleLabThree bottomMargin:10*widthRate];
}

-(void)initContentViewForHow
{
    UIScrollView *howScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DeviceMaxWidth*2, 0, DeviceMaxWidth, CGRectGetHeight(self.myScrollView.frame))];
    howScrollView.showsVerticalScrollIndicator = NO;
    howScrollView.backgroundColor = viewColor;
    [self.myScrollView addSubview:howScrollView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 15*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"只需三步 轻松收益";
    titleLab.textColor = contentTitleColorStr1;
    [howScrollView addSubview:titleLab];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setImage:imageWithName(@"main_four_image")];
    [howScrollView addSubview:imageView];
    
    imageView.sd_layout
    .leftSpaceToView(howScrollView,0)
    .rightSpaceToView(howScrollView,0)
    .topSpaceToView(titleLab,10*widthRate)
    .heightIs(215*widthRate);
    
    NSString *textLabStr = @"组建自己的队列，用自己的邀请码邀请6个好友下载APP并注册为会员，成为之间的队列的前面会员。\n\n帮助自己队列前排的6人，组建自己的队列。\n\n购买（代言）产品，参与四大广告收益。";
    UILabel *textLab = [UILabel new];
    textLab.textAlignment = NSTextAlignmentLeft;
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.isAttributedContent = YES;
    textLab.textColor = contentTitleColorStr1;
    [howScrollView addSubview:textLab];
    textLab.attributedText = [FrankTools setLineSpaceing:4 WithString:textLabStr WithRange:NSMakeRange(0, textLabStr.length)];
    
    textLab.sd_layout
    .leftSpaceToView(howScrollView,10*widthRate)
    .rightSpaceToView(howScrollView,10*widthRate)
    .topSpaceToView(imageView,15*widthRate)
    .autoHeightRatio(0);
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inviteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    inviteBtn.layer.cornerRadius = 8;
    inviteBtn.layer.masksToBounds = YES;
    inviteBtn.backgroundColor = mainColor;
    [inviteBtn addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    [howScrollView addSubview:inviteBtn];
    
    CGFloat hight = 0;
    if (iPhone6And7 || iPhone6And7plus || iPhone5) {
        hight = 100*widthRate;
    }else{
        hight = 50*widthRate;
    }
    
    inviteBtn.sd_layout
    .centerXEqualToView(howScrollView)
    .topSpaceToView(textLab,hight)
    .widthIs(DeviceMaxWidth-80*widthRate)
    .heightIs(40*widthRate);
    
    [howScrollView setupAutoContentSizeWithBottomView:inviteBtn bottomMargin:20*widthRate];
}

-(void)clickShareButton{
    NSString * imageStr = PATH(@"public/images/1.jpg");
    NSString *urlStr = [NSString stringWithFormat:@"%@",PATH(@"Home/ad/invitdetail")];
    NSString * conStr = @"传说，是互联网+时代给大众带来的创富机遇。带朋友看广告，就能赚大钱！";
    NSString * titilStr = @"分享邀请详情";
    [FrankTools sharedInstance];
    [FrankTools fxViewAppear:imageStr conStr:conStr withUrlStr:urlStr withTitilStr:titilStr withVc:self isAdShare:nil];
}

-(void)initContentViewForDo
{
    UIScrollView *doScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, CGRectGetHeight(self.myScrollView.frame))];
    doScrollView.showsVerticalScrollIndicator = NO;
    doScrollView.backgroundColor = viewColor;
    [self.myScrollView addSubview:doScrollView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 15*widthRate, DeviceMaxWidth-20*widthRate, 20*widthRate)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"购买即赚钱";
    titleLab.textColor = contentTitleColorStr1;
    [doScrollView addSubview:titleLab];
    
    UIImageView *imageView = [UIImageView new];
    [imageView setImage:imageWithName(@"main_one_image")];
    [doScrollView addSubview:imageView];
    
    imageView.sd_layout
    .leftSpaceToView(doScrollView,0)
    .rightSpaceToView(doScrollView,0)
    .topSpaceToView(titleLab,10*widthRate)
    .heightIs(185*widthRate);
    
    UILabel *titleText = [UILabel new];
    titleText.textAlignment = NSTextAlignmentLeft;
    titleText.font = [UIFont systemFontOfSize:15];
    titleText.text = @"专注健康安全的购物APP";
    titleText.textColor = contentTitleColorStr;
    [doScrollView addSubview:titleText];
    
    titleText.sd_layout
    .leftSpaceToView(doScrollView,10*widthRate)
    .rightSpaceToView(doScrollView,10*widthRate)
    .topSpaceToView(imageView,15*widthRate)
    .heightIs(20*widthRate);
    
    NSString *textLabStr = @"传说全球甄选安全健康的快消产品，找到产品源头，与商家达成合作，直供用户。传说在保证产品品质的同时，帮助商家省掉中间环节，降低营销成本。";
    UILabel *textLab = [UILabel new];
    textLab.textAlignment = NSTextAlignmentLeft;
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.isAttributedContent = YES;
    textLab.textColor = contentTitleColorStr1;
    [doScrollView addSubview:textLab];
    textLab.attributedText = [FrankTools setLineSpaceing:4 WithString:textLabStr WithRange:NSMakeRange(0, textLabStr.length)];
    
    textLab.sd_layout
    .leftSpaceToView(doScrollView,10*widthRate)
    .rightSpaceToView(doScrollView,10*widthRate)
    .topSpaceToView(titleText,5*widthRate)
    .autoHeightRatio(0);
    
    UILabel *titleTextOne = [UILabel new];
    titleTextOne.textAlignment = NSTextAlignmentLeft;
    titleTextOne.font = [UIFont systemFontOfSize:15];
    titleTextOne.text = @"低成本、零风险的创业平台";
    titleTextOne.textColor = contentTitleColorStr;
    [doScrollView addSubview:titleTextOne];
    
    titleTextOne.sd_layout
    .leftSpaceToView(doScrollView,10*widthRate)
    .rightSpaceToView(doScrollView,10*widthRate)
    .topSpaceToView(textLab,15*widthRate)
    .heightIs(20*widthRate);
    
    NSString *textLabOneStr = @"传说是一个大众参与轻松创业的平台，将个人的碎片时间充分利用，通过分享实现价值。用户帮助商家进行口碑宣传，快速获得销量，商家将广告费返还用户，用户实现轻松收益。你购买产品后，将优质的产品体验分享给6位好友，好友下载注册APP后，购买产品，你将获得多项广告收益。同时，你好友推荐的好友购买产品后，你同样会获得被动广告收入，最多可获得33万多人的关联广告收益。传说让创业不在艰难，快乐分享，重复收益，每天递增，一劳永逸，真正做到消费致富。";
    UILabel *textLabOne = [UILabel new];
    textLabOne.textAlignment = NSTextAlignmentLeft;
    textLabOne.font = [UIFont systemFontOfSize:13];
    textLabOne.isAttributedContent = YES;
    textLabOne.textColor = contentTitleColorStr1;
    [doScrollView addSubview:textLabOne];
    textLabOne.attributedText = [FrankTools setLineSpaceing:4 WithString:textLabOneStr WithRange:NSMakeRange(0, textLabOneStr.length)];
    
    textLabOne.sd_layout
    .leftSpaceToView(doScrollView,10*widthRate)
    .rightSpaceToView(doScrollView,10*widthRate)
    .topSpaceToView(titleTextOne,5*widthRate)
    .autoHeightRatio(0);
    
    UILabel *titleTextTwo = [UILabel new];
    titleTextTwo.textAlignment = NSTextAlignmentLeft;
    titleTextTwo.font = [UIFont systemFontOfSize:15];
    titleTextTwo.text = @"带着社会责任与使命的企业";
    titleTextTwo.textColor = contentTitleColorStr;
    [doScrollView addSubview:titleTextTwo];
    
    titleTextTwo.sd_layout
    .leftSpaceToView(doScrollView,10*widthRate)
    .rightSpaceToView(doScrollView,10*widthRate)
    .topSpaceToView(textLabOne,15*widthRate)
    .heightIs(20*widthRate);
    
    NSString *textLabTwoStr = @"传说建立商家与用户的管道，构建个人与商家的、个人与个人之间的链接，提升企业经济，帮助大众创业，提升整个社会经济运作效率，实现全民健康消费、共同创富的宏伟目标。";
    UILabel *textLabTwo = [UILabel new];
    textLabTwo.textAlignment = NSTextAlignmentLeft;
    textLabTwo.font = [UIFont systemFontOfSize:13];
    textLabTwo.isAttributedContent = YES;
    textLabTwo.textColor = contentTitleColorStr1;
    [doScrollView addSubview:textLabTwo];
    textLabTwo.attributedText = [FrankTools setLineSpaceing:4 WithString:textLabTwoStr WithRange:NSMakeRange(0, textLabTwoStr.length)];
    
    textLabTwo.sd_layout
    .leftSpaceToView(doScrollView,10*widthRate)
    .rightSpaceToView(doScrollView,10*widthRate)
    .topSpaceToView(titleTextTwo,5*widthRate)
    .autoHeightRatio(0);
    
    [doScrollView setupAutoContentSizeWithBottomView:textLabTwo bottomMargin:10*widthRate];
    
}

-(void)initTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    NSArray *titilArray = @[@"传说做什么?",@"有什么收益?",@"我该怎么做?"];
    CGFloat titleWith = DeviceMaxWidth/3;
    for (int i=0; i<titilArray.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(i*titleWith, 0, titleWith, 40*widthRate);
        [titleBtn setTitle:titilArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:mainColor forState:UIControlStateSelected];
        titleBtn.tag = i+100;
        [titleBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(clickTitleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleView addSubview:titleBtn];
        
        if (i == 0){
            titleBtn.selected = YES;
        }
    }
    
    UIView *titleLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40*widthRate-2, DeviceMaxWidth/3, 2)];
    titleLine.backgroundColor = mainColor;
    self.titleLine = titleLine;
    [titleView addSubview:self.titleLine];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat pageWidth = DeviceMaxWidth;
    // 根据当前的x坐标和页宽度计算出当前页数
    
    if (scrollView == self.myScrollView) {
        if ((int)scrollView.contentOffset.x%(int)DeviceMaxWidth == 0) {
            int itemIndex = (scrollView.contentOffset.x + DeviceMaxWidth * 0.5) / DeviceMaxWidth;
            int indexOnPageControl = itemIndex % 3;
            self.nowPage = indexOnPageControl;
            FLLog(@"%d",indexOnPageControl);
            [self setTitleView];
        }
    }
}

#pragma mark - clickTitleButtonEvent
-(void)clickTitleButtonEvent:(UIButton *)button_
{
    if (button_.selected) {
        return;
    }
    for (int i=0; i<3; i++) {
        if (i == button_.tag-100) {
            button_.selected = YES;
        }else{
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+100];
            btn.selected = NO;
        }
    }
    self.myScrollView.contentOffset = CGPointMake(DeviceMaxWidth*(button_.tag-100), 0);
}

-(void)setTitleView
{
    UIButton *button_ = [self.view viewWithTag:self.nowPage+100];
    for (int i=0; i<3; i++) {
        if (i == self.nowPage) {
            [UIView animateWithDuration:0.2 animations:^{
                button_.selected = YES;
                self.titleLine.sd_layout
                .leftEqualToView(button_)
                .rightEqualToView(button_);
                [self.titleLine updateLayout];
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                UIButton *btn = (UIButton *)[self.view viewWithTag:i+100];
                btn.selected = NO;
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
