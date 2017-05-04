//
//  UIImage+Resizeable.h
//  LegendWorld
//
//  Created by Tsz on 2016/11/1.
//  Copyright © 2016年 ios-dev-01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizeable)

+ (UIImage *)imageNamed:(NSString *)imagedName cornerRadius:(CGFloat)cornerRidus;
+ (UIImage *)resizableImageNamed:(NSString *)imageName;

- (UIImage *)resizableImageWithCornerRadius:(CGFloat)cornerRidus;
- (UIImage *)resizableImage;

@end

@interface UIImage (Redrawing)

- (UIImage *)redrawingWithTintColor:(UIColor *)tintColor;

@end


@interface UIImage (ButtonBackgroundImage)

+ (UIImage *)backgroundImageWithColor:(UIColor *)color;
+ (UIImage *)backgroundImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRidus;

+ (UIImage *)backgroundStrokeImageWithColor:(UIColor *)color;
+ (UIImage *)backgroundStrokeImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRidus;

@end
