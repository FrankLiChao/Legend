//
//  ApplyAfterSaleViewController.m
//  LegendWorld
//
//  Created by wenrong on 16/11/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "ApplyAfterSaleViewController.h"
#import "ChooseReasonCell.h"
#import "UploadImageCell.h"
#import "WriteReasonCell.h"
#import "PictureViewSend.h"
#import "DrawbackDetailViewController.h"
#define myDotNumbers     @"0123456789.\n"
@interface ApplyAfterSaleViewController ()<UITableViewDelegate,UITableViewDataSource,chooseReasonCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,deleteImageDelegate,UITextFieldDelegate,DrawbackDetailViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *applyAfterSaleTableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) UITableView *chooseTableView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) NSArray *refundServiceArr;
@property (nonatomic, strong) NSArray *refundReasonArr;
@property (nonatomic, strong) NSArray *refundReasonAnotherArr;
@property (nonatomic, strong) NSArray *goodsStatusArr;
@property (nonatomic) NSInteger indexRow;
@property (nonatomic) NSInteger after_type;
@property (nonatomic) NSInteger get_status;
@property (nonatomic) NSInteger sum;
@property (nonatomic) BOOL popFromDrawBackView;
@end

@implementation ApplyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后服务";
    self.after_type = 1;
    self.sendBtn.layer.cornerRadius = 6;
    self.refundServiceArr = @[@"退款退货",@"仅退款"];
    self.refundReasonArr = @[@"商品与描述不符",@"假冒品牌",@"质量有问题",@"不喜欢",@"卖家发错货",@"收到商品少件/破损或污染",@"其他"];
    self.goodsStatusArr = @[@"未收到货",@"已收到货"];
    self.refundReasonAnotherArr = @[@"多拍/错拍/不想要",@"未按约定时间发货",@"空包裹/少货",@"快递一直未送到",@"其他"];
    self.picUploadImgArr = [NSMutableArray array];
    if (self.ifFromFix) {
        FLLog(@"self.imageUrlArr %@",self.imageUrlArr);
        if (self.imageUrlArr.count != 0) {
            for (int i = 0; i < self.imageUrlArr.count; i++) {
                NSString *urlString = self.imageUrlArr[i];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image != nil) {
                        [self.picUploadImgArr addObject:image];
                        if (self.picUploadImgArr.count == self.imageUrlArr.count) {
                            [self.imageUrlArr removeAllObjects];
                            [self.applyAfterSaleTableView reloadData];
                        }
                    }
                    else{
                        [self.imageUrlArr removeAllObjects];
                        [self.applyAfterSaleTableView reloadData];
                    }
                }];
            }
        }
        else{
            [self.applyAfterSaleTableView reloadData];
        }
    }
    else{
        self.imageUrlArr = [NSMutableArray array];
        self.refundExplainStr = @"";
        self.refundMoneyStr = @"";
        self.refundServiceStr = @"退款退货";
        self.refundReasonStr = @"商品与描述不符";
    }
    self.chooseTableView = [[UITableView alloc] init];
    self.tapView = [[UIView alloc] init];
    self.chooseTableView.delegate = self;
    self.chooseTableView.dataSource = self;
    self.chooseTableView.layer.borderWidth = 1;
    self.chooseTableView.layer.borderColor = [UIColor seperateColor].CGColor;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.chooseTableView) {
        if (self.indexRow == 0) {
            return self.refundServiceArr.count;
        }
        if (self.indexRow == 1) {
            if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
               return self.goodsStatusArr.count;
            }
            else{
                return self.refundReasonArr.count;
            }
        }
        if (self.indexRow == 2) {
            if ([self.goodsStatusStr isEqualToString:@"未收到货"]) {
                return self.refundReasonAnotherArr.count;
            }
            else{
                return self.refundReasonArr.count;
            }
        }
    }
    FLLog(@"refundServiceStr ======= %@",_refundServiceStr);
    if ([self.refundServiceStr isEqualToString:@"退款退货"]) {
        return 5;
    }
    if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
        return 6;
    }
    if ([self.refundServiceStr isEqualToString:@"换货"]) {
        return 4;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.chooseTableView) {
        return 30;
    }
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.chooseTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCellKey"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCellKey"];
        }
        cell.textLabel.textColor = [UIColor bodyTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (self.indexRow == 0) {
            cell.textLabel.text = self.refundServiceArr[indexPath.row];
        }
        if ([self.refundServiceStr isEqualToString:@"退款退货"]) {
            if (self.indexRow == 1) {
                cell.textLabel.text = self.refundReasonArr[indexPath.row];
            }
        }
        if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
            if (self.indexRow == 1) {
                cell.textLabel.text = self.goodsStatusArr[indexPath.row];
            }
            if (self.indexRow == 2) {
                if ([self.goodsStatusStr isEqualToString:@"未收到货"]) {
                    cell.textLabel.text = self.refundReasonAnotherArr[indexPath.row];
                }
                else{
                    cell.textLabel.text = self.refundReasonArr[indexPath.row];
                }
            }
        }
        if ([self.refundServiceStr isEqualToString:@"换货"]) {
            if (self.indexRow == 1) {
                cell.textLabel.text = self.refundReasonArr[indexPath.row];
            }
        }
        return cell;
    }
    if ([self.refundServiceStr isEqualToString:@"退款退货"]) {
        if (indexPath.row == 0) {
            ChooseReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReasonCell" owner:self options:nil] firstObject];
            cell.delegate = self;
            cell.chooseBtn.tag = indexPath.row;
            cell.titleLab.text = @"退款服务";
            [cell.chooseBtn setTitle:self.refundServiceStr forState:UIControlStateNormal];
            return cell;
        }
        if (indexPath.row == 1) {
            ChooseReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReasonCell" owner:self options:nil] firstObject];
            cell.delegate = self;
            cell.chooseBtn.tag = indexPath.row;
            cell.titleLab.text = @"退款原因";
            [cell.chooseBtn setTitle:self.refundReasonStr forState:UIControlStateNormal];
            return cell;
        }
        if (indexPath.row == 2) {
            WriteReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WriteReasonCell" owner:self options:nil] firstObject];
            cell.titleLab.text = @"退款金额";
            cell.titleSubLab.hidden = NO;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*最多%@",self.goods_price]];
            [str addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(0,1)];
            cell.titleSubLab.attributedText = str;
            cell.writeReasonTF.placeholder = @"请输入退款金额";
            cell.writeReasonTF.text = self.refundMoneyStr;
            cell.writeReasonTF.delegate = self;
            return cell;
        }
        if (indexPath.row == 3) {
            WriteReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WriteReasonCell" owner:self options:nil] firstObject];
            cell.titleLab.text = @"退款说明";
            cell.writeReasonTF.placeholder = @"退货说明(最多两百字)";
            cell.writeReasonTF.text = self.refundExplainStr;
            cell.writeReasonTF.delegate = self;
            return cell;
        }
        UploadImageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"UploadImageCell" owner:self options:nil] firstObject];
        [self addUploadImage:cell];
        return cell;
    }
    if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
        if (indexPath.row == 0) {
            ChooseReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReasonCell" owner:self options:nil] firstObject];
            cell.delegate = self;
            cell.chooseBtn.tag = indexPath.row;
            cell.titleLab.text = @"退款服务";
            [cell.chooseBtn setTitle:self.refundServiceStr forState:UIControlStateNormal];
            return cell;
        }
        if (indexPath.row == 1) {
            ChooseReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReasonCell" owner:self options:nil] firstObject];
            cell.delegate = self;
            cell.chooseBtn.tag = indexPath.row;
            cell.titleLab.text = @"货物状态";
            [cell.chooseBtn setTitle:self.goodsStatusStr forState:UIControlStateNormal];
            return cell;
        }
        if (indexPath.row == 2) {
            ChooseReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReasonCell" owner:self options:nil] firstObject];
            cell.delegate = self;
            cell.chooseBtn.tag = indexPath.row;
            cell.titleLab.text = @"退款原因";
            if ([self.goodsStatusStr isEqualToString:@"未收到货"]) {
                [cell.chooseBtn setTitle:self.refundReasonAnotherStr forState:UIControlStateNormal];
            }
            if ([self.goodsStatusStr isEqualToString:@"已收到货"]) {
                [cell.chooseBtn setTitle:self.refundReasonStr forState:UIControlStateNormal];
            }
            return cell;
        }
        if (indexPath.row == 3) {
            WriteReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WriteReasonCell" owner:self options:nil] firstObject];
            cell.titleLab.text = @"退款金额";
            cell.titleSubLab.hidden = NO;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*最多%@",self.goods_price]];
            [str addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(0,1)];
            cell.titleSubLab.attributedText = str;
            cell.writeReasonTF.placeholder = @"请输入退款金额";
            cell.writeReasonTF.text = self.refundMoneyStr;
            cell.writeReasonTF.delegate = self;
            return cell;
        }
        if (indexPath.row == 4) {
            WriteReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WriteReasonCell" owner:self options:nil] firstObject];
            cell.titleLab.text = @"退款说明";
            cell.writeReasonTF.placeholder = @"退货说明(最多两百字)";
            cell.writeReasonTF.text = self.refundExplainStr;
            cell.writeReasonTF.delegate = self;
            return cell;
        }
        UploadImageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"UploadImageCell" owner:self options:nil] firstObject];
        [self addUploadImage:cell];
        return cell;
    }
    if ([self.refundServiceStr isEqualToString:@"换货"]) {
        if (indexPath.row == 0) {
            ChooseReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReasonCell" owner:self options:nil] firstObject];
            cell.delegate = self;
            cell.chooseBtn.tag = indexPath.row;
            cell.titleLab.text = @"退款服务";
            [cell.chooseBtn setTitle:self.refundServiceStr forState:UIControlStateNormal];
            return cell;
        }
        if (indexPath.row == 1) {
            ChooseReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseReasonCell" owner:self options:nil] firstObject];
            cell.delegate = self;
            cell.chooseBtn.tag = indexPath.row;
            cell.titleLab.text = @"换货原因";
            [cell.chooseBtn setTitle:self.refundReasonStr forState:UIControlStateNormal];
            return cell;
        }
        if (indexPath.row == 2) {
            WriteReasonCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WriteReasonCell" owner:self options:nil] firstObject];
            cell.titleLab.text = @"换货说明";
            cell.writeReasonTF.placeholder = @"换货说明(最多两百字)";
            cell.writeReasonTF.delegate = self;
            return cell;
        }
        UploadImageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"UploadImageCell" owner:self options:nil] firstObject];
        [self addUploadImage:cell];
        return cell;
    }
    static NSString * tifier = @"FrankCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.chooseTableView) {
        if ([self.refundServiceStr isEqualToString:@"退款退货"]) {
            if (self.indexRow == 0) {
                if (![self.refundServiceStr isEqualToString:self.refundServiceArr[indexPath.row]]) {
                    self.refundReasonStr = self.refundReasonArr[0];
                    self.goodsStatusStr = self.goodsStatusArr[0];
                    self.refundReasonAnotherStr = self.refundReasonAnotherArr[0];
                }
                self.refundServiceStr = self.refundServiceArr[indexPath.row];
                [self.applyAfterSaleTableView reloadData];
            }
            if (self.indexRow == 1) {
                self.refundReasonStr = self.refundReasonArr[indexPath.row];
                [self.applyAfterSaleTableView reloadData];
            }
            self.after_type = 1;
        }
        if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
            if (self.indexRow == 0) {
                if (![self.refundServiceStr isEqualToString:self.refundServiceArr[indexPath.row]]) {
                    self.refundReasonStr = self.refundReasonArr[0];
                    self.goodsStatusStr = self.goodsStatusArr[0];
                    self.refundReasonAnotherStr = self.refundReasonAnotherArr[0];
                }
                self.refundServiceStr = self.refundServiceArr[indexPath.row];
                [self.applyAfterSaleTableView reloadData];
            }
            if (self.indexRow == 1) {
                self.goodsStatusStr = self.goodsStatusArr[indexPath.row];
                [self.applyAfterSaleTableView reloadData];
            }
            if (self.indexRow == 2) {
                if ([self.goodsStatusStr isEqualToString:@"未收到货"]) {
                    self.refundReasonAnotherStr = self.refundReasonAnotherArr[indexPath.row];
                    [self.applyAfterSaleTableView reloadData];
                    self.get_status = 1;
                }
                if ([self.goodsStatusStr isEqualToString:@"已收到货"]) {
                    self.refundReasonStr = self.refundReasonArr[indexPath.row];
                    [self.applyAfterSaleTableView reloadData];
                    self.get_status = 2;
                }
            }
            self.after_type = 3;
        }
        if ([self.refundServiceStr isEqualToString:@"换货"]) {
            if (self.indexRow == 0) {
                if (![self.refundServiceStr isEqualToString:self.refundServiceArr[indexPath.row]]) {
                    self.refundReasonStr = self.refundReasonArr[0];
                    self.goodsStatusStr = self.goodsStatusArr[0];
                    self.refundReasonAnotherStr = self.refundReasonAnotherArr[0];
                }
                self.refundServiceStr = self.refundServiceArr[indexPath.row];
                [self.applyAfterSaleTableView reloadData];
            }
            if (self.indexRow == 1) {
                self.refundReasonStr = self.refundReasonArr[indexPath.row];
                [self.applyAfterSaleTableView reloadData];
            }
            self.after_type = 2;
        }
        [self.chooseTableView removeFromSuperview];
        [self.tapView removeGestureRecognizer:self.tap];
        [self.tapView removeFromSuperview];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
}
- (void)clickChooseReasonCell:(UIButton *)chooseBtn
{
    self.indexRow = chooseBtn.tag;
    CGRect viewFrame = [chooseBtn.superview convertRect:chooseBtn.frame toView:self.view];
    self.chooseTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + 30, viewFrame.size.width, 1);
    if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
        if (self.indexRow == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.chooseTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + 30, viewFrame.size.width, self.refundServiceArr.count*30);
            }];
        }
        if (self.indexRow == 1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.chooseTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + 30, viewFrame.size.width, self.goodsStatusArr.count*30);
            }];
        }
        if (self.indexRow == 2) {
            if ([self.goodsStatusStr isEqualToString:@"未收到货"]) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.chooseTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + 30, viewFrame.size.width, self.refundReasonAnotherArr.count * 30);
                }];
            }
            else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.chooseTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + 30, viewFrame.size.width, self.refundReasonArr.count * 30);
                }];
            }
        }
    }
    else{
        if (self.indexRow == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.chooseTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + 30, viewFrame.size.width, self.refundServiceArr.count*30);
            }];
        }
        if (self.indexRow == 1) {
            [UIView animateWithDuration:0.3 animations:^{
                self.chooseTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + 30, viewFrame.size.width, self.refundReasonArr.count * 30);
            }];
        }
    }
        
    self.tapView.frame = CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight);
    [self.applyAfterSaleTableView addSubview:self.tapView];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coloseTableView:)];
    [self.tapView addGestureRecognizer:self.tap];
    [self.applyAfterSaleTableView addSubview:self.chooseTableView];
    [self.chooseTableView reloadData];
}
    
