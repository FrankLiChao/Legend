//
//  AgentInforViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "AgentInforViewController.h"
#import "BankInforTableViewCell.h"
#import "AgentCertificationViewController.h"

@interface AgentInforViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation AgentInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理商认证";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStylePlain target:self action:@selector(clickEditEvent)];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = viewColor;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"BankInforTableViewCell" bundle:nil] forCellReuseIdentifier:@"BankInforTableViewCell"];
    
//    UILabel *footLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-60, 100)];
//    footLab.textColor = contentTitleColorStr2;
//    footLab.font = [UIFont systemFontOfSize:12];
//    footLab.numberOfLines = 0;
//    footLab.text = @"温馨提示：认证信息已提交，若更换储蓄卡或分润未到账，请第一时间核对并修改，若分润到账无误，为避免影响您的收益，请谨慎修改!";
//    self.myTableView.tableFooterView = footLab;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else {
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 60)];
    bgView.backgroundColor = viewColor;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-30, 60)];
    titleLab.text = [NSString stringWithFormat:@"温馨提示：认证信息已提交，若更换储蓄卡或分润未到账，请第一时间联系客服修改，客服电话：%@",ServicePhone];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.numberOfLines = 0;
    titleLab.textColor = contentTitleColorStr2;
    [bgView addSubview:titleLab];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40)];
    bgView.backgroundColor = viewColor;
    
    NSString *titleStr = @"身份信息";
    if (section == 1) {
        titleStr = @"银行卡信息";
    }
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-30, 40)];
    titleLab.text = titleStr;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = contentTitleColorStr2;
    [bgView addSubview:titleLab];
    
    return bgView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * tifier = @"FrankCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.userRealModel.real_name?self.userRealModel.real_name:@""];
        cell.textLabel.textColor = contentTitleColorStr1;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.text = self.userRealModel.ID_card;
        cell.detailTextLabel.textColor = contentTitleColorStr1;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else {
        BankInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankInforTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [FrankTools setImgWithImgView:cell.logoIm withImageUrl:self.userRealModel.bank_logo withPlaceHolderImage:imageWithName(@"tok_defaulfbank")];
        cell.bankName.text = self.userRealModel.bank_name;
        cell.bankNum.text = [NSString stringWithFormat:@"尾号%@",self.userRealModel.card_tail_num];
        
        return cell;
    }
}

-(void)clickEditEvent{
    AgentCertificationViewController *agentVc = [AgentCertificationViewController new];
    agentVc.agentTag = YES;
    [self.navigationController pushViewController:agentVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
