//
//  WTextField.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WTextField : NSTextField

/**
 设置textField键盘keyUp事件的响应。

 @param callback 接收键盘输入时会收到回调的Block, 参数code是按键编号
 */
- (void)setKeyUp:(void(^)(unsigned short code))callback;

@end
