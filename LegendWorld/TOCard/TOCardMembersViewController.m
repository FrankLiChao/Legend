//
//  TOCardMembersViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardMembersViewController.h"

#import "TOCardMemberHeaderView.h"
#import "TOCardMemberTableViewCell.h"
#import "LoadControl.h"

@interface TOCardMembersViewController () <UITableViewDataSource, UITableViewDelegate, TOCardMemberTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *members;
@property (nonatomic) NSInteger totalDirect;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger maxPageIndex;

@end

@implementation TOCardMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成员详情";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.rowHeight = 70;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 25);
    self.tableView.separatorColor = [UIColor seperateColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"TOCardMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"TOCardMemberTableViewCell"];
    [self.tableView registerClass:[TOCardMemberHeaderView class] forHeaderFooterViewReuseIdentifier:@"TOCardMemberHeaderView"];
    
    self.pageIndex = 1;
    __weak typeof(self) weakSelf = self;
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.tableView];
    loadControl.color = [UIColor noteTextColor];
    loadControl.displayCondition = ^{
        if (weakSelf.isDirectMembers) {
            BOOL isDisplay = weakSelf.members.count > 0;
            return isDisplay;
        }
        return NO;
    };
    loadControl.loadAllCondition = ^{
        if (weakSelf.isDirectMembers) {
            BOOL isLoadAll = weakSelf.pageIndex >= weakSelf.maxPageIndex;
            return isLoadAll;
        }
        return NO;
    };
    [loadControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom
- (void)loadData {
    if (self.isDirectMembers) {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"ru_id": self.rootMember.user_id ? self.rootMember.user_id : @"", @"pg":@(1)};
        [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserOriginUser") parameters:param success:^(id response) {
            self.maxPageIndex = [[response objectForKey:@"origin_users_pages"] integerValue];
            self.totalDirect = [[response objectForKey:@"origin_users_count"] integerValue];
            NSDictionary *listData = [response objectForKey:@"datalist"];
            self.members = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:listData];
            [self.tableView reloadData];
            [self hideHUD];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } else {
        [self showHUDWithMessage:nil];
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"ru_id": self.rootMember.user_id ? self.rootMember.user_id : @""};
        [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserLowLayerMembers") parameters:param success:^(id response) {
            NSDictionary *listData = [response objectForKey:@"datalist"];
            self.members = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:listData];
            [self.tableView reloadData];
            [self hideHUD];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

- (void)loadMoreData:(LoadControl *)loadControl {
    if (self.isDirectMembers) {
        NSInteger nextPage = self.pageIndex + 1;
        NSDictionary *param = @{@"device_id": [FrankTools getDeviceUUID], @"token": [FrankTools getUserToken], @"ru_id": self.rootMember.user_id, @"pg": @(nextPage)};
        [MainRequest RequestHTTPData:PATHTOCard(@"Referee/getUserOriginUser") parameters:param success:^(id response) {
            self.pageIndex = nextPage;
            self.maxPageIndex = [[response objectForKey:@"origin_users_pages"] integerValue];
            self.totalDirect = [[response objectForKey:@"origin_users_count"] integerValue];
            NSDictionary *listData = [response objectForKey:@"datalist"];
            NSArray *myAddDirects = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:listData];
            NSMutableArray *myDirectsM = [NSMutableArray arrayWithArray:self.members];
            [myDirectsM addObjectsFromArray:myAddDirects];
            self.members = [myDirectsM copy];
            [self.tableView reloadData];
            [loadControl endLoading:YES];
        } failed:^(NSDictionary *errorDic) {
            [loadControl endLoading:NO];
        }];
    } else {
        [loadControl endLoading:YES];
    }
}

- (void)callPhone:(id)sender {
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.members.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TOCardMemberHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TOCardMemberHeaderView"];
    header.contentView.backgroundColor = [UIColor backgroundColor];
    header.backgroundColor = [UIColor clearColor];
    if (section == 1) {
        if (self.isDirectMembers) {
            header.titleLabel.text = [NSString stringWithFormat:@"TA的直推（%ld）", (long)self.totalDirect];
            header.infoLabel.hidden = NO;
            header.infoBtn.hidden = YES;
            [header setInfoLabelBenifitLayer:MIN(6, self.totalDirect)];
        } else {
            header.titleLabel.text = [NSString stringWithFormat:@"TA的前排（%ld）", (long)[self.rootMember.low_one_members_count integerValue]];
            header.infoLabel.hidden = YES;
            header.infoBtn.hidden = YES;
            if ([self.rootMember.low_one_members_count integerValue] < 6) {
                header.infoLabel.hidden = NO;
                [header setInfoLabelRemainCount:6 - [self.rootMember.low_one_members_count integerValue]];
            }
        }
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TOCardMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TOCardMemberTableViewCell"];
    cell.gradeImage.hidden = indexPath.section != 0;
    TOCardMemberModel *model = nil;
    if (indexPath.section == 0) {
        model = self.rootMember;
        cell.gradeImage.hidden = NO;
    } else {
        model = [self.members objectAtIndex:indexPath.row];
        cell.gradeImage.hidden = YES;
    }
    NSString *imageStr = [NSString stringWithFormat:@"mine_grade_v%ld", (long)[model.grade integerValue]];
    cell.gradeImage.image = [UIImage imageNamed:imageStr];
    [cell.memberImg sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:defaultUserHead];
    cell.memberName.text = [NSString stringWithFormat:@"%@（%@）",model.user_name, model.telephone];
    cell.memberLevel.text = [NSString stringWithFormat:@"V%ld", (long)[model.grade integerValue]];
    cell.memberDownLine.text = [NSString stringWithFormat:@"%@人", model.low_members_count];
    cell.changeBtn.hidden = YES;
    cell.delegate = self;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index - 1 >= 0 && ![[self.navigationController.viewControllers objectAtIndex:index - 1] isKindOfClass:[TOCardMembersViewController class]]) {
            TOCardMembersViewController *member = [[TOCardMembersViewController alloc] init];
            member.rootMember = [self.members objectAtIndex:indexPath.row];
            member.isDirectMembers = self.isDirectMembers;
            [self.navigationController pushViewController:member animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TOCardMemberTableViewCellDelegate
- (void)didTapCallPhoneBtn:(TOCardMemberTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TOCardMemberModel *model = nil;
    if (indexPath.section == 0) {
        model = self.rootMember;
    } else {
        model = [self.members objectAtIndex:indexPath.row];
    }
    [FrankTools detailPhone:model.telephone];
}

@end
