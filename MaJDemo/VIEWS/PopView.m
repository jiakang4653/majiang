//
//  PopView.m
//  MaJDemo
//
//  Created by ly on 2017/4/1.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "PopView.h"



@interface PopView()
{
    UIView *aview;
    AnimalType myType;
    UIView *superView;
    
}
@end

@implementation PopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame withType:(AnimalType) type superView:(UIView *) sView{
//    frame = CGRectMake((superView.frame.size.width - POP_SIZE_W) / 2, (superView.frame.size.height - POP_SIZE_H) / 2, POP_SIZE_W, POP_SIZE_H);
    self = [super initWithFrame:frame];
    if (self) {
        myType = type;
        superView = sView;
        [self setupView];
    }
    return self;
}

-(void) setupView{
    
    aview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    aview.backgroundColor = [UIColor clearColor];
    
    [self addSubview:aview];
    [self addViewByType:myType];
    
    aview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    self.autoresizingMask =UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    
    
}

-(void)show{
    [superView addSubview:self];
    [self to_animation];
}


-(void) addViewByType:(AnimalType) type{
    NSString *imgName ;
    if (type == AnimalType_TING) {
        imgName = @"ting";
    }else
        if (type == AnimalType_CHI) {
        imgName = @"chi";
        }
    else
        if (type == AnimalType_HU) {
         imgName = @"hu";
        }
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.frame = aview.bounds;
    imgv.image = [UIImage imageNamed:imgName];
    imgv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    [aview addSubview:imgv];
}

-(void) to_animation{
    
    {
        CAKeyframeAnimation * animation;
        
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        animation.duration = 0.5;
        
        animation.delegate = self;
        
        animation.removedOnCompletion = YES;
        
        animation.fillMode = kCAFillModeForwards;
        
        
        
        NSMutableArray *values = [NSMutableArray array];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        
        
        animation.values = values;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
        
        [aview.layer addAnimation:animation forKey:nil];
        [self addSubview:aview];
        
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.finishedBlock) {
            self.finishedBlock(@"");
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeFromSuperview];
                });
            }];
        }

    });
}

@end
