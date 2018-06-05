//
//  ShaiziView.m
//  MaJDemo
//
//  Created by ly on 2017/1/16.
//  Copyright © 2017年 HX. All rights reserved.
//


#import "ShaiziView.h"

#define TIMEOUT 3.0
#define TIMEINNER 0.3
#define POINT_W 30

@interface ShaiziView()

@property (strong,nonatomic) UIImageView *szImageView;
@property (strong,nonatomic) UIImageView *pointImageView;
@property (strong,nonatomic) NSTimer *szTimer;
@property (strong,nonatomic) NSMutableArray *szImages;

@property (nonatomic) CGFloat timeOut;
@property (nonatomic) NSInteger endPoint;
@end

@implementation ShaiziView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupView];
    }
    return self;
}
-(void) setupData{
    
    _timeOut = 2.0;
    
    _szImages = [NSMutableArray array];
    for (NSInteger i = 1; i<7; i++) {
        [_szImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%zd",i]]];
    }
}
-(void) setupView{
    [self.szImageView setImage:[UIImage imageNamed:@"1"]];
    [self addSubview:self.szImageView];
    [self addSubview:self.pointImageView];
}

-(UIImageView *)szImageView{
    if (_szImageView == nil) {
        _szImageView = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_W, POINT_W, self.bounds.size.width - 2*POINT_W, self.bounds.size.height-2*POINT_W)];
    }
    return _szImageView;
}

-(UIImageView *)pointImageView{
    if (_pointImageView == nil) {
        _pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-POINT_W)/2, self.bounds.size.height-POINT_W, POINT_W,POINT_W)];
        _pointImageView.image = [UIImage imageNamed:@"1"];
    }
    return _pointImageView;
}


-(void) loop:(NSTimer *) timer{
    _timeOut += TIMEINNER;
    NSInteger radom = arc4random() % 6;
    _szImageView.image = [_szImages objectAtIndex:radom];
    if (_timeOut>TIMEOUT) {
        [_szTimer invalidate];
        _szTimer = nil;
        _endPoint = radom + 1;
        if (self.EndBlock) {
            self.EndBlock([NSNumber numberWithInteger:_endPoint]);
        }
    }
}

-(void) start:(DeskDirect) dirdect{
    [self reset];
    [self moveByDirdect:dirdect];
    if (_szTimer != nil) {
        [_szTimer invalidate];
        _szTimer = nil;
    }
        _szTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEINNER target:self selector:@selector(loop:) userInfo:nil repeats:YES];
}
-(void) moveByDirdect:(DeskDirect) dirdect{

    if (dirdect == DeskDirect_TOP) {
        self.pointImageView.frame = CGRectMake((self.bounds.size.width - POINT_W)/2, 0, POINT_W, POINT_W);
    }else
        if (dirdect == DeskDirect_LEFT) {
            self.pointImageView.frame = CGRectMake(0, (self.bounds.size.height - POINT_W)/2, POINT_W, POINT_W);
        }
        else
            if (dirdect == DeskDirect_BOTTOM) {
                self.pointImageView.frame = CGRectMake((self.bounds.size.width - POINT_W)/2, (self.bounds.size.height - POINT_W), POINT_W, POINT_W);
            }
            else
                if (dirdect == DeskDirect_RIGHT) {
                    self.pointImageView.frame = CGRectMake((self.bounds.size.width - POINT_W), (self.bounds.size.height - POINT_W)/2, POINT_W, POINT_W);
                }
        
}
-(void) reset{
    _timeOut = 0.0;
    
}
@end
