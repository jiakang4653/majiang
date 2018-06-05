//
//  AppDelegate.h
//  MaJDemo
//
//  Created by ly on 2017/1/16.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeskVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) DeskVC *rootVC;
@end

