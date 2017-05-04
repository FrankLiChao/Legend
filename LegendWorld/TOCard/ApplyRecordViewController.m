//
//  ApplyRecordViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/28.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ApplyRecordViewController.h"
#import "ApplyRecordTableViewCell.h"
#import "ApplyRecordModel.h"

@interface ApplyRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong,nonatomic)NSArray *dataArray;

@end

@implementation ApplyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请记录";
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorColor = tableDefSepLineColor;
    self.myTableView.backgroundColor = viewColor;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.estimatedRowHeight = 200;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    [self.myTableView registerNib:[UINib nibWithNibName:@"ApplyRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyRecordTableViewCell"];
    
    [self requestData];
}

-(void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHTOCard(@"Pos/posRecordList") parameters:dic success:^(id responseData) {
        [self hideHUD];
        FLLog(@"%@",responseData);
        self.dataArray = [responseData objectForKey:@"record_list"];
        [self.myTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITableViewDelegate - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30)];
    bgView.backgroundColor = viewColor;

    NSArray *array = [ApplyRecordModel parseResponse:self.dataArray[section]];
    ApplyRecordModel *model = [ApplyRecordModel new];
    if (array.count) {
        model = array[0];
    }
    
    UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-30, 30)];
    dataLab.text = model.create_month;
    dataLab.textColor = contentTitleColorStr2;
    dataLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:dataLab];
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyRecordTableViewCell"];
    NSArray *array = [ApplyRecordModel parseResponse:self.dataArray[indexPath.section]];
    ApplyRecordModel *model = array[indexPath.row];
    NSString *contentStr = [NSString stringWithFormat:@"申请%@台",model.number];
    cell.nameLab.attributedText = [FrankTools setFontColor:mainColor WithString:contentStr WithRange:NSMakeRange(2, model.number.length)];
    cell.detailLab.text = model.create_date;
    cell.statusLab.textColor = contentTitleColorStr1;
    if ([model.status integerValue] == 0) {
        cell.statusLab.text = @"审核中";
    }else if ([model.status integerValue] == 1) {
        cell.statusLab.text = @"已发货";
        cell.statusLab.textColor = mainColor;
    }else if ([model.status integerValue] == 2) {
        cell.statusLab.text = @"未通过";
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
