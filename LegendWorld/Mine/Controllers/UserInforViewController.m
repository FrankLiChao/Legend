//
//  UserInforViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/9/19.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "UserInforViewController.h"
#import "UserInforModel.h"
#import "UserFixInforViewController.h"
#import "ChooseRebingWayViewController.h"
#import "GradeViewController.h"
#import "VIPGreadeModel.h"
#import "BecomeDelegateViewController.h"
#import "ImageBrowserView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "AddressManagerViewController.h"

@interface UserInforViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,ChangeUserInforDelegate,RefreshingViewDelegate, AddressManagerViewControllerDelegate>

@property (strong, nonatomic) UserInforModel *userInforModel;
//用户姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
//用户邮箱输入框

@property (weak, nonatomic) IBOutlet UITextField *userEmailTF;
//用户微信输入框
@property (weak, nonatomic) IBOutlet UITextField *userWeChatTF;
//用户性别显示框
@property (weak, nonatomic) IBOutlet UILabel *userSexLab;
//用户头像图片

@property (weak, nonatomic) IBOutlet UIImageView *userIconIma;
//用户地址显示框
@property (weak, nonatomic) IBOutlet UIButton *gradeBtn;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLab;
//用户电话绑定显示框
@property (weak, nonatomic) IBOutlet UILabel *userCellPhoneBindingLab;
@property (weak, nonatomic) IBOutlet BaseTextField *levelTF;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *acounLab;
@end

@implementation UserInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.userIconIma.layer.cornerRadius = 30;
    self.userIconIma.layer.masksToBounds = YES;
    self.userIconIma.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectActionBigImage)];
    [self.userIconIma addGestureRecognizer:tapGesture];
    
    self.userNameTF.delegate = self;
    self.userEmailTF.delegate = self;
    self.userWeChatTF.delegate = self;
    [self.gradeBtn addTarget:self action:@selector(clickGradeEvent:) forControlEvents:UIControlEventTouchUpInside];
    _personLab.textColor = contentTitleColorStr2;
    _acounLab.textColor = contentTitleColorStr2;
    _acounLab.backgroundColor = viewColor;
    [self getNetData];
}

-(void)dealloc{


}



-(void)getNetData
{
    if (!self.userInforModel) {
        self.userInforModel = [[UserInforModel alloc] init];
    }
    [self showHUD];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":[FrankTools getUserToken]};
    [MainRequest RequestHTTPData:PATH(@"api/user/getUserInfo") parameters:parameters success:^(id responseData) {
        [self hideHUD];
        self.userInforModel = [UserInforModel mj_objectWithKeyValues:[responseData objectForKey:@"user_info"]];
        [self userInforDataBuild];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateUserData];
        });
    } failed:^(NSDictionary *errorDic) {
        if ([self isReLogin:errorDic]){
            [self hideHUD];
            [self popLoginView:self];
        } else {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
}

-(void)refreshingUI{
    [self getNetData];
}

-(void)userInforDataBuild
{
    [FrankTools setImgWithImgView:_userIconIma withImageUrl:self.userInforModel.photo_url withPlaceHolderImage:defaultUserHead];
    if (self.userInforModel.user_name.length == 0) {
        self.userNameTF.text = self.userInforModel.mobile_no;
    }
    self.userNameTF.text = self.userInforModel.user_name;
    if ([self.userInforModel.sex isEqualToString:@"2"]) {
       self.userSexLab.text = @"男";
    }
    if ([self.userInforModel.sex isEqualToString:@"1"]) {
        self.userSexLab.text = @"女";
    }
    if ([self.userInforModel.sex isEqualToString:@"0"]) {
        self.userSexLab.text = @"男";
    }
    if ([self.userInforModel.honor_grade integerValue] == 0) {
        self.levelTF.text = [NSString stringWithFormat:@""];
    }else {
        self.levelTF.text = [NSString stringWithFormat:@"V%@",self.userInforModel.honor_grade];
    }
    self.userAddressLab.text = self.userInforModel.address;
    self.userCellPhoneBindingLab.text = self.userInforModel.mobile_no;
    self.userEmailTF.text = self.userInforModel.email;
    self.userWeChatTF.text = self.userInforModel.wx_account;
    
}

-(void)clickGradeEvent:(UIButton *)button_{
    FLLog(@"代理等级");
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"api/User/getVipGradeInfo") parameters:dic success:^(id responseData) {
        FLLog(@"%@",responseData);
        [self showHUDWithResult:YES message:nil];
        VIPGreadeModel *model = [VIPGreadeModel parseVIPGreadeResponse:responseData];
        GradeViewController *gradeView = [GradeViewController new];
        gradeView.vipModel = model;
        [self.navigationController pushViewController:gradeView animated:YES];
    } failed:^(NSDictionary *errorDic) {
        if ([[errorDic objectForKey:@"error_code"] integerValue] == 400004) {
            [self hideHUD];
            BecomeDelegateViewController *testVc = [BecomeDelegateViewController new];
            [self.navigationController pushViewController:testVc animated:YES];
        }else{
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)selectActionBigImage
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.image = self.userIconIma.image; //图片
    photo.srcImageView = self.userIconIma;
    [photos addObject:photo];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (IBAction)userIconAct:(UIButton *)sender {
    UIActionSheet *iconSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"拍照",@"相册",nil];

    [iconSheet showInView:self.view];
}
- (IBAction)userSexAct:(UIButton *)sender {
    UIActionSheet *sexSheet = [[UIActionSheet alloc]
                    initWithTitle:nil
                    delegate:self
                    cancelButtonTitle:@"取消"
                    destructiveButtonTitle:nil
                    otherButtonTitles:@"男",@"女",nil];
    
    [sexSheet showInView:self.view];
}
- (IBAction)userAddressAct:(UIButton *)sender {
    AddressManagerViewController *address = [AddressManagerViewController new];
    address.delegate = self;
    [self.navigationController pushViewController:address animated:YES];
}

- (void)modifyAddress:(RecieveAddressModel *)address {
    NSString *addressStr = [NSString stringWithFormat:@"%@ %@",address.area,address.address];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"field":@"address",
                                 @"value":addressStr,
                                 @"token":[FrankTools getUserToken]};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
        self.userAddressLab.text = [NSString stringWithFormat:@"%@",addressStr];
        [self updateUserData];
        [self showHUDWithResult:YES message:@"地址修改成功"];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}


