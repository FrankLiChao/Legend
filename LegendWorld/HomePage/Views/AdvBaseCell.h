//
//  AdvBaseCell.h
//  legend
//
//  Created by heyk on 16/1/26.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol AdvBaseCellDelegate <NSObject>

-(void)valueChanged:(NSString*)value;

@end
@interface AdvBaseCell : UITableViewCell

@property (nonatomic,weak)id <AdvBaseCellDelegate>delegate;
-(void)selectValue:(NSString*)value;
-(NSString*)getMyAnswer;
@end
