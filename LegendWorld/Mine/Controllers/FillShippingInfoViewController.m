//
//  FillShippingInfoViewController.m
//  LegendWorld
//
//  Created by Tsz on 2016/11/16.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "FillShippingInfoViewController.h"

@interface FillShippingInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectShippingBtn;
@property (weak, nonatomic) IBOutlet UITextField *shippingTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) UITableView *tableView;


@property (nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSArray *data;
@end

@implementation FillShippingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写物流";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.selectShippingBtn setBackgroundImage:[UIImage backgroundStrokeImageWithColor:[UIColor noteTextColor]] forState:UIControlStateNormal];
    [self.selectShippingBtn setTitleColor:[UIColor noteTextColor] forState:UIControlStateNormal];
    
    self.shippingTextField.layer.borderColor = [UIColor noteTextColor].CGColor;
    self.shippingTextField.layer.borderWidth = 0.5;
    
    [self.okBtn setBackgroundImage:[UIImage backgroundImageWithColor:[UIColor themeColor] cornerRadius:6] forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.selectedIndex = 0;
    self.data = @[@"选择物流公司",@"顺丰快递",@"申通快递",@"圆通快递",@"韵达快递",@"其他"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectBtnClicked:(UIButton *)sender {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(sender.frame), CGRectGetMaxY(sender.frame), CGRectGetWidth(sender.frame), 0) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.layer.borderColor = [UIColor seperateColor].CGColor;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 40;
    self.tableView.separatorColor = [UIColor seperateColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.tableView.frame;
        frame.size.height = 40 * self.data.count;
        self.tableView.frame = frame;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.tableView.frame;
        frame.size.height = 0;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
    }];
}

- (IBAction)okBtnClicked:(id)sender {
    if (self.selectedIndex == 0) {
        [self showHUDWithResult:NO message:@"请选择物流公司"];
        return;
    }
    if ([self.shippingTextField.text trim].length <= 0) {
        [self showHUDWithResult:NO message:@"请填写物流单号"];
        return;
    }
    
    NSInteger shippingNum = [[self.shippingTextField.text trim] integerValue];
    [self showHUDWithMessage:nil];
    NSDictionary *param = @{@"device_id":[FrankTools getDeviceUUID], @"token":[FrankTools getUserToken], @"after_id":self.after_id ? self.after_id : @"", @"express_company":self.data[self.selectedIndex], @"express_num": @(shippingNum)};
    [MainRequest RequestHTTPData:PATHShop(@"Api/After/subAfterExpress") parameters:param success:^(id response) {
        [self showHUDWithResult:YES message:@"提交成功" completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshPreviousVC)]) {
                [self.delegate refreshPreviousVC];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self dismiss];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.font = [UIFont bodyTextFont];
    cell.textLabel.textColor = [UIColor bodyTextColor];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.selectShippingBtn setTitle:self.data[indexPath.row] forState:UIControlStateNormal];
    [self.selectShippingBtn setTitleColor:indexPath.row == 0 ? [UIColor noteTextColor] : [UIColor bodyTextColor] forState:UIControlStateNormal];
    [self dismiss];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
