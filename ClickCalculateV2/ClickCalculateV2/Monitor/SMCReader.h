//
//  SMCReader.h
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMCReader : NSObject

@property (nonatomic, assign) NSInteger fanSpeed;

@property (nonatomic, assign) CGFloat temperature;

- (void)updateRecord;

@end

NS_ASSUME_NONNULL_END
