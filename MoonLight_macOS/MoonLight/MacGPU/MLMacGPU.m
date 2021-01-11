//
//  MLMacGPU.m
//
//  Created by LJJ on 2020/11/11.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MLMacGPU.h"
#import "MLGPUMiner.h"
#import "MLDataSet.h"
#import "MLCommon.h"

@implementation MLMacGPU

- (instancetype)init {
    self = [super init];
    if (self) {
        _gpuInfo = @"can not get gpuInfo!";
        _gpuUsage = 0;
        [self startGPUCapture];
    }
    return self;
}

- (void)startGPUCapture {
    MLGPUMiner *graphicsMiner = [[MLGPUMiner alloc]init];
    NSArray *utilizationValues = [graphicsMiner utilizationDataSets];
    NSArray *cpuWaitValues = [graphicsMiner cpuWaitDataSets];
    NSArray *totalValues = [graphicsMiner totalVRAMDataSets];
    NSArray *freeValues = [graphicsMiner freeVRAMDataSets];
    if ((totalValues.count != freeValues.count) || (totalValues.count != cpuWaitValues.count) || (totalValues.count != utilizationValues.count) || (totalValues.count == 0)) {
        NSLog(@"GPU: n/a");
        return;
    }
    for (NSInteger i = 0; i < totalValues.count; i++) {
        // VRAM Usage
        MLDataSet *usedDataSet = [[MLDataSet alloc] initWithContentsOfOtherDataSet:totalValues[i]];
        [usedDataSet subtractOtherDataSetValues:freeValues[i]];
        
        // Device Utilization or CPU Wait
        BOOL drawUtilization = ([utilizationValues[i] max] > 0);
        
        // Draw the text
        
        CGFloat t = [(MLDataSet *)totalValues[i] currentValue];
        CGFloat f = [(MLDataSet *)freeValues[i] currentValue];
        NSString *usageText = nil;
        if (drawUtilization) {
            self.gpuUsage = [(MLDataSet *)utilizationValues[i] currentValue];
        }
        NSString *leftText = nil;
        NSString *rightText = nil;
        
        NSString *gpuTitle = totalValues.count < 2 ? @"GPU" : [NSString stringWithFormat:@"GPU %d", (int)i + 1];
        NSString *vendorString = graphicsMiner.vendorNames[i];
        leftText = [NSString stringWithFormat:@"%@ %@", gpuTitle, vendorString];
        
        if (t > 0) {
            rightText = [NSString stringWithFormat:@"%@ / %@ %@", [MLCommon formattedStringForBytes:t - f], [MLCommon formattedStringForBytes:t], usageText];
            _gpuInfo = [NSString stringWithFormat:@"%@ \n %@",leftText,rightText];
        }
    }
}
@end

