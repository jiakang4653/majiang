//
//  UIView+Animal.h
//  MaJDemo
//
//  Created by ly on 2017/4/1.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AnimalType) {
    AnimalType_TING,
    AnimalType_HU,
    AnimalType_CHI
};

#define AnimalType_TING_TAG 555
#define AnimalType_HU_TAG 556
#define AnimalType_CHI_TAG 557

@interface UIView (Animal)

-(void) addAnimalByType:(AnimalType) type;
-(void) removeAnimalByType:(AnimalType) type;
-(void) removeAnimalAll;
@end

@interface UILabel(PARAMETER)
-(void)set_label_parameter_withtext:(NSString *)text
                      withtextColor:(UIColor *)color
                  withtextAlignment:(NSTextAlignment)alignment
                           withFont:(CGFloat )font_num;
@end
