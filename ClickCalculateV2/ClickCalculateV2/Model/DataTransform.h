//
//  DataTransform.h
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTransform : NSObject

+ (NSString *)hexToDecimal:(NSString *)dec;

+ (NSString *)decimalToHex:(NSString *)hex;

+ (NSString *)convertRGB:(NSString *)rgbString;

@end

NS_ASSUME_NONNULL_END
