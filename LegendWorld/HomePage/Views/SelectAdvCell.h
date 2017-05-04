//
//  SelectAdvCell.h
//  legend
//
//  Created by heyk on 16/1/26.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvBaseCell.h"


@interface SelectAdvCell : AdvBaseCell
@property (nonatomic,strong)UILabel *questionLabel;
@property (nonatomic,strong)UIView  *selectContentView;


-(void)setContent:(NSString*)str selects:(NSArray*)array;


@end
