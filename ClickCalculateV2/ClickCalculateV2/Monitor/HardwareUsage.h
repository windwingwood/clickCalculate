//
//  HardwareUsage.h
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HardwareUsage : NSObject

@property (nonatomic, assign) uint64_t physicalMemory;

@property (nonatomic, assign) uint64_t freeMemory;

@property (nonatomic, assign) CGFloat CPUUsage;

@property (nonatomic, assign) CGFloat memoryUsage;

- (void)updateRecord;

@end

NS_ASSUME_NONNULL_END
