//
//  AdverBaseViewController.m
//  legend
//
//  Created by heyk on 16/1/25.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "AdverBaseViewController.h"
#import "UitlCommon.h"
#import "SDImageCache.h"
#import "AdvInfoCell.h"
#import "AdvBaseCell.h"
#import "MainRequest.h"

@interface AdverBaseViewController ()<UITableViewDataSource,UITableViewDelegate,AdvBaseCellDelegate>

@property (nonatomic,weak) IBOutlet UILabel *advTitleLabel;
@property (nonatomic,weak) IBOutlet UILabel *advDetailLabel;
@property (nonatomic,weak) IBOutlet UILabel *donePercentLabel;
@property (nonatomic,weak) IBOutlet UIView  *donePercentBackView;
@property (nonatomic,weak) IBOutlet UIView  *donePercentGrayBackView;
@property (nonatomic,weak) IBOutlet UIView  *headView;
@property (nonatomic,weak) IBOutlet UIView  *footView;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *donePercent;
@property (nonatomic, strong) AdDetailInfoModel *datasource;

@end

@implementation AdverBaseViewController{
    
    NSInteger readDownCount;//强制阅读倒计时
    NSTimer *readCountDownTimer ;
    NSString *actionButtonTitle;
    NSString *actionButtonImage;
    dispatch_queue_t  myDownImageWaitQueue;
}

- (void)setActionButtonTitle:(NSString*)str imageName:(NSString*)imageName{
    
    actionButtonTitle = str;
    actionButtonImage = imageName;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滑动返回手势无效
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareImageView"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnEvent)];
    self.aTabelView.delegate = self;
    self.aTabelView.dataSource = self;
    myDownImageWaitQueue = dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL);
    self.title = @"广告详情";
    _headView.hidden = YES;
    _footView.hidden = YES;
    readDownCount  = 10;
    self.imageDownDic = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAd) name:@"adSaveSuccess" object:nil];
    
    [self showHUD];
    [AdDetailInfoModel loadDataWithAdDetail:self.baseModel success:^(AdDetailInfoModel *adDetailModel) {
        self.model = adDetailModel;
        __block NSInteger downImageCount = 0;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        for (ADPicContentModel *picModel in _model.content) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:picModel.pic_url]
                                                            options:0
                                                           progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                               downImageCount++;
                                                               if (downImageCount == _model.content.count ) {
                                                                   dispatch_semaphore_signal(semaphore);
                                                               }
                                                           }];
        }
        if (!_model.content || _model.content.count == 0) {
            dispatch_semaphore_signal(semaphore);
        }
        dispatch_async(myDownImageWaitQueue, ^(){
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadUI];
            });
        });
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:YES message:[errorDic objectForKey:@"error_msg"]];
    }];
    __weak typeof(self) weakSelf = self;
    self.rightBarBtnEvent = ^ {
        NSString * imageStr = weakSelf.model.share_img;
        NSString * urlStr = weakSelf.model.share_link;
        NSString * conStr = @"传说，是互联网+时代给大众带来的创富机遇。带朋友看广告，就能赚大钱！";
        NSString * titilStr = weakSelf.model.ad_title;
        NSString *shareStatus = nil;
        if ([weakSelf.model.is_collect integerValue] == 0) {
            shareStatus = @"1";
        }else if ([weakSelf.model.is_collect integerValue] == 1) {
            shareStatus = @"2";
        }
        [FrankTools fxViewAppear:imageStr conStr:conStr withUrlStr:urlStr withTitilStr:titilStr withVc:weakSelf isAdShare:shareStatus];
    };
}

