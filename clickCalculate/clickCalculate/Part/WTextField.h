//
//  WTextField.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WTextField : NSTextField

- (void)setKeyUp:(void(^)(unsigned short code))callback;

@end
