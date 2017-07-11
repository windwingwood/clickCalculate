//
//  ViewController.m
//  clickCalculate
//
//  Created by 月砂 on 2017/7/11.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //初始化
    self.item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    //添加事件
    self.item.target = self;
    self.item.button.action = @selector(clickItem:);
    //设置图标
    [self.item.button setImage:[NSImage imageNamed:@""]];
    
    //
    self.popover = [NSPopover new];
    self.popover.behavior = NSPopoverBehaviorTransient;
    self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)clickItem:(NSStatusBarButton *)button{
    [_popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
}


@end
