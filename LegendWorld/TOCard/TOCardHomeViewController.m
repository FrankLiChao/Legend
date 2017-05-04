//
//  TOCardHomeViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardHomeViewController.h"
#import "TOCardGuideViewController.h"
#import "TOCardMembersViewController.h"
#import "TOCardActivateViewController.h"
#import "ProductDetailViewController.h"
#import "MyIncomeViewController.h"
#import "TOCardSearchViewController.h"
#import "AgentCertificationViewController.h"
#import "AgentInforViewController.h"
#import "ApplyPOSViewController.h"

#import "TOCardMyInfoView.h"
#import "TOCardMemberHeaderView.h"
#import "TOCardMemberTableViewCell.h"
#import "TaskAlertView.h"
#import "InviteFriendsView.h"
#import "LoadControl.h"
#import "UserRealAuthModel.h"

#import "POSAgreementViewController.h"

@interface TOCardHomeViewController () <UITableViewDelegate, UITableViewDataSource, TOCardMemberTableViewCellDelegate, UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) TOCardMyInfoView *infoView;

@property (strong, nonatomic) TOCardMemberModel *mySelf;
@property (strong, nonatomic) TOCardMemberModel *myMonster;
@property (strong, nonatomic) NSArray *myMembers;//前排成员
@property (strong, nonatomic) NSArray *myDirects;//直推成员
@property (nonatomic) NSInteger totalDirect;//直推成员总数
@property (nonatomic) NSInteger pageIndex;//直推成员页吗数
@property (nonatomic) NSInteger maxPageIndex;//直推成员总页数

@property (nonatomic) TaskType taskType;
@property (nonatomic) NSInteger taskDay;
@property (nonatomic) NSInteger taskHour;
@property (nonatomic) NSInteger taskMinute;
@property (nonatomic) BOOL ischageStatus;

@property (nonatomic) NSDictionary *qrCodeData;

@end

