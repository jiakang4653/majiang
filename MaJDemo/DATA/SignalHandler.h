//
//  SignalHandler.h
//  MF_sgenglish
//
//  Created by kangjia on 2017/3/8.
//  Copyright © 2017年 mf. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/signal.h>

@interface SignalHandler : NSObject

//注册捕获信号的方法
+ (void)RegisterSignalHandler;

@end