-(void)saveAd{
    NSString *urlStr = nil;
    if ([self.model.is_collect integerValue] == 1) {
        urlStr = PATH(@"api/ad/cancelAdCollect");
    }else{
        urlStr = PATH(@"api/ad/addAdCollect");
    }
    NSDictionary *dic = @{@"ad_id":self.model.ad_id?self.model.ad_id:@"",
                          @"device_id":[FrankTools getDeviceUUID],
                          @"token":[FrankTools getUserToken]
                          };
    [MainRequest RequestHTTPData:urlStr parameters:dic success:^(id responseData) {
        if ([self.model.is_collect integerValue] == 1) {
            [self showHUDWithResult:YES message:@"已取消收藏"];
        } else {
            [self showHUDWithResult:YES message:@"收藏成功"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (id)initWithBaseModel:(AdvertModel *)baseModel {
    self = [super initWithNibName:@"AdverBaseViewController" bundle:nil];
    if (self) {
        self.baseModel = baseModel;
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (readCountDownTimer && [readCountDownTimer isValid]) {
        [readCountDownTimer invalidate];
        readCountDownTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom methods
- (void)startTimer {
    readCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:readCountDownTimer forMode:NSRunLoopCommonModes];
}

-(void)readCountDown:(NSTimer*)timer{
    readDownCount--;
    if (readDownCount <= 0) {
        [timer invalidate];
        
        self.actionButton.enabled = YES;
        [self.actionButton setAttributedTitle:nil forState:UIControlStateNormal];
        [self.actionButton setBackgroundColor:mainColor];
        [self.actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionButton setImage:[UIImage imageNamed:actionButtonImage] forState:UIControlStateNormal];
        
        [self downtimeOver];
        
    }
    else{
        NSString *key = [[NSNumber numberWithInteger:readDownCount] stringValue];
        NSString *content = [NSString stringWithFormat:@"还有%@秒可以答题",key];
        
        NSMutableAttributedString *str = [UitlCommon setString:content keyString:key color:mainColor otherColor:[UIColor grayColor]];
        [self.actionButton setAttributedTitle:str forState:UIControlStateNormal];
        
    }
}

-(void)downtimeOver{
    
    
}
- (void)checkGoodsDetail{
}

- (void)addShareButton{
    
    UIButton *back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [back_btn setFrame:CGRectMake(0, 0, 25, 25)];
    [back_btn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:back_btn];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightItem, nil]];
}

- (void)shareClick:(UIButton*)share{
    [self.view endEditing:YES];
}

#pragma mark WebEngine delegate
- (void)reloadUI{
    [self addShareButton];
    _headView.hidden = NO;
    _footView.hidden = NO;
    _advTitleLabel.text = _model.ad_title;
    _advDetailLabel.text = [NSString stringWithFormat:@"悬赏金额：%@  单价：%@  等级：%@",_model.budget?_model.budget:@"0",_model.price?_model.price:@"0",[UitlCommon transferLevel:_model.limit_grade]];
    int percent = [_model.finish_percent intValue];
    if (percent > 100) {
        percent = 100;
    }
    if (percent == 0) {
        _donePercentBackView.backgroundColor = adGrayColor;
    } else {
        _donePercentBackView.backgroundColor = mainColor;
    }
    _donePercentLabel.text = [NSString stringWithFormat:@"%d%%",percent];
    _donePercent.constant = [_model.finish_percent floatValue] /100*240*widthRate;
    [self.actionButton setBackgroundColor:mainColor];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.actionButton.enabled = NO;
    [_aTabelView  reloadData];
    [self.actionButton setAttributedTitle:nil forState:UIControlStateNormal];
    [self.actionButton setImage:nil forState:UIControlStateNormal];
    if(percent >= 100 ){
        if(self.model.shop_url){
            self.actionButton.enabled = YES;
            if ([_model.is_seller boolValue]) {
                [self.actionButton setTitle:@"查看商品详情" forState:UIControlStateNormal];
            }
            else{
                [self.actionButton setTitle:@"查看商家详情" forState:UIControlStateNormal];
            }
        }
        else{
            self.actionButton.backgroundColor = tableDefSepLineColor;
            [self.actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

            if ([_model.is_seller boolValue]) {
                [self.actionButton setTitle:@"查看商品详情" forState:UIControlStateNormal];
                
            }
            else{
                [self.actionButton setTitle:@"该条广告已抢完" forState:UIControlStateNormal];
            }
   

        }
        return;
    }
    if([self.model.is_read boolValue]) {
        
        if(self.model.shop_url){
            self.actionButton.enabled = YES;
            
            if ([_model.is_seller boolValue]) {
                [self.actionButton setTitle:@"查看商品详情" forState:UIControlStateNormal];
            }
            else{
                [self.actionButton setTitle:@"查看商家详情" forState:UIControlStateNormal];
            }
        }
        else{
            self.actionButton.backgroundColor = tableDefSepLineColor;
            [self.actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            if ([_model.is_seller boolValue]) {
                [self.actionButton setTitle:@"查看商品详情" forState:UIControlStateNormal];
                
            }
            else{
                [self.actionButton setTitle:@"已抢" forState:UIControlStateNormal];
            }
        }
        return;
    }
    
    if(!_bUnAvailable){//可以操作的类别
        if([_model.force_read intValue]>0){//强制阅读
            
            self.actionButton.backgroundColor = tableDefSepLineColor;
            NSString *timers = [NSString stringWithFormat:@"%@",_model.force_read];
            
            NSMutableAttributedString *str = [UitlCommon setString:[NSString stringWithFormat:@"还有%@秒可以答题",timers] keyString:timers color:mainColor otherColor:[UIColor grayColor]];
            [self.actionButton setAttributedTitle:str forState:UIControlStateNormal];
            [self startTimer];
        }
        else{//不需要强制阅读的
            self.actionButton.enabled = YES;
            [self.actionButton setAttributedTitle:nil forState:UIControlStateNormal];
            [self.actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
            [self.actionButton setImage:[UIImage imageNamed:actionButtonImage] forState:UIControlStateNormal];
        }
    }
    else{
        [self.actionButton setAttributedTitle:nil forState:UIControlStateNormal];
        [self.actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
        [self.actionButton setImage:[UIImage imageNamed:actionButtonImage] forState:UIControlStateNormal];
        
        self.actionButton.backgroundColor = tableDefSepLineColor;
        [self.actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }
    
    
    
}

#pragma mark tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {//行数
    
    if (!self.model) {
        return 0;
    }
    
    NSInteger exterRow = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(customTableView:numberOfRowsInSection:)]) {
        exterRow = [self.delegate customTableView:tableView numberOfRowsInSection:section];
    }
    return exterRow + self.model.content.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {//广告介绍部分
        AdvInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvInfoCell"];
        if (!cell) {
            cell = [[AdvInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdvInfoCell"];
        }
        
        [cell setContent:self.model.intro];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }
    else if(indexPath.row -1 < _model.content.count && _model.content.count !=0){//图片部分
        AdverPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdverPhotoCell"];
        if (!cell) {
            cell = [[AdverPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdverPhotoCell"];
        }
        ADPicContentModel *picModel = [self.model.content objectAtIndex:indexPath.row-1];
        [((AdverPhotoCell*)cell).photoImageV sd_setImageWithURL:[NSURL URLWithString:picModel.pic_url] placeholderImage:defaultUserHead completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        return cell;
    }
    else{
        AdvBaseCell *cell = [self.delegate customTableView:tableView cellForRowAtIndexPath:indexPath];
        [cell selectValue:self.anwser];
        if (self.delegate && [self.delegate respondsToSelector:@selector(customTableView:cellForRowAtIndexPath:)]) {
            cell.delegate = self;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([UitlCommon isNull:self.model.intro]) {
            return 0;
        }
        else{
            return [AdvInfoCell cellHeight:self.model.intro];
        }
    }
    else if(indexPath.row -1 < _model.content.count && _model.content.count !=0){//图片部分{
        ADPicContentModel *picModel = [self.model.content objectAtIndex:indexPath.row-1];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:picModel.pic_url];
        CGFloat height = 0;
        if (image) {
             height = ([UIScreen mainScreen].bounds.size.width - 24)*image.size.height/image.size.width;
        }
        return height;        
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(customTableView:heightForRowAtIndexPath:)]) {
            return [self.delegate customTableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row -1 < _model.content.count && _model.content.count !=0) {
        ADPicContentModel *picModel = [self.model.content objectAtIndex:indexPath.row-1];
        if (picModel.pic_link) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:picModel.pic_link]];
        }
    }
}
#pragma mark  AdvBaseCellDelegate
-(void)valueChanged:(NSString*)value{
    self.anwser = value;
}
@end
