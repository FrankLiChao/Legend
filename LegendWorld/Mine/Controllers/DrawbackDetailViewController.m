//
//  DrawbackDetailViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "DrawbackDetailViewController.h"
#import "AgreeRefundTableViewCell.h"
#import "ExchangeGoodsCell.h"
#import "FillShippingInfoViewController.h"
#import "SellerInforTableViewCell.h"
#import "RefundInforTableViewCell.h"
#import "CloseRefundTableViewCell.h"
#import "ExpressTableViewCell.h"
#import "AfterInfoModel.h"
#import "SellerModel.h"
#import "PictureTableViewCell.h"
#import "ApplyAfterSaleViewController.h"
#import "OrderDetailViewController.h"
#import "JSONParser.h"

@interface DrawbackDetailViewController ()<UITableViewDelegate,UITableViewDataSource,FillShippingInfoViewControllerDelegate,ApplyAfterSaleViewDelegate,UIAlertViewDelegate>

@property(weak,nonatomic)UITableView *myTableView;
@property(strong,nonatomic)AfterInfoModel *afterModel;
@property(strong,nonatomic)SellerModel *sellerModel;
@property(strong,nonatomic)NSArray  *nameArray;
@property(strong,nonatomic)NSArray  *pictureArray;//图片数组

@end

