//
//  RunHorseLamp_Imediately.m
//  MYRunHorseLamp_demo
//
//  Created by chenweinan on 17/4/3.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "RunHorseLamp_Imediately.h"
#import "RunHorseLampView.h"

@interface RunHorseLamp_Imediately ()

@property (strong, nonatomic) RunHorseLampView *lampView;

@end

@implementation RunHorseLamp_Imediately

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configRunHorseLamp];
    // Do any additional setup after loading the view from its nib.
}

- (void)configRunHorseLamp{
    self.lampView = [[RunHorseLampView alloc] initWithFrame:CGRectMake(0, 128, CGRectGetWidth([UIScreen mainScreen].bounds), 27) text:nil options:([RunHorseLampViewOptions optionsWithDuration:7.0f textColor:nil textFont:[UIFont systemFontOfSize:13] backgroundColor:nil])];
    [self.view addSubview:self.lampView];

    self.lampView.stopType = RunHorseLampStopImediately;

    self.lampView.text = @"恭喜福州陈先生成功定制专业版6880            恭喜苏州王先生成功定制专业版6880            恭喜泉州金先生成功定制专业版6880            ";
}

- (void)requestTips{
    //请求成功
    self.lampView.text = @"请求结果：恭喜福州陈先生成功定制专业版6880            恭喜苏州王先生成功定制专业版6880            恭喜泉州金先生成功定制专业版6880            ";
    [self.lampView stopRuning];
    [self.lampView startRuning];
}

#pragma mark 事件处理

- (IBAction)onClickStart:(UIButton *)sender {
    [self.lampView startRuning];
}

- (IBAction)onClickStop:(UIButton *)sender {
    [self.lampView stopRuning];
}

- (IBAction)onClickRequest:(UIButton *)sender {
    [self requestTips];
}
@end
