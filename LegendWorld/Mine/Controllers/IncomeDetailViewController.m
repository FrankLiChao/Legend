//
//  IncomeDetailViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "IncomeDetailViewController.h"
#import "IncomeTitleTableViewCell.h"
#import "IncomePersonTableViewCell.h"
#import "IncomeDetailTableVCell.h"
#import "IncomeDetailModel.h"

@interface IncomeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) IncomeDetailModel *incomeDetailModel;
@property (nonatomic,strong)UITableView *mytabView;

@end

@implementation IncomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收益详情";
    _userModel = [self getUserData];
    [self initFrameView];
    [self requestData];
}

-(void)requestData{
    NSString *httpUrl = @"";
    if (self.isProcessPage) {
        httpUrl = PATH(@"Api/Cash/processIncomeDetail");
    }else{
        httpUrl = PATH(@"Api/Cash/myIncomeDetail");
    }
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"income_id":self.income_id?self.income_id:@""};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:httpUrl parameters:dic success:^(id responseData) {
        [self hideHUD];
        self.mytabView.delegate = self;
        self.mytabView.dataSource = self;
        self.incomeDetailModel = [IncomeDetailModel parseIncomeDetailDic:responseData];
        [self.mytabView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

-(void)initFrameView{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytabView = myTableView;
    [self.view addSubview:myTableView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.incomeDetailModel.share_type integerValue] == 5) {
        return 7;
    }
    if (self.isProcessPage && self.isCansole) {
        return 5;
    }
    if (self.isTok) {
        return 3;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 160*widthRate;
    }else{
        return 40;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * titletifier = @"titleCell";
        IncomeTitleTableViewCell * titlecell = [tableView dequeueReusableCellWithIdentifier:titletifier];
        if (titlecell == nil) {
            titlecell = [[IncomeTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titletifier];
        }
        titlecell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *imageStr = @"";
        if ([self.incomeDetailModel.share_type integerValue] == 2 || [self.incomeDetailModel.share_type integerValue] == 19) {
            imageStr = @"mine_guanlian";
        }else if ([self.incomeDetailModel.share_type integerValue] == 4 || [self.incomeDetailModel.share_type integerValue] == 18) {
            imageStr = @"mine_zhitui";
        }else if ([self.incomeDetailModel.share_type integerValue] == 5){
            imageStr = @"mine_fenhong";
        }else if ([self.incomeDetailModel.share_type integerValue] == 16) {
            imageStr = @"mine_jiangli";
        }else if ([self.incomeDetailModel.share_type integerValue] == 17) {
            imageStr = @"mine_fenhong";
        }

        [titlecell.headIm setImage:imageWithName(imageStr)];
        titlecell.moneyLab.text = [NSString stringWithFormat:@"%.2f",[self.incomeDetailModel.money floatValue]];
        if (self.isProcessPage) {
            titlecell.statusLab.text = self.incomeDetailModel.status_msg;
            titlecell.statusLab.textColor = mainColor;
        }else{
            titlecell.statusLab.text = ([self.incomeDetailModel.status integerValue] == 1)?@"已到账":@"未到账";
        }
        return titlecell;
    }else if (indexPath.row == 1) {
        static NSString * persontifier = @"personCell";
        IncomePersonTableViewCell * personcell = [tableView dequeueReusableCellWithIdentifier:persontifier];
        if (personcell == nil) {
            personcell = [[IncomePersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:persontifier];
        }
        personcell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.incomeDetailModel.share_type integerValue] == 5) {
            personcell.detailLab.hidden = NO;
            personcell.headIm.hidden = YES;
            personcell.nameLab.hidden = YES;
            personcell.nameTitleLab.text = @"代言商品";
            personcell.detailLab.text = self.incomeDetailModel.goods_name;
            
        }else if ([self.incomeDetailModel.share_type integerValue] == 16){
            personcell.detailLab.hidden = NO;
            personcell.headIm.hidden = YES;
            personcell.nameLab.hidden = YES;
            personcell.nameTitleLab.text = @"任务内容";
            personcell.detailLab.text = self.incomeDetailModel.task_info;
        }else if ([self.incomeDetailModel.share_type integerValue] == 17){
            personcell.headIm.hidden = NO;
            personcell.detailLab.hidden = YES;
            personcell.nameLab.hidden = NO;
            personcell.nameTitleLab.text = @"刷卡人所属代理";
            [FrankTools setImgWithImgView:personcell.headIm withImageUrl:self.incomeDetailModel.expense_user_photo withPlaceHolderImage:defaultUserHead];
            personcell.nameLab.text = self.incomeDetailModel.expense_user_name;
        }else{
            personcell.headIm.hidden = NO;
            [FrankTools setImgWithImgView:personcell.headIm withImageUrl:_userModel.photo_url withPlaceHolderImage:defaultUserHead];
            personcell.detailLab.hidden = YES;
            personcell.nameLab.hidden = NO;
            personcell.nameLab.text = self.incomeDetailModel.user_name;
        }
        return personcell;
    }else{
        static NSString * tifier = @"FrankCell";
        IncomeDetailTableVCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (cell == nil) {
            cell = [[IncomeDetailTableVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 2) {
            if ([self.incomeDetailModel.share_type integerValue] == 5) {
                cell.nameLab.text = @"直推VIP成员购买人数";
                cell.detailLab.text = self.incomeDetailModel.recommend_buy_num;
                
            }else if ([self.incomeDetailModel.share_type integerValue] == 16 || [self.incomeDetailModel.share_type integerValue] == 17) {
                cell.nameLab.text = @"收益到达时间";
                cell.detailLab.text = self.incomeDetailModel.finish_date;
            }else {
                cell.nameLab.text = @"商品";
                cell.detailLab.text = self.incomeDetailModel.goods_name;
            }
            
        }else if (indexPath.row == 3) {
            if ([self.incomeDetailModel.share_type integerValue] == 5) {
                cell.nameLab.text = @"我享受的关联收益层";
                cell.detailLab.text = self.incomeDetailModel.share_reward_layer;
            }else{
                cell.nameLab.text = @"件数";
                cell.detailLab.text = [NSString stringWithFormat:@"x%ld",(long)[self.incomeDetailModel.goods_number integerValue]];
            }
        }else if (indexPath.row == 4) {
            if ([self.incomeDetailModel.share_type integerValue] == 5) {
                cell.nameLab.text = @"我享受的关联收益人数";
                cell.detailLab.text = self.incomeDetailModel.share_relate_num;
            }else {
                cell.nameLab.text = @"创建时间";
                cell.detailLab.text = self.incomeDetailModel.create_date;
            }
        }else if (indexPath.row == 5){
            if ([self.incomeDetailModel.share_type integerValue] == 5) {
                cell.nameLab.text = @"购买时间";
                cell.detailLab.text = self.incomeDetailModel.buy_time;
            }else{
                if (self.isProcessPage) {//进行中的收益到达时间
                    cell.nameLab.text = @"预计收益到达时间";
                    cell.detailLab.text = self.incomeDetailModel.pre_info_date;
                }else{
                    cell.nameLab.text = @"收益到达时间";
                    cell.detailLab.text = self.incomeDetailModel.finish_date;
                }
            }
        }else{
            if ([self.incomeDetailModel.share_type integerValue] == 5) {
                cell.nameLab.text = @"分红时间";
                cell.detailLab.text = self.incomeDetailModel.finish_date;
            }
        }
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
