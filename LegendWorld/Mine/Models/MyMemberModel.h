//
//  MyMemberModel.h
//  LegendWorld
//
//  Created by wenrong on 16/9/23.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArmyListModel : NSObject
@property (nonatomic,retain)NSString *address;
@property (nonatomic,retain)NSString *children_num;
@property (nonatomic,retain)NSString *duty;
@property (nonatomic,retain)NSString *hx_id;
@property (nonatomic,retain)NSString *is_remove;
@property (nonatomic,retain)NSString *mobile_no;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *num;
@property (nonatomic,retain)NSString *photo_url;
@property (nonatomic,retain)NSString *unread_num;
@property (nonatomic,retain)NSString *user_id;
@end
@interface TeacherModel : NSObject
@property (nonatomic,retain)NSString *address;
@property (nonatomic,retain)NSString *duty;
@property (nonatomic,retain)NSString *hx_id;
@property (nonatomic,retain)NSString *mobile_no;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *num;
@property (nonatomic,retain)NSString *photo_url;
@property (nonatomic,retain)NSString *user_id;
@end
@interface MyMemberModel : NSObject
@property (nonatomic,retain)TeacherModel *teacherModel;
@property (nonatomic,retain)NSArray<ArmyListModel*> *armyListModel;
@end
