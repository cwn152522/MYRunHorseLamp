//
//  ViewController.m
//  MYRunHorseLamp_demo
//
//  Created by 伟南 陈 on 2017/3/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "ViewController.h"
#import "RunHorseLamp_Normal.h"
#import "RunHorseLamp_Imediately.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 事件处理

- (IBAction)onClickNormalState:(UIButton *)sender {
    RunHorseLamp_Normal *vc = [[RunHorseLamp_Normal alloc] initWithNibName:@"RunHorseLamp_Normal" bundle:nil];
    vc.title = @"跑马灯 - 正常模式";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickImediatelyState:(UIButton *)sender {
    RunHorseLamp_Imediately *vc = [[RunHorseLamp_Imediately alloc] initWithNibName:@"RunHorseLamp_Imediately" bundle:nil];
    vc.title = @"跑马灯 - 立即模式";
    [self.navigationController pushViewController:vc animated:YES];;
}
@end