- (void)coloseTableView:(UITapGestureRecognizer *)tap
{
        [self.chooseTableView removeFromSuperview];
        [self.tapView removeGestureRecognizer:tap];
        [self.tapView removeFromSuperview];
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
    
    [self.picUploadImgArr addObject:[info objectForKey:UIImagePickerControllerEditedImage]];
    [self.applyAfterSaleTableView reloadData];
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
- (void)addUploadImage:(UploadImageCell *)cell
{
    if (self.picUploadImgArr.count<3) {
        for (int i = 0; i<self.picUploadImgArr.count; i++) {
            PictureViewSend *picVS = [[[NSBundle mainBundle] loadNibNamed:@"PictureViewSend" owner:self options:nil] firstObject];
            picVS.frame = CGRectMake(15+75*i, 10, 70, 70);
            picVS.pictureImage.image = self.picUploadImgArr[i];
            picVS.delegate = self;
            picVS.deleteBtn.tag = i;
            [cell.uploadImgView addSubview:picVS];
        }
        UIButton *addBtn = [[UIButton alloc] init];
        addBtn.frame = CGRectMake(15 + 75*self.picUploadImgArr.count, 10, 70, 70);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"upLoadImg"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(clickUploadImgBtn) forControlEvents:UIControlEventTouchUpInside];
        [cell.uploadImgView addSubview:addBtn];
    }
    if (self.picUploadImgArr.count == 3) {
        for (int i = 0; i<self.picUploadImgArr.count; i++) {
            PictureViewSend *picVS = [[[NSBundle mainBundle] loadNibNamed:@"PictureViewSend" owner:self options:nil] firstObject];
            picVS.frame = CGRectMake(15+75*i, 10, 70, 70);
            picVS.pictureImage.image = self.picUploadImgArr[i];
            picVS.delegate = self;
            picVS.deleteBtn.tag = i;
            [cell.uploadImgView addSubview:picVS];
        }
    }
}
- (void)deleteImageAct:(NSInteger)num andCell:(NSInteger)cellNum
{
    FLLog(@"skdkajl");
    [self.picUploadImgArr removeObjectAtIndex:num];
    [self.applyAfterSaleTableView reloadData];
}

