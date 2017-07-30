//
//  NetworkStatsModel.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/26.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkStats <NSObject>

@required
- (void)flowDidRefrush:(NSString*)download with:(NSString*)upload;

@end

@interface NetworkStatsModel : NSObject

@property (nonatomic, weak) id delegate;

/**
 获得一个模块单例

 @return 流量监控模块单例
 */
+ (instancetype)sharedInstance;

/**
 启动流量监控
 
 会通过代理回调反馈数据。
 
 这个方法在实现stop之前，只能执行一次。
 */
- (void)start;

@end
