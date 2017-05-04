//
//  GoodsAppraiseViewController.m
//  LegendWorld
//
//  Created by Frank on 2016/12/8.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "GoodsAppraiseViewController.h"
#import "GoodsAppraiseTableViewCell.h"
#import "MJRefresh.h"
#import "GoodsAppraiseModel.h"

@interface GoodsAppraiseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger totalPage;
@property (weak,nonatomic)UITableView   *myTableView;
@property (strong,nonatomic)NSMutableArray *appraiseList;

@end

@implementation GoodsAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品评价";
    [self initFrameView];
    self.pageIndex = 1;
    self.appraiseList = [NSMutableArray new];
    [self requestData];
}

-(void)initFrameView{
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight-64) style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.estimatedRowHeight = 200;
    self.myTableView = myTableView;
    [myTableView addFooterWithTarget:self action:@selector(footerRefresh)];
    myTableView.rowHeight = UITableViewAutomaticDimension;
    [myTableView registerNib:[UINib nibWithNibName:@"GoodsAppraiseTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsAppraiseTableViewCell"];
    [self.view addSubview:myTableView];
    
    myTableView.tableFooterView = [UIView new];
}

-(void)requestData
{
    NSString *goods_id = _currentModel.goods_id;
    NSDictionary *dic = @{@"device_id":[FrankTools getDeviceUUID],
                          @"goods_id":goods_id?goods_id:@"",
                          @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex]};
    [self showHUDWithMessage:@"加载中"];
    [MainRequest RequestHTTPData:PATHShop(@"api/GoodsComment/getCommentListNew") parameters:dic success:^(id responseData) {
        [self hideHUD];
        if (self.pageIndex == 1) {
            self.myTableView.delegate = self;
            self.myTableView.dataSource = self;
        }
        self.totalPage = [[responseData objectForKey:@"total_page"] integerValue];
        NSArray *array = [GoodsAppraiseModel parseResponse:responseData];
        if (array) {
            [self.appraiseList addObjectsFromArray:array];
        }
        if (self.appraiseList) {
            [self.myTableView reloadData];
        }
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)footerRefresh
{
    if (self.pageIndex >= self.totalPage) {
        [self.myTableView footerEndRefreshing];
        return;
    }
    self.pageIndex++;
    [self requestData];
    [self.myTableView footerEndRefreshing];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appraiseList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsAppraiseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsAppraiseTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodsAppraiseModel *model = self.appraiseList[indexPath.row];
    cell.nameLab.text = model.user_name;
    cell.contentLab.text = model.content;
    cell.dateLab.text = model.create_time;
    cell.headIm.layer.cornerRadius = 30;
    cell.headIm.layer.masksToBounds = YES;
    [FrankTools setImgWithImgView:cell.headIm withImageUrl:model.user_avatar withPlaceHolderImage:defaultUserHead];
    [cell bindingDataForCell:model];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
