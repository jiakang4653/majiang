//
//  SignalHandler.m
//  MF_sgenglish
//
//  Created by kangjia on 2017/3/8.
//  Copyright © 2017年 mf. All rights reserved.
//

#import "SignalHandler.h"
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>


//当前处理的异常个数
volatile int32_t UncaughtExceptionCount = 0;
//最大能够处理的异常个数
volatile int32_t UncaughtExceptionMaximum = 10;


@implementation SignalHandler


static  SignalHandler *s_SignalHandler =  nil;

+ (instancetype)Instance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_SignalHandler == nil) {
            s_SignalHandler  =  [[SignalHandler alloc] init];
        }
    });
    
    return s_SignalHandler;
}
//捕获信号后的回调函数
void HandleException(int signo)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signo] forKey:@"signal"];
    
    //创建一个OC异常对象
    NSException *ex = [NSException exceptionWithName:@"SignalExceptionName" reason:[NSString stringWithFormat:@"Signal %d was raised.\n",signo] userInfo:userInfo];
    
    //处理异常消息
    [[SignalHandler Instance] performSelectorOnMainThread:@selector(HandleException:) withObject:ex waitUntilDone:YES];
}

+ (void)RegisterSignalHandler
{
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, HandleException);
    
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, HandleException);
    
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, HandleException);
    
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, HandleException);
    
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, HandleException);
    
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, HandleException);
}


BOOL isDismissed = NO;
//处理异常用到的方法
- (void)HandleException:(NSException *)exception
{
    
    
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *errordir=[documentDirectory stringByAppendingPathComponent:@"errordump"];
    BOOL isdir;
    NSFileManager *fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:errordir isDirectory:&isdir]){
        [fm createDirectoryAtPath:errordir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *str=[NSString stringWithFormat:@"%@:%@",exception,
                   [exception callStackSymbols]];
    NSDictionary *dic = @{@"error":str,@"orderNo":[NSString stringWithFormat:@"%@signal_error",@"name"]};
    
    
    
    
    
    NSString *errorfile=[errordir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@signal_error.txt",[NSDate date]]];
    
    [str writeToFile:errorfile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"errorFile:%@",errorfile);
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"程序出现问题啦" message:@"崩溃信息" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alertView show];
    
    
    //当接收到异常处理消息时，让程序开始runloop，防止程序死亡
    while (!isDismissed) {
        for (NSString *mode in (NSArray *)CFBridgingRelease(allModes))
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    
    //当点击弹出视图的Cancel按钮哦,isDimissed ＝ YES,上边的循环跳出
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    //因为这个弹出视图只有一个Cancel按钮，所以直接进行修改isDimsmissed这个变量了
    isDismissed = YES;
}
@end
