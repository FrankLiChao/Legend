//
//  BillboardViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/14.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BillboardViewController.h"
#import "BillBoardTableViewCell.h"
#import "MainRequest.h"
#import "MJExtension.h"
#import "BillboardDetaiViewController.h"

@interface BillboardViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)BillboardModel *richesModel;
@property(nonatomic,strong)BillboardModel *nowModel;
@property(nonatomic,strong)BillboardModel *recommendModel;
@property(nonatomic,weak)UITableView *richesTableView;//财富榜
@property(nonatomic,weak)UITableView *nowTableView; //新人榜
@property(nonatomic,weak)UITableView *recommendTableView;
@property(nonatomic,weak)UIScrollView *myScrollView;
@property(nonatomic,weak)UIView *titleLine;
@property(nonatomic,assign)NSInteger nowPage;

@end

@implementation BillboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排行榜";
    [self initData];
    [self initTitleView];
    [self initRichesView];

}

-(void)initData
{
    self.nowPage = 0;
    self.richesModel = [BillboardModel new];
    self.nowModel = [BillboardModel new];
    self.recommendModel = [BillboardModel new];
}

-(void)requestData
{
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID]};
    NSString *HttpURLStr = nil;
    if (self.nowPage == 0) {
        HttpURLStr = PATH(@"api/RankList/incomeRankList");
    } else if (self.nowPage == 1) {
        HttpURLStr = PATH(@"api/RankList/newUserRankList");
    } else {
        HttpURLStr = PATH(@"api/RankList/recommendRankList");
    }
    [self hideHUD];
    [MainRequest RequestHTTPData:HttpURLStr parameters:dic success:^(id responseData) {
        BillboardModel *model = [BillboardModel mj_objectWithKeyValues:responseData];
        model.week_rank_list = [WeekRankModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"week_rank_list"]];
        model.month_rank_list = [MonthRankModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"month_rank_list"]];
        if (model) {
            if (self.nowPage == 0) {
                self.richesModel = model;
            } else if (self.nowPage == 1) {
                self.nowModel = model;
            } else {
                self.recommendModel = model;
            }
            [self reloadTableView];
        }
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)reloadTableView
{
    if (self.nowPage == 0) {
        self.richesTableView.delegate = self;
        self.richesTableView.dataSource = self;
        [self.richesTableView reloadData];
    }else if (self.nowPage == 1) {
        self.nowTableView.delegate = self;
        self.nowTableView.dataSource = self;
        [self.nowTableView reloadData];
    }else{
        self.recommendTableView.delegate = self;
        self.recommendTableView.dataSource = self;
        [self.recommendTableView reloadData];
    }
}

-(void)initTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    NSArray *titilArray = @[@"财富榜",@"新人榜",@"推荐榜"];
    CGFloat titleWith = DeviceMaxWidth/3;
    for (int i=0; i<titilArray.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(i*titleWith, 0, titleWith, 40*widthRate);
        [titleBtn setTitle:titilArray[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:mainColor forState:UIControlStateSelected];
        titleBtn.tag = i+100;
        [titleBtn setTitleColor:contentTitleColorStr1 forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(clickBillboardTitleEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40*widthRate, DeviceMaxWidth, DeviceMaxHeight-64-40*widthRate)];
    myScrollView.showsVerticalScrollIndicator = YES;
    myScrollView.backgroundColor = viewColor;
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView = myScrollView;
    [self.view addSubview:self.myScrollView];
    
    myScrollView.contentSize = CGSizeMake(DeviceMaxWidth*3, CGRectGetHeight(myScrollView.frame));
}

-(void)initFrameView
{
    [self initRichesView];
    [self initNewTableView];
    [self initRecommendTableView];
}

-(void)initRichesView
{
    if (!self.richesTableView) {
        UITableView *richesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, CGRectGetHeight(self.myScrollView.frame)) style:UITableViewStylePlain];
//        richesTableView.delegate = self;
//        richesTableView.dataSource = self;
        richesTableView.showsVerticalScrollIndicator = NO;
        richesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.richesTableView = richesTableView;
        [self.myScrollView addSubview:self.richesTableView];
        self.nowPage = 0;
        [self requestData];
    }
}

-(void)initNewTableView
{
    if (!self.nowTableView) {
        UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(DeviceMaxWidth, 0, DeviceMaxWidth, CGRectGetHeight(self.myScrollView.frame)) style:UITableViewStylePlain];
//        newTableView.delegate = self;
//        newTableView.dataSource = self;
        newTableView.showsVerticalScrollIndicator = NO;
        newTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.nowTableView = newTableView;
        [self.myScrollView addSubview:self.nowTableView];
        self.nowPage = 1;
        [self requestData];
    }
}

