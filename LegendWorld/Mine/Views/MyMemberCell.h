//
//  MyMemberCell.h
//  LegendWorld
//
//  Created by wenrong on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol callMemberDelegate <NSObject>

-(void)callMemberAct:(NSInteger)num;
-(void)changeMemberAct:(NSInteger)num;

@end



@interface MyMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *memberIconIma;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLab;
@property (weak, nonatomic) IBOutlet UILabel *memberPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *memberLevelLab;
@property (weak, nonatomic) IBOutlet UIButton *changeMemberBtn;
@property (weak, nonatomic) IBOutlet UILabel *memberPersonLab;
- (IBAction)callPersonAct:(UIButton *)sender;
@property (nonatomic, weak)id <callMemberDelegate> delegate;
@end