@implementation TOCardHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TO卡";
    __weak typeof (self) weakSelf = self;
    self.backBarBtnEvent = ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_image"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看收益" style:UIBarButtonItemStylePlain target:self action:@selector(openMyBenifits:)];
    /* v2.1.3 版本注释掉搜索功能
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SearchWhite"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClicked:)];
    */
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    UserModel *user = [self getUserData];
    
    TOCardMyInfoView *info = [[[NSBundle mainBundle] loadNibNamed:@"TOCardMyInfoView" owner:self options:nil] firstObject];
    self.infoView = info;
    self.infoView.backgroundColor = [UIColor themeColor];
    self.infoView.frame = CGRectMake(0, 0, DeviceMaxWidth, 220);
    self.infoView.name.text = user.user_name;
    [self.infoView.avatar sd_setImageWithURL:[NSURL URLWithString:user.photo_url] placeholderImage:defaultUserHead];
    [self.infoView.buyCardBtn addTarget:self action:@selector(buyCard:) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView.inviteFriendsBtn addTarget:self action:@selector(inviteFriends:) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView.seeMyBenifitBtn addTarget:self action:@selector(clickPOSEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView.agentBtn addTarget:self action:@selector(clickAgentEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.autoresizesSubviews = NO;
    self.tableView.tableHeaderView = self.infoView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.rowHeight = 70;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 25);
    self.tableView.separatorColor = [UIColor seperateColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"TOCardMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"TOCardMemberTableViewCell"];
    [self.tableView registerClass:[TOCardMemberHeaderView class] forHeaderFooterViewReuseIdentifier:@"TOCardMemberHeaderView"];
    
    self.pageIndex = 1;
    
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.tableView];
    loadControl.color = [UIColor noteTextColor];
    loadControl.displayCondition = ^{
        BOOL isDisplay = weakSelf.myDirects.count > 0;
        return isDisplay;
    };
    loadControl.loadAllCondition = ^{
        BOOL isLoadAll = weakSelf.pageIndex >= weakSelf.maxPageIndex;
        return isLoadAll;
    };
    [loadControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
    
    NSInteger grade = [user.tocard_grade integerValue];
    if (grade <= 0) {
        if (self.isActivated) {
            TOCardGuideViewController *guide = [[TOCardGuideViewController alloc] init];
            [self.navigationController pushViewController:guide animated:NO];
            return;
        } else {
            TOCardActivateViewController *activate = [[TOCardActivateViewController alloc] init];
            [self.navigationController pushViewController:activate animated:NO];
            return;
        }
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
    [self requestTaskInfo];
    for (UIView *sub in self.navigationController.navigationBar.subviews) {
        for (UIView *subSub in sub.subviews) {
            if ([subSub isKindOfClass:[UIImageView class]] && subSub.frame.size.height == 0.5) {
                subSub.hidden = YES;
                return;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *sub in self.navigationController.navigationBar.subviews) {
        for (UIView *subSub in sub.subviews) {
            if ([subSub isKindOfClass:[UIImageView class]] && subSub.frame.size.height == 0.5) {
                subSub.hidden = NO;
                return;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom
- (void)requestData {
    [self showHUDWithMessage:nil];
    UserModel *user = [self getUserData];
    NSDictionary *param1 = @{@"device_id": [FrankTools getDeviceUUID],
                             @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserRefereeInfo") parameters:param1 success:^(id response1) {
        NSDictionary *infoDic1 = [response1 objectForKey:@"referee_info"];
        self.mySelf = [TOCardMemberModel mj_objectWithKeyValues:infoDic1];
        self.infoView.members.text = [NSString stringWithFormat:@"总成员数：%@人", self.mySelf.low_members_count];
        self.infoView.todaynewLab.text = [NSString stringWithFormat:@"今日新增：%@人",self.mySelf.today_add_members_count?self.mySelf.today_add_members_count:@"0"];
        self.infoView.gradeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"mine_grade_v%ld", (long)[self.mySelf.grade integerValue]]];
        [self.infoView.avatar sd_setImageWithURL:[NSURL URLWithString:self.mySelf.photo_url] placeholderImage:defaultUserHead];
        
        NSDictionary *param2 = @{@"device_id": [FrankTools getDeviceUUID],
                                 @"token": [FrankTools getUserToken]};
        [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserMentorRefereeInfo") parameters:param2 success:^(id response2) {
            NSDictionary *infoDic2 = [response2 objectForKey:@"referee_info"];
            if (infoDic2 != nil && [infoDic2 isKindOfClass:[NSDictionary class]]) {
                self.myMonster = [TOCardMemberModel mj_objectWithKeyValues:infoDic2];
            }
            NSDictionary *param3 = @{@"device_id": [FrankTools getDeviceUUID],
                                     @"token": [FrankTools getUserToken],
                                     @"ru_id": user.user_id};
            [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserLowLayerMembers") parameters:param3 success:^(id response3) {
                self.myMembers = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:[response3 objectForKey:@"datalist"]];
                
                NSDictionary *param4 = @{@"device_id": [FrankTools getDeviceUUID],
                                         @"token": [FrankTools getUserToken],
                                         @"ru_id": user.user_id,
                                         @"pg": @(1)};
                [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserOriginUser") parameters:param4 success:^(id response4) {
                    self.maxPageIndex = [[response4 objectForKey:@"origin_users_pages"] integerValue];
                    self.totalDirect = [[response4 objectForKey:@"origin_users_count"] integerValue];
                    self.myDirects = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:[response4 objectForKey:@"datalist"]];
                    [self.tableView reloadData];
                    [self hideHUD];
                } failed:^(NSDictionary *errorDic) {
                    [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
                }];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
             [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)requestTaskInfo {
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID],
                            @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserMissionState") parameters:param success:^(id response) {
        [self hideHUD];
        NSDictionary *infoDic = [response objectForKey:@"mission_info"];
        if ([infoDic isKindOfClass:[NSDictionary class]]) {
            self.taskDay = [[[infoDic objectForKey:@"diff_time"] objectForKey:@"day"] integerValue];
            self.taskHour = [[[infoDic objectForKey:@"diff_time"] objectForKey:@"hour"] integerValue];
            self.taskMinute = [[[infoDic objectForKey:@"diff_time"] objectForKey:@"min"] integerValue];
            BOOL isThirtyTaskFinished = [[infoDic objectForKey:@"thirty_mission"] boolValue];
            if (isThirtyTaskFinished) {
                BOOL isSixtyTaskFinished = [[infoDic objectForKey:@"sixty_mission"] boolValue];
                if (isSixtyTaskFinished) {
                    self.taskType = TaskTypeNone;
                } else {
                    self.taskType = TaskTypeOldDriver;
                }
            } else {
                self.taskType = TaskTypeNewer;
            }
        }
        [self.tableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)loadMoreData:(LoadControl *)loadControl {
    UserModel *user = [self getUserData];
    NSInteger nextPage = self.pageIndex + 1;
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID],
                            @"token": [FrankTools getUserToken],
                            @"ru_id": user.user_id,
                            @"pg": @(nextPage)};
    [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserOriginUser") parameters:param success:^(id response) {
        self.pageIndex = nextPage;
        self.maxPageIndex = [[response objectForKey:@"origin_users_pages"] integerValue];
        self.totalDirect = [[response objectForKey:@"origin_users_count"] integerValue];
        NSArray *myAddDirects = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"datalist"]];
        NSMutableArray *myDirectsM = [NSMutableArray arrayWithArray:self.myDirects];
        [myDirectsM addObjectsFromArray:myAddDirects];
        self.myDirects = [myDirectsM copy];
        [self.tableView reloadData];
        [loadControl endLoading:YES];
    } failed:^(NSDictionary *errorDic) {
        [loadControl endLoading:NO];
    }];
}

- (void)searchButtonClicked:(id)sender {
    TOCardSearchViewController *search = [[TOCardSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)openMyBenifits:(id)sender {
    MyIncomeViewController *myIncome = [[MyIncomeViewController alloc] init];
    [self.navigationController pushViewController:myIncome animated:YES];
}

- (void)clickPOSEvent:(UIButton *)button_{
    NSLog(@"POS机申请");
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHTOCard(@"Pos/isAgreePosPro") parameters:dic success:^(id responseData) {
        [self hideHUD];
        FLLog(@"%@",responseData);
        NSInteger is_agree_pos = [[responseData objectForKey:@"is_agree_pos"] integerValue];
        if (is_agree_pos == 1) { //已同意申请协议
            ApplyPOSViewController *applyPOSVC = [ApplyPOSViewController new];
            [self.navigationController pushViewController:applyPOSVC animated:YES];
        }else {
            POSAgreementViewController *posVc = [POSAgreementViewController new];
            [self.navigationController pushViewController:posVc animated:YES];
        }
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)seeMyTask:(UIButton *)sender {
    TaskAlertView *alert = [[[NSBundle mainBundle] loadNibNamed:@"TaskAlertView" owner:self options:nil] firstObject];
    alert.day = self.taskDay;
    alert.hour = self.taskHour;
    alert.minute = self.taskMinute;
    alert.taskType = self.taskType;
    [alert show];
}

- (void)taskAlertActionEvent:(UIButton *)sender {
    
}

-(void)clickAgentEvent:(UIButton *)button_{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHTOCard(@"User/getToIDBankInfo") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        [self hideHUD];
        UserRealAuthModel *model = [UserRealAuthModel parseModel:responseData];
        AgentInforViewController *agentInfor = [AgentInforViewController new];
        agentInfor.userRealModel = model;
        [self.navigationController pushViewController:agentInfor animated:YES];
    } failed:^(NSDictionary *errorDic) {
        if ([[errorDic objectForKey:@"error_code"] integerValue] == 2010002) {
            [self hideHUD];
            AgentCertificationViewController *agentVc = [AgentCertificationViewController new];
            
            [self.navigationController pushViewController:agentVc animated:YES];
        }else{
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
}

- (void)buyCard:(UIButton *)sender {    
    [self showHUDWithMessage:nil];
    NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID],
                            @"token": [FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATHShop(@"api/goods/getTocardId") parameters:param success:^(id response) {
        NSString *goods_id = [response objectForKey:@"goods_id"];
        if ([goods_id integerValue] > 0) {
            [self hideHUD];
            ProductDetailViewController *product = [[ProductDetailViewController alloc] init];
            product.goods_id = goods_id;
            product.isTok = YES;
            [self.navigationController pushViewController:product animated:YES];
        } else {
            [self showHUDWithResult:NO message:@"找不到对应商品"];
        }
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)inviteFriends:(UIButton *)sender {
    if (self.qrCodeData) {
        [self showInviteView];
        return;
    }
    [self showHUDWithMessage:nil];
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATH(@"Api/User/myTocardShareInfo") parameters:dic success:^(id responseData) {
        self.qrCodeData = responseData;
        [self showInviteView];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)showInviteView {
    InviteFriendsView *inviteView = [[InviteFriendsView alloc] initWithFrame:self.view.bounds];
    inviteView.dataDic = [self.qrCodeData copy];
    inviteView.nameLab.text = self.mySelf.user_name;
    inviteView.invateCode.text = [NSString stringWithFormat:@"我的邀请码：%@",[self.qrCodeData objectForKey:@"recommended_encode"]];
    NSString *code_thumb = [NSString stringWithFormat:@"%@",[[self.qrCodeData objectForKey:@"share_info"] objectForKey:@"code_thumb"]];
    [inviteView.qrcodeIm sd_setImageWithURL:[NSURL URLWithString:code_thumb]];
    [inviteView.headIm sd_setImageWithURL:[NSURL URLWithString:self.mySelf.photo_url] placeholderImage:defaultUserHead];
    NSString *imageStr = [NSString stringWithFormat:@"mine_grade_v%ld", (long)[self.mySelf.grade integerValue]];
    [inviteView.imageTag setImage:imageWithName(imageStr)];
    [[UIApplication sharedApplication].keyWindow addSubview:inviteView];
}

- (void)exchangeMyMember:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您确定要取消该成员的置换？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = sender.tag;
        [alert show];
        return;
    }
    if (self.ischageStatus) {
        UIAlertView *alterV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前还有成员在置换中，每次最多只能置换一人" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterV show];
        return;
    }
    if (self.myMembers.count < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"当前前排成员数不足6人，无法执行置换操作"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"设置置换后，该成员的状态为置换中，新成员进入后，该成员会挂在新成员名下；新成员进入前，可取消置换。您是否确定要置换该前排成员？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"置换", nil];
    alert.tag = sender.tag;
    [alert show];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.myMonster) {
            return 1;
        }
        return 0;
    } else if (section == 1) {
        return self.myMembers.count;
    } else if (section == 2) {
        return self.myDirects.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TOCardMemberHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TOCardMemberHeaderView"];
    header.contentView.backgroundColor = [UIColor backgroundColor];
    if (section == 0) {
        header.titleLabel.text = @"我的导师";
        header.infoLabel.hidden = YES;
        header.infoBtn.hidden = YES;
    } else if (section == 1) {
        header.titleLabel.text = [NSString stringWithFormat:@"我的前排（%ld）",(long)self.myMembers.count];
        header.infoLabel.hidden = YES;
//        header.infoBtn.hidden = self.taskType == TaskTypeNone;//注释掉查看我的任务功能
        header.infoBtn.hidden = YES; //隐藏查看任务按钮
//        [header.infoBtn addTarget:self action:@selector(seeMyTask:) forControlEvents:UIControlEventTouchUpInside];
    } else if(section == 2) {
        header.titleLabel.text = [NSString stringWithFormat:@"我的直推（%ld）",(long)self.totalDirect];
        header.infoLabel.hidden = NO;
        header.infoBtn.hidden = YES;
        [header setInfoLabelBenifitLayer:MIN(6, self.totalDirect)];
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TOCardMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TOCardMemberTableViewCell"];
    TOCardMemberModel *model = nil;
    if (indexPath.section == 0) {
        model = self.myMonster;
        cell.memberDownLine.hidden = YES;
        cell.memberDownLineTitle.hidden = YES;
        cell.changeBtn.hidden = YES;
        cell.exchangeTag.hidden = YES;
    } else if (indexPath.section == 1) {
        model = [self.myMembers objectAtIndex:indexPath.row];
        cell.memberDownLine.hidden = NO;
        cell.memberDownLineTitle.hidden = NO;
        cell.changeBtn.hidden = NO;
        if ([model.is_remove integerValue] == 1) {
            self.ischageStatus = YES;
            cell.exchangeTag.hidden = NO;
            [cell.changeBtn setTitle:@"取消" forState:UIControlStateNormal];
        }else {
            cell.exchangeTag.hidden = YES;
            [cell.changeBtn setTitle:@"置换" forState:UIControlStateNormal];
        }
    } else if (indexPath.section == 2) {
        model = [self.myDirects objectAtIndex:indexPath.row];
        cell.memberDownLine.hidden = NO;
        cell.memberDownLineTitle.hidden = NO;
        cell.changeBtn.hidden = YES;
        cell.exchangeTag.hidden = YES;
    }
    [cell.memberImg sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:defaultUserHead];
    cell.memberName.text = [NSString stringWithFormat:@"%@(%@)",model.user_name, model.telephone];
    cell.gradeImage.hidden = YES;
    cell.memberLevel.text = [NSString stringWithFormat:@"V%ld", (long)[model.grade integerValue]];
    cell.memberDownLine.text = [NSString stringWithFormat:@"%@人", model.low_members_count];
    cell.delegate = self;
    cell.changeBtn.tag = indexPath.row;
    [cell.changeBtn addTarget:self action:@selector(exchangeMyMember:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TOCardMemberModel *model = nil;
    if (indexPath.section == 0) {
        return;
    } else if (indexPath.section == 1) {
        model = [self.myMembers objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        model = [self.myDirects objectAtIndex:indexPath.row];
    }
    TOCardMembersViewController *member = [[TOCardMembersViewController alloc] init];
    member.rootMember = model;
    member.isDirectMembers = indexPath.section == 2;
    [self.navigationController pushViewController:member animated:YES];
}

#pragma mark - TOCardMemberTableViewCellDelegate
- (void)didTapCallPhoneBtn:(TOCardMemberTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TOCardMemberModel *model = nil;
    if (indexPath.section == 0) {
        model = self.myMonster;
    } else if (indexPath.section == 1) {
        model = [self.myMembers objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        model = [self.myDirects objectAtIndex:indexPath.row];
    }
    [FrankTools detailPhone:model.telephone];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"] && buttonIndex == 1) { //表示取消置换操作
        TOCardMemberModel *model = [self.myMembers objectAtIndex:alertView.tag];
        UserModel *user = [self getUserData];
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID],
                                @"token": [FrankTools getUserToken],
                                @"remove_id": @([model.user_id integerValue]),
                                @"action": @"0"};
        [MainRequest RequestHTTPData:PATHTOCard(@"Referee/replaceToStright") parameters:param success:^(id response) {
            NSDictionary *param2 = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"ru_id": user.user_id};
            [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserLowLayerMembers") parameters:param2 success:^(id response2) {
                NSDictionary *listData = [response2 objectForKey:@"datalist"];
                self.myMembers = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:listData];
                [self.tableView reloadData];
                self.ischageStatus = NO;
                [self showHUDWithResult:YES message:@"取消置换成功"];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
        return;
    }
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"置换"] && buttonIndex == 1) {
        TOCardMemberModel *model = [self.myMembers objectAtIndex:alertView.tag];
        UserModel *user = [self getUserData];
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID],
                                @"token": [FrankTools getUserToken],
                                @"remove_id": @([model.user_id integerValue]),
                                @"action": @"1"};
        [MainRequest RequestHTTPData:PATHTOCard(@"Referee/replaceToStright") parameters:param success:^(id response) {
            NSDictionary *param2 = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"ru_id": user.user_id};
            [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserLowLayerMembers") parameters:param2 success:^(id response2) {
                NSDictionary *listData = [response2 objectForKey:@"datalist"];
                self.myMembers = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:listData];
                [self.tableView reloadData];
                [self showHUDWithResult:YES message:@"置换成功"];
            } failed:^(NSDictionary *errorDic) {
                [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

@end
