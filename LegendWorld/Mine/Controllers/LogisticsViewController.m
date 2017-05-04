//
//  LogisticsViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsHeaderView.h"
#import "LogisticsCell.h"
@interface LogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *logisticsTableView;
@property (weak, nonatomic) IBOutlet UIView *noLogisticsView;

@end

@implementation LogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    if (self.logistics == nil) {
        self.noLogisticsView.hidden = NO;
    }
    LogisticsHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"LogisticsHeaderView" owner:self options:nil] firstObject];
    headerView.frame = CGRectMake(0, 0, DeviceMaxWidth, 120);
    [FrankTools setImgWithImgView:headerView.LogisticsImg withImageUrl:@"" withPlaceHolderImage:[UIImage imageNamed:@"logistics"]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"物流状态    %@",self.logistics.deliveryStatusDesc]];
    [str addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(8,self.logistics.deliveryStatusDesc.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(8, self.logistics.deliveryStatusDesc.length)];
    headerView.LogisticsStatusLab.attributedText = str;
    headerView.companyLab.text = [NSString stringWithFormat:@"承运公司：%@",self.logistics.companyName];
    headerView.LogisticsNumLab.text = [NSString stringWithFormat:@"运单编号：%@",self.logistics.number];
    headerView.phoneNumLab.text = [NSString stringWithFormat:@"官方电话：%@",self.logistics.telephone];
    self.logisticsTableView.tableHeaderView = headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logistics.processes.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsCellKey"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LogisticsCell" owner:self options:nil] firstObject];
    }
    if (indexPath.row == 0) {
        cell.upLab.hidden = YES;
        cell.midLab.backgroundColor = mainColor;
    }
    if (indexPath.row == self.logistics.processes.count - 1) {
        cell.downLab.hidden = YES;
    }
    LogisticsProcessModel *model = self.logistics.processes[indexPath.row];
    cell.statusLab.text = model.statusDesc;
    cell.timeLab.text = model.time;
    return cell;
}

@end
