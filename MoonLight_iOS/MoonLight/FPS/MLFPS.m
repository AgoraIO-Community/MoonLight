//
//  MLFPS.m
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2021/5/20.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "MLFPS.h"

@interface MLFPS ()

@property (nonatomic, strong)  CADisplayLink *displayLink;
@property (nonatomic, assign)  NSInteger count;
@property (nonatomic, assign)  NSInteger beginTime;

@end

@implementation MLFPS

+ (MLFPS *)sharedFPSIndicator {
    static dispatch_once_t onceToken;
    static MLFPS *fps;
    dispatch_once(&onceToken, ^{
        fps = [[MLFPS alloc] init];
    });
    return fps;
}

- (instancetype)init{
    
    if (self = [super init]) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark -- Help Methods

- (void)startMonitoring{
     _displayLink.paused = NO;
}

- (void)pauseMonitoring{
    _displayLink.paused = YES;
}

- (void)removeMonitoring{
    [self pauseMonitoring];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink invalidate];
}

#pragma mark -- Event Handle

//这个方法的执行频率跟当前屏幕的刷新频率是一样的，屏幕每渲染刷新一次，就执行一次，那么1秒的时长执行刷新的次数就是当前的FPS值
- (void)displayLinkTick:(CADisplayLink *)link{
    
    if (_beginTime == 0) {
        _beginTime = link.timestamp;
        return;
    }
    _count++;

    NSTimeInterval interval = link.timestamp - _beginTime;
    if (interval < 1) {
        return;
    }

    float fps = _count / interval;
    
    if (self.FPSBlock != nil) {
        self.FPSBlock(fps);
    }

    _beginTime = link.timestamp;
    _count = 0;
}

- (void)dealloc{
    [self removeMonitoring];
}

@end
