//
//  JSTextField.h
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/13.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSTextField : NSTextField

- (void)inputString:(NSString *)stringValue;

- (void)clean;

@end

NS_ASSUME_NONNULL_END
