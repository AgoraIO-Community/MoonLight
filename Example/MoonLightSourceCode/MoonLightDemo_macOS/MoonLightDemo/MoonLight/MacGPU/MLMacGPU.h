//
//  MLMacGPU.h
//
//  Created by LJJ on 2020/11/11.
//  Copyright © 2020 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLMacGPU : NSObject
@property (nonatomic, assign) CGFloat gpuUsage;
@property (nonatomic, copy) NSString *gpuInfo;

@end

NS_ASSUME_NONNULL_END

