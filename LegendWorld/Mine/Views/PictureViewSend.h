//
//  PictureViewSend.h
//  LegendWorld
//
//  Created by wenrong on 16/10/12.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteImageDelegate <NSObject>

-(void)deleteImageAct:(NSInteger)num andCell:(NSInteger)cellNum;

@end



@interface PictureViewSend : UIView
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
- (IBAction)deleteAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapToChoosePicture;
@property (nonatomic, weak) id<deleteImageDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
