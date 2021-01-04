//
//  MoonLight.m
//  GPU4MacDemo
//
//  Created by LJJ on 2020/11/11.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MoonLight.h"

@interface MoonLight ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation MoonLight

- (instancetype)init {
    self = [super init];
    if (self) {
        #if TARGET_OS_IOS
        _gpuUsage = [MLiOSGPU gpuUsage];
        _gpuInfo = [NSString stringWithFormat:@"%f", _gpuUsage];
        #else
        MLMacGPU *macGpu = [[MLMacGPU alloc]init];
        _gpuInfo = macGpu.gpuInfo;
        _gpuUsage = macGpu.gpuUsage;
        #endif
        _appCPU = [MLAppCPU getCpuUsage];
        _appMemory = [MLAppMemory getAppMemory];
        _systemCPU = [MLSystemCPU getSystemCpuUsage];
    }
    return self;
}

static MoonLight *moonLight = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moonLight = [[MoonLight alloc]init];
    });
    return moonLight;
}

- (instancetype)initWithDelegate:(id<MoonLightDelegate>)delegate timeInterval:(double) timeInterval {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moonLight = [[MoonLight alloc]init];
    });
    moonLight.delegate = delegate;
    moonLight.timeInterval = timeInterval;
    return moonLight;
}

- (void)startTimer {
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        _queue = dispatch_queue_create("MoonLightQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, _timeInterval * NSEC_PER_SEC, 0);
        __weak typeof(self) _self = self;
        dispatch_source_set_event_handler(_timer, ^{
            self.appCPU = [MLAppCPU getCpuUsage];
            self.appMemory = [MLAppMemory getAppMemory];
            self.systemCPU = [MLSystemCPU getSystemCpuUsage];
        #if TARGET_OS_IOS
            self.gpuUsage = [MLiOSGPU gpuUsage];
            self.gpuInfo = [NSString stringWithFormat:@"%f", self.gpuUsage];
        #else
            MLMacGPU *macGpu = [[MLMacGPU alloc]init];
            self.gpuUsage = macGpu.gpuUsage;
            self.gpuInfo = macGpu.gpuInfo;
        #endif
            if (_self.delegate && [_self.delegate respondsToSelector:@selector(captureOutputAppCPU:systemCPU:appMemory:gpuUsage:gpuInfo:)]) {
                [_self.delegate captureOutputAppCPU:_self.appCPU systemCPU:_self.systemCPU appMemory:_self.appMemory gpuUsage:_self.gpuUsage gpuInfo:_self.gpuInfo];
            }
           });
        dispatch_resume(_timer);
    }
}

-(void)stopTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        _queue = nil;
    }
}
@end