-(void)initRecommendTableView
{
    if (!self.recommendTableView) {
        UITableView *recommendTableView = [[UITableView alloc] initWithFrame:CGRectMake(DeviceMaxWidth*2, 0, DeviceMaxWidth, CGRectGetHeight(self.myScrollView.frame)) style:UITableViewStylePlain];
//        recommendTableView.delegate = self;
//        recommendTableView.dataSource = self;
        recommendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        recommendTableView.showsVerticalScrollIndicator = NO;
        self.recommendTableView = recommendTableView;
        [self.myScrollView addSubview:self.recommendTableView];
        self.nowPage = 2;
        [self requestData];
    }
}

#pragma mark - UItabViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BillboardModel *model = [BillboardModel new];
    NSInteger count = 0;
    if (tableView == self.richesTableView) {
        model = self.richesModel;
    }else if (tableView == self.nowTableView) {
        model = self.nowModel;
    }else {
        model = self.recommendModel;
    }
    if (section == 0) {
        count = model.week_rank_list.count;
    }else {
        count = model.month_rank_list.count;
    }
    if (count > 10) {
        return 10;
    }else{
        return count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 80)];
    hView.backgroundColor = viewColor;
    
    UILabel *weekLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth-20*widthRate, 40)];
    if (section == 0) {
        weekLab.text = @"本周";
        UIButton *weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [weekButton setTitleColor:mainColor forState:UIControlStateNormal];
        weekButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [weekButton setTitleColor:[UIColor colorFromHexRGB:@"ff6f21"] forState:UIControlStateNormal];
        [weekButton setImage:imageWithName(@"home_more_image") forState:UIControlStateNormal];
        [weekButton setTitle:@"更多" forState:UIControlStateNormal];
        [weekButton addTarget:self action:@selector(clickMoreButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [hView addSubview:weekButton];
        weekButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
        weekButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        weekButton.sd_layout
        .rightSpaceToView(hView,10*widthRate)
        .xIs(0)
        .widthIs(65)
        .heightIs(40);
        
    }else{
        weekLab.text = @"本月";
        UIButton *monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        monthButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [monthButton setTitle:@"更多" forState:UIControlStateNormal];
        [monthButton setTitleColor:[UIColor colorFromHexRGB:@"ff6f21"] forState:UIControlStateNormal];
        [monthButton setImage:imageWithName(@"home_more_image") forState:UIControlStateNormal];
        [monthButton addTarget:self action:@selector(clickMonthMoreButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [hView addSubview:monthButton];
        monthButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
        monthButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        monthButton.sd_layout
        .rightSpaceToView(hView,10*widthRate)
        .xIs(0)
        .widthIs(65)
        .heightIs(40);
    }
    weekLab.textColor = contentTitleColorStr1;
    weekLab.font = [UIFont systemFontOfSize:15];
    [hView addSubview:weekLab];
    
    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];
    [hView addSubview:titleView];
    
    titleView.sd_layout
    .leftEqualToView(hView)
    .rightEqualToView(hView)
    .topSpaceToView(hView,40)
    .heightIs(40);
    
    UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 0, DeviceMaxWidth/4-10*widthRate, 40)];
    tagLab.text = @"排名";
    tagLab.textColor = contentTitleColorStr1;
    tagLab.font = [UIFont systemFontOfSize:13];
    tagLab.textAlignment = NSTextAlignmentLeft;
    [titleView addSubview:tagLab];
    
    UILabel *nameLab = [UILabel new];
    nameLab.text = @"昵称";
    nameLab.textColor = contentTitleColorStr1;
    nameLab.font = [UIFont systemFontOfSize:13];
    nameLab.textAlignment = NSTextAlignmentLeft;
    [titleView addSubview:nameLab];
    
    nameLab.sd_layout
    .leftSpaceToView(tagLab,0*widthRate)
    .topEqualToView(tagLab)
    .widthIs(DeviceMaxWidth/4)
    .heightIs(40);
    
//    UILabel *phoneLab = [UILabel new];
//    phoneLab.text = @"电话";
//    phoneLab.textColor = contentTitleColorStr1;
//    phoneLab.font = [UIFont systemFontOfSize:13];
//    phoneLab.textAlignment = NSTextAlignmentCenter;
//    [titleView addSubview:phoneLab];
//    
//    phoneLab.sd_layout
//    .leftSpaceToView(nameLab,50*widthRate)
//    .topEqualToView(nameLab)
//    .widthIs(30)
//    .heightIs(40);
    
    UILabel *gradeLab = [UILabel new];
    gradeLab.text = @"等级";
    gradeLab.textColor = contentTitleColorStr1;
    gradeLab.font = [UIFont systemFontOfSize:13];
    gradeLab.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:gradeLab];
    
    gradeLab.sd_layout
    .leftSpaceToView(nameLab,0*widthRate)
    .topEqualToView(nameLab)
    .widthIs(DeviceMaxWidth/4)
    .heightIs(40);
    
    NSString *recommendStr = nil;
    if (tableView == self.recommendTableView) {
        recommendStr = @"推荐人数";
    }else{
        recommendStr = @"收益";
    }
    
    UILabel *moneyLab = [UILabel new];
    moneyLab.text = recommendStr;
    moneyLab.textColor = contentTitleColorStr1;
    moneyLab.font = [UIFont systemFontOfSize:13];
    moneyLab.textAlignment = NSTextAlignmentRight;
    [titleView addSubview:moneyLab];
    
    moneyLab.sd_layout
    .rightSpaceToView(titleView,10)
    .topEqualToView(nameLab)
    .widthIs(DeviceMaxWidth/4-10)
    .heightIs(40);
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 80-0.5, DeviceMaxWidth, 0.5)];
    lineV.backgroundColor = tableDefSepLineColor;
    [hView addSubview:lineV];
    
    return hView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    BillBoardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[BillBoardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tagLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    
    if (indexPath.row == 0) {
        cell.tagLab.backgroundColor = mainColor;
    }else if (indexPath.row == 1) {
        cell.tagLab.backgroundColor = [UIColor colorFromHexRGB:@"fe7021"];
    }else if (indexPath.row == 2) {
        cell.tagLab.backgroundColor = [UIColor colorFromHexRGB:@"feac17"];
    }else{
        cell.tagLab.backgroundColor = [UIColor colorFromHexRGB:@"d9d9d9"];
    }
    if (indexPath.section == 0) {
        WeekRankModel *model = [WeekRankModel new];
        if (tableView == self.richesTableView) {
            model = self.richesModel.week_rank_list[indexPath.row];
        }else if (tableView == self.nowTableView) {
            model = self.nowModel.week_rank_list[indexPath.row];
        }else {
            model = self.recommendModel.week_rank_list[indexPath.row];
        }
        cell.name.text = model.user_name;
        if (tableView == self.recommendTableView) {
            cell.money.text = [NSString stringWithFormat:@"%@",model.week_add_member];
        }else{
            cell.money.text = [NSString stringWithFormat:@"￥%.2f",[model.week_income floatValue]];
        }
        cell.grade.text = model.grade_name;
        cell.phone.text = [FrankTools replacePhoneNumber:model.telephone];
    }else{
        MonthRankModel *model = [MonthRankModel new];
        if (tableView == self.richesTableView) {
            model = self.richesModel.month_rank_list[indexPath.row];
        }else if (tableView == self.nowTableView) {
            model = self.nowModel.month_rank_list[indexPath.row];
        }else {
            model = self.recommendModel.month_rank_list[indexPath.row];
        }
        cell.name.text = model.user_name;
        if (tableView == self.recommendTableView) {
            cell.money.text = [NSString stringWithFormat:@"%@",model.month_add_member];
        }else{
            cell.money.text = [NSString stringWithFormat:@"￥%.2f",[model.month_income floatValue]];
        }
        
        cell.phone.text = [FrankTools replacePhoneNumber:model.telephone];
        cell.grade.text = model.grade_name;
    }
    
    return cell;
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
            if (self.nowPage == 0) {
                [self initRichesView];
            }else if (self.nowPage == 1) {
                [self initNewTableView];
            }else{
                [self initRecommendTableView];
            }
        }
    }
}

