//
//  UIView+CWNView.h
//  NSLayout封装
//
//  Created by 陈伟南 on 15/12/29.
//  Copyright © 2015年 陈伟南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CWNView)

- (NSLayoutConstraint *)setLayoutWidth:(CGFloat)width;

- (NSLayoutConstraint *)setLayoutHeight:(CGFloat)height;

- (NSLayoutConstraint *)setLayoutLeft:(UIView *)targetView multiplier:(CGFloat)multiplier constant:(CGFloat)c;

- (void)setLayoutRight:(UIView *)targetView multiplier:(CGFloat)multiplier constant:(CGFloat)c;

- (void)setLayoutTop:(UIView *)targetView multiplier:(CGFloat)multiplier constant:(CGFloat)c;

- (void)setLayoutBottom:(UIView *)targetView multiplier:(CGFloat)multiplier constant:(CGFloat)c;

- (void)setLayoutWidth:(UIView *)targetView multiplier:(CGFloat)multiplier constant:(CGFloat)c;

- (void)setLayoutHeight:(UIView *)targetView  multiplier:(CGFloat)multiplier constant:(CGFloat)c;

- (void)setLayoutLeftFromSuperViewWithConstant:(CGFloat)c;

- (NSLayoutConstraint *)setLayoutRightFromSuperViewWithConstant:(CGFloat)c;

- (void)setLayoutTopFromSuperViewWithConstant:(CGFloat)c;

- (NSLayoutConstraint *)setLayoutBottomFromSuperViewWithConstant:(CGFloat)c;

- (void)setLayoutCenterX:(UIView *)targetView;

- (void)setLayoutCenterX:(UIView *)targetView constant:(CGFloat)c;

- (void)setLayoutCenterY:(UIView *)targetView;

- (void)setLayoutCenterY:(UIView *)targetView constant:(CGFloat)c;

@end
