//
//  MineViewController.m
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MineViewController.h"
#import "CertificationUploadViewController.h"
#import "MyWalletViewController.h"
#import "SetViewController.h"
#import "UserInforViewController.h"
#import "InviteViewController.h"
#import "UserModel.h"
#import "MyMemberViewController.h"
#import "VerificationStateViewController.h"
#import "MyOrderViewController.h"
#import "InviteFriendsView.h"
#import "MyCollectionViewController.h"
#import "HelpAndFeedbackController.h"
#import "ApplyAfterSaleViewController.h"
#import "CustomTableViewCell.h"
#import "MineHeaderView.h"
#import "MineOrderFooterView.h"

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate, MineOrderFooterCollectionViewCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) MineHeaderView *header;

@property (nonatomic, strong) NSArray *cellTitleArray; //列表中的title文本
@property (nonatomic, strong) NSArray *cellImageArray; //列表中的image
@property (nonatomic, strong) NSDictionary *userData;//本地化的用户数据
@property (nonatomic, strong) NSArray *cellDeteilArray;//保存审核状态和用户收益
@property (nonatomic, strong) UserModel *userModel;

@end

@implementation MineViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.cellTitleArray = @[@[@"我的订单"],
                            @[@"邀请好友",@"实名认证",@"我的收藏"],
                            @[@"我的钱包",@"我的成员"],
                            @[@"帮助与反馈",@"系统设置"]];
    self.cellImageArray = @[@[@"mine_order"],
                            @[@"mine_invite",@"mine_shiming",@"mine_love"],
                            @[@"mine_wallet",@"mine_members"],
                            @[@"mine_help",@"mine_setting"]];
    
    MineHeaderView *header = (MineHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:self options:nil] firstObject];
    self.header = header;
    self.header.frame = CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxWidth/1.6);
    self.header.avatarImageView.layer.cornerRadius = DeviceMaxWidth/10;
    self.header.avatarImageView.layer.masksToBounds = YES;
    self.header.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.header.avatarImageView.layer.borderWidth = 3;
    self.header.avatarImageView.image = defaultUserHead;
    self.header.nameLabel.text = @"登录/注册";
    [self.header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView:)]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor seperateColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.autoresizesSubviews = NO;
    self.tableView.rowHeight = 45;
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomTableViewCell"];
    [self.tableView registerClass:[MineOrderFooterView class] forHeaderFooterViewReuseIdentifier:@"MineOrderFooterView"];
    [self.view addSubview:self.tableView];
    
    if ([LoginUserManager sharedManager].isLogin) {
        [self updateUserData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.contentOffset = CGPointZero;
    self.userModel = [self getUserData];
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom
- (void)updateUI{
    if ([FrankTools isLogin]) {
        [self.header.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.photo_url] placeholderImage:defaultUserHead];
        NSString *imName = [NSString stringWithFormat:@"mine_grade_v%ld", (long)[self.userModel.honor_grade integerValue]];
        self.header.levelImageView.image = [UIImage imageNamed:imName];
        self.header.nameLabel.text = [NSString stringWithFormat:@"%@",self.userModel.user_name];
        
        self.header.line.hidden = NO;
        self.header.leftLabel.hidden = NO;
        self.header.rightLabel.hidden = NO;
        
        self.header.leftLabel.text = [NSString stringWithFormat:@"今日新增：%ld人",(long)[self.userModel.day_grow integerValue]];
        self.header.rightLabel.text = [NSString stringWithFormat:@"所有成员：%ld人",(long)[self.userModel.straight_number integerValue]];
    } else {
        self.header.avatarImageView.image = defaultUserHead;
        self.header.levelImageView.image = nil;
        self.header.nameLabel.text = @"登录/注册";
        
        self.header.line.hidden = YES;
        self.header.leftLabel.hidden = YES;
        self.header.rightLabel.hidden = YES;
        
        self.header.leftLabel.text = nil;
        self.header.rightLabel.text = nil;
    }
    [self.tableView reloadData];
}

- (void)tapHeaderView:(UITapGestureRecognizer *)sender {
    if ([FrankTools isLogin]) {
        UserInforViewController *userInforVC = [[UserInforViewController alloc] init];
        userInforVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInforVC animated:YES];
    } else {
        [self showLoginViewController];
    }
}