@implementation DrawbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款详情";
    [self initData];
    [self initFrameView];
    [self requestData];
    __weak typeof(self) weakSelf = self;
    self.backBarBtnEvent = ^{
        if ([self.afterModel.after_status integerValue] == 4 || weakSelf.isAfterPage) {
            NSArray *array = weakSelf.navigationController.viewControllers;
            for (UIViewController *vc in array) {
                if ([vc isKindOfClass:[OrderDetailViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

-(void)initData{
    self.nameArray = @[@"退款类型",@"退款金额",@"退款原因",@"退款说明",@"申请时间",@"完成时间",@"图片"];
}

-(void)requestData{
    NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                          @"device_id":[FrankTools getDeviceUUID],
                          @"after_id":self.after_id?self.after_id:@""};
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHShop(@"api/After/getAfterInfo") parameters:dic success:^(id responseData) {
        [self hideHUD];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.afterModel = [AfterInfoModel parseAfterInforResponse:responseData];
        self.sellerModel = [SellerModel parseResponse:responseData];
        self.pictureArray = [self.afterModel.after_img componentsSeparatedByString:@","];
        [self.myTableView reloadData];
    } failed:^(NSDictionary *errorDic) {
        [self hideHUD];
    }];
}

-(void)initFrameView{
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    tableV.showsVerticalScrollIndicator = NO;
    tableV.backgroundColor = viewColor;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.estimatedRowHeight = 200;
    tableV.rowHeight = UITableViewAutomaticDimension;
    self.myTableView = tableV;
    [tableV registerNib:[UINib nibWithNibName:@"PictureTableViewCell" bundle:nil] forCellReuseIdentifier:@"PictureTableViewCellKey"];
    [tableV registerNib:[UINib nibWithNibName:@"ExpressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExpressTableViewCellKey"];
    [tableV registerNib:[UINib nibWithNibName:@"ExchangeGoodsCell" bundle:nil] forCellReuseIdentifier:@"ExchangeGoodsCellKey"];
    [tableV registerNib:[UINib nibWithNibName:@"AgreeRefundTableViewCell" bundle:nil] forCellReuseIdentifier:@"AgreeRefundTableViewCellKey"];
    [tableV registerNib:[UINib nibWithNibName:@"CloseRefundTableViewCell" bundle:nil] forCellReuseIdentifier:@"CloseRefundTableViewCellKey"];
    tableV.allowsSelection = NO;
    [self.view addSubview:tableV];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10*widthRate;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 10*widthRate)];
    bgView.backgroundColor = viewColor;
    return bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        NSInteger count = 0;
        if (self.pictureArray.count > 0 && ![self.pictureArray[0] isEqualToString:@""]) {
            count = 1;
        }
        if ([self.afterModel.after_status integerValue] == 4) {
            return 6+count;
        }
        if ([self.afterModel.after_status integerValue] == 2 && [self.afterModel.is_complete integerValue] == 1) {
            return 6+count;
        }
        return 5+count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([self.afterModel.after_status integerValue] == 1) {
            AgreeRefundTableViewCell *cell = (AgreeRefundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AgreeRefundTableViewCellKey"];
            [cell.statusIm setImage:imageWithName(@"mine_afterstatus")];
            cell.statusLab.text = [AfterInfoModel getAfterStatus:[self.afterModel.after_status integerValue] :[self.afterModel.after_type integerValue]];
            [cell.modefyBtn setTitle:@"修改退款申请" forState:UIControlStateNormal];
            [cell.applyServerBtn setTitle:@"撤销退款申请" forState:UIControlStateNormal];
            [cell.revokBtn setTitle:@"申请客服介入" forState:UIControlStateNormal];
            [cell.modefyBtn addTarget:self action:@selector(clickModifyEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.applyServerBtn addTarget:self action:@selector(clickRevokeEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.revokBtn addTarget:self action:@selector(clickCustomerEvent:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else if ([self.afterModel.after_status integerValue] == 5) {
            AgreeRefundTableViewCell *cell = (AgreeRefundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AgreeRefundTableViewCellKey"];
            [cell.statusIm setImage:imageWithName(@"mine_afterstatus")];
            cell.statusLab.text = [AfterInfoModel getAfterStatus:[self.afterModel.after_status integerValue] :[self.afterModel.after_type integerValue]];
            cell.contentLab.text = [NSString stringWithFormat:@"拒绝理由:%@",self.afterModel.refuse_reason];
            [cell.modefyBtn setTitle:@"修改退款申请" forState:UIControlStateNormal];
            [cell.applyServerBtn setTitle:@"撤销退款申请" forState:UIControlStateNormal];
            [cell.revokBtn setTitle:@"申请客服介入" forState:UIControlStateNormal];
            [cell.modefyBtn addTarget:self action:@selector(clickModifyEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.applyServerBtn addTarget:self action:@selector(clickRevokeEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.revokBtn addTarget:self action:@selector(clickCustomerEvent:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if ([self.afterModel.after_status integerValue] == 6) {
            CloseRefundTableViewCell *cell = (CloseRefundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CloseRefundTableViewCellKey"];
            [cell.statusIm setImage:imageWithName(@"mine_closeimage")];
//            cell.statusLab.text = [AfterInfoModel getCompleteReason:self.afterModel.after_type];
            if ([self.afterModel.after_type integerValue] == 1) {
                cell.statusLab.text = @"退款退货已关闭";
            }else{
                cell.statusLab.text = @"退款已关闭";
            }
            
            cell.closeResonLab.text = [NSString stringWithFormat:@"关闭原因：%@",[AfterInfoModel getCompleteReason:self.afterModel.complete_type]];
            cell.closeTimeLab.text = [NSString stringWithFormat:@"关闭时间：%@",self.afterModel.complete_time];
            return cell;
        }else if ([self.afterModel.after_status integerValue] == 2 && [self.afterModel.is_complete integerValue] == 2) {//ExpressTableViewCell
            ExpressTableViewCell *cell = (ExpressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpressTableViewCellKey"];
            cell.statusLab.text = [AfterInfoModel getAfterStatus:[self.afterModel.after_status integerValue] :[self.afterModel.after_type integerValue]];
            NSDictionary *addrDic = [JSONParser parseToDictionaryWithString:self.sellerModel.after_address];
            FLLog(@"%@",addrDic);
            NSString *province = [addrDic objectForKey:@"province"];
            NSString *city = [addrDic objectForKey:@"city"];
            NSString *area = [addrDic objectForKey:@"area"];
            NSString *address = [addrDic objectForKey:@"address"];
            NSString *consignee = [addrDic objectForKey:@"consignee"];
            NSString *mobile = [addrDic objectForKey:@"mobile"];
            cell.addressLab.text = [NSString stringWithFormat:@"%@  %@\n %@ %@ %@ %@",consignee?consignee:@"",mobile?mobile:@"",province?province:@"",city?city:@"",area?area:@"",address?address:@""];
            
            [cell.expressBtn addTarget:self action:@selector(clickExpressButtonEvent) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if ([self.afterModel.after_status integerValue] == 3) {//
            ExchangeGoodsCell *cell = (ExchangeGoodsCell *)[tableView dequeueReusableCellWithIdentifier:@"ExchangeGoodsCellKey"];
            [cell.statusIm setImage:imageWithName(@"mine_afteragree")];
            cell.statusLab.text = [AfterInfoModel getAfterStatus:[self.afterModel.after_status integerValue] :[self.afterModel.after_type integerValue]];
            cell.contentLab.text = @"商品回寄中，等待商家确认，如9天23时后商家未确认收货，则帮你完成退款";
            cell.expressLab.text = [NSString stringWithFormat:@"物流公司：%@",self.afterModel.express_company];
            cell.expressNumLab.text = [NSString stringWithFormat:@"快递单号：%@",self.afterModel.express_num];
            [cell.sureTakeBtn setTitle:@"撤销退款申请" forState:UIControlStateNormal];
            [cell.saleAfterBtn setTitle:@"申请客服介入" forState:UIControlStateNormal];
            [cell.sureTakeBtn addTarget:self action:@selector(clickRevokeEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.saleAfterBtn addTarget:self action:@selector(clickCustomerEvent:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else{
            CloseRefundTableViewCell *cell = (CloseRefundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CloseRefundTableViewCellKey"];
            [cell.statusIm setImage:imageWithName(@"mine_afteragree")];
            cell.statusLab.text = @"退款已完成";
            cell.closeResonLab.text = [NSString stringWithFormat:@"退款金额：¥%@",self.afterModel.refund_money];
            return cell;
        }
    }else if (indexPath.section == 1) {
        SellerInforTableViewCell * scell = [tableView dequeueReusableCellWithIdentifier:@"SellerInforTableViewCellKey"];
        if (scell == nil) {
            scell = [[[NSBundle mainBundle] loadNibNamed:@"SellerInforTableViewCell" owner:self options:nil] firstObject];
        }
        scell.selectionStyle = UITableViewCellSelectionStyleNone;
        scell.nameLab.text = self.sellerModel.seller_name;
        scell.phoneLab.text = self.sellerModel.telephone;
        [FrankTools setImgWithImgView:scell.shopImage withImageUrl:self.sellerModel.thumb_img withPlaceHolderImage:placeHolderImg];
        [scell.phoneBtn addTarget:self action:@selector(clickPhoneEvent) forControlEvents:UIControlEventTouchUpInside];
        return scell;
    }else{//RefundInforTableViewCell
        if ((indexPath.row == 5 && [self.afterModel.after_status integerValue] != 4) || indexPath.row == 6) {
            PictureTableViewCell *cell = (PictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PictureTableViewCellKey"];
            [self bindPictureEvent:cell];
            return cell;
        }
        RefundInforTableViewCell * dcell = [tableView dequeueReusableCellWithIdentifier:@"RefundInforTableViewCellKey"];
        if (dcell == nil) {
            dcell = [[[NSBundle mainBundle] loadNibNamed:@"RefundInforTableViewCell" owner:self options:nil] firstObject];
        }
        dcell.selectionStyle = UITableViewCellSelectionStyleNone;
        dcell.reFundNameLab.text = self.nameArray[indexPath.row];
        dcell.lineIm.hidden = NO;
        if (indexPath.row == 0) {
            NSString *typeStr = @"";
            if ([self.afterModel.after_type integerValue] == 1) {
                typeStr = @"退款退货";
            }else if ([self.afterModel.after_type integerValue] == 2) {
                typeStr = @"换货";
            }else {
                typeStr = @"仅退款";
            }
            dcell.resonLab.text = typeStr;
        }else if (indexPath.row == 1) {
            dcell.resonLab.text = self.afterModel.refund_money;
        }else if (indexPath.row == 2) {
            dcell.resonLab.text = self.afterModel.after_reason;
        }else if (indexPath.row == 3) {
            if ([self.afterModel.refund_explain isEqualToString:@""] || self.afterModel.refund_explain == nil) {
                dcell.resonLab.text = @"暂无说明";
            }else {
                dcell.resonLab.text = self.afterModel.refund_explain;
            }
        }else if (indexPath.row == 4) {
            dcell.resonLab.text = self.afterModel.apply_time;
        }else if (indexPath.row == 5 ) {
            if ([self.afterModel.after_status integerValue] == 4) {
                dcell.reFundNameLab.text = @"完成时间";
                dcell.resonLab.text = self.afterModel.complete_time;
            }
        }
        return dcell;
    }
}

#pragma mark - 点击事件
-(void)clickPhoneEvent{
    [FrankTools detailPhone:self.sellerModel.telephone];
}

-(void)bindPictureEvent:(PictureTableViewCell *)cell{
    switch (self.pictureArray.count) {
        case 1:
            [FrankTools setImgWithImgView:cell.imageOne withImageUrl:self.pictureArray[0] withPlaceHolderImage:placeHolderImg];
            break;
        case 2:
            [FrankTools setImgWithImgView:cell.imageOne withImageUrl:self.pictureArray[0] withPlaceHolderImage:placeHolderImg];
            [FrankTools setImgWithImgView:cell.imageTwo withImageUrl:self.pictureArray[1] withPlaceHolderImage:placeHolderImg];
            break;
        case 3:
            [FrankTools setImgWithImgView:cell.imageOne withImageUrl:self.pictureArray[0] withPlaceHolderImage:placeHolderImg];
            [FrankTools setImgWithImgView:cell.imageTwo withImageUrl:self.pictureArray[1] withPlaceHolderImage:placeHolderImg];
            [FrankTools setImgWithImgView:cell.imagethree withImageUrl:self.pictureArray[2] withPlaceHolderImage:placeHolderImg];
            break;
        default:
            break;
    }
}

-(void)clickModifyEvent:(UIButton *)button_{
    if (self.isAfterPage) {
        [self.delegate popFromDrawBack:self.afterModel.after_id];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ApplyAfterSaleViewController *afterVc = [ApplyAfterSaleViewController new];
    afterVc.order_id = self.afterModel.order_id;
    afterVc.goods_id = self.afterModel.goods_id;
    afterVc.seller_id = self.afterModel.seller_id;
    afterVc.goods_price = self.afterModel.order_amount;
    afterVc.attr_id = self.afterModel.attr_id;
    afterVc.refundMoneyStr = self.afterModel.refund_money;;
    afterVc.refundExplainStr = self.afterModel.refund_explain;
    afterVc.after_id = self.afterModel.after_id;
    if ([self.afterModel.after_type isEqualToString:@"1"]) {
        afterVc.refundServiceStr = @"退款退货";
        afterVc.refundReasonStr = self.afterModel.after_reason;
    }
    if ([self.afterModel.after_type isEqualToString:@"3"]) {
        afterVc.refundServiceStr = @"仅退款";
        afterVc.refundReasonAnotherStr = self.afterModel.after_reason;
    }
    if ([self.afterModel.get_status isEqualToString:@"1"]||[self.afterModel.get_status isEqualToString:@"0"]) {
        afterVc.goodsStatusStr = @"未收到货";
    }
    if ([self.afterModel.get_status isEqualToString:@"2"]) {
        afterVc.goodsStatusStr = @"已收到货";
    }
    
    afterVc.imageUrlArr = [[NSMutableArray alloc] initWithArray:self.pictureArray];
    FLLog(@"%@  =====  %@",afterVc.imageUrlArr,self.pictureArray);
    afterVc.ifFromFix = YES;
    afterVc.delegate = self;
    [self.navigationController pushViewController:afterVc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                              @"device_id":[FrankTools getDeviceUUID],
                              @"after_id":self.afterModel.after_id};
        [self showHUDWithMessage:nil];
        [MainRequest RequestHTTPData:PATHShop(@"api/After/userCancelAfter") parameters:dic success:^(id responseData) {
            FLLog(@"%@",responseData);
//            self.afterModel.after_status = @"6";
            [self showHUDWithResult:YES message:@"取消成功"];
            self.after_id = [NSString stringWithFormat:@"%@",[responseData objectForKey:@"after_id"]];
            [self requestData];
//            [self.myTableView reloadData];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

-(void)clickRevokeEvent:(UIButton *)button_{
    if ([button_.titleLabel.text isEqualToString:@"撤销退款申请"]) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"撤销申请后您将不能重新发起售后申请，是否确认撤销？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤销", nil];
        [alterView show];
    }
}

-(void)clickCustomerEvent:(UIButton *)button_{
    if ([button_.titleLabel.text isEqualToString:@"申请客服介入"]) {
        NSDictionary *dic = @{@"token":[FrankTools getUserToken],
                              @"device_id":[FrankTools getDeviceUUID],
                              @"after_id":self.afterModel.after_id};
        [self showHUDWithMessage:nil];
        [MainRequest RequestHTTPData:PATHShop(@"api/After/contactCustomer") parameters:dic success:^(id responseData) {
            FLLog(@"%@",responseData);
            [self hideHUD];
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"申请已提交，客服人员将在3个工作日内与您联系，请保持手机畅通，若有疑问，请拨打24小时客服电话：\n%@",ServicePhone] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alterView show];
            [self.myTableView reloadData];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
        }];
    }
}

- (void)popBackAct:(NSString *)after_id{
    self.after_id = after_id;
    
    [self requestData];
}

-(void)clickExpressButtonEvent{
    FillShippingInfoViewController *fillVc = [FillShippingInfoViewController new];
    fillVc.after_id = self.afterModel.after_id;
    fillVc.delegate = self;
    [self.navigationController pushViewController:fillVc animated:YES];
}

- (void)refreshPreviousVC{
    self.pictureArray = [NSArray array];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
