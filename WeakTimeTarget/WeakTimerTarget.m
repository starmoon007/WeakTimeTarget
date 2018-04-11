//
//  WeakTimerTarget.m
//  WeakTimeTarget
//
//  Created by NULL on 2018/4/11.
//  Copyright © 2018年 NULL. All rights reserved.
//

#import "WeakTimerTarget.h"
#import <objc/runtime.h>

@interface WeakTimerTargetdonotCrash: NSObject


@end


@implementation WeakTimerTargetdonotCrash


void travel(id self, SEL _cmd){
    NSLog(@"travel");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    // 添加空方法
    class_addMethod([self class], sel, (IMP)travel, "V@:");
    return  YES;
}


@end


static WeakTimerTarget *target = nil;


@implementation WeakTimerTarget


- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    if (aSelector == _aSelector){
        if (!_aTarget){
            if (_remove){
                _remove();
            }
            if (_timer){
                [_timer invalidate];
            }
            return [[WeakTimerTargetdonotCrash alloc] init];
        }
        return _aTarget;
    }
    return [super forwardingTargetForSelector:aSelector];
    
}




@end
