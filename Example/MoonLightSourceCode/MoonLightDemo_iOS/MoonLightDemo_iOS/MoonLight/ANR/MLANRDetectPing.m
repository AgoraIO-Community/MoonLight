//
//  MLANRDetectPing.m
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2021/5/25.
//  Copyright © 2020 Agora. All rights reserved.

#import "MLANRDetectPing.h"
#import "BSBacktraceLogger.h"

@interface MLANRDetectPing ()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_queue_t monitoringQueue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) NSTimeInterval timeOutInerval;
@property (nonatomic, assign) BOOL isMonitoring;
@property (nonatomic, assign, readwrite) NSInteger count;
@end

@implementation MLANRDetectPing

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isMonitoring = false;
        self.timeOutInerval = 3;
        self.queue = dispatch_queue_create("AgoraANRQueue", nil);
        self.semaphore = dispatch_semaphore_create(0);
        self.count = 0;
    }
    return self;
}

static MLANRDetectPing *MLMLANRDetectPing;
+ (instancetype)initWithMonitoringQueue:(dispatch_queue_t)monitoringQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MLMLANRDetectPing = [[MLANRDetectPing alloc] init];
        MLMLANRDetectPing.monitoringQueue = monitoringQueue;
    });
    return MLMLANRDetectPing;
}

- (void)start {
    if (_isMonitoring) {
        return;
    }
    _isMonitoring = true;
    dispatch_async(_queue, ^{
        while (self.isMonitoring == true) {
            __block BOOL timeOut = true;
            dispatch_async(self.monitoringQueue, ^{
                timeOut = false;
                dispatch_semaphore_signal(self.semaphore);
            });
            [NSThread sleepForTimeInterval:self.timeOutInerval];
            
            if (timeOut == true) {
                NSString *symblols = [BSBacktraceLogger bs_backtraceOfAllThread];
                if (symblols != nil) {
                    NSLog(@"基于线程卡顿触发ANR：");
                    self.count += 1;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(anrOutputStackFromPing:anrSum:)]) {
                        [self.delegate anrOutputStackFromPing:symblols anrSum:self.count];
                    }
                }
            }
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

-(void)stop {
    if (_isMonitoring == false ) {
        return;
    }
    _isMonitoring = false;
    self.count = 0;
}


@end
