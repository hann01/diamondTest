//
//  CacheCrash.m
//  PictureScrollViewDemo
//
//  Created by YBJ-H on 16/7/6.
//  Copyright © 2016年 YBJ-H. All rights reserved.
//

#import "CacheCrash.h"

@implementation CacheCrash

void uncaughtExceptionHandler(NSException *exception)
{
    NSException *exc = exception;
    
    NSArray *stackAddressesArray = [exception callStackReturnAddresses];
    
    NSArray *stackSymbleArray = [exception callStackSymbols];
    
    NSString *exceptionName = exception.name;
    NSString *exceptionReason = exception.reason;
    NSDictionary *exceptionDic = exception.userInfo;
    
    
    NSString *exceptionString = [NSString stringWithFormat:@"name:%@\nreason:%@\nuserInfo:%@\nSymbleArray:%@\nAddressesArray:%@\n",exceptionName,exceptionReason,exceptionDic,stackAddressesArray,stackSymbleArray];
    
    // 1 把捕获的异常写入文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *logPath = [NSString stringWithFormat:@"%@/crash111.log",path];
    
    [exceptionString writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // 2 把捕获的异常通过邮件发送开发者
    
//    NSLog(@"===\n%@\n===",exceptionString);

//    NSLog(@"11== %@",exception);


}



@end