- (void)clickUploadImgBtn
{
    [self addPicture];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    WriteReasonCell *cell  = (WriteReasonCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.applyAfterSaleTableView indexPathForCell:cell];
    if ([self.refundServiceStr isEqualToString:@"退款退货"]) {
        if (indexPath.row == 2) {
            self.refundMoneyStr = textField.text;
        }
        else{
            self.refundExplainStr = textField.text;
        }
    }
    if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
        if (indexPath.row == 3) {
            self.refundMoneyStr = textField.text;
        }
        else{
            self.refundExplainStr = textField.text;
        }
    }
    FLLog(@"row =========== %ld",indexPath.row);
}
- (IBAction)sendApplyAct:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([self.refundMoneyStr isEqualToString:@""]) {
        [self showHUDWithResult:NO message:@"请填写退款金额"];
        return;
    }
     NSString * price = @"(\\+)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,8}(([.]\\d{0,2})?)))?";
     NSPredicate *regextestPrice = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", price];
    if (![regextestPrice evaluateWithObject:self.refundMoneyStr]) {
        [self showHUDWithResult:NO message:@"请填写正确的金额"];
        return;
    }
        if (self.picUploadImgArr.count == 0) {
        [self uploadData];
    }
    if (self.picUploadImgArr.count != 0){
        for (int i = 0; i < self.picUploadImgArr.count; i++) {
        NSDictionary *parameters = @{@"device_id":[FrankTools getDeviceUUID]};
        [MainRequest uploadPhoto:ImagePATH(@"utility/upload_img.php") parameters:parameters imageD:self.picUploadImgArr[i] success:^(id responseObject) {
            [self.imageUrlArr addObject:[[responseObject objectForKey:@"data"] objectForKey:@"img_path"]];
            self.sum++;
            if (self.sum == self.picUploadImgArr.count) {
                [self uploadData];
            }
        } failed:^(NSError *error) {
            [self showHUDWithResult:NO message:@"上传图片出现未知的问题"];
        }];
    }
    }
}

