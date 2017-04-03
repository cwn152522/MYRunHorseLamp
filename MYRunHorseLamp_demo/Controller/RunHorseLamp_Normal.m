//
//  RunHorseLamp_Normal.m
//  MYRunHorseLamp_demo
//
//  Created by chenweinan on 17/4/3.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "RunHorseLamp_Normal.h"
#import "RunHorseLampView.h"

@interface RunHorseLamp_Normal ()

@property (strong, nonatomic) UIView *lampBackView;
@property (strong, nonatomic) RunHorseLampView *lampView;

@end

@implementation RunHorseLamp_Normal

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lampBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 128, CGRectGetWidth([UIScreen mainScreen].bounds), 27)];
    self.lampBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:self.lampBackView];

    [self configRunHorseLamp];
    // Do any additional setup after loading the view from its nib.
}

- (void)configRunHorseLamp{
    self.lampView = [[RunHorseLampView alloc] initWithFrame:self.lampBackView.bounds text:nil options:([RunHorseLampViewOptions optionsWithDuration:7.0f textColor:nil textFont:[UIFont systemFontOfSize:13] backgroundColor:[UIColor clearColor]])];
    [self.lampBackView addSubview:self.lampView];

    __weak typeof(self) weakSelf = self;
    self.lampView.runingStateChangedBlock = ^(BOOL isRuning){
        if(isRuning == YES){
            NSLog(@"正在跑");
        }else{
            NSLog(@"已经结束"); //重新开始
            [weakSelf.lampView startRuning];
        }
    };

    self.lampView.text = @"恭喜福州陈先生成功定制专业版6880            恭喜苏州王先生成功定制专业版6880            恭喜泉州金先生成功定制专业版6880            ";
}

- (void)requestTips{
    //请求成功，注意更换文本时调用的不是startRuning，而是stopRuning，然后在block回调里进行startRuning
    NSString *text = @"请求结果：恭喜福州陈先生成功定制专业版6880            恭喜苏州王先生成功定制专业版6880            恭喜泉州金先生成功定制专业版6880            ";
    if([self.lampView.text length] == 0){//初始化文本
        self.lampView.text = text;
        [self.lampView startRuning];
    }else{//更换文本
        self.lampView.text = text;
        [self.lampView stopRuning];
    }
}

#pragma mark 事件处理

- (IBAction)onClickStart:(UIButton *)sender {
    [self.lampView startRuning];
}

- (IBAction)onClickStop:(UIButton *)sender {
    [self.lampView stopRuning];
}

- (IBAction)onClickRequest:(UIButton *)sender {
    self.lampView.text = @"";
    [self requestTips];
}
@end
