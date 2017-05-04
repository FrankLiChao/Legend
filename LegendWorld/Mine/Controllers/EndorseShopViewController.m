//
//  EndorseShopViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "EndorseShopViewController.h"
#import "IncomeContentTableCell.h"
#import "MineTableViewCell.h"
#import "CycleTableViewCell.h"
#import "DeadlineTableViewCell.h"
#import "EndorseSellerModel.h"
#import "SellerShopViewController.h"
#import "DownlineViewController.h"

@interface EndorseShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)NSArray *tifierArray;
@property(strong,nonatomic)NSArray *sellerList;
@property(nonatomic,weak)UITableView *myTableView;
@end

@implementation EndorseShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已代言商家";
    _tifierArray = @[@"titleFier",@"shopFier",@"cycleFier",@"customFier"];
    [self initFrameView];
    [self requestData];
}

-(void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"Api/Cash/endorseSellerList") parameters:dic success:^(id responseData) {
        self.sellerList = [EndorseSellerModel parseResponse:responseData];
        [self hideHUD];
        [self.myTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)initFrameView{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.backgroundColor = viewColor;
    self.myTableView = myTableView;
    [self.view addSubview:myTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sellerList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 70*widthRate;
    }
    return 45*widthRate;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tifier = @"";
    if (indexPath.row == 0) {
        tifier = _tifierArray[0];
    }else if (indexPath.row == 1) {
        tifier = _tifierArray[1];
    }else if (indexPath.row == 2) {
        tifier = _tifierArray[2];
    }else {
        tifier = _tifierArray[3];
    }
    EndorseSellerModel *model = self.sellerList[indexPath.section];
    if (indexPath.row == 0) {//DeadlineTableViewCell
        DeadlineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (cell == nil) {
            cell = [[DeadlineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailLab startCountdownTime:[model.endorse_end_time doubleValue]];
        return cell;
    }
    else if (indexPath.row == 1) {
        IncomeContentTableCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (cell == nil) {
            cell = [[IncomeContentTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.logoIm setImage:imageWithName(@"mine_shop_image")];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",model.seller_name];
        cell.moneyLab.text = [NSString stringWithFormat:@"下次分红时间%@",model.next_share_date];
        return cell;
    } else if (indexPath.row == 2) {//CycleTableViewCell
        CycleTableViewCell * ccell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (ccell == nil) {
            ccell = [[CycleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        ccell.selectionStyle = UITableViewCellSelectionStyleNone;
        [ccell.tipBtn addTarget:self action:@selector(clickTipEvent) forControlEvents:UIControlEventTouchUpInside];
        ccell.nameLab.text = @"下次分红收益";
        ccell.detailLab.text = [NSString stringWithFormat:@"%@元",model.next_share_income];
        return ccell;
    }
    else{
        MineTableViewCell * mcell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (mcell == nil) {
            mcell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        mcell.selectionStyle = UITableViewCellSelectionStyleNone;
        mcell.arrowImage.hidden = YES;
        if (indexPath.row == 3) {
            mcell.nameLab.text = @"直推VIP成员购买人数";
            mcell.deteiLab.text = [NSString stringWithFormat:@"%@人",model.recommend_buy_num];
            mcell.arrowImage.hidden = NO;
        }else if (indexPath.row == 4) {
            mcell.nameLab.text = @"我最多可享受的收益层";
            mcell.deteiLab.text = [NSString stringWithFormat:@"%@层",model.share_reward_layer];
        }else if (indexPath.row == 5) {
            mcell.nameLab.text = @"我当前的关联收益人数";
            mcell.deteiLab.text = [NSString stringWithFormat:@"%@人",model.relate_income_num];
        }else{
            mcell.nameLab.text = @"分红时间";
            mcell.deteiLab.text = [NSString stringWithFormat:@"%@",model.pre_share_date];
        }
        return mcell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EndorseSellerModel *model = self.sellerList[indexPath.section];
    if (indexPath.row == 1) {
        SellerShopViewController *sellerVc = [SellerShopViewController new];
        sellerVc.sellerId = [model.seller_id integerValue];
        [self.navigationController pushViewController:sellerVc animated:YES];
    }else if (indexPath.row == 3) {
        DownlineViewController *downVc = [DownlineViewController new];
        downVc.seller_id = model.seller_id;
        downVc.user_id = model.user_id;
        [self.navigationController pushViewController:downVc animated:YES];
    }
}

#pragma mark - 点击事件
-(void)clickTipEvent{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注：下次分红收益金额为截止到当前时间您已获得的分红收益，随着您推荐人数的增加和下线完成代言人数的增加，分红收益会一直增长" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
