//
//  SetViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SetViewController.h"
#import "SetViewCell.h"
#import "FrankTools.h"
#import "ResetKeyViewController.h"
#import "UserDelegateViewController.h"
#import "AboutUsViewController.h"
#import "SetPayKeyViewController.h"
#import "SetQuitCell.h"
#import "CustomAlterView.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,quitDelegate>

@property (weak, nonatomic) IBOutlet UITableView *setTableView;
@property (strong, nonatomic) NSArray *cellArr;
@property (strong, nonatomic) NSArray *cellSectionTwoArr;
@property (strong, nonatomic) NSArray *cellSectionThreeArr;
@property (strong, nonatomic) NSString *removeFileSize;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用设置";
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;
    self.cellArr = @[@"登录密码设置",@"支付密码设置"];
    self.cellSectionTwoArr = @[@"用户协议",@"关于我们"];
    self.cellSectionThreeArr = @[@"清除缓存",@"检查更新",@"客户电话"];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    CGFloat size = [self folderSizeAtMainPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtMainPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtMainPath:NSTemporaryDirectory()];
    self.removeFileSize = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM", size] : [NSString stringWithFormat:@"缓存%.2fK", size * 1024.0];
}
#pragma mark - 创建tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 4;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            if (DeviceMaxWidth == 320) {
                return 90*0.85;
            }
            return 90;
        }
    }
    if (DeviceMaxWidth == 320) {
        return 45*0.85;
    }
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            SetQuitCell *setQuitCell = [tableView dequeueReusableCellWithIdentifier:@"SetQuitCellKey"];
            if (!setQuitCell) {
                setQuitCell = [[[NSBundle mainBundle] loadNibNamed:@"SetQuitCell" owner:self options:nil] firstObject];
            }
            if (self.ifLogin == YES) {
                setQuitCell.quitBtn.hidden = NO;
            }
            else{
                setQuitCell.quitBtn.hidden = YES;
            }
            setQuitCell.delegate = self;
            return setQuitCell;
        }
        
    }
    SetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetViewCellKey"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetViewCell" owner:self options:nil] firstObject];
    }
    if (indexPath.section == 0) {
        cell.setTitleLab.text = self.cellArr[indexPath.row];
    }
    if (indexPath.section == 1) {
        cell.setTitleLab.text = self.cellSectionTwoArr[indexPath.row];
    }
    if (indexPath.section == 2) {
        cell.setTitleLab.text = self.cellSectionThreeArr[indexPath.row];
        cell.setArrowIma.hidden = YES;
        if (indexPath.row == 0) {
            cell.setContentLab.text = self.removeFileSize;
            cell.setContentLab.textColor = [UIColor lightGrayColor];
        }
        if (indexPath.row == 1) {
            cell.setContentLab.text = @"版本";
            cell.setContentLab.textColor = [UIColor darkGrayColor];
        }
        if (indexPath.row == 2) {
            cell.setContentLab.text = ServicePhone;
            cell.setContentLab.textColor = [UIColor orangeColor];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([FrankTools loginIsOrNot:self]) {
                ResetKeyViewController *resetKeyVC = [[ResetKeyViewController alloc] init];
                resetKeyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:resetKeyVC animated:YES];
            }
        }
        if (indexPath.row == 1) {
            if ([FrankTools loginIsOrNot:self]) {
//                UserModel *model = [self getUserData];
                if ([FrankTools isPayPassword]) {
                    ResetKeyViewController *resetKeyVC = [[ResetKeyViewController alloc] init];
                    resetKeyVC.hidesBottomBarWhenPushed = YES;
                    resetKeyVC.ifFromPayKeySetView = YES;
                    [self.navigationController pushViewController:resetKeyVC animated:YES];
                }
                else{
                    SetPayKeyViewController *setPayKeyVC = [[SetPayKeyViewController alloc] init];
                    setPayKeyVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:setPayKeyVC animated:YES];
                }
            }
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UserDelegateViewController *userDelegateVC = [[UserDelegateViewController alloc] init];
            userDelegateVC.hidesBottomBarWhenPushed = YES;
            userDelegateVC.sourceType = 0;
            [self.navigationController pushViewController:userDelegateVC animated:YES];
        }
        if (indexPath.row == 1) {
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
            aboutUsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self showHUDWithMessage:@"清理缓存中"];
            [self removeCacheAct];
        }
        if (indexPath.row == 1) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate checkAPPVersion];
        }
        if (indexPath.row == 2) {
            [FrankTools detailPhone:ServicePhone];
        }
        if (indexPath.row == 3) {

        }
    }



}
-(void)removeCacheAct
{
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
    [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
    [self cleanCaches:NSTemporaryDirectory()];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showHUDWithResult:YES message:@"清理成功"];
        self.removeFileSize = @"暂无缓存";
        [_setTableView reloadData];
    });
}

- (CGFloat)folderSizeAtMainPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

-(void)quitAct
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:saveLocalTokenFile] isEqualToString:@""]) {
        [self showHUDWithResult:NO message:@"账号没有登录"];
        return;
    }
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/user/logout") parameters:parameters success:^(id response) {
        [self showHUDWithResult:YES message:@"退出成功"];
        [FrankTools clearUserLocalData];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:YES message:@"退出成功"];
        [FrankTools clearUserLocalData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
