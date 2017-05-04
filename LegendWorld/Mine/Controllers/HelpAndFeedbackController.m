//
//  HelpAndFeedbackController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "HelpAndFeedbackController.h"
#import "FeedbackViewController.h"
#import "HelpAndFeedbackDetailViewController.h"
#import "LoadControl.h"
@interface HelpAndFeedbackController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *helpAndFeedbackTableView;
@property (nonatomic, strong) NSMutableArray *helpAndFeedbackListArr;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger maxPageIndex;
@end

@implementation HelpAndFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助与反馈";
    self.pageIndex = 1;
    self.helpAndFeedbackListArr = [NSMutableArray array];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"意见反馈" style: UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.borderColor = [UIColor seperateColor].CGColor;
    [self netRequest];
    __weak typeof (self) weakSelf = self;
    LoadControl *loadControl = [[LoadControl alloc] initWithScrollView:self.helpAndFeedbackTableView];
    loadControl.color = [UIColor noteTextColor];
    loadControl.displayCondition = ^{
        BOOL isDisplay = weakSelf.helpAndFeedbackListArr.count > 0;
        return isDisplay;
    };
    loadControl.loadAllCondition = ^{
        BOOL isLoadAll = weakSelf.pageIndex >= weakSelf.maxPageIndex;
        return isLoadAll;
    };
    [loadControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadMoreData:(LoadControl *)loadControl
{
    self.pageIndex ++;
    [self netRequest];
}
- (void)netRequest
{
    [self showHUDWithMessage:@""];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"page":[NSNumber numberWithInteger:self.pageIndex]};
    [MainRequest RequestHTTPData:PATH(@"Api/Help/getHelpList") parameters:parameters success:^(id response) {
        FLLog(@"response ======= %@",response);
        for (HelpAndFeedbackModel *model in [HelpAndFeedbackModel parseResponse:response]) {
            [self.helpAndFeedbackListArr addObject:model];
        }
        [self hideHUD];
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        [self.helpAndFeedbackTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        FLLog(@"errorDic ======= %@",errorDic);
        [self hideHUD];
    }];
}

- (void)rightBarItemClick
{
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedbackVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.helpAndFeedbackListArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellKey"];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:@"cellKey"];
    }
    HelpAndFeedbackModel *model = self.helpAndFeedbackListArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor titleTextColor];
    cell.textLabel.text = model.title;
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(0, cell.frame.size.height - 1, DeviceMaxWidth, 1);
    lbl.backgroundColor =  [UIColor backgroundColor];
    [cell.contentView addSubview:lbl];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpAndFeedbackModel *model = self.helpAndFeedbackListArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HelpAndFeedbackDetailViewController *helpAndFeedbackDetailVC = [[HelpAndFeedbackDetailViewController alloc] init];
    helpAndFeedbackDetailVC.hidesBottomBarWhenPushed = YES;
    helpAndFeedbackDetailVC.helpId = model.help_id;
    [self.navigationController pushViewController:helpAndFeedbackDetailVC animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.pageIndex = 1;
    [textField endEditing:YES];
    [self showHUDWithMessage:@""];
    [self.helpAndFeedbackListArr removeAllObjects];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"page":[NSNumber numberWithInteger:self.pageIndex],@"keywords":textField.text};
    [MainRequest RequestHTTPData:PATH(@"Api/Help/getHelpList") parameters:parameters success:^(id response) {
        FLLog(@"response ======= %@",response);
        for (HelpAndFeedbackModel *model in [HelpAndFeedbackModel parseResponse:response]) {
            [self.helpAndFeedbackListArr addObject:model];
        }
        if ([[HelpAndFeedbackModel parseResponse:response] count] == 0) {
          [self showHUDWithResult:NO message:@"未查到相关信息"];
        }
        self.maxPageIndex = [[response objectForKey:@"total_page"] integerValue];
        [self.helpAndFeedbackTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        FLLog(@"errorDic ======= %@",errorDic);
    }];
    return YES;
}
@end
