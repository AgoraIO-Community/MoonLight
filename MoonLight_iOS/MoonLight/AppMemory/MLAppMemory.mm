//
//  MLAppMemory.m
//
//  Created by LJJ on 2020/11/11.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MLAppMemory.h"
#if TARGET_OS_IPHONE
#include <mach/mach.h>
#endif

@implementation MLAppMemory

+ (float)getAppMemory{
    NSUInteger memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (NSUInteger) vmInfo.phys_footprint;
    } else {
        return -1;
    }
    return memoryUsageInByte/1024.0/1024.0;
}

@end
