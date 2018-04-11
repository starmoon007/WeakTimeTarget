### iOS 基于消息转发机制实现弱引用计时器

在iOS开发中,我们经常使用NSTimer.常使用下列几个方法:


```
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
...
```
其中NSTimer示例都会对aTarget进行强持有

```
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
```

上述逻辑如果不主动的指向timer的`invalidate`方法释放timer中的target, `NormalViewController`和 `timer`就构成了循环引用关系
ViewController中我们还好处理,不过有时我们需要在View或者其他对象中来开启计时器,这个时候没有完善的生命周期方法,我们可能完全找不到正确调用timer `invalidate`方法的时机.
下面使用OC的消息转发机制来实现了一个`weak`的timer,该方案肯定不是最好方案,不过只是提供一个解决循环引用关系的思路.

自定义`WeakTimer`基础于`NSTimer`

```
@interface WeakTimer : NSTimer

@end


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    // 将时机Timer的target设置成WeakTimerTarget对象
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

```

WeakTimerTarget:

```
@interface WeakTimerTarget : NSObject

@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, weak) NSTimer *timer;

@end
@implementation WeakTimerTarget


- (id)forwardingTargetForSelector:(SEL)aSelector{
    
    if (aSelector == _aSelector){
        if (!_aTarget){
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

```

1. WeakTimerTarget对象中会有弱属性`aTarget` 方法`aSelector` 并弱引用`timer`
2. timer实际会使用WeakTimerTarget对象调用aSelector方法
3. WeakTimerTarget对象未实现aSelector方法
4. WeakTimerTarget执行消息转发流程

在消息转发第二部中我们将方法调用转给实际的target - `aTarget`, 最后结果其实变成了

```
    [aTarget aSelector]
``` 
aTarget对象强引用timer
timer强引用WeakTimerTarget对象
WeakTimerTarget对象弱引用aTarget
打破了循环引用关系
当aTarget被释放的时候,WeakTimerTarget对象中的`aTarget == nil`
这个时候执行

```
    [_timer invalidate];
```
停止timer
这个时候我们在`- (id)forwardingTargetForSelector:(SEL)aSelector`方法中返回了一个`WeakTimerTargetdonotCrash`对象
该对象的作用是: 将该步的消息转发流程走完, 并避免此次方法调用导致crash

```
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

```

该对象其实只做一个简单的事: 在消息转发流程第一步中, 补救WeakTimerTargetdonotCrash对象的未实现方法调用导致的crash


[demo](https://github.com/starmoon007/WeakTimeTarget)

后续为完善demo,使用runtime直接修改NSTimer,将NSTimer改成弱引用类型的计时器.











