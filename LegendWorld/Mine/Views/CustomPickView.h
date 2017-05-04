//
//  CustomPickView.h
//  legend
//
//  Created by heyk on 16/1/11.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CustomPickValueChange)(NSString *str,NSInteger component);
typedef void (^CustomPickSelect)(id content);
typedef void (^CustomPickDisSelect)(id content);

@interface CustomPickView : UIView

+(CustomPickView*)getInstance;

-(void)showPick:(NSString*)currentValue data:(NSArray*)data valueChange:(CustomPickValueChange)changeBlock select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect;

-(void)showDatePick:(NSString*)currentValue select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect;

-(void)showProvicePick:(NSString*)currentValue valueChange:(CustomPickValueChange)changeBlock select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect;

//带有全部
-(void)showLocationPick:(NSString*)currentValue valueChange:(CustomPickValueChange)changeBlock select:(CustomPickSelect)selectBlock disSelect:(CustomPickDisSelect)disSelect;


@end
