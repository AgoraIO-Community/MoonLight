//
//  MLANRDetectPing.h
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2021/5/25.
//  Copyright © 2020 Agora. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLANRDetectPing : NSObject
// 记录基于线程卡顿触发的ANR的次数
@property (nonatomic, assign, readonly) NSInteger count;

+ (instancetype)initWithMonitoringQueue:(dispatch_queue_t)monitoringQueue;
- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
