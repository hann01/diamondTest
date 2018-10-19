//
//  ExceptionCatch.h
//  PictureScrollViewDemo
//
//  Created by YBJ-H on 16/7/11.
//  Copyright © 2016年 YBJ-H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ExceptionCatch : NSObject
{
    BOOL        dismissed;
}

void HandleException(NSException *exception);

void SignalHandler(int signal);

void InstallUncaughtExceptionHandler(void);

@end
