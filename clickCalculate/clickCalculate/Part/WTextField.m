//
//  WTextField.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "WTextField.h"

@interface WTextField ()

@property (nonatomic, copy) void (^keyUp)(unsigned short code);

@end

@implementation WTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)keyUp:(NSEvent *)event {
    if (self.keyUp) {
        self.keyUp(event.keyCode);
    }
}

- (void)setKeyUp:(void(^)(unsigned short code))callback {
    _keyUp = callback;
}

@end
