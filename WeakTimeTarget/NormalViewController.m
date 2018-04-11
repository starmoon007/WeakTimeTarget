//
//  NormalViewController.m
//  WeakTimeTarget
//
//  Created by NULL on 2018/4/11.
//  Copyright © 2018年 NULL. All rights reserved.
//

#import "NormalViewController.h"

@interface NormalViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action) userInfo:nil repeats:YES];
    
}

- (void)action{
    NSLog(@"%s",__func__);
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}


@end
