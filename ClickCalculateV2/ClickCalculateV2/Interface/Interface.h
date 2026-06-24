//
//  Interface.h
//  ClickCalculateV2
//
//  Created by YP on 2026/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Interface : NSObject

@property (nonatomic, copy) NSString *(^provider)(NSString *path);

+ (instancetype)sharedInstace;

- (void)start:(int)port;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
