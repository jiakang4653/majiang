//
//  AnimalView.m
//  MaJDemo
//
//  Created by ly on 2017/3/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "AnimalView.h"

@implementation AnimalView

static NSTimer *animalTimer;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void) stop{
    if (animalTimer) {
        [animalTimer invalidate];
        animalTimer = nil;
    }
}
+(void) addAnimalToView:(UIView *) superView{
//    [[self class] stop];
//    animalTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(test:) userInfo:superView repeats:YES];

}
+(void) test:(NSTimer *) timer{
    UIView *superView = [timer userInfo];
    __block AnimalView *waterView = [[AnimalView alloc]initWithFrame:superView.bounds];
    waterView.userInteractionEnabled = NO;
    [waterView setBackgroundImage:[UIImage imageNamed:@"hu"] forState:UIControlStateNormal];
    waterView.backgroundColor = [UIColor clearColor];
    
    [superView addSubview:waterView];
//    [superView.superview sendSubviewToBack:waterView];
    //    self.waterView = waterView;
    
    
    [UIView animateWithDuration:1.5 animations:^{
        
        waterView.transform = CGAffineTransformScale(waterView.transform, 1.4, 1.4);
        
        waterView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [waterView removeFromSuperview];
    }];
}
- (void)drawRect:(CGRect)rect {
    
    // 半径
    CGFloat rabius = 31;
    // 开始角
    CGFloat startAngle = 0;
    
    // 中心点
    CGPoint point = CGPointMake(31, 31);  //
    
    // 结束角
    CGFloat endAngle = 2*M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;       // 添加路径
    
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    
    [self.layer addSublayer:layer];
    
}
@end
