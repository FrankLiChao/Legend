//
//  AdverBaseViewController.h
//  legend
//
//  Created by heyk on 16/1/25.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "BaseViewController.h"
#import "AdvertModel.h"
#import "AdverPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "AdvBaseCell.h"

@protocol AdverBaseViewControllerDelegate <NSObject>
@optional
- (AdvBaseCell *)customTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)customTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)customTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end

@interface AdverBaseViewController : BaseViewController

@property (nonatomic,strong)  NSMutableDictionary *imageDownDic;
@property (nonatomic,weak) IBOutlet UITableView *aTabelView;
@property (nonatomic,weak) IBOutlet UIButton *actionButton;
@property (nonatomic,strong) AdvertModel *baseModel;
@property (nonatomic,strong) AdDetailInfoModel *model;
@property (nonatomic,assign) BOOL  bUnAvailable;//是否是支持的类型
@property (nonatomic,weak) id<AdverBaseViewControllerDelegate>delegate;
@property (nonatomic,strong) NSString *anwser;
@property (nonatomic,strong) NSString *brand_id;
@property (nonatomic,copy,readonly) NSString *advId;

- (id)initWithBaseModel:(AdvertModel *) baseModel;
- (void)reloadUI;

-(void)setActionButtonTitle:(NSString*)str imageName:(NSString*)imageName;

-(void)downtimeOver;//倒计时结束

- (void)checkGoodsDetail;

@end
