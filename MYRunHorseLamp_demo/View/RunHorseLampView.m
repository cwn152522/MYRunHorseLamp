//
//  RunHorseLampView.m
//  MYRunHorseLamp_demo
//
//  Created by 伟南 陈 on 2017/3/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "RunHorseLampView.h"
#import "UIView+CWNView.h"

#define  ShiPei(x) [UIScreen mainScreen].bounds.size.width / 320.0 * x

//-----------------------------------RunHorseLampViewOptions-----------------------------------

@interface RunHorseLampViewOptions ()

@property (assign, nonatomic) BOOL runLabelIsRun;//记录runLabel的动画状态
@property (assign, nonatomic) BOOL runLabelV2IsRun;//记录runLabelV2的动画状态

@property (assign, nonatomic) CGFloat timeInset;//两个文本间隔时间，即后面的文本在前面文本跑完前几秒接上去跑，决定文本距离
@property (assign, nonatomic) CGFloat duration;//整个text滚动需要的时间

@property (assign, nonatomic) BOOL shouldStop;//记录用户停止操作(YES)，默认为NO，仅当runLabelIsRun和runLabelV2IsRun均为NO时复位

@end

@implementation RunHorseLampViewOptions

+ (instancetype)optionsWithDuration:(CGFloat)duration textColor:(UIColor *)textColor textFont:(UIFont *)font backgroundColor:(UIColor *)backgroundColor{
    RunHorseLampViewOptions *options = [[RunHorseLampViewOptions alloc] init];

    options.duration_per_width = duration <= 0 ? ShiPei(3) : ShiPei(duration);
    options.textColor = textColor == nil ? [UIColor whiteColor] : textColor;
    options.font = font == nil ? [UIFont systemFontOfSize:15] : font;
    options.backgroundColor = backgroundColor == nil ? [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] : backgroundColor;

    options.timeInset = options.duration_per_width * (5.0 / 6);//跑马灯label宽度为文本宽加一个屏幕的宽度
    return options;
}

@end


//-----------------------------------RunHorseLampView-----------------------------------

@interface RunHorseLampView ()

@property (strong, nonatomic) UILabel *runLabel;
@property (strong, nonatomic) NSLayoutConstraint *runLabelWidth;
@property (strong, nonatomic) NSLayoutConstraint *runLabelLeft;

@property (strong, nonatomic) UILabel *runLabelV2;
@property (strong, nonatomic) NSLayoutConstraint *runLabelV2Width;
@property (strong, nonatomic) NSLayoutConstraint *runLabelV2Left;

@property (strong, nonatomic) RunHorseLampViewOptions *options;//偏好设置

@end

@implementation RunHorseLampView

- (instancetype)initWithFrame:(CGRect)frame text:(id)text options:(RunHorseLampViewOptions *)options{
    if(self = [super initWithFrame:frame]){
        self.layer.masksToBounds = YES;
        self.options = options;
        self.backgroundColor = options.backgroundColor;
    
    
        [self addSubview:self.runLabel];
        [self addSubview:self.runLabelV2];
    
        _runLabelLeft = [_runLabel setLayoutLeft:self multiplier:1 constant:0];
        [_runLabel setLayoutTopFromSuperViewWithConstant:0];
        [_runLabel setLayoutBottomFromSuperViewWithConstant:0];
        _runLabelWidth = [_runLabel setLayoutWidth:0];
        
        _runLabelV2Left = [_runLabelV2 setLayoutLeft:self multiplier:1 constant:0];
        [_runLabelV2 setLayoutTopFromSuperViewWithConstant:0];
        [_runLabelV2 setLayoutBottomFromSuperViewWithConstant:0];
        _runLabelV2Width = [_runLabelV2 setLayoutWidth:0];
        
        
        _text = text;
        [self configWithText:text];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)configWithText:(id)text{
    __block NSString *str = @"";
    if([text isKindOfClass:[NSString class]]){
        if([text length] == 0)
            return;
        str = text;
    }else if([text isKindOfClass:[NSArray class]]){
        if([text count] == 0)
            return;
        [text enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            str = [str stringByAppendingFormat:@"%@                ", obj];
        }];
    }
    _text = text;
    
    [_runLabel setText:str];
    [_runLabelV2 setText:str];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _runLabelWidth.constant = rect.size.width + CGRectGetWidth(self.bounds);
    _runLabelV2Width.constant =  _runLabelWidth.constant;
    [self layoutIfNeeded];
    
    _options.duration = (_options.duration_per_width * _runLabelWidth.constant / CGRectGetWidth(self.bounds));
}

#pragma mark public methods

