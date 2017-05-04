//
//  DrawbackDetailViewController.h
//  LegendWorld
//
//  Created by Frank on 2016/11/10.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"

@protocol DrawbackDetailViewDelegate <NSObject>

-(void)popFromDrawBack:(NSString *)after_id;

@end



@interface DrawbackDetailViewController : BaseViewController

@property (nonatomic, strong)NSString *after_id;//售后Id
@property (nonatomic)BOOL isAfterPage;//是售后页面则为Yes,否则为NO
@property (nonatomic, weak) id <DrawbackDetailViewDelegate> delegate;
@end
