//
//  MoonLight.h
//  GPU4MacDemo
//
//  Created by LJJ on 2020/11/11.
//  Copyright © 2020 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLAppMemory.h"
#import "MLAppCPU.h"
#import "MLSystemCPU.h"

#if TARGET_OS_IOS
#import "MLiOSGPU.h"
#elif TARGET_OS_MAC
#import "MLMacGPU.h"
#endif

NS_ASSUME_NONNULL_BEGIN
@protocol MoonLightDelegate <NSObject>
- (void)captureOutputAppCPU:(float)appCPU systemCPU:(float)systemCPU appMemory:(float)appMemory gpuUsage:(float)gpuUsage gpuInfo:(NSString *)gpuInfo;

@end

@interface MoonLight : NSObject
@property (nonatomic, assign) float appCPU;
@property (nonatomic, assign) float systemCPU;
@property (nonatomic, assign) float appMemory;
@property (nonatomic, assign) float gpuUsage;
@property (nonatomic, copy) NSString *gpuInfo;
@property (nonatomic, assign) double timeInterval;
@property (nullable, nonatomic, weak) id<MoonLightDelegate> delegate;

- (instancetype)initWithDelegate:(id<MoonLightDelegate>)delegate timeInterval:(double) timeInterval;
- (void)startTimer;
- (void)stopTimer;
@end

NS_ASSUME_NONNULL_END
