//
//  GoodsAppraiseTableViewCell.m
//  LegendWorld
//
//  Created by Frank on 2016/12/9.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "GoodsAppraiseTableViewCell.h"
#import "JSONParser.h"

@implementation GoodsAppraiseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindingDataForCell:(GoodsAppraiseModel *)model{
    [self startData:[model.comment_rank integerValue]];
    NSArray *array = [JSONParser parseToArrayWithString:model.goods_attr];
    NSDictionary *attrDic = array[0];
    self.attrLab.text = [NSString stringWithFormat:@"%@: %@",[attrDic objectForKey:@"name"],[attrDic objectForKey:@"value"]];
    [self imageData:model.comment_img];
    
}

-(void)imageData:(NSArray *)imageArray{
    switch (imageArray.count) {
        case 0:
            self.image1.hidden = YES;
            self.image2.hidden = YES;
            self.image3.hidden = YES;
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            self.imageBgViewOneHight.constant = 0;
            self.imageBgViewTwoHight.constant = 0;
            break;
        case 1:
            self.image1.hidden = NO;
            self.image2.hidden = YES;
            self.image3.hidden = YES;
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            self.imageBgViewOneHight.constant = 70;
            self.imageBgViewTwoHight.constant = 0;
            [FrankTools setImgWithImgView:self.image1 withImageUrl:imageArray[0] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            break;
        case 2:
            self.image1.hidden = NO;
            self.image2.hidden = NO;
            self.image3.hidden = YES;
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            self.imageBgViewOneHight.constant = 70;
            self.imageBgViewTwoHight.constant = 0;
            [FrankTools setImgWithImgView:self.image1 withImageUrl:imageArray[0] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image2 withImageUrl:imageArray[1] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            break;
        case 3:
            self.image1.hidden = NO;
            self.image2.hidden = NO;
            self.image3.hidden = NO;
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            self.imageBgViewOneHight.constant = 70;
            self.imageBgViewTwoHight.constant = 0;
            [FrankTools setImgWithImgView:self.image1 withImageUrl:imageArray[0] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image2 withImageUrl:imageArray[1] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image3 withImageUrl:imageArray[2] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            break;
        case 4:
            self.image1.hidden = NO;
            self.image2.hidden = NO;
            self.image3.hidden = NO;
            self.image4.hidden = NO;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            self.imageBgViewOneHight.constant = 70;
            self.imageBgViewTwoHight.constant = 70;
            [FrankTools setImgWithImgView:self.image1 withImageUrl:imageArray[0] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image2 withImageUrl:imageArray[1] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image3 withImageUrl:imageArray[2] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image4 withImageUrl:imageArray[3] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            break;
        case 5:
            self.image1.hidden = NO;
            self.image2.hidden = NO;
            self.image3.hidden = NO;
            self.image4.hidden = NO;
            self.image5.hidden = NO;
            self.image6.hidden = YES;
            self.imageBgViewOneHight.constant = 70;
            self.imageBgViewTwoHight.constant = 70;
            [FrankTools setImgWithImgView:self.image1 withImageUrl:imageArray[0] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image2 withImageUrl:imageArray[1] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image3 withImageUrl:imageArray[2] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image4 withImageUrl:imageArray[3] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image5 withImageUrl:imageArray[4] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            break;
        case 6:
            self.image1.hidden = NO;
            self.image2.hidden = NO;
            self.image3.hidden = NO;
            self.image4.hidden = NO;
            self.image5.hidden = NO;
            self.image6.hidden = NO;
            self.imageBgViewOneHight.constant = 70;
            self.imageBgViewTwoHight.constant = 70;
            [FrankTools setImgWithImgView:self.image1 withImageUrl:imageArray[0] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image2 withImageUrl:imageArray[1] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image3 withImageUrl:imageArray[2] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image4 withImageUrl:imageArray[3] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image5 withImageUrl:imageArray[4] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            [FrankTools setImgWithImgView:self.image6 withImageUrl:imageArray[5] withPlaceHolderImage:imageWithName(@"icon_placeHolder")];
            break;
        default:
            self.imageBgViewOneHight.constant = 0;
            self.imageBgViewTwoHight.constant = 0;
            self.image1.hidden = YES;
            self.image2.hidden = YES;
            self.image3.hidden = YES;
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            break;
    }
}


-(void)startData:(NSInteger)count{
    switch (count) {
        case 1:
            [self.start1 setImage:imageWithName(@"bt_star_b")];
            [self.start2 setImage:imageWithName(@"bt_star_a")];
            [self.start3 setImage:imageWithName(@"bt_star_a")];
            [self.start4 setImage:imageWithName(@"bt_star_a")];
            [self.start5 setImage:imageWithName(@"bt_star_a")];
            break;
        case 2:
            [self.start1 setImage:imageWithName(@"bt_star_b")];
            [self.start2 setImage:imageWithName(@"bt_star_b")];
            [self.start3 setImage:imageWithName(@"bt_star_a")];
            [self.start4 setImage:imageWithName(@"bt_star_a")];
            [self.start5 setImage:imageWithName(@"bt_star_a")];
            break;
        case 3:
            [self.start1 setImage:imageWithName(@"bt_star_b")];
            [self.start2 setImage:imageWithName(@"bt_star_b")];
            [self.start3 setImage:imageWithName(@"bt_star_b")];
            [self.start4 setImage:imageWithName(@"bt_star_a")];
            [self.start5 setImage:imageWithName(@"bt_star_a")];
            break;
        case 4:
            [self.start1 setImage:imageWithName(@"bt_star_b")];
            [self.start2 setImage:imageWithName(@"bt_star_b")];
            [self.start3 setImage:imageWithName(@"bt_star_b")];
            [self.start4 setImage:imageWithName(@"bt_star_b")];
            [self.start5 setImage:imageWithName(@"bt_star_a")];
            break;
        case 5:
            [self.start1 setImage:imageWithName(@"bt_star_b")];
            [self.start2 setImage:imageWithName(@"bt_star_b")];
            [self.start3 setImage:imageWithName(@"bt_star_b")];
            [self.start4 setImage:imageWithName(@"bt_star_b")];
            [self.start5 setImage:imageWithName(@"bt_star_b")];
            break;
        default:
            [self.start1 setImage:imageWithName(@"bt_star_b")];
            [self.start2 setImage:imageWithName(@"bt_star_b")];
            [self.start3 setImage:imageWithName(@"bt_star_b")];
            [self.start4 setImage:imageWithName(@"bt_star_b")];
            [self.start5 setImage:imageWithName(@"bt_star_b")];
            break;
    }
}

@end
