//
//  RunHorseLampView.h
//  MYRunHorseLamp_demo
//
//  Created by 伟南 陈 on 2017/3/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//A

#import <UIKit/UIKit.h>

@interface RunHorseLampView : UIControl

/**
 移动一个单位宽度文字所需的时间，默认为5秒
 */
@property (assign, nonatomic) CGFloat duration_perwidth;

/**
 跑马灯点击回调
 */
@property (copy, nonatomic) void(^RunHourseLampViewClickBlock)();


/*
 开始动画
 @param 跑马灯文本，支持纯文本和富文本
 */
- (void)startRuning:(id)text;

/**
 * 结束动画
 *
 */
- (void)stopRuning;

@end
