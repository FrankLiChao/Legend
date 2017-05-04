//
//  AdvBaseCell.m
//  legend
//
//  Created by heyk on 16/1/26.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import "AdvBaseCell.h"

@implementation AdvBaseCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(NSString*)getMyAnswer{
    
    return nil;
}

-(void)selectValue:(NSString*)value{

}
@end
