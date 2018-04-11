//
//  WeakTimer.m
//  WeakTimeTarget
//
//  Created by NULL on 2018/4/11.
//  Copyright © 2018年 NULL. All rights reserved.
//

#import "WeakTimer.h"
#import "WeakTimerTarget.h"


//static NSMutableArray *weakTimerTargets;

@implementation WeakTimer

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    
    WeakTimerTarget *target = [[WeakTimerTarget alloc] init];
    target.aTarget = aTarget;
    target.aSelector = aSelector;
    WeakTimer *timer = [[WeakTimer superclass] scheduledTimerWithTimeInterval:ti target:target selector:aSelector userInfo:userInfo repeats:yesOrNo];
    target.timer = timer;
    return timer;
    
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