- (void)showLoginViewController {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)inviteFriends {
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/user/myShareInfo") parameters:dic success:^(id responseData) {
        [self hideHUD];
        
        InviteFriendsView *inviteView = [[InviteFriendsView alloc] initWithFrame:self.view.bounds];
        inviteView.dataDic = responseData;
        inviteView.nameLab.text = [NSString stringWithFormat:@"%@",self.userModel.user_name];
        inviteView.invateCode.text = [NSString stringWithFormat:@"我的邀请码：%@",[responseData objectForKey:@"recommended_encode"]];
        [inviteView.qrcodeIm sd_setImageWithURL:[NSURL URLWithString:[[responseData objectForKey:@"share_info"] objectForKey:@"code_thumb"]]];
        [inviteView.headIm sd_setImageWithURL:[NSURL URLWithString:self.userModel.photo_url] placeholderImage:defaultUserHead];
        if ([self.userModel.honor_grade integerValue] == 0) {
            inviteView.imageTag.hidden = YES;
            inviteView.imageTag.image = nil;
        } else {
            inviteView.imageTag.hidden = NO;
            NSString *imageStr = [NSString stringWithFormat:@"mine_grade_v%ld", (long)[self.userModel.honor_grade integerValue]];
            [inviteView.imageTag setImage:imageWithName(imageStr)];
        }
        [[UIApplication sharedApplication].keyWindow addSubview:inviteView];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellTitleArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 87.5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 15)];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        MineOrderFooterView *orderFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MineOrderFooterView"];
        orderFooter.delegate = self;
        return orderFooter;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    cell.selectedBackgroundView.backgroundColor = [[UIColor noteTextColor] colorWithAlphaComponent:0.5];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = self.cellTitleArray[indexPath.section][indexPath.row];
    cell.imgView.image = [UIImage imageNamed:self.cellImageArray[indexPath.section][indexPath.row]];
    cell.infoLabel.hidden = YES;
    cell.infoLabel.text = nil;
    if ([FrankTools getUserToken].length > 0) {
        if ([cell.titleLabel.text isEqualToString:@"实名认证"]) {
            cell.infoLabel.hidden = NO;
            NSString *statusStr = @"未申请";
            if ([self.userModel.real_auth_status integerValue] == 0) {
                statusStr = @"待审核";
            } else if ([self.userModel.real_auth_status integerValue] == 1){
                statusStr = @"审核中";
            } else if ([self.userModel.real_auth_status integerValue] == 2){
                statusStr = @"已通过";
            } else if ([self.userModel.real_auth_status integerValue] == 3){
                statusStr = @"未通过";
            } else if ([self.userModel.real_auth_status integerValue] == 4){
                statusStr = @"未申请";
            }
            cell.infoLabel.text = statusStr;
        } else if ([cell.titleLabel.text isEqualToString:@"我的钱包"]) {
            cell.infoLabel.hidden = NO;
            cell.infoLabel.text = [NSString stringWithFormat:@"总收益：￥%@", self.userModel.total_income];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([FrankTools isLogin]) {
            MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
            myOrder.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myOrder animated:YES];
        } else {
            [self showLoginViewController];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if ([FrankTools isLogin]) {
                [self inviteFriends];
            } else {
                [self showLoginViewController];
            }
        } else if (indexPath.row == 1) {
            if ([FrankTools isLogin]) {
                [self showHUDWithMessage:@"正在查询"];
                NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                             @"token":[FrankTools getUserToken]};
                [MainRequest RequestHTTPData:PATH(@"Api/user/realNameInfo") parameters:parameters success:^(id response) {
                    [self hideHUD];
                    if ([[[response objectForKey:@"user_real_auth_info"] objectForKey:@"real_name"]isEqualToString:@""]) {
                        CertificationUploadViewController *certification = [CertificationUploadViewController new];
                        certification.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:certification animated:YES];
                    } else {
                        VerificationStateViewController *verificationStateVC = [[VerificationStateViewController alloc] init];
                        verificationStateVC.realName = [[response objectForKey:@"user_real_auth_info"] objectForKey:@"real_name"];
                        verificationStateVC.IDCardNum = [[response objectForKey:@"user_real_auth_info"] objectForKey:@"id_card"];
                        verificationStateVC.state = [NSString stringWithFormat:@"%@",[[response objectForKey:@"user_real_auth_info"] objectForKey:@"status"]];
                        verificationStateVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:verificationStateVC animated:YES];
                    }
                } failed:^(NSDictionary *errorDic) {
                    [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
                }];
            } else {
                [self showLoginViewController];
            }
        } else if (indexPath.row == 2) {
            if ([FrankTools isLogin]) {
                MyCollectionViewController *myCollectionVC = [[MyCollectionViewController alloc] init];
                myCollectionVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCollectionVC animated:YES];
            } else {
                [self showLoginViewController];
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if ([FrankTools isLogin]) {
                MyWalletViewController *myWalletView = [MyWalletViewController new];
                myWalletView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myWalletView animated:YES];
            } else {
                [self showLoginViewController];
            }
        } else if (indexPath.row == 1) {
            if ([FrankTools isLogin]) {
                MyMemberViewController * myMemberVC = [[MyMemberViewController alloc] init];
                myMemberVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myMemberVC animated:YES];
            } else {
                [self showLoginViewController];
            }
        }
    }  else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            HelpAndFeedbackController *helpAndFeedbackVC = [[HelpAndFeedbackController alloc] init];
            helpAndFeedbackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpAndFeedbackVC animated:YES];
        } else if (indexPath.row == 1) {
            SetViewController *setVC = [[SetViewController alloc] init];
            setVC.hidesBottomBarWhenPushed = YES;
            setVC.ifLogin = [FrankTools isLogin];
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (self.tableView.contentOffset.y < 0) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        } else if (self.tableView.contentOffset.y == 0) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }
}

#pragma mark - MineOrderFooterCollectionViewCellDelegate
- (void)orderFooterSelectItemAtIndex:(NSInteger)index {
    if ([FrankTools isLogin]) {
        MyOrderViewController *myOrder = [[MyOrderViewController alloc] init];
        myOrder.pageIndex = index + 1;
        myOrder.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myOrder animated:YES];
    } else {
        [self showLoginViewController];
    }
}

@end
