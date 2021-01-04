//
//  MLGPUMiner.h
//  MoonLightDemo
//
//  Created by LJJ on 2020/11/18.
//  Copyright © 2020 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLDataSet.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UInt32, MLPCIVendor) {
    MLPCIVendorIntel = 0x8086,
    MLPCIVendorAMD = 0x1002,
    MLPCIVendorNVidia = 0x10de,
    MLPCIVendorApple = 0x106b
};

@interface MLGPUMiner : NSObject

@property NSInteger numSamples;

@property (nonatomic) NSInteger numberOfGPUs;

@property (readonly) NSArray *totalVRAMDataSets;

@property (readonly) NSArray *freeVRAMDataSets;

@property (readonly) NSArray *cpuWaitDataSets;

@property (readonly) NSArray *utilizationDataSets;

@property (readonly) NSArray *vendorNames;

- (void)getLatestGraphicsInfo;
- (void)setDataSize:(NSInteger)newNumSamples;

@end


@interface MLGraphicsCard : NSObject


@property MLPCIVendor vendor;


@property long long totalVRAM;

@property long long usedVRAM;

@property long long freeVRAM;

@property long long cpuWait;

@property int deviceUtilization;


+ (BOOL)matchingPCIDevice:(NSDictionary *)pciDictionary accelerator:(NSDictionary *)acceleratorDictionary;

- (instancetype)initWithPCIDevice:(NSDictionary *)pciDictionary accelerator:(NSDictionary *)acceleratorDictionary;

- (NSString *)vendorString;

@end

NS_ASSUME_NONNULL_END

