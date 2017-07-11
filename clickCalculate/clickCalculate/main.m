//
//  main.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/11.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication * app = [NSApplication sharedApplication];
    id delegate = [AppDelegate new];
    app.delegate = delegate;
    
    return NSApplicationMain(argc, argv);
}
