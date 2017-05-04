//
//  CertificationUploadImageViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/15.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "CertificationUploadImageViewController.h"
#import "CertificationInfoViewController.h"
#import "PictureViewSend.h"

@interface CertificationUploadImageViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,deleteImageDelegate>

@property (weak, nonatomic) IBOutlet UIButton *IDFontBtn;
@property (weak, nonatomic) IBOutlet UIButton *IDBackBtn;
@property (weak, nonatomic) IBOutlet UIView *IDFontView;
@property (weak, nonatomic) IBOutlet UIView *IDBackView;
@property (weak, nonatomic) IBOutlet UIButton *IDHandHoldBtn;
@property (weak, nonatomic) IBOutlet UIView *IDHandHoldView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic) BOOL ifFont;
@property (nonatomic) BOOL ifBack;
@property (nonatomic) BOOL ifSelf;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (strong, nonatomic) NSString *frontImaUrl;
@property (strong, nonatomic) NSString *backImaUrl;
@property (strong, nonatomic) NSString *userIconImaUrl;
@property (nonatomic) NSUInteger sum;

@end

@implementation CertificationUploadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sendBtn.backgroundColor = [UIColor clearColor];
    [self.sendBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:6] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor noteTextColor] cornerRadius:6] forState:UIControlStateDisabled];
    
    self.imageArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<3; i++) {
        [self.imageArr addObject:@""];
    }
}

- (void)updateSendBtn {
    if (self.checkBtn.isSelected && self.sum == 3) {
        self.sendBtn.enabled = YES;
    } else {
        self.sendBtn.enabled = NO;
    }
}

- (IBAction)agreeBtnEvent:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [self updateSendBtn];
}

- (IBAction)seeAgreementEvent:(id)sender {
    CertificationInfoViewController *info = [[CertificationInfoViewController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
}

- (IBAction)IDFontAct:(UIButton *)sender {
    [(UIActionSheet *)[self createSheet] showInView:self.view];
    self.ifFont = YES;
    self.ifSelf = NO;
    self.ifBack = NO;
}

- (IBAction)IDBackAct:(UIButton *)sender {
    [(UIActionSheet *)[self createSheet] showInView:self.view];
    self.ifBack = YES;
    self.ifFont = NO;
    self.ifSelf = NO;
}

- (IBAction)IDHandHoldAct:(UIButton *)sender {
    [(UIActionSheet *)[self createSheet] showInView:self.view];
    self.ifSelf = YES;
    self.ifFont = NO;
    self.ifBack = NO;
}

- (IBAction)sendAct:(UIButton *)sender {
    if (self.sum < 3) {
        [self showHUDWithResult:NO message:@"请补齐您需要的提供的照片"];
        return;
    }
    [self showHUDWithMessage:@"请等待资料上传"];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID]};
    [MainRequest uploadPhoto:ImagePATH(@"utility/upload_img.php") parameters:parameters imageD:self.imageArr[0] success:^(id responseObject) {
        self.frontImaUrl = [[responseObject objectForKey:@"data"] objectForKey:@"img_path"];
        [self uploadData];
    } failed:^(NSError *error) {
        [self showHUDWithResult:NO message:@"身份证正面图片上传失败"];
    }];
    [MainRequest uploadPhoto:ImagePATH(@"utility/upload_img.php") parameters:parameters imageD:self.imageArr[1] success:^(id responseObject) {
        self.backImaUrl = [[responseObject objectForKey:@"data"] objectForKey:@"img_path"];
        [self uploadData];
    } failed:^(NSError *error) {
        [self showHUDWithResult:NO message:@"身份证背面图片上传失败"];
    }];
    [MainRequest uploadPhoto:ImagePATH(@"utility/upload_img.php") parameters:parameters imageD:self.imageArr[2] success:^(id responseObject) {
        self.userIconImaUrl = [[responseObject objectForKey:@"data"] objectForKey:@"img_path"];
        [self uploadData];
    } failed:^(NSError *error) {
        [self showHUDWithResult:NO message:@"半身照图片上传失败"];
    }];
}

