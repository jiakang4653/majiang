//
//  PopView.h
//  MaJDemo
//
//  Created by ly on 2017/4/1.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animal.h"

#define POP_SIZE_W 60
#define POP_SIZE_H 60

@interface PopView : UIView<CAAnimationDelegate>

@property (nonatomic,copy,readwrite) void (^ finishedBlock)(id bean);
-(instancetype)initWithFrame:(CGRect)frame withType:(AnimalType) type superView:(UIView *) sView;
-(void) show;
@end
