//
//  MLFPS.h
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2021/5/20.
//  Copyright © 2021 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MLFPSBlock)(float fps);

@interface MLFPS : NSObject


@property (nonatomic, copy) MLFPSBlock FPSBlock;

+ (MLFPS *)sharedFPSIndicator;

- (void)startMonitoring;

- (void)pauseMonitoring;

- (void)removeMonitoring;
@end

NS_ASSUME_NONNULL_END
