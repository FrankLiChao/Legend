//
//  EvaluationNewViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/10/11.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "EvaluationNewViewController.h"
#import "UIImageView+WebCache.h"
#import "PictureViewSend.h"
#import "EvaluationCell.h"
#import "EvaluationFooterViewCell.h"
#import "GoodsModel.h"
#define pictureWidth (DeviceMaxWidth-55)/6
@interface EvaluationNewViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ratingViewDelegate,deleteImageDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,EvaluationFooterViewDelegate>

@property (nonatomic) NSInteger scoreAll;
@property (nonatomic) NSInteger sum;
@property (strong, nonatomic) NSMutableArray *pictureArr;
@property (strong, nonatomic) NSMutableArray *viewForXIBArr;
@property (strong, nonatomic) NSMutableArray *imageUrlsArr;
@property (strong, nonatomic) UIButton *addPictureBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLab;
@property (weak, nonatomic) IBOutlet UILabel *priceTopLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceDownLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UIImageView *orderIconIma;
@property (weak, nonatomic) IBOutlet LHRatingView *starView;
@property (weak, nonatomic) IBOutlet UITextView *evaluationTV;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UITableView *evaluationTableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) NSMutableArray *imageSubmitArr;
@property (nonatomic, strong) NSMutableArray *stringSubmitArr;
@property (nonatomic, strong) NSMutableArray *starSubmitArr;
@property (nonatomic) NSInteger clickIndex;
@end

