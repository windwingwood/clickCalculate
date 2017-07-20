//
//  calculateModel.h
//  clickCalculate
//
//  Created by 月砂 on 2017/7/19.
//  Copyright © 2017年 月砂. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CM_TypeDecimal = 2,
    CM_TypeHex
} CMType;

@interface calculateModel : NSObject

@property (nonatomic ,assign) CMType type;

+ (NSString *)calculateBy:(NSString *)string;

@end
