//
//  calculateModel+numberSystem.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/20.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "calculateModel.h"

@interface calculateModel (numberSystem)

- (NSString *)hexFrom:(NSString *)decimal;
- (NSString *)decimalFrom:(NSString *)hex;


@end
