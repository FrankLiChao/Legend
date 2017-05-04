//
//  FeedbackViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/7.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PictureViewSend.h"
#define pictureWidth (DeviceMaxWidth-45)/4
@interface FeedbackViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,deleteImageDelegate>
@property (weak, nonatomic) IBOutlet UIView *sendImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic) NSInteger sum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewC;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) UIButton *addPictureBtn;
@property (strong, nonatomic) NSMutableArray *pictureArr;
@property (strong, nonatomic) NSMutableArray *viewForXIBArr;
@property (strong, nonatomic) NSMutableArray *imageUrlsArr;
@property (nonatomic) NSInteger picSum;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.sendBtn.layer.cornerRadius = 6;
    self.pictureArr = [NSMutableArray array];
    self.viewForXIBArr = [NSMutableArray array];
    self.imageUrlsArr = [NSMutableArray array];
    self.imageViewC.constant = (DeviceMaxWidth - 45)/4 + 10;
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentTV.layer.borderWidth = 1;
    self.contentTV.layer.borderColor = [UIColor seperateColor].CGColor;
    // Do any additional setup after loading the view from its nib.
    [self buildAddBtn];
}
- (IBAction)sendAct:(UIButton *)sender {
    if (self.contentTV.text.length == 0) {
        [self showHUDWithResult:NO message:@"请填写您要反馈的建议"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提交建议" message:@"请检查你填写的信息，确认提交？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showHUD];
        if (weakSelf.pictureArr.count == 0) {
            NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"origin":@1,@"content":weakSelf.contentTV.text,@"images":weakSelf.imageUrlsArr};
            [MainRequest RequestHTTPData:PATH(@"Api/Suggest/sendSuggest") parameters:parameters success:^(id response) {
                [weakSelf showHUDWithResult:YES message:@"提交成功" completion:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } failed:^(NSDictionary *errorDic) {
                [weakSelf showHUDWithResult:NO message:@"提交失败"];
            }];
        } else {
            for (UIImage *image in weakSelf.pictureArr) {
                NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                             @"img_type":@2};
                [MainRequest uploadPhoto:ImagePATH(@"utility/upload_img.php") parameters:parameters imageD:image success:^(id responseObject) {
                    NSString *url = responseObject[@"data"][@"img_path"];
                    [weakSelf.imageUrlsArr addObject:url];
                    weakSelf.picSum ++;
                    if (weakSelf.picSum == weakSelf.pictureArr.count) {
                        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],@"token":[FrankTools getUserToken],@"origin":@1,@"content":weakSelf.contentTV.text,@"images":weakSelf.imageUrlsArr};
                        [MainRequest RequestHTTPData:PATH(@"Api/Suggest/sendSuggest") parameters:parameters success:^(id response) {
                            [weakSelf showHUDWithResult:YES message:@"提交成功" completion:^{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }];
                        } failed:^(NSDictionary *errorDic) {
                            [weakSelf showHUDWithResult:NO message:@"提交失败"];
                        }];
                    }
                } failed:^(NSError *error) {
                    weakSelf.picSum ++;
                    [weakSelf showHUDWithResult:NO message:@"上传失败"];
                }];
            }
        }
    }]];
    [weakSelf presentViewController:alertController animated:YES completion:nil];

}
#pragma mark - textView占位符
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"在此填写内容"]) {
        textView.text = @"";
        textView.textColor = [UIColor colorFromHexRGB:@"464646"];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length<1) {
        textView.text = @"在此填写内容";
        self.sendBtn.backgroundColor = [UIColor noteTextColor];
        textView.textColor = [UIColor colorFromHexRGB:@"9B9B9B"];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark - 用textView的代理方法实现对textView字数的实时监控

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >=300) {
        self.wordLabel.text = @"0字";
        return ;
    }
    else {
        self.sum = 300-textView.text.length;
        self.wordLabel.text = [NSString stringWithFormat:@"%ld字",(long)self.sum];
    }
    if (textView.text.length > 0) {
        self.sendBtn.backgroundColor = mainColor;
        self.sendBtn.enabled = YES;
    }
    else{
        self.sendBtn.backgroundColor = [UIColor noteTextColor];
        self.sendBtn.enabled = NO;
    }
};
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)buildAddBtn
{
    if (self.addPictureBtn == nil) {
        self.addPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, (DeviceMaxWidth - 45)/4, (DeviceMaxWidth - 45)/4)];
        self.addPictureBtn.layer.borderWidth = 1;
        self.addPictureBtn.layer.cornerRadius = 6;
        self.addPictureBtn.layer.masksToBounds = YES;
        self.addPictureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.addPictureBtn setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
        [self.addPictureBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        [self.sendImageView addSubview:self.addPictureBtn];
    }
}
- (void)addPicture
{
    UIActionSheet *iconSheet = [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"拍照",@"相册",nil];
    
    
    [iconSheet showInView:self.view];
    
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
    
    [self.pictureArr addObject:[info objectForKey:UIImagePickerControllerEditedImage]];
    if (self.pictureArr.count >= 4) {
        self.imageViewC.constant = pictureWidth * 2 + 25;
    }
    else{
        self.imageViewC.constant = (DeviceMaxWidth - 45)/4 + 10;
    }
    [self buildImageView];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openCamera];
    }
    if (buttonIndex == 1) {
        [self openPics];
    }
}
-(void)buildImageView
{
    for (UIView *view in self.viewForXIBArr) {
        [view removeFromSuperview];
    }
    [self.viewForXIBArr removeAllObjects];
    for (int j = 0; j<self.pictureArr.count; j++) {
        UIView *viewForXIB = [[UIView alloc] init];
        if (j >= 4) {
            viewForXIB.frame = CGRectMake(15+(j-4)*(pictureWidth+5), pictureWidth + 15, pictureWidth, pictureWidth);
        }
        else{
            viewForXIB.frame = CGRectMake(15+j*(pictureWidth+5), 10, pictureWidth, pictureWidth);
        }
        PictureViewSend *pictureViewSend = [[[NSBundle mainBundle] loadNibNamed:@"PictureViewSend" owner:self options:nil] firstObject];
        pictureViewSend.frame = CGRectMake(0, 0, pictureWidth, pictureWidth);
        pictureViewSend.deleteBtn.tag = j;
        pictureViewSend.pictureImage.image = self.pictureArr[j];
        pictureViewSend.delegate = self;
        [viewForXIB addSubview:pictureViewSend];
        [self.sendImageView addSubview:viewForXIB];
        [self.viewForXIBArr addObject:viewForXIB];
    }
    if (self.pictureArr.count >= 8) {
        self.addPictureBtn.hidden = YES;
        self.imageViewC.constant = pictureWidth * 2 + 25;
    }
    if (self.pictureArr.count >= 4 && self.pictureArr.count < 8) {
        self.addPictureBtn.hidden = NO;
        self.addPictureBtn.frame = CGRectMake(15 + (self.pictureArr.count - 4)*(pictureWidth + 5), 15 + pictureWidth, pictureWidth, pictureWidth);
        self.imageViewC.constant = pictureWidth * 2 + 25;
    }
    if (self.pictureArr.count < 4) {
        self.addPictureBtn.hidden = NO;
        self.addPictureBtn.frame = CGRectMake(15 + (self.pictureArr.count)*(pictureWidth + 5), 10, pictureWidth, pictureWidth);
        self.imageViewC.constant = (DeviceMaxWidth - 45)/4 + 10;
    }
}
-(void)deleteImageAct:(NSInteger)num andCell:(NSInteger)cellNum
{
    [self.pictureArr removeObjectAtIndex:num];
    [self buildImageView];
}

@end
