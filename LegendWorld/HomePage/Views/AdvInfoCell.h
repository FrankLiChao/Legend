//
//  AdvInfoCell.h
//  legend
//
//  Created by heyk on 16/1/27.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvInfoCell : UITableViewCell


+(float)cellHeight:(NSString*)str;
-(void)setContent:(NSString*)str;

@end
