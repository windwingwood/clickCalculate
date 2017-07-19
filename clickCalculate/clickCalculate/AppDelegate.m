//
//  AppDelegate.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/11.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "AppDelegate.h"
#import "calculateView.h"
#import <objc/runtime.h>

@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSPopover *popover;
@property (weak) IBOutlet NSMenu *mainMenu;


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self setStatusBar];
    //[self setRuntime];
    //[self setMenu];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - 

- (void)setRuntime{
    Method windowKeyDown = class_getClassMethod([NSWindow class], @selector(keyDown:));
    Method textKeyDown = class_getClassMethod([WTextField class], @selector(keyDown:));
    method_exchangeImplementations(windowKeyDown, textKeyDown);
}

- (void)setMenu{
    NSApplication * app = [NSApplication sharedApplication];
    app.mainMenu = _mainMenu;
}

- (void)setStatusBar{
    //初始化
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    //添加事件
    _statusItem.target = self;
    _statusItem.button.action = @selector(clickItem:);
    //设置图标
    [_statusItem.button setImage:[NSImage imageNamed:@""]];
    //设置弹出页
    [self setPopover];
}

- (void)setPopover{
    _popover = [NSPopover new];
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popover.contentViewController = [calculateView new];
}

- (void)clickItem:(NSStatusBarButton *)button{
    [_popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
}

@end
