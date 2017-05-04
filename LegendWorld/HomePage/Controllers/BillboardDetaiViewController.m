//
//  BillboardDetaiViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BillboardDetaiViewController.h"
#import "BillBoardTableViewCell.h"

@interface BillboardDetaiViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(weak,nonatomic)UITableView *myTableView;

@end

@implementation BillboardDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    
    [self initFrameView];
}

-(void)dealloc{
    
}

-(void)initFrameView
{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = myTableView;
    [self.view addSubview:self.myTableView];
}

#pragma mark - UItabViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == 0) {
        return _dataModel.week_rank_list.count;
    }else{
        return _dataModel.month_rank_list.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    
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
    
    NSString *recomeLab = nil;
    if (_jumpType == 2) {
        recomeLab = @"推荐人数";
    }else{
        recomeLab = @"收益";
    }
    UILabel *moneyLab = [UILabel new];
    moneyLab.text = recomeLab;
    moneyLab.textColor = contentTitleColorStr1;
    moneyLab.font = [UIFont systemFontOfSize:13];
    moneyLab.textAlignment = NSTextAlignmentRight;
    [titleView addSubview:moneyLab];
    
    moneyLab.sd_layout
    .rightSpaceToView(titleView,10)
    .topEqualToView(gradeLab)
    .widthIs(DeviceMaxWidth/4-10)
    .heightIs(40);
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, DeviceMaxWidth, 0.5)];
    lineV.backgroundColor = tableDefSepLineColor;
    [titleView addSubview:lineV];
    
    return titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    BillBoardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[BillBoardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
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
    
    if (_type == 0) {
        WeekRankModel *model = _dataModel.week_rank_list[indexPath.row];
        cell.name.text = model.user_name;
        if (_jumpType == 2) {
            cell.money.text = [NSString stringWithFormat:@"%@",model.week_add_member];
        }else{
            cell.money.text = [NSString stringWithFormat:@"￥%.2f",[model.week_income floatValue]];
        }
        cell.grade.text = model.grade_name;
        cell.phone.text = [FrankTools replacePhoneNumber:model.telephone];
    }else{
        MonthRankModel *model = _dataModel.month_rank_list[indexPath.row];
        cell.name.text = model.user_name;
        if (_jumpType == 2) {
            cell.money.text = [NSString stringWithFormat:@"%@",model.month_add_member];
        }else{
            cell.money.text = [NSString stringWithFormat:@"￥%.2f",[model.month_income floatValue]];
        }
        cell.phone.text = [FrankTools replacePhoneNumber:model.telephone];
        cell.grade.text = model.grade_name;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