- (void)uploadData {
    if (!self.userIconImaUrl) {
        return;
    }
    if (!self.frontImaUrl) {
        return;
    }
    if (!self.backImaUrl) {
        return;
    }
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":[FrankTools getUserToken],
                                 @"real_name":self.realNameStr,
                                 @"ID_card":self.IDCardStr,
                                 @"emergency_contact_name":self.conetctPersonNameStr,
                                 @"emergency_contact_phone":self.cellPhoneStr,
                                 @"ID_photo_front":self.frontImaUrl,
                                 @"ID_photo_back":self.backImaUrl,
                                 @"body_photo_half":self.userIconImaUrl};
    [MainRequest RequestHTTPData:PATH(@"Api/user/realNameAuth") parameters:parameters success:^(id response) {
        [self hideHUD];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提交成功" message:@"您提交的信息正在进行审核，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        [self updateUserData];
    } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];

}

- (UIActionSheet *)createSheet {
    UIActionSheet *picOrCameraSheet = [[UIActionSheet alloc]
                                       initWithTitle:nil
                                       delegate:self
                                       cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                       otherButtonTitles:@"拍照",nil];
    picOrCameraSheet.delegate = self;
    return picOrCameraSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self openCamera];
    }
}

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageCamera = [info objectForKey:UIImagePickerControllerEditedImage];
    PictureViewSend *pictureViewSend = [[[NSBundle mainBundle] loadNibNamed:@"PictureViewSend" owner:self options:nil] firstObject];
    if (self.ifFont) {
        self.IDFontView.hidden = NO;
        pictureViewSend.frame = CGRectMake(0, 0, self.IDFontView.frame.size.width, self.IDFontView.frame.size.height);
        pictureViewSend.pictureImage.image = imageCamera;
        pictureViewSend.deleteBtn.tag = 1;
        pictureViewSend.delegate = self;
        self.sum++;
        [self updateSendBtn];
        [self.imageArr setObject:imageCamera atIndexedSubscript:0];
        [self.IDFontView addSubview:pictureViewSend];
    }
    if (self.ifBack) {
        self.IDBackView.hidden = NO;
        pictureViewSend.frame = CGRectMake(0, 0, self.IDBackView.frame.size.width, self.IDBackView.frame.size.height);
        pictureViewSend.pictureImage.image = imageCamera;
        pictureViewSend.deleteBtn.tag = 2;
        pictureViewSend.delegate = self;
        self.sum++;
        [self updateSendBtn];
        [self.imageArr setObject:imageCamera atIndexedSubscript:1];
        [self.IDBackView addSubview:pictureViewSend];
    }
    if (self.ifSelf) {
        self.IDHandHoldView.hidden = NO;
        pictureViewSend.frame = CGRectMake(0, 0, self.IDHandHoldView.frame.size.width, self.IDHandHoldView.frame.size.height);
        pictureViewSend.pictureImage.image = imageCamera;
        pictureViewSend.deleteBtn.tag = 3;
        pictureViewSend.delegate = self;
        self.sum++;
        [self updateSendBtn];
        [self.imageArr setObject:imageCamera atIndexedSubscript:2];
        [self.IDHandHoldView addSubview:pictureViewSend];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)deleteImageAct:(NSInteger)num andCell:(NSInteger)cellNum
{
    if (num == 1) {
        [(UIButton *)[self.IDFontView viewWithTag:1].superview removeFromSuperview];
        self.IDFontView.hidden = YES;
        self.sum = self.sum - 1;
        [self updateSendBtn];
        [self.imageArr setObject:@"" atIndexedSubscript:0];
        self.ifFont = NO;
    }
    if (num == 2) {
        [(UIButton *)[self.IDBackView viewWithTag:2].superview removeFromSuperview];
        self.IDBackView.hidden = YES;
        self.sum = self.sum - 1;
        [self updateSendBtn];
        [self.imageArr setObject:@"" atIndexedSubscript:1];
        self.ifBack = NO;
    }
    if (num == 3) {
        [(UIButton *)[self.IDHandHoldView viewWithTag:3].superview removeFromSuperview];
        self.IDHandHoldView.hidden = YES;
        self.sum = self.sum - 1;
        [self updateSendBtn];
        [self.imageArr setObject:@"" atIndexedSubscript:2];
        self.ifSelf = NO;
    }
}
@end
