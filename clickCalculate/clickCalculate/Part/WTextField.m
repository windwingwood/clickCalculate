//
//  WTextField.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "WTextField.h"

@implementation WTextField {
    void (^keyUp)(unsigned short code);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)keyUp:(NSEvent *)event {
    if(keyUp != nil)keyUp(event.keyCode);
}

- (void)setKeyUp:(void(^)(unsigned short code))callback {
    keyUp = callback;
}

@end
