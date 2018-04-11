//
//  WeakTimerTarget.h
//  WeakTimeTarget
//
//  Created by NULL on 2018/4/11.
//  Copyright © 2018年 NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakTimerTarget : NSObject

@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL aSelector;

@property (nonatomic, copy) void(^remove)(void);

@property (nonatomic, weak) NSTimer *timer;


@end