#pragma mark - clickBillboardTitleEvent
-(void)clickBillboardTitleEvent:(UIButton *)button_
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
    if (button_.tag-100 == 0) {
        [self initRichesView];
    }else if (button_.tag-100 == 1) {
        [self initNewTableView];
    }else{
        [self initRecommendTableView];
    }
    self.myScrollView.contentOffset = CGPointMake(DeviceMaxWidth*(button_.tag-100), 0);
}

-(void)clickMoreButtonEvent:(UIButton *)button_
{
    BillboardDetaiViewController *billBoardView = [BillboardDetaiViewController new];
    billBoardView.type = 0;
    if (self.nowPage == 0) {
        billBoardView.dataModel = self.richesModel;
    }else if (self.nowPage == 1) {
        billBoardView.dataModel = self.nowModel;
    }else {
        billBoardView.dataModel = self.recommendModel;
    }
    billBoardView.jumpType = self.nowPage;
    [self.navigationController pushViewController:billBoardView animated:YES];
}

-(void)clickMonthMoreButtonEvent:(UIButton *)button_
{
    BillboardDetaiViewController *billBoardView = [BillboardDetaiViewController new];
    billBoardView.type = 1;
    if (self.nowPage == 0) {
        billBoardView.dataModel = self.richesModel;
    }else if (self.nowPage == 1) {
        billBoardView.dataModel = self.nowModel;
    }else {
        billBoardView.dataModel = self.recommendModel;
    }
    [self.navigationController pushViewController:billBoardView animated:YES];
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
