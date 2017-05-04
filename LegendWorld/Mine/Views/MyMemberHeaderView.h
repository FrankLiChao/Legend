//
//  MyMemberHeaderView.h
//  LegendWorld
//
//  Created by wenrong on 16/11/4.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMemberHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userIconImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *userNewMemberLab;
@property (weak, nonatomic) IBOutlet UILabel *userMemberLab;
@property (weak, nonatomic) IBOutlet UIImageView *gradeImg;
@property (strong, nonatomic) NSArray *honor_gradeImArray;
@end
