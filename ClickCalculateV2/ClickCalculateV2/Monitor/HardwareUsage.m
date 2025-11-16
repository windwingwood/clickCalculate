//
//  HardwareUsage.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/14.
//

#import "HardwareUsage.h"

@interface HardwareUsage ()

@end

@implementation HardwareUsage

- (NSString *)description
{
    return [NSString stringWithFormat:@"CPU负载:%.1f%% 内存负载%.1f%% %.1fG可用", self.CPUUsage*100, self.memoryUsage*100, self.freeMemory/1024.0/1024.0/1024.0];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.physicalMemory = [NSProcessInfo processInfo].physicalMemory;
    }
    return self;
}

- (void)updateRecord {
    self.freeMemory = [self availableMemory];
    self.memoryUsage = (1-self.freeMemory/(double)self.physicalMemory);
    self.CPUUsage = [self getCPUUsage];
}

// https://github.com/Milker90/iOS-Monitor-Platform
- (CGFloat)getCPUUsage {
    static host_cpu_load_info_data_t previous_info = {0, 0, 0, 0};
    static CGFloat cpu_usage = 0;
    
    mach_msg_type_number_t count;
    host_cpu_load_info_data_t info;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    
    kern_return_t kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    natural_t user   = info.cpu_ticks[CPU_STATE_USER] - previous_info.cpu_ticks[CPU_STATE_USER];
    natural_t nice   = info.cpu_ticks[CPU_STATE_NICE] - previous_info.cpu_ticks[CPU_STATE_NICE];
    natural_t system = info.cpu_ticks[CPU_STATE_SYSTEM] - previous_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle   = info.cpu_ticks[CPU_STATE_IDLE] - previous_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t total  = user + nice + system + idle;
    previous_info    = info;
    
    if (total != 0) {
        cpu_usage = (user + nice + system) * 1.0 / total;
    }
    
    return cpu_usage;
}

- (uint64_t)availableMemory {
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return 0;
    }
    
//    long long total = vmStats.free_count + vmStats.inactive_count + vmStats.active_count + vmStats.wire_count;
//    long long free = vmStats.free_count + vmStats.inactive_count;
//    long long used = vmStats.active_count + vmStats.wire_count;
    
//    long long totalSize = total * vm_page_size;
//    long long freeSize = free * vm_page_size;
//    long long usedSize = used * vm_page_size;
//    double freex = free/(double)total;
//    double usedx = used/(double)total;
        
    return vm_page_size * (vmStats.free_count + vmStats.inactive_count);
}

@end
