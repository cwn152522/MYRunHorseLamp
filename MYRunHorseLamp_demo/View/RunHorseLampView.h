//
//  RunHorseLampView.h
//  MYRunHorseLamp_demo
//
//  Created by 伟南 陈 on 2017/3/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>

//-----------------------------------RunHorseLampViewOptions-----------------------------------

@interface RunHorseLampViewOptions : NSObject

@property (assign, nonatomic) CGFloat duration_per_width;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 * 初始化方法
 *
 * @ param duration     可选配置项，iphone5下文本移动一个 跑马灯宽度所需的时间，默认为3s，其它设备会自动适配出合适时间
 * @ param textColor    可选配置项，跑马灯文本的颜色，默认为白色
 * @ param font     可选配置项，跑马灯文本的字体，默认为15号字体
 * @ param backgroundColor      可选配置项，跑马灯背景颜色，默认为透明度百分80的黑色
 */

+ (instancetype)optionsWithDuration:(CGFloat)duration textColor:(UIColor *)textColor textFont:(UIFont *)font backgroundColor:(UIColor *)backgroundColor;

@end


//-----------------------------------RunHorseLampView-----------------------------------

typedef void (^RuningStateChangedBlock) (BOOL isRuning);//跑马灯状态跟踪回调，仅在stopType为Normally时有效

typedef NS_ENUM(NSUInteger, RunHorseLampStopType) {
    RunHorseLampStopNormally,//正常模式，stopRuning调用后跑马灯不会立即停止，而是继续跑完
    RunHorseLampStopImediately//立即模式，stopRuning调用后跑马灯会立即停止
};

@interface RunHorseLampView : UIView

@property (strong, nonatomic) id text;
@property (assign, nonatomic) RunHorseLampStopType stopType;
@property (copy, nonatomic) RuningStateChangedBlock runingStateChangedBlock;

 /**
  * 初始化方法
  *
  * @ param frame   跑马灯的位置和大小
  * @ param text    初始化文本
  * @ param options     跑马灯相关可选配置项
  */
- (instancetype)initWithFrame:(CGRect)frame text:(id)text options:(RunHorseLampViewOptions *)options;//初始化

/**
 * 开始动画
 */
- (void)startRuning;

/**
 * 结束动画
 *
 * @ note   立即停止或者等当前文本跑完后停止，取决于stopType
 */
- (void)stopRuning;

@end
