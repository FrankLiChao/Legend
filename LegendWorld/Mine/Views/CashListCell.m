//
//  CashListCell.m
//  legend
//
//  Created by heyk on 15/11/30.
//  Copyright © 2015年 e3mo. All rights reserved.
//

#import "CashListCell.h"
//#import "NSDate+Category.h"

@implementation CashListCell

+(CashListCell*)getInstanceWithReuseIdentifier:(NSString*)reuseIdentifier{
    
    CashListCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"CashListCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[CashListCell class]] && [((UITableViewCell*)obj).reuseIdentifier isEqualToString:reuseIdentifier]){
            cell = (CashListCell *)obj;
            if ([reuseIdentifier isEqualToString:@"CashListCell"]) {
                cell.statusImage1.layer.cornerRadius = 5;
                cell.statusImage2.layer.cornerRadius = 5;
                cell.statusImage3.layer.cornerRadius = 5;
                cell.detailHeight.constant =  208*widthRate - 83*widthRate;
            }

            [cell setUI];
            break;
        }
    }
    return cell;
    
}


-(void)setUI{
    
    self.typeNameLabel.font = [UIFont systemFontOfSize:16*widthRate];
    self.dateLabel.font = [UIFont systemFontOfSize:12*widthRate];
    
    self.amountLabel.font = [UIFont systemFontOfSize:24*widthRate];
    self.typeNameDetailLabel.font = [UIFont systemFontOfSize:15];
    self.statusLabel.font = [UIFont systemFontOfSize:14*widthRate];
    self.statusLabel1.font = [UIFont systemFontOfSize:14*widthRate];
    self.statusLabel2.font = [UIFont systemFontOfSize:14*widthRate];
    self.statusLabel3.font = [UIFont systemFontOfSize:14*widthRate];
    
    self.statusDateLabel1.font = [UIFont systemFontOfSize:12*widthRate];
    self.statusDateLabel2.font = [UIFont systemFontOfSize:12*widthRate];
    self.statusDateLabel3.font = [UIFont systemFontOfSize:12*widthRate];
    
}


-(void)setUIWithModel:(CashListModel*)model clickResponse:(CashListCellClickBlock)block{
    
    self.clickBlock = block;
    
    if ([model.finish_time intValue]==0) {
         self.dateLabel.text = model.apply_time;
    }
   else  self.dateLabel.text = model.finish_time;
    
    self.amountLabel.text = [NSString stringWithFormat:@"%@",model.money];
    self.statusDateLabel1.text = @"申请成功";
    
    switch ([model getType]) {
        case CashType_Bank:
        {
            self.typeNameLabel.text = @"银行卡提现";
            self.typeNameDetailLabel.text = [NSString stringWithFormat:@"%@(%@)",model.bank_name,model.bank_no];
            self.statusLabel2.text = @"处理中";
            self.statusLabel3.text = @"提现成功";
        }
            break;
        case CashType_WeChat_LuckMoney:
        case CashType_WeChat:
        {
            self.typeNameLabel.text = @"微信提现";
            self.typeNameDetailLabel.text = [NSString stringWithFormat:@"微信提现(%@)",model.nick_name];
            self.statusLabel2.text = @"处理中";
            self.statusLabel3.text = @"提现成功";
        }
            break;
        default:
            break;
    }
    
    switch ([model getSatus]) {
        case CashStatus_ApplySuccess://申请成功
        {
            self.statusLabel.text = @"处理中";
            self.statusLabel.textColor = [UIColor colorFromHexRGB:@"2f94d9"];
            self.statusDateLabel1.text = [model applyDateStr];
            self.statusLabel1.textColor = contentTitleColorStr;
            self.statusImage1.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            self.line1_left.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            self.line1_right.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            
            self.statusDateLabel2.text = nil;
            self.statusLabel2.textColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            self.statusImage2.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            self.line2_left.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            self.line2_right.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            
            
            self.statusDateLabel3.text = nil;
            self.statusLabel3.textColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            self.statusImage3.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
        }
            break;
        case CashStatus_Auditing://申请中
        {
            self.statusLabel.text = @"处理中";
            self.statusLabel.textColor = [UIColor colorFromHexRGB:@"2f94d9"];
            
            self.statusDateLabel1.text = [model applyDateStr];
            self.statusLabel1.textColor = contentTitleColorStr;
            self.statusImage1.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            self.line1_left.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            self.line1_right.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            
            //Frank待修改的地方
//            NSDate *now = [NSDate date];
//            self.statusDateLabel2.text = [self formattedDateDescription];
            self.statusLabel2.textColor = contentTitleColorStr;
            self.statusImage2.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            self.line2_left.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            self.line2_right.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            
            
            self.statusDateLabel3.text = nil;
            self.statusLabel3.textColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            self.statusImage3.backgroundColor = [UIColor colorFromHexRGB:@"d3d3d3"];
            
        }
            break;
        case  CashStatus_HavePay://提现成功
        {
            self.statusLabel.text = @"提现成功";
            self.statusLabel.textColor = [UIColor colorFromHexRGB:@"38be7e"];
            
            self.statusDateLabel1.text = [model applyDateStr];
            self.statusLabel1.textColor = contentTitleColorStr;
            self.statusImage1.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            self.line1_left.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            self.line1_right.backgroundColor = [UIColor colorFromHexRGB:@"38be7e"];
            
            
            self.statusDateLabel2.text = nil;
            self.statusLabel2.textColor = contentTitleColorStr;
            self.statusImage2.backgroundColor = contentTitleColorGreen;
            self.line2_left.backgroundColor = contentTitleColorGreen;
            self.line2_right.backgroundColor = contentTitleColorGreen;
            
            
            self.statusDateLabel3.text = [NSString stringWithFormat:@"%@",[model.finish_time intValue]==0?model.apply_time:model.finish_time];
            self.statusLabel3.textColor = contentTitleColorGreen;
            self.statusImage3.backgroundColor = contentTitleColorGreen;
        }
            break;
        case CashStatus_AuditFailed://失败
        case CashStatus_PayFailed:
        case CashStatus_BackToAccount:
        {
            if (CashStatus_BackToAccount == [model getSatus]) {
                 self.statusLabel.text = @"提现失败并返款";
            }
            else{
                 self.statusLabel.text = @"提现失败";
            }
           
            self.statusLabel.textColor = mainColor;
            
            self.statusDateLabel1.text = [model applyDateStr];
            self.statusLabel1.textColor = contentTitleColorStr;
            self.statusImage1.backgroundColor = contentTitleColorGreen;
            self.line1_left.backgroundColor = contentTitleColorGreen;
            self.line1_right.backgroundColor = contentTitleColorGreen;
            
            
            self.statusDateLabel2.text = nil;
            self.statusLabel2.textColor = contentTitleColorStr;
            self.statusImage2.backgroundColor = contentTitleColorGreen;
            self.line2_left.backgroundColor = contentTitleColorGreen;
            self.line2_right.backgroundColor = mainColor;
            
            
            
            self.statusDateLabel3.text = [NSString stringWithFormat:@"%@",[model.finish_time intValue]==0?model.apply_time:model.finish_time];
            self.statusLabel3.textColor = mainColor;
            self.statusImage3.backgroundColor = mainColor;
            self.statusLabel3.text = @"提现失败";
            
        }
            break;
        default:{
        
        }
            break;
    }
    [self.contentView bringSubviewToFront:_spearateLine];
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)clickOpen:(id)sender{
    
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}



@end
