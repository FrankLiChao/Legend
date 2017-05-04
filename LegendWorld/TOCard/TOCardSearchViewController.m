//
//  TOCardSearchViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/12/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "TOCardSearchViewController.h"

#import "TOCardMemberTableViewCell.h"
#import "TOCardMemberHeaderView.h"
#import "TOCardMembersViewController.h"
#import "MJRefresh.h"

@interface TOCardSearchViewController () <UITableViewDataSource, UITableViewDelegate, TOCardMemberTableViewCellDelegate, UISearchBarDelegate>

@property (weak, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *myMembers;
@property (nonatomic,strong) NSArray *myDirects;
@property (nonatomic) NSInteger maxPageIndex;
@property (nonatomic) NSInteger pageNumber;

@end

@implementation TOCardSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30)];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.tintColor = [UIColor themeColor];
    self.searchBar.textColor = [UIColor bodyTextColor];
    self.searchBar.placeholder = @"请输入成员名或手机号查找";
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarBtnClicked:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.rowHeight = 70;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 25);
    self.tableView.separatorColor = [UIColor seperateColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"TOCardMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"TOCardMemberTableViewCell"];
    [self.tableView registerClass:[TOCardMemberHeaderView class] forHeaderFooterViewReuseIdentifier:@"TOCardMemberHeaderView"];
    
    self.pageNumber = 1;
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

- (void)footerRefresh
{
    if (self.pageNumber >= self.maxPageIndex) {
        [self.tableView footerEndRefreshing];
        return;
    }
    self.pageNumber ++;
    [self searchBarBtnClicked:nil];
    [self.tableView footerEndRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom
- (void)searchBarBtnClicked:(id)sender {
    NSString *text = self.searchBar.text.trim;
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"word":[NSString stringWithFormat:@"%@",text],
                          @"pg":[NSString stringWithFormat:@"%ld",self.pageNumber]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHTOCard(@"Referee/searchOriginUser") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        [self hideHUD];
        if (self.pageNumber == 1) {
            self.myDirects = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"datalist"]];
            self.maxPageIndex = [[responseData objectForKey:@"origin_users_pages"] integerValue];
        } else {
            NSMutableArray *array = [TOCardMemberModel mj_objectArrayWithKeyValuesArray:[responseData objectForKey:@"datalist"]];
            if (array.count > 0) {
                NSMutableArray *muArray = [[NSMutableArray alloc] initWithArray:self.myDirects];
                [muArray addObjectsFromArray:array];
                self.myDirects = muArray;
            }
        }
        if (self.myDirects.count == 0) {
            self.tableView.hidden = YES;
        }else{
            self.tableView.hidden = NO;
        }
        [self.tableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.myMembers.count;
    } else {
        return self.myDirects.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.myMembers.count > 0) {
            return 40;
        }
        return 0;
    } else {
        if (self.myDirects.count > 0) {
            return 40;
        }
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TOCardMemberHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TOCardMemberHeaderView"];
    header.contentView.backgroundColor = [UIColor backgroundColor];
    header.infoBtn.hidden = YES;
    header.infoLabel.hidden = YES;
    header.titleLabel.text = section == 0 ? @"我的前排" : @"我的直推";
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TOCardMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TOCardMemberTableViewCell"];
    TOCardMemberModel *model = indexPath.section == 0 ? [self.myMembers objectAtIndex:indexPath.row] : [self.myDirects objectAtIndex:indexPath.row];
    [cell.memberImg sd_setImageWithURL:[NSURL URLWithString:model.photo_url] placeholderImage:defaultUserHead];
    cell.memberName.text = [NSString stringWithFormat:@"%@（%@）",model.user_name, model.telephone];
    cell.memberLevel.text = [NSString stringWithFormat:@"V%ld", (long)[model.grade integerValue]];
    cell.memberDownLine.text = [NSString stringWithFormat:@"%@人", model.low_members_count];
    cell.changeBtn.hidden = indexPath.section != 0;
    cell.gradeImage.hidden = YES;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TOCardMemberModel *model = self.myDirects[indexPath.row];
    TOCardMembersViewController *member = [[TOCardMembersViewController alloc] init];
    member.rootMember = model;
    member.isDirectMembers = YES;
    [self.navigationController pushViewController:member animated:YES];
}

#pragma mark - TOCardMemberTableViewCellDelegate
- (void)didTapCallPhoneBtn:(TOCardMemberTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TOCardMemberModel *model = indexPath.section == 0 ? [self.myMembers objectAtIndex:indexPath.row] : [self.myDirects objectAtIndex:indexPath.row];
    [FrankTools detailPhone:model.telephone];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.navigationItem.rightBarButtonItem.enabled = searchText.trim.length > 0;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.pageNumber = 1;
    [self searchBarBtnClicked:nil];
}

@end
