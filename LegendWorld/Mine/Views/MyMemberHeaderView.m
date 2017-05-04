//
//  MyMemberHeaderView.m
//  LegendWorld
//
//  Created by wenrong on 16/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "MyMemberHeaderView.h"

@implementation MyMemberHeaderView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.honor_gradeImArray = @[@"mine_grade_v1",@"mine_grade_v2",@"mine_grade_v3",@"mine_grade_v4",@"mine_grade_v5",@"mine_grade_v6",@"mine_grade_v7",@"mine_grade_v8",@"mine_grade_v9",@"mine_grade_v10",@"mine_grade_v11",@"mine_grade_v12",@"mine_grade_v13"];
    self.userIconImg.layer.cornerRadius = 75/2;
    self.userIconImg.layer.masksToBounds = YES;
    NSDictionary *userInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:userLoginDataToLocal];
    self.userNameLab.text = [userInfoDic objectForKey:@"user_name"];
    self.userNewMemberLab.text = [NSString stringWithFormat:@"今日新增 %@人",[userInfoDic objectForKey:@"day_grow"]];
    self.userMemberLab.text = [NSString stringWithFormat:@"全部成员 %@人",[userInfoDic objectForKey:@"straight_number"]];
    [FrankTools setImgWithImgView:self.userIconImg withImageUrl:[userInfoDic objectForKey:@"photo_url"] withPlaceHolderImage:defaultUserHead];
    NSInteger num = [[userInfoDic objectForKey:@"honor_grade"] integerValue];
    if (num == 0) {
        self.gradeImg.hidden = YES;
    }else{
        self.gradeImg.hidden = NO;
        self.gradeImg.image = [UIImage imageNamed:self.honor_gradeImArray[num-1]];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
