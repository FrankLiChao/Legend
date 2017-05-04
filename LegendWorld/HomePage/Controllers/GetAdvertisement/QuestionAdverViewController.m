//
//  QuestionAdverViewController.m
//  legend
//
//  Created by heyk on 16/1/25.
//  Copyright © 2016年 e3mo. All rights reserved.
//
#import "QuestionAdverViewController.h"
#import "QuestionAnswerCell.h"
#import "UitlCommon.h"
#import "AdverNetRequest.h"

@interface QuestionAdverViewController ()<AdverBaseViewControllerDelegate>

@end
@implementation QuestionAdverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setActionButtonTitle:@"提交答案" imageName:nil];
    [self.actionButton addTarget:self action:@selector(clickAnswer:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(void)clickAnswer:(UIButton*)button{
    [self.view endEditing:YES];
    if ([self.model.is_read boolValue] || [self.model.finish_percent intValue] == 100) {
        if ([self.model.is_seller boolValue] && self.model.goods_id) {
            [self checkGoodsDetail];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.shop_url]];
        }
    }
    else{
        if ([UitlCommon isNull:self.anwser]) {
            [self showHUDWithResult:NO message:@"请填写您的答案"];
        }
        else{
            __weak QuestionAdverViewController *weakSelf = self;
            [self showHUDWithMessage:@"验证中..."];
            [AdverNetRequest advFinish:self.model answer:self.anwser success:^(BOOL bSuccess, NSString *message) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ANSWER_ADV_SUCCESS_NOTIFY object:weakSelf.model];
                [weakSelf showHUDWithResult:YES message:message];
                weakSelf.model.is_read = [NSNumber numberWithBool:YES];
                [weakSelf reloadUI];

            } failed:^(NSDictionary *errorDic) {
                [weakSelf showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"]];
            }];
        }
    }
}
#pragma mark AdverBaseViewControllerDelegate
- (AdvBaseCell *)customTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionAnswerCell"];
    if (!cell) {
        cell = [[QuestionAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionAnswerCell"];
    }
    [cell setContent:self.model.question];
    return cell;
}
- (CGFloat)customTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static QuestionAnswerCell *cell1 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell1 = [[QuestionAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionAnswerCell"];
    });
    [cell1 setContent:self.model.question];
    CGFloat height = [cell1.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}
- (NSInteger)customTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.model.is_read boolValue] || [self.model.finish_percent intValue] == 100) {
        return 0;
    }
    return 1;
}
@end
