//
//  MessageModel.h
//  LegendWorld
//
//  Created by wenrong on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeListModel : NSObject

@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) NSString* effect_time;
@property (nonatomic,retain) NSString* is_read;
@property (nonatomic,retain) NSString* notice_id;
@property (nonatomic,retain) NSString* title;

@end


@interface MessageModel : NSObject
@property (nonatomic,strong) NSArray<NoticeListModel *> *notice_list;
@end