- (void)startRuning{
    if(_options.runLabelIsRun || _options.runLabelV2IsRun)//跑马灯还在跑
        return;

    if(([self.text isKindOfClass:[NSArray class]] && [self.text count] > 0) ||( [self.text isKindOfClass:[NSString class]] && [self.text length] > 0)){
        [self configWithText:_text];
    }else{//文本非法
        [self stopRuning];
        return;
    }
    
    [self runLabelStartRun:0];
    [self runLabelV2StartRun:_options.duration - _options.timeInset];
}

- (void)stopRuning{
    switch (_stopType) {
        case RunHorseLampStopNormally:{//只记录状态，在跑马灯一个循环结束后停止
            if(_options.shouldStop == NO){
                _options.shouldStop = YES;
            }
        }
            break;
        case RunHorseLampStopImediately:{//立即停止
            [self applicationWillResignActive];
        }
            break;
        default:
            break;
    }
}

#pragma mark private methods

- (void)runLabelStartRun:(CGFloat)delay{
    _runLabelLeft.constant = -_runLabelWidth.constant;
    
    _options.runLabelIsRun = YES;
    [self responseBlock:YES];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_options.duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished == NO)//应用挂起或强制移除动画后finished＝NO
            return ;
        
        weakSelf.runLabelLeft.constant = 0;
        [weakSelf layoutIfNeeded];
        
        //递归调用临界条件
        if(weakSelf.options.shouldStop == YES){//(1)当动画停止类型为RunHorseLampStopNormally时用户请求停止动画
            weakSelf.options.runLabelIsRun = NO;
            if(weakSelf.options.runLabelV2IsRun == NO){//(1)条件下，两个label动画均结束，通知外界“可以更换文本，重新start了”
                weakSelf.options.shouldStop = NO;
                [weakSelf responseBlock:NO];
            }
            return ;
        }
        
        [weakSelf runLabelStartRun:weakSelf.options.duration - weakSelf.options.timeInset * 2];//递归调用。参数：确保能在前面文本跑完前kTimeInset秒出发
    }];
}

- (void)runLabelV2StartRun:(CGFloat)delay{
    _runLabelV2Left.constant = -_runLabelV2Width.constant;
    
    _options.runLabelV2IsRun = YES;
    [self responseBlock:YES];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.options.duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished == NO) //应用挂起或强制移除动画后finished＝NO
            return ;
        
        weakSelf.runLabelV2Left.constant = 0;
        [weakSelf layoutIfNeeded];
        
        //递归调用临界条件
        if(weakSelf.options.shouldStop == YES){// (1)当动画停止类型为RunHorseLampStopNormally时用户请求停止动画
            weakSelf.options.runLabelV2IsRun = NO;
            if(weakSelf.options.runLabelIsRun == NO){//(1)条件下，两个label动画均结束，通知外界“可以更换文本，重新start了”
                weakSelf.options.shouldStop = NO;
                [weakSelf responseBlock:NO];
            }
            return ;
        }
        
        [weakSelf runLabelV2StartRun:weakSelf.options.duration - weakSelf.options.timeInset * 2];//递归调用。参数：确保能在前面文本跑完前kTimeInset秒出发
    }];
}

- (void)responseBlock:(BOOL)isRuning{
    if(_stopType == RunHorseLampStopImediately)//动画停止类型为：立即停止，所以不需要反馈动画状态；
        return;
    
    if(_runingStateChangedBlock){
        _runingStateChangedBlock(isRuning);
    }
}

#pragma mark 通知事件处理

- (void)applicationWillResignActive{ //跑马灯复位操作、中止正在执行的动画
    _runLabelV2Left.constant = 0;
    _runLabelLeft.constant = 0;
    [self layoutIfNeeded];
    
    [_runLabel.layer removeAllAnimations];//用户强制remove动画，会走动画块的completion回调告知动画未完成
    [_runLabelV2.layer removeAllAnimations];//用户强制remove动画，会走动画块的completion回调告知动画未完成
    _options.runLabelIsRun = NO;
    _options.runLabelV2IsRun = NO;
}

- (void)applicationDidBecomeActive{//恢复动画
    [self startRuning];
}

#pragma mark 控件get方法

- (UILabel *)runLabel{
    if(_runLabel ==  nil){
        _runLabel = [[UILabel alloc] init];
        _runLabel.textColor = _options.textColor;
        [_runLabel setFont:_options.font];
        [_runLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _runLabel;
}

- (UILabel *)runLabelV2{
    if(_runLabelV2 ==  nil){
        _runLabelV2 = [[UILabel alloc] init];
        _runLabelV2.textColor = _options.textColor;
        [_runLabelV2 setFont:_options.font];
        [_runLabelV2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _runLabelV2;
}

@end
