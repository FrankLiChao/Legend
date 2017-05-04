//
//  MessageDetailViewController.h
//  LegendWorld
//
//  Created by wenrong on 16/9/22.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"
#import "NoticeViewController.h"

@interface MessageDetailViewController : BaseViewController

@property (nonatomic,retain) NSString *messageTitleStr;
@property (nonatomic,retain) NSString *messageContentStr;
@property (nonatomic,retain) NSString *messageTimeStr;
@property (nonatomic,retain) NoticeListModel *model;
@property (nonatomic, weak) NoticeViewController *delegate;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@end