@implementation EvaluationNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.evaluationTV.delegate = self;
    self.sendBtn.layer.cornerRadius = 6;
    self.imageSubmitArr = [NSMutableArray array];
    self.stringSubmitArr = [NSMutableArray array];
    self.starSubmitArr = [NSMutableArray array];
    for (int i = 0; i<self.modelDataArr.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        [self.imageSubmitArr addObject:arr];
    }

    for (int i = 0; i < self.modelDataArr.count; i++) {
        NSString *string = @"";
        [self.stringSubmitArr addObject:string];
    }
    for (int i = 0; i < self.modelDataArr.count; i++) {
        NSNumber* starNum = @0;
        [self.starSubmitArr addObject:starNum];
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)sendAct:(UIButton *)sender {
    

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
    [(NSMutableArray *)self.imageSubmitArr[self.clickIndex] addObject:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self.evaluationTableView reloadData];
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
-(void)addPicture
{
    UIActionSheet *iconSheet = [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"拍照",@"相册",nil];
    
    
    [iconSheet showInView:self.view];
    
}


#pragma mark - textView占位符
-(void)textViewDidBeginEditing:(UITextView *)textView
{
        if ([textView.text isEqualToString:@"填写评价内容："]) {
            textView.text = @"";
            textView.textColor = [UIColor colorFromHexRGB:@"464646"];
        }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *str = (NSString *)self.stringSubmitArr[textView.tag];
    str = textView.text;
    [self.stringSubmitArr replaceObjectAtIndex:textView.tag withObject:str];
    FLLog(@"arr ======== %@",self.stringSubmitArr);
        if (textView.text.length<1) {
            textView.text = @"填写评价内容：";
            textView.textColor = [UIColor colorFromHexRGB:@"9B9B9B"];
        }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 得分代理
- (void)ratingView:(LHRatingView *)view score:(CGFloat)score {
     NSNumber *num = (NSNumber *)self.starSubmitArr[view.tag];
    [num integerValue];
    NSInteger nums;
    nums = score;
    [self.starSubmitArr replaceObjectAtIndex:view.tag withObject:[NSNumber numberWithInteger:nums]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelDataArr.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.modelDataArr.count) {
        return 100;
    }
    return 455;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.modelDataArr.count) {
        EvaluationFooterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluationFooterViewCellKey"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationFooterViewCell" owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluationCellKey"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodsModel *model = self.modelDataArr[indexPath.row];
    cell.orderIDLab.text = [NSString stringWithFormat:@"订单号:%@",self.order_id];
    cell.priceDownLab.text = model.shop_price;
    cell.orderNameLab.text = model.goods_name;
    cell.evaluationTV.delegate = self;
    if (![self.stringSubmitArr[indexPath.row] isEqualToString:@""]) {
        cell.evaluationTV.text = self.stringSubmitArr[indexPath.row];
        cell.evaluationTV.textColor = [UIColor noteTextColor];
    }
    cell.evaluationTV.tag = indexPath.row;
    cell.starView.delegate = self;
    cell.starView.tag = indexPath.row;
    [cell.starView configRatingView:[self.starSubmitArr[indexPath.row] floatValue]];
    cell.tag = indexPath.row;
    [self addUploadImage:cell];
    cell.amountLab.text = [NSString stringWithFormat:@"X%ld",(long)model.goods_number];
    [FrankTools setImgWithImgView:cell.orderIconIma withImageUrl:model.goods_thumb withPlaceHolderImage:placeHolderImg];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)clickEvaluationSubmitAct
{
    for (int i = 0; i < self.starSubmitArr.count; i++) {
        if ([self.starSubmitArr[i] isEqual:@0]) {
            [self showHUDWithResult:NO message:@"请给商品打分"];
            return;
        }
    }
    [self showHUDWithMessage:nil];
    NSInteger sum = self.imageSubmitArr.count;
    for (int i = 0; i < self.imageSubmitArr.count; i++) {
        NSMutableArray *arr = self.imageSubmitArr[i];
        sum = arr.count + sum;
    }
    if (sum > self.imageSubmitArr.count) {
        for (int i = 0; i < self.imageSubmitArr.count; i++) {
            NSMutableArray *arr = self.imageSubmitArr[i] ;
            for (int j = 0; j < arr.count; j++) {
                UIImage *image = arr[j];
                NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                             @"img_type":@2};
                [MainRequest uploadPhoto:ImagePATH(@"utility/upload_img.php") parameters:parameters imageD:image success:^(id responseObject) {
                    NSString *url = responseObject[@"data"][@"img_path"];
                    [arr replaceObjectAtIndex:j withObject:url];
                    [self uploadData:YES];
                } failed:^(NSError *error) {
                    [self showHUDWithResult:NO message:@"上传失败"];
                }];
                
            }
        }
    }
    else{
        [self uploadData:NO];
    }
}
- (void)uploadData:(BOOL)imageOrNot
{
    if (imageOrNot) {
        for (int i = 0; i < self.imageSubmitArr.count; i++) {
            NSMutableArray *arr = self.imageSubmitArr[i];
            for (int j = 0; j < arr.count; j++) {
                if ([arr[j] isKindOfClass:[UIImage class]]) {
                    return;
                }
            }
        }
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < self.modelDataArr.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        GoodsModel *model = self.modelDataArr[i];
        [dic setObject:model.goods_id?model.goods_id:@"" forKey:@"goods_id"];
        [dic setObject:model.size_id ? model.size_id : @"0" forKey:@"size_id"];
        [dic setObject:self.stringSubmitArr[i] forKey:@"content"];
        [dic setObject:self.starSubmitArr[i] forKey:@"rank1"];
        [dic setObject:self.imageSubmitArr[i] forKey:@"comment_img"];
        [dataArr addObject:dic];
    }
    
    NSString *resultString = [JSONParser parseToStringWithArray:dataArr];
    NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID],
                                 @"token":[FrankTools getUserToken],
                                 @"seller_id":self.seller_id?self.seller_id:@"",
                                 @"order_id":self.order_id?self.order_id:@"",
                                 @"goods_list":resultString ? resultString : @""};
    FLLog(@"parameters ========= %@",parameters);
    [MainRequest RequestHTTPData:PATHShop(@"Api/GoodsComment/addCommentList") parameters:parameters success:^(id response) {
        NSString *msgStr = [NSString stringWithFormat:@"%@",[response objectForKey:@"msg"]];
        if ([[response objectForKey:@"status"] integerValue] == 1) {
            [self showHUDWithResult:YES message:msgStr?msgStr:@""];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [self showHUDWithResult:NO message:msgStr?msgStr:@""];
        }
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"评论失败"];
    }];
}
- (void)addImageToSubmit:(UIButton*)sender
{
    self.clickIndex = sender.tag;
    [self addPicture];
}
- (void)addUploadImage:(EvaluationCell *)cell
{
    NSMutableArray *arr = self.imageSubmitArr[cell.tag];
    if (arr.count < 6) {
        for (int i = 0; i < arr.count; i++) {
            PictureViewSend *picVS = [[[NSBundle mainBundle] loadNibNamed:@"PictureViewSend" owner:self options:nil] firstObject];
            picVS.frame = CGRectMake(15+(pictureWidth + 5)*i, 10, pictureWidth, pictureWidth);
            picVS.pictureImage.image = arr[i];
            picVS.delegate = self;
            picVS.deleteBtn.tag = i;
            picVS.tag = cell.tag;
            [cell.pictureView addSubview:picVS];
        }
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(15+arr.count*(pictureWidth+5), 10, pictureWidth, pictureWidth);
        [button setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addImageToSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [cell.pictureView addSubview:button];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        button.tag = cell.tag;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;

    }
    if (arr.count == 6) {
        for (int i = 0; i < arr.count; i++) {
            PictureViewSend *picVS = [[[NSBundle mainBundle] loadNibNamed:@"PictureViewSend" owner:self options:nil] firstObject];
            picVS.frame = CGRectMake(15+(pictureWidth + 5)*i, 10, pictureWidth, pictureWidth);
            picVS.pictureImage.image = arr[i];
            picVS.delegate = self;
            picVS.deleteBtn.tag = i;
            picVS.tag = cell.tag;
            [cell.pictureView addSubview:picVS];
        }
    }
}

-(void)deleteImageAct:(NSInteger)num andCell:(NSInteger)cellNum
{
    NSMutableArray *arr = self.imageSubmitArr[cellNum];
    [arr removeObjectAtIndex:num];
    [self.evaluationTableView reloadData];
}
@end
