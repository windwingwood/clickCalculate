//
//  NetworkSpeed.h
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkSpeedDelegate <NSObject>

- (void)networkSpeedDidUpdate:(NSString *)uploadSpeed with:(NSString *)downloadSpeed;

@end

@interface NetworkSpeed : NSObject

@property (nonatomic, weak) id<NetworkSpeedDelegate> delegate;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
