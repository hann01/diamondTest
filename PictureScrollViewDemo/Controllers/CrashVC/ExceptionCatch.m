//
//  ExceptionCatch.m
//  PictureScrollViewDemo
//
//  Created by YBJ-H on 16/7/11.
//  Copyright © 2016年 YBJ-H. All rights reserved.
//

#import "ExceptionCatch.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>


@interface ExceptionCatch ()<UIAlertViewDelegate>

@end


NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int UncaughtExceptionCount = 0;
const int UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation ExceptionCatch


void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    //如果异常大于设定数  则不作处理
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    //根据系统exception 获取异常堆栈
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    NSLog(@"exc-%@",exception);
    
    //在主线程中执行方法  并传参数
    [[[[ExceptionCatch alloc] init] autorelease]performSelectorOnMainThread:@selector(handleException:)
        withObject:[NSException exceptionWithName:[exception name]
                                           reason:[exception reason]
                                         userInfo:userInfo]
                                    waitUntilDone:YES];
}

//signal 异常处理
void SignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    //如果异常大于设定数  则不作处理
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    //singal异常 获取调用堆栈
    NSArray *callStack = [ExceptionCatch backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
//    NSDictionary *userInfoDic = [NSDictionary  dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSString *reason = [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.", nil),signal];
    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                     reason:reason
                                                   userInfo:userInfo ];
    
    
    [[[[ExceptionCatch alloc] init] autorelease]performSelectorOnMainThread:@selector(handleException:)
                                                                 withObject:exception
                                                              waitUntilDone:YES];
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常", nil)
                                                    message:[NSString stringWithFormat:NSLocalizedString(
                                                                                                         @"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"
                                                                                                         @"异常原因如下:\n%@\n%@", nil),
                                                             [exception reason],
                                                             [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
                                                   delegate:[[ExceptionCatch alloc]init]
                                          cancelButtonTitle:NSLocalizedString(@"退出", nil)
                                          otherButtonTitles:NSLocalizedString(@"继续", nil), nil]
                          autorelease];
    [alert show];
}

void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

//调用堆栈
+ (NSArray *)backtrace
{
    //指针数组
    void* callstack[128];
    //backtrace 用来获得当前线程调用的堆栈，获取的信息存放在callstack 中。 128用来指定存放的元素数量。返回值是取得的元素个数。
    int frames = backtrace(callstack, 128);
    //backtrace_symbols 将callstack数组中的信息转化成一个字符串数组
    //返回值 是指向字符串数组的指针
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (i = 0; i < frames; i ++) {
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    
    for (i = UncaughtExceptionHandlerSkipAddressCount;i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}


- (void)handleException:(NSException *)exception
{
    
//    获取系统当前时间，（）
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *crashTime = [formatter stringFromDate:[NSDate date]];
    
    //设备信息
    NSString *appName = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *shortVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *bundleVersion = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *deviceMode = [UIDevice currentDevice].model;
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *appInfo = [NSString stringWithFormat:@"APP:%@%@(%@)\nDevice:%@\nOS Version:%@%@\nUUID:%@\n",appName,shortVersion,bundleVersion,deviceMode,systemName,systemVersion,udid];
    
//    1 把捕获的异常写入文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *logPath = [NSString stringWithFormat:@"%@/crashLog.log",path];
    
    NSString *exceptionString = [NSString stringWithFormat:@"crash time:%@\nname:%@\nreason:%@\nuserInfo:%@\n%@",crashTime,exception.name,exception.reason,exception.userInfo,appInfo];
    
    [exceptionString writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
     /*
   
     CFRunLoopRef runLoop = CFRunLoopGetCurrent();
     CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
     
     while (!dismissed)
     {
     for (NSString *mode in (NSArray *)allModes)
     {
     CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
     }
     }
     
     CFRelease(allModes);
     
     NSSetUncaughtExceptionHandler(NULL);
     signal(SIGABRT, SIG_DFL);
     signal(SIGILL, SIG_DFL);
     signal(SIGSEGV, SIG_DFL);
     signal(SIGFPE, SIG_DFL);
     signal(SIGBUS, SIG_DFL);
     signal(SIGPIPE, SIG_DFL);
     
     if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
     {
     kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
     }
     else
     {
     [exception raise];
     }
     */
} 


@end
