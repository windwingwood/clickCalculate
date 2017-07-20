//
//  calculateView.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/18.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "calculateView.h"

@interface calculateView ()

@end

@implementation calculateView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_inputText setKeyUp:^(unsigned short code) {
        if (code == 36) {
            NSLog(@"start");
            [_inputText setStringValue:[calculateModel calculateBy:_inputText.stringValue]];
            NSLog(@"end");
        }
    }];
}

#pragma mark - 

- (IBAction)clickClean:(id)sender {
    [_inputText setStringValue:@""];
}


@end
