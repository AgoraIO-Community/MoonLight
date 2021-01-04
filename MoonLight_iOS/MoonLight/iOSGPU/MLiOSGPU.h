//
//  MLiOSGPU.h
//
//  Created by LJJ on 2020/11/18.
//  Copyright © 2020 Agora. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @warning DO NOT INTEGRATE THIS IN APPSTORE VERSION, it will be @b rejected!
 */
@interface MLiOSGPU : NSObject
@property (nonatomic, readonly) NSInteger deviceUtilization;    // percent
@property (nonatomic, readonly) NSInteger rendererUtilization;  // percent
@property (nonatomic, readonly) NSInteger tilerUtilization;     // percent
@property (nonatomic, readonly) int64_t hardwareWaitTime;                   // nano second
@property (nonatomic, readonly) int64_t finishGLWaitTime;                   // nano second
@property (nonatomic, readonly) int64_t freeToAllocGPUAddressWaitTime;      // nano second
@property (nonatomic, readonly) NSInteger contextGLCount;
@property (nonatomic, readonly) NSInteger renderCount;
@property (nonatomic, readonly) NSInteger recoveryCount;
@property (nonatomic, readonly) NSInteger textureCount;

@property (nonatomic, class, readonly) float gpuUsage;

+ (void)fetchCurrentUtilization:(NS_NOESCAPE void(^)(MLiOSGPU *current))block;

@end

NS_ASSUME_NONNULL_END
