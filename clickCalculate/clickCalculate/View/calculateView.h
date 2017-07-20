//
//  calculateView.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/18.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WTextField.h"
#import "calculateModel.h"
#import "calculateModel+numberSystem.h"

@interface calculateView : NSViewController

@property (nonatomic, strong) calculateModel * model;
@property (weak) IBOutlet WTextField *inputText;

@end
