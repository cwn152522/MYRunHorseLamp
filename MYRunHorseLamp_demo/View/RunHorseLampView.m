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

@property (assign, nonatomic) BOOL removeAnimation;

@property (assign, nonatomic) CGFloat duration;//移动整个文本所需的时间

@end

@implementation RunHorseLampView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.masksToBounds = YES;
        self.duration_perwidth = 5.0f;
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
    }
    return self;
}

- (void)addAnimation{
    CGFloat left = self.firstLabelLeft.constant;
    [self layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.firstLabelLeft.constant =  -weakSelf.firstLabelWidth.constant;
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(weakSelf.removeAnimation == NO){
            weakSelf.duration = weakSelf.firstLabelWidth.constant * 1.0 / weakSelf.frame.size.width * weakSelf.duration_perwidth;
            weakSelf.firstLabelLeft.constant = 0;
            [weakSelf addAnimation];
        }else{
            weakSelf.firstLabelLeft.constant = left;
            weakSelf.firstLabel.text = @"";
            weakSelf.secondLabel.text = @"";
        }
    }];
}

- (void)startRuning:(NSString *)text{
    if([text length] == 0)
        [self stopRuning];
    
    [self layoutIfNeeded];
    self.firstLabelLeft.constant = self.frame.size.width;
    
    
    [self performSelector:@selector(delayRuning:) withObject:text afterDelay:0.33];
}

- (void)delayRuning:(NSString *)text{//延时，等上一个结束
    self.firstLabel.text = [text stringByAppendingString:@"            "];
    self.secondLabel.text = [text stringByAppendingString:@"            "];;
    
    CGSize size = [self.firstLabel sizeThatFits:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    self.firstLabelWidth.constant = size.width >= self.frame.size.width ? size.width : self.frame.size.width;
    
    self.duration = self.firstLabelWidth.constant * 2.0 / self.frame.size.width * self.duration_perwidth;
    
    _removeAnimation = NO;
    [self addAnimation];
}

- (void)stopRuning{
    self.removeAnimation = YES;
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
