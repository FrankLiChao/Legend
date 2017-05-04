//
//  StackLayout.m
//  LegendWorld
//
//  Created by Tsz on 2016/10/31.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import "StackLayout.h"

@implementation StackLayout


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attr = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for(NSInteger i = 0; i < attr.count; i++) {
        UICollectionViewLayoutAttributes *current = attr[i];
        if (i == 0) {
            CGRect frame = current.frame;
            frame.origin.x = 0;
            current.frame = frame;
        } else {
            UICollectionViewLayoutAttributes *previous = attr[i - 1];
            if (current.frame.origin.y == previous.frame.origin.y) {
                CGRect frame = current.frame;
                frame.origin.x = previous.frame.origin.x + previous.frame.size.width + self.minimumLineSpacing;
                current.frame = frame;
            } else {
                CGRect frame = current.frame;
                frame.origin.x = 0;
                current.frame = frame;
            }
        }
    }
    return attr;
}

@end
