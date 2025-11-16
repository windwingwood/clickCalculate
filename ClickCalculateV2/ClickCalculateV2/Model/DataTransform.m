//
//  DataTransform.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#import "DataTransform.h"

@implementation DataTransform

+ (NSString *)hexToDecimal:(NSString *)dec {
    char *p = NULL;
    unsigned long num = strtoul([dec UTF8String], &p, 10);
    if (*p != 0) return @"格式错误";
    return [NSString stringWithFormat:@"0x%lX",num];
}

+ (NSString *)decimalToHex:(NSString *)hex {
    char *p = NULL;
    unsigned long num = strtoul([hex UTF8String], &p, 16);
    if (*p != 0) return @"格式错误";
    return [NSString stringWithFormat:@"%lu",num];
}

unsigned long readHexNumber(const char *p) {
    if (p == NULL) return 0;
    if (*p <= '9') return *p - '0';
    if (*p <= 'F') return *p - 55;
    if (*p <= 'f')return *p - 87;
    return 0;
}

char writeHexNumber(unsigned long num) {
    if (num < 10) return num + '0';
    if (num < 16) return num + 55;
    return 0;
}

+ (NSString *)convertRGB:(NSString *)rgbString {
    const char *cp = [rgbString UTF8String];
    char *p = NULL;
    unsigned long red,green,blue;
    if (cp[0] == '#' && [rgbString length] == 7) {
        int i = 0;
        red = readHexNumber(&cp[++i]) *16;
        red += readHexNumber(&cp[++i]);
        green = readHexNumber(&cp[++i]) *16;
        green += readHexNumber(&cp[++i]);
        blue = readHexNumber(&cp[++i]) *16;
        blue += readHexNumber(&cp[++i]);
        return [NSString stringWithFormat:@"%lu,%lu,%lu",red,green,blue];
    } else if ([rgbString length] > 3) {
        red = strtoul(cp, &p, 10);
        green = strtoul(&p[1], &p, 10);
        blue = strtoul(&p[1], &p, 10);
        if (*p == 0 && red <=255 && green <=255 && blue <=255) {
            char op[8] = "#000000";
            int i = 7;
            op[--i] = writeHexNumber(blue % 16);
            op[--i] = writeHexNumber(blue / 16);
            op[--i] = writeHexNumber(green % 16);
            op[--i] = writeHexNumber(green / 16);
            op[--i] = writeHexNumber(red % 16);
            op[--i] = writeHexNumber(red / 16);
            return [NSString stringWithUTF8String:op];
        }
    }
    return @"格式错误";
}

@end