- (void)uploadData
{
    [self showHUDWithMessage:nil];
    NSDictionary *parameters = [[NSDictionary alloc] init];

    if (self.popFromDrawBackView || self.ifFromFix){
        if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
            if ([self.goodsStatusStr isEqualToString:@"未收到货"]) {
                self.get_status = 2;
            }
            else{
                self.get_status = 1;
            }
            parameters = @{@"device_id":[FrankTools getDeviceUUID],
                           @"token":[FrankTools getUserToken],
                           @"after_id":self.after_id,
                           @"after_type":[NSNumber numberWithInteger:3],
                           @"get_status":[NSNumber numberWithInteger:self.get_status],
                           @"after_reason":self.refundReasonAnotherStr,
                           @"refund_money":self.refundMoneyStr,
                           @"refund_explain":self.refundExplainStr,
                           @"after_img":self.imageUrlArr,
                           @"order_id":self.order_id};
        }
        else{
            parameters = @{@"device_id":[FrankTools getDeviceUUID],
                           @"token":[FrankTools getUserToken],
                           @"after_type":[NSNumber numberWithInteger:1],
                           @"after_id":self.after_id,
                           @"after_reason":self.refundReasonStr,
                           @"refund_money":self.refundMoneyStr,
                           @"refund_explain":self.refundExplainStr,
                           @"after_img":self.imageUrlArr,
                           @"order_id":self.order_id
                           };
        }
        [MainRequest RequestHTTPData:PATHShop(@"Api/After/editAferInfo") parameters:parameters success:^(id response) {
            if ([[response objectForKey:@"status"] integerValue] != 0) {
                [self showHUDWithResult:YES message:[response objectForKey:@"msg"]];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([[response objectForKey:@"status"] integerValue] == 0) {
                    [self showHUDWithResult:NO message:[response objectForKey:@"msg"]];
                }
                else{
                    if (self.ifFromFix) {
                        [self.delegate popBackAct:[response objectForKey:@"after_id"]];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    if (self.popFromDrawBackView) {
                        DrawbackDetailViewController *drawbackDetailVC = [[DrawbackDetailViewController alloc] init];
                        drawbackDetailVC.after_id = [response objectForKey:@"after_id"];
                        drawbackDetailVC.hidesBottomBarWhenPushed = YES;
                        drawbackDetailVC.isAfterPage = YES;
                        drawbackDetailVC.delegate = self;
                        [self.navigationController pushViewController:drawbackDetailVC animated:YES];
                    }
                }
            });
            self.sum = 0;
        } failed:^(NSDictionary *errorDic) {
            self.sum = 0;
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
    else{
        if ([self.refundServiceStr isEqualToString:@"仅退款"]) {
            parameters = @{@"device_id":[FrankTools getDeviceUUID],
                           @"token":[FrankTools getUserToken],
                           @"order_id":self.order_id,
                           @"goods_id":self.goods_id,
                           @"seller_id":self.seller_id,
                           @"after_type":[NSNumber numberWithInteger:3],
                           @"attr_id":self.attr_id,
                           @"get_status":[NSNumber numberWithInteger:self.get_status],
                           @"after_reason":self.refundReasonAnotherStr,
                           @"refund_money":self.refundMoneyStr,
                           @"refund_explain":self.refundExplainStr,
                           @"after_img":self.imageUrlArr};
        }
        else{
            parameters = @{@"device_id":[FrankTools getDeviceUUID],
                           @"token":[FrankTools getUserToken],
                           @"order_id":self.order_id,
                           @"goods_id":self.goods_id,
                           @"seller_id":self.seller_id,
                           @"after_type":[NSNumber numberWithInteger:1],
                           @"attr_id":self.attr_id,
                           @"after_reason":self.refundReasonStr,
                           @"refund_money":self.refundMoneyStr,
                           @"refund_explain":self.refundExplainStr,
                           @"after_img":self.imageUrlArr};
        }
        [MainRequest RequestHTTPData:PATHShop(@"Api/After/subAfter") parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:[response objectForKey:@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                DrawbackDetailViewController *drawbackDetailVC = [[DrawbackDetailViewController alloc] init];
                drawbackDetailVC.after_id = [response objectForKey:@"after_id"];
                drawbackDetailVC.hidesBottomBarWhenPushed = YES;
                drawbackDetailVC.isAfterPage = YES;
                drawbackDetailVC.delegate = self;
                [self.navigationController pushViewController:drawbackDetailVC animated:YES];
            });
            self.sum = 0;
        } failed:^(NSDictionary *errorDic) {
            self.sum = 0;
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }

}
- (void)popFromDrawBack:(NSString *)after_id
{
    self.after_id = after_id;
    self.popFromDrawBackView = YES;
}
@end
