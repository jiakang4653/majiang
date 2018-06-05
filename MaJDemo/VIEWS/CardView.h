//
//  CardView.h
//  MaJDemo
//
//  Created by ly on 2017/1/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic,copy) NSString *placeChar;
@property BOOL isUpState;

-(instancetype)initWithFrame:(CGRect)frame withChar:(NSString *) c  isBack:(BOOL) showback;
-(NSString *)charV;
-(void) setEatBackGround;
-(void) setTiBackGround;
-(void) setBackToNo;
-(void) showTingLayer:(BOOL) ishow;
-(void) showTingRenminder:(BOOL) isshow;
+(UIImage *) getImgForChar:(NSString *) charc;
@end
