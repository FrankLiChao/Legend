//
//  SetQuitCell.h
//  LegendWorld
//
//  Created by wenrong on 16/9/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol quitDelegate <NSObject>

-(void)quitAct;

@end

@interface SetQuitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
- (IBAction)quitAct:(UIButton *)sender;
@property (nonatomic, weak) id<quitDelegate>delegate;
@end
