//
//  RunHorseLampView.m
//  MYRunHorseLamp_demo
//
//  Created by 伟南 陈 on 2017/3/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "RunHorseLampView.h"
#import "UIView+CWNView.h"

@interface RunHorseLampView ()

@property (strong, nonatomic) UILabel *firstLabel;//第一个文本
@property (strong, nonatomic) UILabel *secondLabel;//第二个文本

@property (strong, nonatomic) NSLayoutConstraint *firstLabelLeft;//默认为self.width，移动结束时为-self.width
@property (strong, nonatomic) NSLayoutConstraint *firstLabelWidth;//文本的宽度

@property (assign, nonatomic) CGFloat duration;//移动整个文本所需的时间

@property (assign, nonatomic) BOOL appIsActive;//当前是否属于前台
@property (assign ,nonatomic) BOOL isAttributedString;    // 是否是富文本
@property (assign, nonatomic) BOOL isRuning;//是否正在动画

@end

@implementation RunHorseLampView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - <*********************** 初始化跑马灯 ************************>

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.masksToBounds = YES;
        self.duration_perwidth = 8.0f;
        self.appIsActive = YES;
        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
        
        __weak typeof(self) weakSelf = self;
        [self.firstLabel cwn_makeConstraints:^(UIView *maker) {
            weakSelf.firstLabelLeft = [maker.leftToSuper(0) lastConstraint];
            weakSelf.firstLabelWidth =  [maker.topToSuper(0).bottomToSuper(0).width(weakSelf.frame.size.width) lastConstraint];
        }];
        
        [self.secondLabel cwn_makeConstraints:^(UIView *maker) {
            maker.leftTo(weakSelf.firstLabel, 1, 0).centerYto(weakSelf.firstLabel, 0).widthTo(weakSelf.firstLabel, 1, 0).heightTo(weakSelf.firstLabel, 1, 0);
        }];
        
        
        //双击home键会不活跃UIApplicationWillResignActiveNotification，不会调UIApplicationDidEnterBackgroundNotification
        //回到应用会变活跃UIApplicationDidBecomeActiveNotification，不会调UIApplicationWillEnterForegroundNotification
        //双击home键不会打断动画，因此排除这种情况监听，只做如下监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationDidEnterBackgroundNotification object:nil];//为什么不用UIApplicationWillResignActiveNotification?
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];//为什么不用UIApplicationDidBecomeActiveNotification?
    }
    return self;
}

#pragma mark - <*********************** 动画执行方法 ************************>

#pragma mark 纯文本开始动画
- (void)startRuning:(id)text{
    if([text length] == 0){
        [self stopRuning];
        self.isRuning = NO;
        return;
    }
    
    //动画复位
    self.isAttributedString = [text isKindOfClass:[NSAttributedString class]] ? YES : NO;
    [self layoutIfNeeded];
    self.firstLabelLeft.constant = 0;
    
    //文本发生变化，需要重新设置跑马灯，获取动画时间
    if(text != ([text isKindOfClass:[NSAttributedString class]] ? self.firstLabel.attributedText : self.firstLabel.text)){
        if([text isKindOfClass:[NSAttributedString class]]){
            self.firstLabel.attributedText = text;
            self.secondLabel.attributedText = text;
        }else{
            self.firstLabel.text = text;
            self.secondLabel.text = text;
        }
        
        CGSize size = [self.firstLabel sizeThatFits:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        self.firstLabelWidth.constant = size.width >= self.frame.size.width ? size.width : self.frame.size.width;
        
        self.duration = self.firstLabelWidth.constant * 2.0 / self.frame.size.width * self.duration_perwidth;
    }
    
    //跑马灯已经在跑了就不用调用
    if(self.isRuning == NO){
        [self performSelector:@selector(addAnimation) withObject:nil afterDelay:0.44];
        self.isRuning = YES;
    }
}


#pragma mark 添加动画

- (void)addAnimation{
    [self layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.firstLabelLeft.constant =  -weakSelf.firstLabelWidth.constant;
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(weakSelf.appIsActive == YES){//正常结束或不正常被中断。。。。如列表的滑动，页面的切换等都可能被系统强制中断动画，需要重启动画
            [weakSelf reStartRunning];
        }
    }];
}

#pragma mark 重启动画
- (void)reStartRunning{
    self.isRuning = NO;
    
    if (self.isAttributedString) {
        if([self.firstLabel.attributedText length] > 0)
            [self  startRuning:self.firstLabel.attributedText];
    }
    else{
        if([self.firstLabel.text length] > 0)
            [self startRuning:self.firstLabel.text];
    }
}

#pragma mark 停止动画
- (void)stopRuning{
    //清空文本
    if (self.isAttributedString) {
        self.firstLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        self.secondLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }
    else{
        self.firstLabel.text = @"";
        self.secondLabel.text = @"";
    }
    
    //移除所有动画
    [self.layer removeAllAnimations];
    
    self.isRuning = NO;
    self.firstLabelLeft.constant = 0;
    [self layoutIfNeeded];
}

#pragma mark - <*********************** 监听事件处理 ************************>

- (void)applicationWillResignActive{
    _appIsActive = NO;
}

- (void)applicationDidBecomeActive{
    _appIsActive = YES;
    [self reStartRunning];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.RunHourseLampViewClickBlock){
        self.RunHourseLampViewClickBlock();
    }
}

#pragma mark - <*********************** 控件get方法 ************************>

- (UILabel *)firstLabel{
    if(!_firstLabel){
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.font = [UIFont systemFontOfSize:14];
        _firstLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if(!_secondLabel){
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = [UIFont systemFontOfSize:14];
        _secondLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _secondLabel;
}

@end
