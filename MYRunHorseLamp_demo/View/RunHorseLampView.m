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

@property (strong, nonatomic) UILabel *firstLabel;
@property (strong, nonatomic) UILabel *secondLabel;

@property (strong, nonatomic) NSLayoutConstraint *firstLabelLeft;//默认为self.width，移动结束时为-self.width
@property (strong, nonatomic) NSLayoutConstraint *firstLabelWidth;

@property (assign, nonatomic) CGFloat duration;//移动整个文本所需的时间

@property (assign, nonatomic) BOOL appIsActive;

@end

@implementation RunHorseLampView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.masksToBounds = YES;
        self.duration_perwidth = 5.0f;
        self.appIsActive = YES;
        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
        
        __weak typeof(self) weakSelf = self;
        [self.firstLabel cwn_makeConstraints:^(UIView *maker) {
            weakSelf.firstLabelLeft = [maker.leftToSuper(self.frame.size.width) lastConstraint];
            weakSelf.firstLabelWidth =  [maker.topToSuper(0).bottomToSuper(0).width(self.frame.size.width) lastConstraint];
        }];
        
        [self.secondLabel cwn_makeConstraints:^(UIView *maker) {
            maker.leftTo(weakSelf.firstLabel, 1, 0).centerYto(weakSelf.firstLabel, 0).widthTo(weakSelf.firstLabel, 1, 0).heightTo(weakSelf.firstLabel, 1, 0);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)addAnimation{
    [self layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.firstLabelLeft.constant =  -weakSelf.firstLabelWidth.constant;
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished == NO){
            if(weakSelf.appIsActive == YES){//不正常被中断，需要重启
                if([weakSelf.firstLabel.text length] > 0)
                    [weakSelf startRuning:weakSelf.firstLabel.text];
            }
        }else{
            weakSelf.duration = weakSelf.firstLabelWidth.constant * 1.0 / weakSelf.frame.size.width * weakSelf.duration_perwidth;
            weakSelf.firstLabelLeft.constant = 0;
            [weakSelf addAnimation];
        }
    }];
}

- (void)startRuning:(NSString *)text{
    if([text length] == 0){
        [self stopRuning];
        return;
    }
    
    [self layoutIfNeeded];
    self.firstLabelLeft.constant = self.frame.size.width;
    
    
    [self performSelector:@selector(delayRuning:) withObject:text afterDelay:0.33];
}

- (void)delayRuning:(NSString *)text{//延时，等上一个结束
    self.firstLabel.text = text;
    self.secondLabel.text = text;
    
    CGSize size = [self.firstLabel sizeThatFits:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    self.firstLabelWidth.constant = size.width >= self.frame.size.width ? size.width : self.frame.size.width;
    
    self.duration = self.firstLabelWidth.constant * 2.0 / self.frame.size.width * self.duration_perwidth;
    
    [self addAnimation];
}

- (void)stopRuning{
    self.firstLabel.text = @"";
    self.secondLabel.text = @"";
}

#pragma mark - 监听事件处理

- (void)applicationWillResignActive{
    _appIsActive = NO;
}

- (void)applicationDidBecomeActive{
    _appIsActive = YES;
    if([[self.firstLabel text] length] > 0){
        [self startRuning:self.firstLabel.text];
    }
}

#pragma mark - 控件get方法

- (UILabel *)firstLabel{
    if(!_firstLabel){
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.font = [UIFont systemFontOfSize:14];
        _firstLabel.textColor = [UIColor lightGrayColor];
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if(!_secondLabel){
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = [UIFont systemFontOfSize:14];
        _secondLabel.textColor = [UIColor lightGrayColor];
    }
    return _secondLabel;
}

@end
