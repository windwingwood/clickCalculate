//
//  MonitorView.h
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorView : NSView

+ (instancetype)monitorView;

- (void)addItemWithTitle:(NSString *)title;

- (void)updateItem:(NSString *)value atIndex:(NSInteger)index;

- (void)removeAllItem;

@end

NS_ASSUME_NONNULL_END
