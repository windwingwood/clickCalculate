//
//  SMCReader.m
//  ClickCalculateV2
//
//  Created by Kaztha on 2025/11/15.
//

#import "SMCReader.h"
#import "SMCHeader.h"

// from SMCWrapper
@interface SMCReader ()

@end

@implementation SMCReader

- (NSString *)description
{
    return [NSString stringWithFormat:@"当前温度:%.1f 风扇转速:%ld", self.temperature, self.fanSpeed];
}

- (void)updateRecord {
    io_connect_t conn = [self connectToSMC];
    if (!conn) return;
    
    CGFloat temperature = 0.0;
    
    // 尝试读取不同的温度传感器
    NSArray *temList = @[@"TCXC", @"TC0C", @"TC1C", @"TC0P", @"TC0D", @"TC0H"];
    NSArray *fanList = @[@"F0Ac", @"F1Ac"];
    
    for (NSString *key in temList) {
        NSString *result = [self readSMCInfo:key connect:conn];
        if (result) {
//            NSLog(@"成功读取 %@ [%@]", key, result);
            CGFloat tt = [result floatValue];
            if (tt > temperature) temperature = tt;
        } else {
//            NSLog(@"无法读取 %@", key);
        }
    }
    self.temperature = temperature;
    
    for (NSString *key in fanList) {
        NSString *result = [self readSMCInfo:key connect:conn];
        if (result) {
//            NSLog(@"成功读取 %@ [%@]", key, result);
            self.fanSpeed = [result integerValue];
            break;
        } else {
            NSLog(@"无法读取 %@", key);
        }
    }
    
    IOServiceClose(conn);
}

#pragma mark - SMC

- (io_connect_t)connectToSMC {
    io_service_t service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSMC"));
    if (!service) return 0;
    
    io_connect_t conn = 0;
    kern_return_t result = IOServiceOpen(service, mach_task_self(), 0, &conn);
    IOObjectRelease(service);
    [self checkKernError:result];
    return (result == kIOReturnSuccess) ? conn : 0;
}

- (NSString *)readSMCInfo:(NSString *)key connect:(io_connect_t)conn {
    const char *keyStr = [key UTF8String];
    SMCVal_t val;
    NSString *result = nil;
    if ([self readSMCKey:(char *)keyStr value:&val conn:conn] == kIOReturnSuccess) {
        result = [self valToNSString:&val];
    }
    return result;
}

- (kern_return_t)readSMCKey:(char *)key value:(SMCVal_t *)val conn:(io_connect_t)conn {
    SMCKeyData_t input;
    SMCKeyData_t output;
    size_t size = sizeof(SMCKeyData_t);
    
    memset(&input, 0, size);
    memset(&output, 0, size);
    memset(val, 0, sizeof(SMCVal_t));
    
    input.key = [self strToInt:key forSize:4 inBase:16];
    input.data8 = SMC_CMD_READ_KEYINFO;
    
    kern_return_t result = IOConnectCallStructMethod(conn, KERNEL_INDEX_SMC,
                                                     &input, size, &output, &size);
    [self checkKernError:result];
    if (result != kIOReturnSuccess) return result;
    
    val->dataSize = output.keyInfo.dataSize;
    [self intToStr:val->dataType forValue:output.keyInfo.dataType];
    
    input.keyInfo.dataSize = output.keyInfo.dataSize;
    input.data8 = SMC_CMD_READ_BYTES;
    
    result = IOConnectCallStructMethod(conn, KERNEL_INDEX_SMC,
                                       &input, size, &output, &size);
    [self checkKernError:result];
    if (result != kIOReturnSuccess) return result;
    
    memcpy(val->bytes, output.bytes, sizeof(output.bytes));
    return kIOReturnSuccess;
}

#pragma mark - Other

- (UInt32)strToInt:(char *)str forSize:(int)size inBase:(int)base {
    UInt32 total = 0;
    for (int i = 0; i < size; i++) {
        if (base == 16)
            total += str[i] << (size - 1 - i) * 8;
        else
            total += (unsigned char) (str[i] << (size - 1 - i) * 8);
    }
    return total;
}

- (void)intToStr:(char *)str forValue:(UInt32)val {
    str[0] = '\0';
    sprintf(str, "%c%c%c%c",
            (unsigned int) val >> 24,
            (unsigned int) val >> 16,
            (unsigned int) val >> 8,
            (unsigned int) val);
}

