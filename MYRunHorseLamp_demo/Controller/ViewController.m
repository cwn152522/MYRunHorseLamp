//
//  ViewController.m
//  MYRunHorseLamp_demo
//
//  Created by 伟南 陈 on 2017/3/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "ViewController.h"
#import "RunHorseLampView.h"

@interface ViewController ()

@property (strong, nonatomic) RunHorseLampView *lampView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lampView = [[RunHorseLampView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth([UIScreen mainScreen].bounds), 20)];
    [self.view addSubview:self.lampView];
    
    [self.lampView startRuning:@"阿胶犯上作乱大家佛大四的回复打算返回 i 啊互粉苏打粉和 i 吴虹飞哇             "];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
