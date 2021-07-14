//
//  MoonLight.m
//
//  Created by LJJ on 2020/11/11.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MoonLight.h"

#if TARGET_OS_IOS
#import "BSBacktraceLogger.h"
#endif

@interface MoonLight ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign, readwrite) float appCPU;
@property (nonatomic, assign, readwrite) float systemCPU;
@property (nonatomic, assign, readwrite) float appMemory;
@property (nonatomic, assign, readwrite) float gpuUsage;
@property (nonatomic, copy, readwrite) NSString *gpuInfo;
@property (nonatomic, assign, readwrite) NSInteger cpuAnrCount;
@property (nonatomic, assign, readwrite) NSInteger gpuAnrCount;
@property (nonatomic, assign, readwrite) double fps;
@property (nonatomic, strong) MLFPS *mlFps;
@property (nonatomic, assign) float lastAppCPU;
@property (nonatomic, assign) float lastGpuUsage;
@end

@implementation MoonLight

- (instancetype)init {
    self = [super init];
    if (self) {
        #if TARGET_OS_IOS
        _gpuUsage = [MLiOSGPU gpuUsage];
        _gpuInfo = [NSString stringWithFormat:@"GPUInfo: %f", _gpuUsage];
        _mlFps = [MLFPS sharedFPSIndicator];
        
        #else
        MLMacGPU *macGpu = [[MLMacGPU alloc]init];
        _gpuInfo = macGpu.gpuInfo;
        _gpuUsage = macGpu.gpuUsage;
        #endif
        _appCPU = [MLAppCPU getCpuUsage];
        _appMemory = [MLAppMemory getAppMemory];
        _systemCPU = [MLSystemCPU getSystemCpuUsage];
        _lastAppCPU = 0;
        _lastGpuUsage = 0;
        _cpuAnrCount = 0;
        _gpuAnrCount = 0;
        _isANR = true;
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
    if (timeInterval <= 0) {
        moonLight.timeInterval = 1;
    } else {
        moonLight.timeInterval = timeInterval;
    }
    return moonLight;
}

- (void)startTimer {
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        _queue = dispatch_queue_create("MoonLightQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, _timeInterval * NSEC_PER_SEC, 0);
        __weak typeof(self) _self = self;
        [_mlFps startMonitoring];
        _mlFps.FPSBlock = ^(float fps) {
            _self.fps = fps;
        };
        dispatch_source_set_event_handler(_timer, ^{
            self.appCPU = [MLAppCPU getCpuUsage];
            self.appMemory = [MLAppMemory getAppMemory];
            self.systemCPU = [MLSystemCPU getSystemCpuUsage];
        #if TARGET_OS_IOS
            self.gpuUsage = [MLiOSGPU gpuUsage];
            self.gpuInfo = [NSString stringWithFormat:@"GPUUsage: %f", self.gpuUsage];
        #else
            MLMacGPU *macGpu = [[MLMacGPU alloc]init];
            self.gpuUsage = macGpu.gpuUsage;
            self.gpuInfo = macGpu.gpuInfo;
        #endif
            if (self.isANR) {
                if (self.lastAppCPU >= 80.0 && self.appCPU >= 80.0 ) {
                    NSString *symbols = [BSBacktraceLogger bs_backtraceOfAllThread];
                    if (symbols != nil) {
                        NSLog(@"连续两次CPU超80，记录卡顿：");
                        self.cpuAnrCount += 1;
                        if (_self.delegate && [_self.delegate respondsToSelector:@selector(captureOutputCpuAnr:cpuAnrSum:)]) {
                            [_self.delegate captureOutputCpuAnr:symbols cpuAnrSum:_self.cpuAnrCount];
                        }
                    }
                }
                if (self.lastGpuUsage >= 70.0 && self.gpuUsage >= 70.0) {
                    NSString *symbols = [BSBacktraceLogger bs_backtraceOfAllThread];
                    if (symbols != nil) {
                        NSLog(@"连续两次GPU超70，记录卡顿：");
                        self.gpuAnrCount += 1;
                        if (_self.delegate && [_self.delegate respondsToSelector:@selector(captureOutputGpuAnr:gpuAnrSum:)]) {
                            [_self.delegate captureOutputGpuAnr:symbols gpuAnrSum:_self.gpuAnrCount];
                        }
                    }
                }
            }
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
        [_mlFps pauseMonitoring];
        _lastAppCPU = 0;
        _lastGpuUsage = 0;
    }
}
@end
