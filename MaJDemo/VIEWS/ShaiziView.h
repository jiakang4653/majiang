//
//  ShaiziView.h
//  MaJDemo
//
//  Created by ly on 2017/1/16.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DeskDirect) {
    DeskDirect_TOP,
    DeskDirect_LEFT,
    DeskDirect_BOTTOM,
    DeskDirect_RIGHT
    
};

@interface ShaiziView : UIView

@property (copy) void (^EndBlock)(NSNumber* point);

-(void) start:(DeskDirect) dirdect;
@end
