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
#import <net/if.h>

@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) calculateView *calView;
@property (weak) IBOutlet NSMenu *mainMenu;


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self setStatusBar];
//    [self setRuntime];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - 

- (void)setRuntime{
    Method windowKeyDown = class_getInstanceMethod([NSTextField class], @selector(keyDown:));
    Method textKeyDown = class_getInstanceMethod([WTextField class], @selector(keyDown:));
    method_exchangeImplementations(windowKeyDown, textKeyDown);
//    IMP myIMP = (IMP)method_getImplementation(textKeyDown);
//    class_replaceMethod([NSResponder class], @selector(keyDown:), myIMP, "v@:@");
    
}

- (void)setStatusBar{
    //初始化 - 可变宽度
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    //添加事件
    _statusItem.target = self;
    _statusItem.button.action = @selector(clickItem:);
    //设置标题
    _statusItem.title = @"0kbs";
    //设置弹出页
    [self setPopover];
}

- (void)setPopover{
    _calView = [calculateView new];
    _popover = [NSPopover new];
    _popover.behavior = NSPopoverBehaviorTransient;
    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _popover.contentViewController = _calView;
}

- (void)clickItem:(NSStatusBarButton *)button{
    [_popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
}

@end
