//
//  SelectAdverViewController.m
//  legend
//
//  Created by heyk on 16/1/26.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "SelectAdverViewController.h"
#import "SelectAdvCell.h"
#import "AdverNetRequest.h"
#import "UitlCommon.h"

@interface SelectAdverViewController ()<AdverBaseViewControllerDelegate>

@end
@implementation SelectAdverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.delegate = self;
    
    [self setActionButtonTitle:@"提交答案" imageName:nil];
    [self.actionButton addTarget:self action:@selector(clickAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        } else {
            [self showHUDWithMessage:@"验证中..."];
            __weak SelectAdverViewController *weakSelf = self;
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
    SelectAdvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectAdvCell"];
    if (!cell) {
        cell = [[SelectAdvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectAdvCell"];
    }
    
    [cell setContent:self.model.question selects:self.model.question_option];
    
  
    return cell;
}

- (CGFloat)customTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static SelectAdvCell *cell1 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell1 = [[SelectAdvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectAdvCell"];
    });
    
    [cell1 setContent:self.model.question selects:self.model.question_option];
    
    CGFloat height = [cell1.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (NSInteger)customTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.model.is_read boolValue] || [self.model.finish_percent intValue] == 100) {
        return 0;
    }
    
    if(self.model.question_option && self.model.question_option.count>0) return 1;
    else return 0;
}
@end
