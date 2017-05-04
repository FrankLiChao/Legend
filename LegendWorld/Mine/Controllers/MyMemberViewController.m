//
//  MyMemberViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyMemberViewController.h"
#import "MyMemberCell.h"
#import "MainRequest.h"
#import "MyMemberModel.h"
#import "MyMemberTitleView.h"
#import "MyMemberHeaderView.h"

@interface MyMemberViewController ()<UITableViewDelegate,UITableViewDataSource,callMemberDelegate,RefreshingViewDelegate>

@property (strong, nonatomic) MyMemberModel *myMemberModel;
@property (strong, nonatomic) NSMutableArray *phoneNumArr;
@property (nonatomic) BOOL ifYouAreTheMonster;
@property (weak, nonatomic) IBOutlet UITableView *myMemberTableView;
@end

@implementation MyMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的成员";
    self.ifYouAreTheMonster = NO;//默认不是顶级大师
    self.myMemberModel = [[MyMemberModel alloc] init];
    self.phoneNumArr = [NSMutableArray array];
    [self requestData];
    MyMemberHeaderView *myMemberHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"MyMemberHeaderView" owner:self options:nil] firstObject];
    myMemberHeaderView.frame = CGRectMake(0, 0, DeviceMaxWidth, 95);
    self.myMemberTableView.tableHeaderView = myMemberHeaderView;
}

-(void)requestData{
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":[FrankTools getUserToken]};
    [self showHUD];
    [MainRequest RequestHTTPData:PATH(@"api/user/getMyArmyNew") parameters:parameters success:^(id response) {
        self.myMemberModel.armyListModel = [ArmyListModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"army_list"]];
        if ([[response objectForKey:@"teacher"] isKindOfClass:[NSDictionary class]]) {
            self.myMemberModel.teacherModel = [TeacherModel mj_objectWithKeyValues:[response objectForKey:@"teacher"]];
            [self.phoneNumArr addObject:self.myMemberModel.teacherModel.mobile_no];
            for (ArmyListModel *model in self.myMemberModel.armyListModel) {
                [self.phoneNumArr addObject:model.mobile_no];
            }
        } else {
            self.ifYouAreTheMonster = YES;
            for (ArmyListModel *model in self.myMemberModel.armyListModel) {
                [self.phoneNumArr addObject:model.mobile_no];
            }
        }
        self.myMemberTableView.delegate = self;
        self.myMemberTableView.dataSource = self;
        [self.myMemberTableView reloadData];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        if ([self isReLogin:errorDic]) {
            [self hideHUD];
            [self popLoginView:self];
        } else {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
}

-(void)refreshingUI{
    [self requestData];
}

#pragma mark - 创建tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ifYouAreTheMonster == YES) {
        return self.myMemberModel.armyListModel.count;
    }
    if (section == 0) {
        return 1;
    }
    return self.myMemberModel.armyListModel.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.ifYouAreTheMonster == YES) {
        return 1;
    }
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyMemberTitleView *myMemberTitleV = [[[NSBundle mainBundle] loadNibNamed:@"MyMemberTitleView" owner:self options:nil] firstObject];
    if (self.ifYouAreTheMonster == YES) {
        if (self.myMemberModel.armyListModel.count>0) {
            myMemberTitleV.titleLab.text = @"我的成员";
            return myMemberTitleV;
        }
        myMemberTitleV.titleLab.hidden = YES;
        myMemberTitleV.memberLeftLab.hidden = YES;
        return myMemberTitleV;
    }
    if (section == 0) {
        myMemberTitleV.titleLab.text = @"我的导师";
        myMemberTitleV.memberLeftLab.hidden = YES;
    }
    else{
        myMemberTitleV.titleLab.text = [NSString stringWithFormat:@"我的成员(%ld)",(unsigned long)self.myMemberModel.armyListModel.count];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前成员数还差%ld人",(6 - self.myMemberModel.armyListModel.count)]];
        [str addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(7,1)];
        myMemberTitleV.memberLeftLab.attributedText = str;
    }
    return myMemberTitleV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (DeviceMaxWidth == 320) {
        return 40*widthRate;
    }
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMemberCell *myMemberCell = [tableView dequeueReusableCellWithIdentifier:@"MyMemberCellKey"];
    if (!myMemberCell) {
        myMemberCell = [[[NSBundle mainBundle] loadNibNamed:@"MyMemberCell" owner:self options:nil] firstObject];
    }
    myMemberCell.delegate = self;
    if (self.ifYouAreTheMonster == YES) {
        ArmyListModel *model = self.myMemberModel.armyListModel[indexPath.row];
        [FrankTools setImgWithImgView:myMemberCell.memberIconIma withImageUrl:model.photo_url withPlaceHolderImage:defaultUserHead];
        myMemberCell.memberNameLab.text = model.name;
        myMemberCell.memberPhoneLab.text = [NSString stringWithFormat:@"(%@)",model.mobile_no];
        myMemberCell.memberLevelLab.text = model.duty;
        myMemberCell.memberPersonLab.text = [NSString stringWithFormat:@"%@人",model.children_num];
        myMemberCell.tag = indexPath.row;
        return myMemberCell;
    }
    if ([indexPath section] == 0) {
        TeacherModel *model = self.myMemberModel.teacherModel;
        [FrankTools setImgWithImgView:myMemberCell.memberIconIma withImageUrl:model.photo_url withPlaceHolderImage:defaultUserHead];
        myMemberCell.memberNameLab.text = model.name;
        myMemberCell.memberPhoneLab.text = [NSString stringWithFormat:@"(%@)",model.mobile_no];
        myMemberCell.memberLevelLab.text = model.duty;
        myMemberCell.changeMemberBtn.hidden = YES;
        myMemberCell.memberPersonLab.text = [NSString stringWithFormat:@"%@人",model.num];
        myMemberCell.tag = indexPath.row;
    }
    if ([indexPath section] == 1) {
        ArmyListModel *model = self.myMemberModel.armyListModel[indexPath.row];
        [FrankTools setImgWithImgView:myMemberCell.memberIconIma withImageUrl:model.photo_url withPlaceHolderImage:defaultUserHead];
        myMemberCell.memberNameLab.text = model.name;
        myMemberCell.memberPhoneLab.text = [NSString stringWithFormat:@"(%@)",model.mobile_no];
        myMemberCell.memberLevelLab.text = model.duty;
        myMemberCell.memberPersonLab.text = [NSString stringWithFormat:@"%@人",model.children_num];
        myMemberCell.tag = indexPath.row;
    }
    return myMemberCell;
}
-(void)callMemberAct:(NSInteger)num
{
    [FrankTools detailPhone:self.phoneNumArr[num]];
}
-(void)changeMemberAct:(NSInteger)num
{
    if (self.myMemberModel.armyListModel.count < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前成员数不足6人，无法执行下换操作" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"下换后该成员会任意分配到你下线成员的团队中" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            ArmyListModel *model = self.myMemberModel.armyListModel[num];
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"remove_id":model.user_id,@"action":[NSNumber numberWithInteger:1]};
            [MainRequest RequestHTTPData:PATH(@"Api/User/replaceStright") parameters:parameters success:^(id response) {
                [self showHUDWithResult:YES message:@"移除成功"];
            } failed:^(NSDictionary *errorDic) {
                if ([[errorDic objectForKey:@"error_code"] integerValue] == 2041001) {
                    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"处理失败" message:@"有直属前排还未完成下换" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alterView show];
                } else {
                    [self showHUDWithResult:NO message:@"移除失败"];
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
}
-(void)dealloc{
    
}
@end
