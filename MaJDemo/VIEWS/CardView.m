//
//  CardView.m
//  MaJDemo
//
//  Created by ly on 2017/1/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "CardView.h"



@interface CardView()
@property (nonatomic,copy) NSString *charV;
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic) BOOL isBack;
@property (nonatomic) BOOL isEat;

@property (nonatomic,strong) UILabel *placeView;
@property (nonatomic,strong) UIImageView *backv;;

@property (nonatomic,strong) UIView *tingViewLayer;
@property (nonatomic,strong) UIImageView *tingViewRenminder;
@end

@implementation CardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame withChar:(NSString *) c isBack:(BOOL) showback{
    self = [super initWithFrame:frame];
    if (self) {
        self.isBack = showback;
        [self setcharV:c];
        [self addSubview:self.backv];
        UIImage *img;
        if (self.isBack) {
            img = [UIImage imageNamed:@"charback"];
        }else
        img=[[self class] getImgForChar:self.charV];
        
        NSLog(@"frame2:%@==%@===%@",NSStringFromCGSize(self.frame.size),NSStringFromCGSize(self.backgroundView.frame.size),NSStringFromCGSize(img.size));
        [self addSubview:self.backgroundView];
        self.backgroundView.image = img;
        
        [self addSubview:self.tingViewLayer];
        [self addSubview:self.tingViewRenminder];
        
        [self addSubview:self.placeView];
        self.placeView.hidden = YES;
        
    }
    
    return self;
}


-(UIView *)tingViewLayer{
    if (_tingViewLayer == nil) {
        _tingViewLayer = [[UIView alloc] initWithFrame:self.bounds];
        _tingViewLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _tingViewLayer.hidden = YES;
    }
    return _tingViewLayer;
}
-(UIImageView *)tingViewRenminder{
    if (_tingViewRenminder == nil) {
        _tingViewRenminder = [[UIImageView alloc] initWithFrame:CGRectMake(10,-10, 10, 10)];
        _tingViewRenminder.image = [UIImage imageNamed:@"reminder"];
        _tingViewRenminder.hidden = YES;
    }
    return _tingViewRenminder;
}
-(void) showTingLayer:(BOOL) ishow{
    self.tingViewLayer.hidden = !ishow;
}
-(void) showTingRenminder:(BOOL) isshow{
    self.tingViewRenminder.hidden = !isshow;
}
-(UIImageView *)backv{
    if (_backv == nil) {
        _backv = [[UIImageView alloc] initWithFrame:self.bounds];
        _backv.contentMode = UIViewContentModeScaleAspectFit;
        _backv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
        UIImage *backimg = [UIImage imageNamed:@"universal"];
        _backv.image = backimg;
    }
    return _backv;
}

-(UIImageView *) backgroundView{
    
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    }
    return _backgroundView;
}

-(NSString *)charV{
    return _charV;
}

-(void)setcharV:(NSString *)charV{
    
    if (![self.charV isEqualToString:charV]) {
        self.charV = charV;
        UIImage *img;
        if (self.isBack) {
            img = [UIImage imageNamed:@"charback"];
        }else
            img=[[self class] getImgForChar:self.charV];
        self.backgroundView.image =img;
    }
}

-(void) setTiBackGround{
    self.backv.image = [UIImage imageNamed:@"press_universal"];
}
-(void) setEatBackGround{

    //图片去掉1
    UIImage *    img= [[self class] getImgForChar:self.charV];
    self.backgroundView.image =img;
    self.isEat = TRUE;
    
    if (_placeChar) {
        //图片去掉1
        self.backgroundView.image = [[self class] getImgForChar:_placeChar];
        //[UIImage imageNamed:[NSString stringWithFormat:@"%@",_placeChar]];
    }
}
-(void) setBackToNo{
    self.isBack = NO;
}

-(UILabel *)placeView{

    if (_placeView == nil) {
        _placeView = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 10, 10)];
        _placeView.textColor = [UIColor redColor];
        _placeView.text = @"替";
        _placeView.font = [UIFont systemFontOfSize:8];
    }
    return _placeView;
}

-(void) setPlaceChar:(NSString *)placeChar{
    
    if ([_placeChar isEqualToString:placeChar]) {
        return;
    }
    
    if (![[self charV] isEqualToString:WNKEY]) {
        return;
    }

    if (self.isBack) {
        return;
    }
    
    _placeChar = placeChar;
    //图片去掉1
    UIImage *img  = [[self class] getImgForChar:_placeChar];
    //[UIImage imageNamed:[NSString stringWithFormat:@"%@",_placeChar]];
    self.backgroundView.image = img;
     self.placeView.hidden = NO;
    [self bringSubviewToFront:self.placeView];
}

+(UIImage *) getImgForChar:(NSString *) charc{

    return [UIImage imageNamed:[NSString stringWithFormat:@"mahjong_%@",charc]];
}
@end
