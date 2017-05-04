//
//  SearchGoodsViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "CommodityListViewController.h"
#import "HotWordCollectionViewCell.h"
#import "CollectionTitleHeaderView.h"

#import "SellerShopViewController.h"

#import "StackLayout.h"

@interface SearchGoodsViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIAlertViewDelegate>

//Models
@property (nonatomic, strong) NSArray *hotWords;
@property (nonatomic, strong) NSArray<SearchHistoryModel *> *searchHistory;

//IBOutlets
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UICollectionView *headerCollectionView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UISearchBar *searchBar;

@end

static NSInteger const maxHistoryCount = 20;
static CGFloat const seperate = 10.0;
@implementation SearchGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30)];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.text = self.searchText;
    self.searchBar.tintColor = [UIColor themeColor];
    self.searchBar.textColor = [UIColor bodyTextColor];
    self.searchBar.placeholder = @"请输入商品名称";
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarBtnClicked:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = seperate;
    layout.minimumInteritemSpacing = seperate;
    layout.headerReferenceSize = CGSizeMake(30 + 12.5, 40);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *headerCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40) collectionViewLayout:layout];
    self.headerCollectionView = headerCollection;
    self.headerCollectionView.backgroundColor = [UIColor clearColor];
    self.headerCollectionView.dataSource = self;
    self.headerCollectionView.delegate = self;
    self.headerCollectionView.contentInset = UIEdgeInsetsMake(7.5, 15, 7.5, 15);
    [self.headerCollectionView registerNib:[UINib nibWithNibName:@"CollectionTitleHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleHeaderView"];
    [self.headerCollectionView registerNib:[UINib nibWithNibName:@"HotWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotWordCollectionViewCell"];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.frame = CGRectMake(50, 20, CGRectGetWidth(self.view.bounds) - 100, 40);
    clearBtn.tintColor = [UIColor bodyTextColor];
    [clearBtn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [clearBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor bodyTextColor] cornerRadius:6] forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor bodyTextColor] forState:UIControlStateNormal];
    [clearBtn setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [clearBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7.5)];
    [clearBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7.5, 0, 0)];
    [clearBtn addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 80)];
    [footerView addSubview:clearBtn];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footerView.bounds), 0.5)];
    line.backgroundColor = [UIColor seperateColor];
    [footerView addSubview:line];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor seperateColor];
    self.tableView.tableHeaderView = self.headerCollectionView;
    self.tableView.tableFooterView = footerView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    StackLayout *stack = [[StackLayout alloc] init];
    stack.minimumLineSpacing = seperate;
    stack.minimumInteritemSpacing = seperate;
    stack.scrollDirection = UICollectionViewScrollDirectionVertical;
    stack.headerReferenceSize = CGSizeMake(DeviceMaxWidth, 40);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:stack];
    self.collectionView = collectionView;
    self.collectionView.hidden = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionTitleHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotWordCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.collectionView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
- (void)updateUI {
    self.navigationItem.rightBarButtonItem.enabled = [self.searchBar.text trim].length > 0;
    
    self.tableView.hidden = self.searchHistory.count == 0;
    self.collectionView.hidden = self.searchHistory.count != 0;
    
    [self.tableView reloadData];
    [self.headerCollectionView reloadData];
    [self.collectionView reloadData];
}

- (void)loadData {
    [self showHUDWithMessage:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.searchHistory = [SearchHistoryModel fetchAll];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    });
    NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID]};
    [MainRequest RequestHTTPData:PATHShop(@"Api/Goods/getHotSearch") parameters:param success:^(id response) {
        self.hotWords = [HotWordModel parseResponse:response];
        
        [self updateUI];
        [self hideHUD];
    } failed:^(NSDictionary *errorDic) {
        [self hideHUD];
    }];
}

- (void)searchBarBtnClicked:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *searchText = [self.searchBar.text trim];
        if (searchText.length <= 0 || searchText == nil) {
            return;
        }
        
        SearchHistoryModel *newHistory = [[SearchHistoryModel alloc] initWithSearchText:searchText];
        NSArray *repeatArr = [SearchHistoryModel fetch:newHistory];
        if (repeatArr.count > 0) {
            for (SearchHistoryModel *obj in repeatArr) {
                SearchHistoryModel *model = (SearchHistoryModel *)obj;
                [SearchHistoryModel update:model withNew:newHistory];
            }
        } else {
            if (self.searchHistory.count >= maxHistoryCount) {
                SearchHistoryModel *lastModel = [self.searchHistory lastObject];
                [SearchHistoryModel delete:lastModel];
            }
            [SearchHistoryModel insert:newHistory];
        }
        self.searchHistory = [SearchHistoryModel fetchAll];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchGoodsViewController:didSearchText:)]) {
                [self.delegate searchGoodsViewController:self didSearchText:searchText];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                CommodityListViewController *goodsList = [[CommodityListViewController alloc] init];
                goodsList.goodsName = searchText;
                goodsList.ifFromSearchView = YES;
                [self.navigationController pushViewController:goodsList animated:YES];
            }
        });
    });
}

- (void)clearButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要清空搜索记录？" delegate:self cancelButtonTitle:@"不清空" otherButtonTitles:@"清空", nil];
    [alert show];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.navigationItem.rightBarButtonItem.enabled = [searchText trim].length > 0;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBarBtnClicked:nil];
    [searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    SearchHistoryModel *history = self.searchHistory[indexPath.row];
    cell.textLabel.text = history.search_text;
    cell.textLabel.textColor = [UIColor bodyTextColor];
    cell.textLabel.font = [UIFont bodyTextFont];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 40)];
    header.backgroundColor = [UIColor backgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(header.bounds) - 30, CGRectGetHeight(header.bounds))];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont titleTextFont];
    label.textColor = [UIColor titleTextColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"历史搜索";
    [header addSubview:label];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchHistoryModel *selectModel = (SearchHistoryModel *)self.searchHistory[indexPath.row];
    self.searchBar.text = selectModel.search_text;
    [self searchBarBtnClicked:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotWords.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionTitleHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleHeaderView" forIndexPath:indexPath];
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotWordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotWordCollectionViewCell" forIndexPath:indexPath];
    HotWordModel *model = self.hotWords[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotWordModel *model = self.hotWords[indexPath.row];
    CGRect bounds = [model.name boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 2 * seperate, seperate)
                                       options:NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName: [UIFont bodyTextFont]}
                                       context:nil];
    return CGSizeMake(bounds.size.width + 2 * seperate, 25);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    HotWordModel *model = self.hotWords[indexPath.row];
    self.searchBar.text = model.name;
    [self searchBarBtnClicked:nil];
}

#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"清空"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SearchHistoryModel deleteAll];
            self.searchHistory = [SearchHistoryModel fetchAll];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI];
            });
        });
    }
}

@end

