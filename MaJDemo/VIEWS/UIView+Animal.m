//
//  UIView+Animal.m
//  MaJDemo
//
//  Created by ly on 2017/4/1.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "UIView+Animal.h"


@implementation UIView (Animal)

-(void) addAnimalByType:(AnimalType) type{
    
    if (self.superview == nil) {
        return;
    }
    
    UIView *superView = self.superview;
    UIImageView *imageview = [[UIImageView alloc] init];
    
    NSMutableArray *images = [NSMutableArray array];
    switch (type) {
        case AnimalType_TING:
        {
            imageview.tag = AnimalType_TING_TAG;
            for (NSInteger i = 0; i<99; i++) {
                NSString *name = [NSString stringWithFormat:@"m%.2zd",i];
                UIImage *img = [UIImage imageNamed:name];
                if (img) {
                    [images addObject:img];
                }
            }
        }
            break;
        case AnimalType_HU:
        {
            imageview.tag = AnimalType_HU_TAG;
            for (NSInteger i = 0; i<99; i++) {
                NSString *name = [NSString stringWithFormat:@"hu_000%.2zd",i];
                UIImage *img = [UIImage imageNamed:name];
                if (img) {
                    [images addObject:img];
                }
            }
        }
            break;
        case AnimalType_CHI:
        {
            imageview.tag = AnimalType_CHI_TAG;
            for (NSInteger i = 0; i<99; i++) {
                NSString *name = [NSString stringWithFormat:@"chi_000%.2zd",i];
                UIImage *img = [UIImage imageNamed:name];
                if (img) {
                    [images addObject:img];
                }
            }
        }
            break;
        default:
            break;
    }

    
    
    
    imageview.animationImages = images;
    imageview.frame = CGRectMake(0, 0, [[self class] animalSize].width, [[self class] animalSize].height);
    imageview.center = self.center;
    imageview.animationDuration = 4.0;
    imageview.animationRepeatCount = 100;
    [superView addSubview:imageview];
    [superView sendSubviewToBack:imageview];
    [imageview startAnimating];
    
    
}
-(void) removeAnimalByType:(AnimalType) type{
    UIImageView *targetView;
    switch (type) {
        case AnimalType_TING:
        {
            UIView *tmp = [self.superview viewWithTag:AnimalType_TING_TAG];
            if (tmp && [tmp isKindOfClass:[UIImageView class]] ) {
                targetView =(UIImageView *) tmp;
            }
        }
            break;
        case AnimalType_HU:
        {
            UIView *tmp = [self.superview viewWithTag:AnimalType_HU_TAG];
            if (tmp && [tmp isKindOfClass:[UIImageView class]] ) {
                targetView =(UIImageView *) tmp;
            }
        }
            break;
        case AnimalType_CHI:
        {
            UIView *tmp = [self.superview viewWithTag:AnimalType_CHI_TAG];
            if (tmp && [tmp isKindOfClass:[UIImageView class]] ) {
                targetView =(UIImageView *) tmp;
            }
        }
            break;
            
        default:
            break;
    }
    
    [targetView setAnimationImages:nil];
    [targetView removeFromSuperview];
}

-(void) removeAnimalAll{
    [self removeAnimalByType:AnimalType_TING];
    [self removeAnimalByType:AnimalType_CHI];
    [self removeAnimalByType:AnimalType_HU];
}

+(CGSize) animalSize{
    
    return CGSizeMake(500.0 / 3.0, 500.0 / 3.0);
}
@end


@implementation UILabel(PARAMETER)

-(void)set_label_parameter_withtext:(NSString *)text
                      withtextColor:(UIColor *)color
                  withtextAlignment:(NSTextAlignment)alignment
                           withFont:(CGFloat )font_num{
    self.text = text;
    self.textColor = color;
    self.textAlignment = alignment;
    self.font = [UIFont systemFontOfSize:font_num];
    
}

@end


