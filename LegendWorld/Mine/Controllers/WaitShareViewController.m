//
//  WaitShareViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "WaitShareViewController.h"
#import "DownlineViewController.h"
#import "IncomeContentTableCell.h"
#import "MineTableViewCell.h"
#import "EndorseShopViewController.h"
#import "WaitShareIncomeModel.h"
#import "SellerShopViewController.h"

@interface WaitShareViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *myTableView;
@property (nonatomic,strong)NSString *endorse_num;//商家数量
@property (nonatomic,strong)NSString *photo_url;//用户头像
@property (nonatomic,strong)NSArray *waitList;

@end

@implementation WaitShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待分红收益";
    [self initFrameView];
    [self requestData];
}

-(void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/sharePreIncome") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        [self hideHUD];
        self.waitList = [WaitShareIncomeModel parseResponse:responseData];
        self.endorse_num = [[responseData objectForKey:@"endorse_list"] objectForKey:@"endorse_num"];
        self.photo_url = [[responseData objectForKey:@"endorse_list"] objectForKey:@"photo_url"];
        [self.myTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)initFrameView{
    UITableView *mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = viewColor;
    mytableView.showsVerticalScrollIndicator = NO;
    mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = mytableView;
    [self.view addSubview:mytableView];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10*widthRate;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 10*widthRate)];
    bgView.backgroundColor = viewColor;
    return bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.waitList.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70*widthRate;
    }
    return 45*widthRate;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * tifier = @"FrankCell";
        IncomeContentTableCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (cell == nil) {
            cell = [[IncomeContentTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.logoIm setImage:imageWithName(@"mine_shop_image")];
        cell.moneyLab.textColor = contentTitleColorStr2;
        if (indexPath.section == 0) {
            cell.nameLab.text = @"已代言商家";
            cell.moneyLab.text = [NSString stringWithFormat:@"共%@家",self.endorse_num?self.endorse_num:@"0"];
        }else{
            WaitShareIncomeModel *model = self.waitList[indexPath.section-1];
            cell.nameLab.text = model.seller_name;
            [FrankTools setImgWithImgView:cell.logoIm withImageUrl:model.thumb_img withPlaceHolderImage:imageWithName(@"mine_shop_image")];
            cell.moneyLab.text = [NSString stringWithFormat:@"下次分红时间：%@",model.next_share_date];
        }
        return cell;
    }else {
        static NSString * ftifier = @"FCell";
        MineTableViewCell * fcell = [tableView dequeueReusableCellWithIdentifier:ftifier];
        if (fcell == nil) {
            fcell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ftifier];
        }
        WaitShareIncomeModel *model = self.waitList[indexPath.section-1];
        fcell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nameArray = @[@"",@"代言周期",@"直推VIP成员购买人数",@"我最多可享受的收益层"];
        NSString *shareCycle = [NSString stringWithFormat:@"%ld天",[model.endorse_time integerValue]/(3600*24)];
        NSString *buy_num = [NSString stringWithFormat:@"%@人",model.recommend_buy_num];
        NSString *shareNum = [NSString stringWithFormat:@"%@层",model.share_reward_layer];
        NSArray *detailArray = @[@"",shareCycle,buy_num,shareNum];
        fcell.nameLab.text = nameArray[indexPath.row];
        fcell.deteiLab.text = detailArray[indexPath.row];
        if (indexPath.row == 2) {
            fcell.arrowImage.hidden = NO;
        }else{
            fcell.arrowImage.hidden = YES;
        }
        fcell.lineView.sd_layout
        .xIs(0)
        .widthIs(DeviceMaxWidth);
        return fcell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        EndorseShopViewController *endorseVc = [EndorseShopViewController new];
        
        [self.navigationController pushViewController:endorseVc animated:YES];
    }
    if (indexPath.row == 2) {
        WaitShareIncomeModel *model = self.waitList[indexPath.section-1];
        DownlineViewController *downLine = [DownlineViewController new];
        downLine.seller_id = model.seller_id;
        downLine.user_id = model.user_id;
        [self.navigationController pushViewController:downLine animated:YES];
    }
    if (indexPath.row == 0 && indexPath.section != 0) {
        WaitShareIncomeModel *model = self.waitList[indexPath.section-1];
        SellerShopViewController *sellerVc = [SellerShopViewController new];
        sellerVc.sellerId = [model.seller_id integerValue];
        [self.navigationController pushViewController:sellerVc animated:YES];
    }
    
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
