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

+ (instancetype)sharedInstance;

- (void)start;

@end
