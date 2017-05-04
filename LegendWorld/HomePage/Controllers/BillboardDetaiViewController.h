//
//  BillboardDetaiViewController.h
//  LegendWorld
//
//  Created by ios-dev-01 on 16/9/18.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "BaseViewController.h"
#import "BillboardModel.h"

@interface BillboardDetaiViewController : BaseViewController

@property (nonatomic,strong) BillboardModel *dataModel;//数据
@property (nonatomic,assign) NSInteger type;//0表示周数据 1表示月数据
@property (nonatomic,assign) NSInteger jumpType;//0财富榜 1新人榜 2推荐榜

@end
