//
//  ViewController.m
//  WeakTimeTarget
//
//  Created by NULL on 2018/4/11.
//  Copyright © 2018年 NULL. All rights reserved.
//

#import "ViewController.h"
#import "NormalViewController.h"
#import "WeakViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)normalClick:(id)sender {
    NormalViewController *normalVC = [[NormalViewController alloc] init];
    [self.navigationController pushViewController:normalVC animated:YES];
}

- (IBAction)weakClick:(id)sender {
    WeakViewController *weakVC = [[WeakViewController alloc] init];
    [self.navigationController pushViewController:weakVC animated:YES];
}




@end
