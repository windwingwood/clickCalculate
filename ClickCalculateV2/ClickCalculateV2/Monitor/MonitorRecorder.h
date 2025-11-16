//
//  MonitorRecorder.h
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#import <Foundation/Foundation.h>
#import "MonitorView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MonitorType) {
    MonitorType_Upload,
    MonitorType_Download,
    MonitorType_CPU,
    MonitorType_Memory,
    MonitorType_Temperature,
    MonitorType_Fan
};

@interface MonitorRecorder : NSObject

@property (nonatomic, strong) MonitorView *view;

@property (nonatomic, strong) void(^configUpdateBlock)(CGFloat width);

+ (instancetype)recorder;

@end

NS_ASSUME_NONNULL_END