- (NSString *)valToNSString:(SMCVal_t *)val {
    if (val->dataSize <= 0) return nil;
    
    char str[32] = "";
    char *dataType = val->dataType;
    UInt32 dataSize = val->dataSize;
    char *bytes = val->bytes;
    
    if ((strcmp(dataType, DATATYPE_UINT8) == 0) ||
        (strcmp(dataType, DATATYPE_UINT16) == 0) ||
        (strcmp(dataType, DATATYPE_UINT32) == 0)) {
        UInt32 uint = [self strToInt:bytes forSize:dataSize inBase:10];
        snprintf(str, 15, "%u ", (unsigned int)uint);
    }
    else if (strcmp(dataType, DATATYPE_FP1F) == 0 && dataSize == 2)
        snprintf(str, 15, "%.5f ", ntohs(*(UInt16*)bytes) / 32768.0);
    else if (strcmp(dataType, DATATYPE_FP4C) == 0 && dataSize == 2)
        snprintf(str, 15, "%.5f ", ntohs(*(UInt16*)bytes) / 4096.0);
    else if (strcmp(dataType, DATATYPE_FP5B) == 0 && dataSize == 2)
        snprintf(str, 15, "%.5f ", ntohs(*(UInt16*)bytes) / 2048.0);
    else if (strcmp(dataType, DATATYPE_FP6A) == 0 && dataSize == 2)
        snprintf(str, 15, "%.4f ", ntohs(*(UInt16*)bytes) / 1024.0);
    else if (strcmp(dataType, DATATYPE_FP79) == 0 && dataSize == 2)
        snprintf(str, 15, "%.4f ", ntohs(*(UInt16*)bytes) / 512.0);
    else if (strcmp(dataType, DATATYPE_FP88) == 0 && dataSize == 2)
        snprintf(str, 15, "%.3f ", ntohs(*(UInt16*)bytes) / 256.0);
    else if (strcmp(dataType, DATATYPE_FPA6) == 0 && dataSize == 2)
        snprintf(str, 15, "%.2f ", ntohs(*(UInt16*)bytes) / 64.0);
    else if (strcmp(dataType, DATATYPE_FPC4) == 0 && dataSize == 2)
        snprintf(str, 15, "%.2f ", ntohs(*(UInt16*)bytes) / 16.0);
    else if (strcmp(dataType, DATATYPE_FPE2) == 0 && dataSize == 2)
        snprintf(str, 15, "%.2f ", ntohs(*(UInt16*)bytes) / 4.0);
    else if (strcmp(dataType, DATATYPE_SP1E) == 0 && dataSize == 2)
        snprintf(str, 15, "%.5f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 16384.0);
    else if (strcmp(dataType, DATATYPE_SP3C) == 0 && dataSize == 2)
        snprintf(str, 15, "%.5f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 4096.0);
    else if (strcmp(dataType, DATATYPE_SP4B) == 0 && dataSize == 2)
        snprintf(str, 15, "%.4f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 2048.0);
    else if (strcmp(dataType, DATATYPE_SP5A) == 0 && dataSize == 2)
        snprintf(str, 15, "%.4f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 1024.0);
    else if (strcmp(dataType, DATATYPE_SP69) == 0 && dataSize == 2)
        snprintf(str, 15, "%.3f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 512.0);
    else if (strcmp(dataType, DATATYPE_SP78) == 0 && dataSize == 2)
        snprintf(str, 15, "%.3f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 256.0);
    else if (strcmp(dataType, DATATYPE_SP87) == 0 && dataSize == 2)
        snprintf(str, 15, "%.3f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 128.0);
    else if (strcmp(dataType, DATATYPE_SP96) == 0 && dataSize == 2)
        snprintf(str, 15, "%.2f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 64.0);
    else if (strcmp(dataType, DATATYPE_SPB4) == 0 && dataSize == 2)
        snprintf(str, 15, "%.2f ", ((SInt16)ntohs(*(UInt16*)bytes)) / 16.0);
    else if (strcmp(dataType, DATATYPE_SPF0) == 0 && dataSize == 2)
        snprintf(str, 15, "%.0f ", (float)ntohs(*(UInt16*)bytes));
    else if (strcmp(dataType, DATATYPE_SI16) == 0 && dataSize == 2)
        snprintf(str, 15, "%d ", ntohs(*(SInt16*)bytes));
    else if (strcmp(dataType, DATATYPE_SI8) == 0 && dataSize == 1)
        snprintf(str, 15, "%d ", (signed char)*bytes);
    else if (strcmp(dataType, DATATYPE_PWM) == 0 && dataSize == 2)
        snprintf(str, 15, "%.1f%% ", ntohs(*(UInt16*)bytes) * 100 / 65536.0);
    else if (strcmp(dataType, DATATYPE_CHARSTAR) == 0)
        snprintf(str, 15, "%s ", bytes);
    else if (strcmp(dataType, DATATYPE_FLAG) == 0)
        snprintf(str, 15, "%s ", bytes[0] ? "TRUE" : "FALSE");
    else {
        int i;
        char tempAb[64];
        for (i = 0; i < dataSize; i++) {
            snprintf(tempAb+strlen(tempAb), 8, "%02x ", (unsigned char) bytes[i]);
        }
        snprintf(str, 15, "%s ", tempAb);
    }
    
    return [[NSString alloc] initWithCString:str encoding:NSUTF8StringEncoding];
}

- (void)checkKernError:(kern_return_t)resultCode {
    if (resultCode == kIOReturnNotPermitted) {
        NSLog(@"无权限"); // 需要删除项目配置里的App Sandbox
    }
    else if (resultCode == kIOReturnUnsupported) {
        NSLog(@"不支持");
    }
    else if (resultCode == kIOReturnBadArgument) {
        NSLog(@"传参错误");
    }
    else if (resultCode != kIOReturnSuccess) {
        NSLog(@"未知错误: %X", resultCode);
    }
}

@end
