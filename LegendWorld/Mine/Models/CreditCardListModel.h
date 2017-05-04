//
//  CreditCardListModel.h
//  LegendWorld
//
//  Created by wenrong on 16/9/27.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCardModel : NSObject
@property (nonatomic,retain) NSString *bank_id;
@property (nonatomic,retain) NSString *bank_name;
@property (nonatomic,retain) NSString *bank_no;
@property (nonatomic,retain) NSString *cardholder;
@property (nonatomic,retain) NSString *create_time;
@property (nonatomic,retain) NSString *credit_id;
@property (nonatomic,retain) NSString *loan_amount;
@property (nonatomic,retain) NSString *logo;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *modify_time;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *user_id;
@end

@interface CreditCardListModel : NSObject
@property (nonatomic, retain) NSArray<CreditCardModel*> *creditCardListArr;
@end