- (IBAction)userCellPhoneBindingAct:(UIButton *)sender {
    ChooseRebingWayViewController *chooseRebingWayVC = [[ChooseRebingWayViewController alloc] init];
    chooseRebingWayVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chooseRebingWayVC animated:YES];
}

-(void)sendAddressBackAct:(NSArray *)addressArr
{
    self.userAddressLab.text = [NSString stringWithFormat:@"%@%@",addressArr[0],addressArr[2]];
}

#pragma mark - uiimagePickerView
// 打开相机
- (void)openCamera {
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        return ;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = YES;
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
    
}

// 打开相册
- (void)openPics {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *userImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID]};
    [MainRequest uploadPhoto:ImagePATH(@"utility/upload_img.php") parameters:parameters imageD:userImage success:^(id responseObject) {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"field":@"photo_url",@"value":[[responseObject objectForKey:@"data"] objectForKey:@"img_path"],@"token":[FrankTools getUserToken]};
        [self showHUD];
        [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
            [self updateUserData];
            _userIconIma.image = userImage;
            [self showHUDWithResult:YES message:@"上传成功"];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } failed:^(NSError *error) {
        [self showHUDWithResult:NO message:@"上传失败"];
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 保存图片后到相册后，调用的相关方法，查看是否保存成功
- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"拍照"]) {
        [self openCamera];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"相册"]) {
        [self openPics];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"男"]) {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"field":@"sex",
                                     @"value":@"0",
                                     @"token":[FrankTools getUserToken]};
        [self showHUD];
        [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
            [self updateUserData];
            _userSexLab.text = @"男";
            [self hideHUD];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"女"]) {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                     @"field":@"sex",
                                     @"value":@1,
                                     @"token":[FrankTools getUserToken]};
        [self showHUD];
        [MainRequest RequestHTTPData:PATH(@"api/user/changeUserinfo") parameters:parameters success:^(id responseData) {
            [self updateUserData];
            _userSexLab.text = @"女";
            [self hideHUD];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
    return;
}

- (IBAction)userNameAct:(UIButton *)sender {
    [self pushToWhichViewController:@"userName"];
}

- (IBAction)userEmailAct:(UIButton *)sender {
    [self pushToWhichViewController:@"userEmail"];
}

- (IBAction)userWeChatAct:(UIButton *)sender {
    [self pushToWhichViewController:@"userWeChat"];
}

-(void)pushToWhichViewController:(NSString *)whichOne
{
    UserFixInforViewController *userFixInforVC = [[UserFixInforViewController alloc] init];
    userFixInforVC.hidesBottomBarWhenPushed = YES;
    userFixInforVC.whichToFixStr = whichOne;
    userFixInforVC.delegate = self;
    [self.navigationController pushViewController:userFixInforVC animated:YES];
}

-(void)changeUserInforProAct:(NSString *)changeStr andWhichTF:(NSString *)whichTF
{
    if ([whichTF isEqualToString:@"userName"]) {
        self.userNameTF.text = changeStr;
    }
    if ([whichTF isEqualToString:@"userEmail"]) {
        self.userEmailTF.text = changeStr;
    }
    if ([whichTF isEqualToString:@"userWeChat"]) {
        self.userWeChatTF.text = changeStr;
    }
}

-(void)tapOnCodeView:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}

@end
