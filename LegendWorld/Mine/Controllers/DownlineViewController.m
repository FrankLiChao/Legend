//
//  DownlineViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "DownlineViewController.h"
#import "downLineTableViewCell.h"
#import "MemberListModel.h"

@interface DownlineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *buy_member_list;
@property(nonatomic,strong)NSArray *no_buy_member_list;
@property(nonatomic,weak)UITableView *myTableView;
@end

@implementation DownlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下线购买层";
    [self initFrameView];
    [self requestData];
}

-(void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"seller_id":[NSString stringWithFormat:@"%@",self.seller_id],
                          @"user_id":[NSString stringWithFormat:@"%@",self.user_id]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/recommendBuyInfo") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        [self hideHUD];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.buy_member_list = [MemberListModel parseResponse:responseData];
        self.no_buy_member_list = [MemberListModel parseNoBuyResponse:responseData];
        [self.myTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)initFrameView{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView = myTableView;
    [self.view addSubview:myTableView];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40*widthRate;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40*widthRate)];
    bgView.backgroundColor = viewColor;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15*widthRate, 0, DeviceMaxWidth-30*widthRate, 40*widthRate)];
    titleLab.textColor = contentTitleColorStr2;
    titleLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:titleLab];
    if (section == 0) {
        titleLab.text = @"已完成购买任务的成员";
    }else {
        titleLab.text = @"未完成购买任务的成员";
    }
    return bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.buy_member_list.count;
    }
    return self.no_buy_member_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*widthRate;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"FrankCell";
    downLineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[downLineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MemberListModel *model = [[MemberListModel alloc] init];
    if (indexPath.section == 0) {
        model = self.buy_member_list[indexPath.row];
    }else {
        model = self.no_buy_member_list[indexPath.row];
    }
    cell.nameLab.text = model.user_name;
    cell.phoneLab.text = model.telephone;
    [FrankTools setImgWithImgView:cell.headIm withImageUrl:model.photo_url withPlaceHolderImage:defaultUserHead];
    [cell.callPhoneBtn addTarget:self action:@selector(clickCallPhoneEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)clickCallPhoneEvent:(UIButton *)button_{
    downLineTableViewCell *cell = (downLineTableViewCell *)button_.superview;
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    MemberListModel *model = [[MemberListModel alloc] init];
    if (indexPath.section == 0) {
        model = self.buy_member_list[indexPath.row];
    }else {
        model = self.no_buy_member_list[indexPath.row];
    }
    [FrankTools detailPhone:model.telephone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
