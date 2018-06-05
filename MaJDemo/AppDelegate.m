//
//  AppDelegate.m
//  MaJDemo
//
//  Created by ly on 2017/1/16.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "AppDelegate.h"
#import "MajHelper.h"
#import "SignalHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.rootVC = [[DeskVC alloc] init];
    self.window.rootViewController = self.rootVC;
    [self.window makeKeyAndVisible];
    
    
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);//异常处理
        [SignalHandler RegisterSignalHandler];//signal 处理
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
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
    NSDictionary *dic = @{@"error":str,@"orderNo":[NSString stringWithFormat:@"%@error",
                                                   @"error"]};
    
    
    
    
    NSString *errorfile=[errordir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@error.txt",
                                                                  [NSDate date]]];
    
    [str writeToFile:errorfile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"errorFile:%@",errorfile);
    
    // Internal error reporting
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
