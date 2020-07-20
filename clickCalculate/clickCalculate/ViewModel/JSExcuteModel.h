//
//  JSExcuteModel.h
//  clickCalculate
//
//  Created by 月砂 on 2020/7/20.
//  Copyright © 2020 月砂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSExcuteModel : NSObject

+ (instancetype)shareInstance;

- (NSString *)calculateBy:(NSString *)string;

- (void)clean;

@end

NS_ASSUME_NONNULL_END
