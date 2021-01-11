//
//  MLSystemCPU.m
//
//  Created by LJJ on 2020/11/11.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MLSystemCPU.h"

#if TARGET_OS_IPHONE
#include <mach/mach.h>
#endif

@implementation MLSystemCPU

+ (float)getSystemCpuUsage
{
    kern_return_t kr;
    mach_msg_type_number_t count;
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    float system_cpu = 0.0;
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    system_cpu = (user + nice + system) * 100.0 / total;
    if (isnan(system_cpu)) {
        system_cpu = 0.0;
    }
    return system_cpu;
}

@end
