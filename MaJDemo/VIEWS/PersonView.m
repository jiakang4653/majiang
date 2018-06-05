//
//  PersonView.m
//  MaJDemo
//
//  Created by ly on 2017/1/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "PersonView.h"

#import "CardView.h"
#import "MajHelper.h"
#import "PopView.h"




@interface PersonView()

{
    //每次保存的结果
    NSInteger ss_dic_error;
    NSString *ss_dic_correctString;
    NSMutableArray *ss_dic_lastCharArray ;
    NSMutableArray *ss_dic_needCharArray ;
    NSMutableArray *ss_dic_preWordsArray ;
    NSMutableArray *ss_dic_resultArray;
    //每次的结果
    NSInteger dic_error;
    NSString *dic_correctString;
    NSMutableArray *dic_lastCharArray ;
    NSMutableArray *dic_needCharArray ;
    NSMutableArray *dic_preWordsArray ;
    NSMutableArray *dic_resultArray; // 保存当error=1时（听） 的多种结果
    NSMutableArray *dic_tingArray;
    NSMutableArray *dic_huArray;
    
    
    
    
    NSMutableDictionary *dic_eatDic;
    NSMutableDictionary *dic_eatDicAll;
    
    NSString *tingPopChar;
    
    //标志,当“听”状态触发时 此值为true
    //    BOOL tingState;
    
    BOOL preTingState;
    BOOL controlState;
    
    
    //是否已经打过牌
    BOOL alreadPostCard;
}

@property (nonatomic,strong) UIView *tingInfoView;
@property (nonatomic) CGSize tingInfoCardSize;
@property (nonatomic) float tingInfoCardMargin;
@property (nonatomic,strong) NSMutableArray *tingLayerViewArray;



@property (nonatomic,strong) UIButton *tingFlagView;

@property (nonatomic,strong) UserInfoVO *userinfo;

@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIImageView * headerImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * scoreLabel;

@property (nonatomic,strong) NSMutableArray *charArray;
@property (nonatomic,strong) NSMutableArray *charViewArray;
@property (nonatomic,strong) NSMutableArray *selectedCharViewArray;
@property (nonatomic) DeskDirect deskDirect;
@property (nonatomic) NSInteger shuaiziNum;
@property (nonatomic,strong) UIButton *aButton;

//@property (nonatomic) NSInteger currentSelectedIndex;
//@property (nonatomic) NSInteger currentRemovedIndex;
//@property (nonatomic) CardView* currentSelectedView;
@property (nonatomic) CardView* currentNeedRemoveView;

@property (nonatomic) BOOL tingSet ;

@property (nonatomic,strong) NSMutableArray* tingNeedChar;
@property (nonatomic,strong) NSMutableArray* tingLastChar;

@property (nonatomic,strong) UIView *eatView;
@property (nonatomic,strong) NSString *selectedEatWord;
@property (nonatomic,strong) UIImageView *eatViewBackground;
@property (nonatomic,strong) UIImageView *eatViewReminder;



@property (nonatomic,strong) UIView *controlView;
@property (nonatomic,strong) UIScrollView *outView;
@property (nonatomic,strong) UILabel *wordInfoView; //提示
@property (nonatomic,strong) UILabel *tingView;
@property (nonatomic,strong) NSMutableArray *outViewArray;

@property (nonatomic,strong) NSMutableArray* eatCharArray;
@property (nonatomic,strong) NSMutableArray* eatCharViewArray;
@property (nonatomic,strong) NSString* eatCharFromOther;
@property (nonatomic,strong) NSString* eatCharFromLibrary;


@property (nonatomic,strong) CardView* moveCardView;;
@property (nonatomic,strong) CardView* operCardView;;
@property (nonatomic) CGFloat moveLastX;;
@property (nonatomic) CGFloat locationInView;;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint originPoint;
@property (nonatomic) BOOL contain;

@property (nonatomic) CGPoint beginPoint; //纵坐标检测
@property (nonatomic) BOOL isCardUpDirect;


@property (nonatomic,strong) CAShapeLayer *border;
@property (nonatomic,strong) CAShapeLayer *eatborder;
@property (nonatomic) BOOL borderState;
@property (nonatomic,strong) UILabel *borderInfo;

@property (nonatomic) NSInteger stepFromOtherOrLibrary;

@property (nonatomic,strong) NSString *save_step_tingOtherChar;
@property (nonatomic,strong) NSString *save_step_tingCacheLibraryChar;

@property (nonatomic) NSInteger save_step;


//定义牌大小
@property (nonatomic) CGSize cardSize;
@property (nonatomic) CGSize outCardSize;
@property (nonatomic) float outCardMargin;
@property (nonatomic) float cardMargin;
@property (nonatomic) float sortCardBeginMarx;

@property (nonatomic) CGSize eatCardSize;
@property (nonatomic) float eatCardMargin;

@property (nonatomic) CGSize selectedCardSize;
@property (nonatomic) float selectedCardMargin;
@end

@implementation PersonView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(UILabel *) tingView{
    if (_tingView == nil) {
        //        _tingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        //        _tingView.text = @"听";
        //        _tingView.backgroundColor = [UIColor clearColor];
        //        _tingView.textColor = [UIColor redColor];
        //        _tingView.font = [UIFont systemFontOfSize:60];
        //        _tingView.textAlignment = NSTextAlignmentLeft;
        //        [self addSubview:_tingView];
        //        _tingView.hidden = YES;
    }
    return _tingView;
}
#pragma mark - 提示信息
//-(UILabel *) wordInfoView{
//    if (_wordInfoView == nil) {
//        _wordInfoView = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.bounds.size.width, 25)];
//        _wordInfoView.backgroundColor = [UIColor clearColor];
//        _wordInfoView.textColor = [UIColor redColor];
//        _wordInfoView.font = [UIFont systemFontOfSize:10];
//        _wordInfoView.textAlignment = NSTextAlignmentLeft;
//    }
//    return _wordInfoView;
//}
-(UIView *)controlView{
    if (_controlView == nil) {
        UIImage *buttonimg = [UIImage imageNamed:@"hu"];
        _controlView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width -buttonimg.size.width*4-156.0/3 - (4-1) * 39.0/3), self.bounds.size.height-self.cardSize.height-45.0/3-69.0/3-buttonimg.size.height, buttonimg.size.width*4 + (4-1) * 39.0/3, buttonimg.size.height)];
        _controlView.backgroundColor = [UIColor clearColor];
        //        NSArray *buttons = @[@"吃",@"组",@"听",@"胡",@"过"];
        NSArray *buttons = @[@"吃",@"听",@"胡",@"过"];
        NSArray *buttonimgs = @[@"chi",@"ting",@"hu",@"guo"];
        
        for (NSInteger i = 0; i<buttons.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*buttonimg.size.width + (i-1) * 39.0/3, 0, buttonimg.size.width, buttonimg.size.height);
            [_controlView addSubview:button];
            button.tag = 1000+i;
            
            [button addTarget:self action:@selector(actionControl:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:[buttonimgs objectAtIndex:i]] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            if (i == 100) {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            button.hidden = YES;
        }
    }
    return _controlView;
}

-(UIView *)tingInfoView{
    if (_tingInfoView == nil) {
        _tingInfoView = [[UIView alloc] init];
        _tingInfoView.backgroundColor = [UIColor clearColor];
    }
    return _tingInfoView;
}



-(UIView *) outView{
    
    if (_outView == nil) {
        _outView = [[UIScrollView alloc] init];
        _outView.backgroundColor  = [UIColor clearColor];
        if (self.deskDirect == DeskDirect_TOP) {
            _outView.frame = CGRectMake(self.headerView.frame.origin.x + self.headerView.frame.size.width + 9,
                                        45.0/3 + 57.0/3 + self.cardSize.height,
                                        SCREEN_W - 1*(self.headerView.frame.origin.x + self.headerView.frame.size.width + 9) ,
                                        self.bounds.size.height - (45.0/3 + 57.0/3 + self.cardSize.height));
        }else{
            _outView.frame = CGRectMake(self.headerView.frame.origin.x + self.headerView.frame.size.width + 9,
                                        0,
                                        SCREEN_W - 1*(self.headerView.frame.origin.x + self.headerView.frame.size.width + 9) ,
                                        self.bounds.size.height - (45.0/3 + 57.0/3 + self.cardSize.height ));
        }
    }
    return _outView;
}
-(UIImageView *)lastOutCardReminderIv{
    if (_lastOutCardReminderIv == nil) {
        _lastOutCardReminderIv = [[UIImageView alloc] init];
        UIImage *reminder_image = [UIImage imageNamed:@"reminder"];
        _lastOutCardReminderIv.frame = CGRectMake(0, 0, reminder_image.size.width*0.8, reminder_image.size.height*0.8);
        _lastOutCardReminderIv.image = reminder_image;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
        animation.autoreverses = YES;
        animation.duration = 1;
        animation.repeatCount = MAXFLOAT;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
        [_lastOutCardReminderIv.layer addAnimation:animation forKey:@"lastreminder"];
        [_outView addSubview:_lastOutCardReminderIv];
    }
    return _lastOutCardReminderIv;
}
-(UILabel *)round_reminder_lb{
    //    if (_round_reminder_lb == nil) {
    //        if (self.deskDirect == DeskDirect_TOP) {
    //            _round_reminder_lb = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.frame.origin.x, _headerView.frame.origin.y + _headerView.frame.size.height + 8, _headerView.frame.size.width, 10)];
    //            _round_reminder_lb.hidden = YES;
    //        }else{
    //        _round_reminder_lb = [[UILabel alloc] initWithFrame:CGRectMake(_headerView.frame.origin.x, (_headerView.frame.origin.y - 10)/2, _headerView.frame.size.width,  10)];
    //        }
    //        [_round_reminder_lb set_label_parameter_withtext:@"出牌回合" withtextColor:[UIColor whiteColor] withtextAlignment:NSTextAlignmentCenter withFont:12];
    //    }
    return _round_reminder_lb;
}
-(instancetype)initWithFrame:(CGRect)frame  withDirect:(DeskDirect) dd{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.currentSelectedIndex = -1;
        _tingNeedChar = [NSMutableArray array];
        _tingLastChar = [NSMutableArray array];
        self.charViewArray = [NSMutableArray array];
        self.selectedCharViewArray = [NSMutableArray array];
        __weak PersonView *pself = self;
        [self addClickBlock:^(NSInteger tag) {
            [pself actionDownForDoubleClick];
        }];
        [self setDirect:dd];
        [self setupHeaderView];
    }
    return self;
}

-(void) setupPersonInfo{
    
    //    _aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _aButton.frame = CGRectMake(self.bounds.size.width - 10 - 40, self.bounds.size.height - 50/3.0-self.cardSize.height-30, 40, 30);
    //    [_aButton setTitle:@"打出" forState:UIControlStateNormal];
    //    [_aButton addTarget:self action:@selector(actionMethod) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:_aButton];
}
-(void) setupWordInfo{
    [self addSubview:self.wordInfoView];
}
-(void) setupControl{
    [self addSubview:self.controlView];
}
-(void) setupOutView{
    [self addSubview:self.round_reminder_lb];
    [self addSubview:self.outView];
    [self sendSubviewToBack:self.outView];
}
-(void) setupHeaderView{
    [self addSubview:self.headerView];
}
-(void) setupHeaderViewData:(UserInfoVO *) userinfo{
    self.userinfo = userinfo;
    self.nameLabel.text = userinfo.userName;
    self.scoreLabel.text = userinfo.score;
}
-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        UIImage *backimg = [UIImage imageNamed:@"headerbackblue"];
        if (self.deskDirect == DeskDirect_BOTTOM) {
            _headerView.frame = CGRectMake(112, 5+self.frame.size.height - 45.0/3 - self.cardSize.height - 57.0/3 - backimg.size.height, backimg.size.width, backimg.size.height);
        }else
            
            _headerView.frame = CGRectMake(112,  45.0/3 , backimg.size.width, backimg.size.height);
        
        
        UIImageView *backiv = [[UIImageView alloc] initWithFrame:_headerView.bounds];
        backiv.image = backimg;
        [_headerView addSubview:backiv];
        
        
        
        
        UIImage *whiteimg = [UIImage imageNamed:@"headerbackwhite"];
        
        float mary = (_headerView.frame.size.width - whiteimg.size.width) / 2;
        
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = whiteimg;
        _headerImageView.frame = CGRectMake((_headerView.frame.size.width - whiteimg.size.width) / 2, (_headerView.frame.size.width - whiteimg.size.width) / 2, whiteimg.size.width, whiteimg.size.height);
        [_headerView addSubview:_headerImageView];
        mary += whiteimg.size.height;
        mary += 3;
        
        
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:9];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.frame = CGRectMake(0, mary, _headerView.frame.size.width, 20);
        [_headerView addSubview:_nameLabel];
        mary += 12;
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.textColor = [UIColor whiteColor];
        _scoreLabel.font = [UIFont systemFontOfSize:9];
        _scoreLabel.frame = CGRectMake(0, mary, _headerView.frame.size.width, 20);
        [_headerView addSubview:_scoreLabel];
        
        
        
    }
    return _headerView;
}

#pragma mark =========================================method
-(void) actionMethod{
    if (self.selectedCharViewArray.count >1) {
        [self actionDownForDoubleClick];
        if (self.isCardUpDirect) {
            [self resetFrame];
        }
        return;
    }
    if (self.selectedCharViewArray.count == 0) {
        if (self.isCardUpDirect) {
            [self resetFrame];
        }
        return;
    }
    
    NSInteger eatCount = 0;
    for (NSInteger i = 0; i<self.eatCharViewArray.count; i++) {
        NSArray *tmp = [self.eatCharViewArray objectAtIndex:i];
        eatCount += tmp.count;
    }
    if ((self.charViewArray.count + eatCount) != 14) {
        if (self.didError) {
            self.didError(@"若不吃不胡先选择\"过\"");
        }
        if (self.isCardUpDirect) {
            [self resetFrame];
        }
        return;
    }
    
    [self resetControlByisEat:NO isting:NO ishu:NO isguo:NO];
    self.borderState = NO;
    
    self.currentNeedRemoveView = [self.selectedCharViewArray objectAtIndex:0];
    NSString *cha = [self.currentNeedRemoveView charV];
    if ([cha isEqualToString:WNKEY]) {
        [self resetFrame];
        return;
    }
    
    NSInteger index = [self.charArray indexOfObject:cha];
    
    if (index != NSNotFound) {
        [self actionOut:cha];
        [self resetFrame];
    }
    
    
}
-(void) setupEatView{
    //    [self addSubview:self.eatView];
    //    [[[UIApplication sharedApplication] keyWindow] addSubview:self.eatView];
    [self.superview addSubview:self.eatView];
}
-(void) setupCardInfo{
    
    if (self.deskDirect == DeskDirect_BOTTOM) {
        //        float rightSpace = 160.0;
        //        float margin = 0.0;
        //        float cardw = MIN(50, (SCREEN_W-2*margin-rightSpace) / 14.0);
        //        float cardh = CARDH * 1.0 / CARDW *cardw;
        
        float beginx = self.sortCardBeginMarx;
        float cardw = self.cardSize.width;
        float cardh = self.cardSize.height;
        float margin = self.cardMargin;
        
        for (NSInteger i = 0; i<self.charArray.count; i++) {
            CardView *tmpv = [[CardView alloc] initWithFrame:CGRectMake(beginx+i*cardw, self.bounds.size.height - cardh, cardw, cardh) withChar:[self.charArray objectAtIndex:i] isBack:NO];
            tmpv.tag = 100+i;
            NSLog(@"%@",NSStringFromCGRect(tmpv.frame));
            UIPanGestureRecognizer *longGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
            [tmpv addGestureRecognizer:longGesture];
            __weak CardView *wtmpv = tmpv;
            [tmpv addClickBlock:^(NSInteger tag) {
                
                //去掉编辑模式逻辑
                //                if (self.currentSelectedIndex == tag - 100) {
                //                    return ;
                //                }
                //                if (self.currentSelectedIndex == -1) {
                //                    self.currentSelectedIndex = tag - 100;
                //                    self.currentSelectedView = tmpv;
                //                    [self setUP:self.currentSelectedView];
                //                }else{
                //                    if (self.borderState) {
                //                        NSInteger index = [self indexofCrad:tmpv];
                //                        NSInteger sindex = [self indexofCrad:self.currentSelectedView];
                //                        if (index != NSNotFound && sindex != NSNotFound) {
                //                            if (sindex>index) {
                //                                [self.charViewArray removeObject:self.currentSelectedView];
                //                                [self.charViewArray insertObject:self.currentSelectedView atIndex:index];
                //                            }else{
                //                                [self.charViewArray removeObject:self.currentSelectedView];
                //                                [self.charViewArray insertObject:self.currentSelectedView atIndex:index-1];
                //                            }
                //                            [self resetFrame];
                //                            self.currentSelectedView = nil;
                //                            self.currentSelectedIndex = -1;
                //
                //                        }
                //                    }else{
                //                        [self setDown:self.currentSelectedView];
                //                        self.currentSelectedIndex = tag - 100;
                //                        self.currentSelectedView = tmpv;
                //                        [self setUP:self.currentSelectedView];
                //                    }
                //                }
                
                
                
                
                if (wtmpv.isUpState) {
                    [self.selectedCharViewArray removeObject:wtmpv];
                    [self setDown:wtmpv];
                    if (preTingState) {
                        [self hiddenTingInfoViewForCard:wtmpv];
                    }
                    
                }else{
                    [self.selectedCharViewArray addObject:wtmpv];
                    [self setUP:wtmpv];
                    if (preTingState) {
                        [self showTingInfoViewForCard:wtmpv];
                    }
                    
                }
                
                
                
            }];
            
            [tmpv addDoubleClickBlock:^(NSInteger tag) {
//                if (controlState) {
//                    [self moveFinished];
//                    _moveCardView = nil;
//                    _operCardView = nil;
//                    
//                    return;
//                }
//                
//                if (preTingState && (![self.tingLayerViewArray containsObject:tmpv])) {
//                    [self moveFinished];
//                    _moveCardView = nil;
//                    _operCardView = nil;
//                    
//                    return;
//                }
//                
//                if (![self.selectedCharViewArray containsObject:wtmpv]) {
//                    [self.selectedCharViewArray addObject:wtmpv];
//                }
//                
//                [self actionMethod];
                
                
                
                if (controlState) {
                    [self moveFinished];
                    _moveCardView = nil;
                    _operCardView = nil;
                    
                    return;
                }
                
                if (preTingState && (![self.tingLayerViewArray containsObject:tmpv])) {
                    [self moveFinished];
                    _moveCardView = nil;
                    _operCardView = nil;
                    
                    return;
                }
                
                
                    [self actionDownForDoubleClick];
                    [self.selectedCharViewArray addObject:tmpv];
                    [self actionMethod];
                    
                    alreadPostCard = TRUE;
                    
                    if (preTingState) {
                        //                tingState = FALSE;
                        _tingSet = TRUE;
                        [self moveLayerForCard];
                        
                        if ([tmpv isKindOfClass:[CardView class]]) {
                            CardView *ctmp =(CardView *) tmpv;
                            [self setupTingData_getNeedAndLastArray:[ctmp charV]];
                            tingPopChar = [ctmp charV];
                            
                            [self hiddenTingInfoViewForCard:(CardView *)tmpv];
                        }
                        [self moveReminderViewForCard];
                        
                    }
                    
                
                
            }];
            
            
            [self.charViewArray addObject:tmpv];
            [self addSubview:tmpv];
        }
    }else
        if (self.deskDirect == DeskDirect_TOP) {
            float leftSpace = 110.0;
            float margin = 0.0;
            //            float cardw = MIN(30, (SCREEN_W-2*margin-leftSpace) / 14.0);
            //            float cardh = CARDH * 1.0 / CARDW *cardw;
            
            float cardw = self.cardSize.width;
            float cardh = self.cardSize.height;
            
            
            for (NSInteger i = 0; i<self.charArray.count; i++) {
                CardView *tmpv = [[CardView alloc] initWithFrame:CGRectMake(margin+leftSpace+i*cardw, 0, cardw, cardh) withChar:[self.charArray objectAtIndex:i] isBack:YES];
                
                //                UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
                //                [tmpv addGestureRecognizer:longGesture];
                
                [self.charViewArray addObject:tmpv];
                [self addSubview:tmpv];
            }
        }
    
    [self resetFrame];
    
}
-(void) setChar:(NSMutableArray *)charArray{
    if (self.charArray == nil) {
        self.charArray = [NSMutableArray array];
    }
    [self.charArray removeAllObjects];
    [self.charArray addObjectsFromArray:charArray];
    
    if (self.deskDirect == DeskDirect_BOTTOM) {
        [self setupEatView];
    }
    
    [self setupCardInfo];
    [self setupOutView];
    
    if (self.deskDirect == DeskDirect_BOTTOM) {
        [self setupPersonInfo];
        [self setupControl];
    }
    
    [self setupWordInfo];
    
    [self firstInit];
    
}

-(void) setDirect:(DeskDirect)deskDirect{
    
    
    self.deskDirect = deskDirect;
    
}

-(void)setShuaiziNum:(NSInteger)shuaiziNum{
    if (self.shuaiziNum != shuaiziNum) {
        self.shuaiziNum = shuaiziNum;
    }
}
-(void) setUP:(UIView *) view{
    if ([view isKindOfClass:[CardView class]]) {
        CardView *tmp =(CardView *) view;
        if (!tmp.isUpState) {
            tmp.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-16, view.bounds.size.width, view.bounds.size.height);
            tmp.isUpState = TRUE;
        }
    }else
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-16, view.bounds.size.width, view.bounds.size.height);
}
-(void) setDown:(UIView *) view{
    if ([view isKindOfClass:[CardView class]]) {
        CardView *tmp =(CardView *) view;
        if (tmp.isUpState) {
            tmp.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+16, view.bounds.size.width, view.bounds.size.height);
            tmp.isUpState = FALSE;
        }
    }else
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+16, view.bounds.size.width, view.bounds.size.height);
    
    if ([view isKindOfClass:[CardView class]]) {
        CardView *cv = (CardView *) view;
        [self hiddenTingInfoViewForCard:cv];
    }
}
-(void) setLogoInfo:(NSDictionary *) dic{
    NSInteger error = [[dic objectForKey:@"error"] integerValue];//还手率
    NSString * correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
    NSMutableArray* lastCharArray = [dic objectForKey:@"last"];//用不到的字母
    NSMutableArray*needCharArray = [dic objectForKey:@"need"];//需要的字母
    NSMutableArray* preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
    
    
    NSString *logo = [NSString stringWithFormat:@"已完成:%@ 换手次:%zd 目标单词:%@ 需打出:%@ 需进入:%@",[self genLog:preWordsArray],error,correctString,[self genLog:lastCharArray],[self genLog:needCharArray]];
    _wordInfoView.text = logo;
    
}
-(NSString *) genLog:(NSArray *) array{
    
    NSMutableString *mu = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i<array.count; i++) {
        [mu appendString:[array objectAtIndex:i]];
        if (i != array.count-1) {
            [mu appendString:@"-"];
        }
    }
    return mu;
}

-(void) resetFrame{
    if (self.deskDirect == DeskDirect_BOTTOM) {
        
        //        float rightSpace = 160.0;
        //        float margin = 0.0;
        //        float cardw = MIN(50, (SCREEN_W-2*margin-rightSpace) / 14.0);
        //        float cardh = CARDH * 1.0 / CARDW *cardw;
        //
        //        float cardeatw = cardw;
        //        float cardeath = CARDEATH / CARDEATW * cardeatw;
        
        float cardw = self.cardSize.width;
        float cardh = self.cardSize.height;
        float cardeatw = self.eatCardSize.width;
        float cardeath = self.eatCardSize.height;
        float cardMargin = self.cardMargin;
        float cardEatMargin = self.eatCardMargin;
        
        
        float beginx = [self sortCardBeginMarx];
        float numofword = 0;
        float afterlen = 0;
        
        for (NSInteger i = 0; i<self.eatCharViewArray.count; i++) {
            NSMutableArray *oneWords = [self.eatCharViewArray objectAtIndex:i];
            
            NSMutableArray *views = [self.eatCharViewArray objectAtIndex:i];
            for (NSInteger j = 0; j<oneWords.count; j++) {
                numofword++;
                UIView *v = [views objectAtIndex:j];
                v.userInteractionEnabled = NO;
                //                v.frame = CGRectMake(afterlen*cardeatw+beginx+ margin+j*cardeatw, self.bounds.size.height - cardh, cardeatw, cardeath);
                v.frame = CGRectMake(beginx, self.bounds.size.height - cardh-15, cardeatw, cardeath);
                beginx += cardeatw;
                beginx += self.eatCardMargin;
                
            }
            //            afterlen += oneWords.count;
            beginx += 10;
            
        }
        
        for (NSInteger i = self.eatCharViewArray.count - 1; i>=0; i--) {
            NSMutableArray *views = [self.eatCharViewArray objectAtIndex:i];
            for (NSInteger j = views.count-1; j>=0; j--) {
                UIView *v = [views objectAtIndex:j];
                [self bringSubviewToFront:v];
            }
            
        }
        
        //查找可以组成的单词
        
        //        float beginxx = 0;
        //        beginxx += beginx;
        //        beginxx += numofword*cardw;
        //
        //        BOOL needAdd  = (numofword + self.charViewArray.count == 14) ? TRUE : FALSE;
        //
        //        for (NSInteger i = 0;i<self.charViewArray.count;i++) {
        //            UIView *v = [self.charViewArray objectAtIndex:i];
        //            v.frame = CGRectMake(beginxx+margin+i*cardw, self.bounds.size.height - cardh, cardw, cardh);
        //            if ( needAdd && (i == self.charViewArray.count-1)) {
        //            v.frame = CGRectMake(beginxx+margin+i*cardw+15, self.bounds.size.height - cardh, cardw, cardh);
        //            }
        //        }
        
        
        
        BOOL needAdd  = ((numofword + self.charViewArray.count) == 14) ? TRUE : FALSE;
        
        for (NSInteger i = 0;i<self.charViewArray.count;i++) {
            UIView *v = [self.charViewArray objectAtIndex:i];
            if ( needAdd && (i == self.charViewArray.count-1)) {
                beginx += 7 + (self.cardSize.width * LEFTSHADE * (1 - LEFTSHADESHOW));
            }
            v.frame = CGRectMake(beginx, self.bounds.size.height - cardh-15, cardw, cardh);
            
            
            beginx += self.cardMargin;
            beginx += cardw;
            
            NSLog(@"frame==============%@",NSStringFromCGRect(v.frame));
        }
        
        for (NSInteger i = self.charViewArray.count - 1; i>=0; i--) {
            CardView *v = [self.charViewArray objectAtIndex:i];
            v.isUpState = FALSE;
            [self bringSubviewToFront:v];
        }
        
    }
    else{
        //        float leftSpace = 110.0;
        //        float margin = 0.0;
        //        float cardw = MIN(30, (SCREEN_W-2*margin-leftSpace) / 14.0);
        //        float cardh = CARDH * 1.0 / CARDW *cardw;
        //
        //        float cardeatw = cardw;
        //        float cardeath = CARDEATH / CARDEATW * cardeatw;
        //
        //        float beginx = 0;
        //        float numofword = 0;
        //        float afterlen = 0;
        //
        //        for (NSInteger i = 0; i<self.eatCharViewArray.count; i++) {
        //            NSMutableArray *oneWords = [self.eatCharViewArray objectAtIndex:i];
        //
        //            NSMutableArray *views = [self.eatCharViewArray objectAtIndex:i];
        //            for (NSInteger j = 0; j<oneWords.count; j++) {
        //                numofword++;
        //                UIView *v = [views objectAtIndex:j];
        //                v.frame = CGRectMake(afterlen*cardeatw+beginx+ margin+j*cardeatw + leftSpace, 0, cardeatw, cardeath);
        //            }
        //            afterlen += oneWords.count;
        //            beginx += 5;
        //
        //        }
        //
        //        float beginxx = 0;
        //        beginxx += beginx;
        //        beginxx += numofword*cardw;
        //
        //        BOOL needAdd  = (numofword + self.charViewArray.count == 14) ? TRUE : FALSE;
        //
        //        for (NSInteger i = 0;i<self.charViewArray.count;i++) {
        //            UIView *v = [self.charViewArray objectAtIndex:i];
        //            v.frame = CGRectMake(beginxx+margin+i*cardw + leftSpace, 0, cardw, cardh);
        //            if ( needAdd && (i == self.charViewArray.count-1)) {
        //                v.frame = CGRectMake(beginxx+margin+i*cardw+leftSpace+15, 0, cardw, cardh);
        //            }
        //
        //        }
        
        
        
        float cardw = self.cardSize.width;
        float cardh = self.cardSize.height;
        float cardeatw = self.eatCardSize.width;
        float cardeath = self.eatCardSize.height;
        float cardMargin = self.cardMargin;
        float cardEatMargin = self.eatCardMargin;
        
        
        float beginx = self.headerView.frame.origin.x + self.headerView.frame.size.width + 10;
        float numofword = 0;
        float afterlen = 0;
        
        for (NSInteger i = 0; i<self.eatCharViewArray.count; i++) {
            NSMutableArray *oneWords = [self.eatCharViewArray objectAtIndex:i];
            
            NSMutableArray *views = [self.eatCharViewArray objectAtIndex:i];
            for (NSInteger j = 0; j<oneWords.count; j++) {
                numofword++;
                UIView *v = [views objectAtIndex:j];
                v.userInteractionEnabled = NO;
                v.frame = CGRectMake(beginx, 15, cardeatw, cardeath);
                beginx += cardeatw;
                beginx += self.eatCardMargin;
                
            }
            beginx += 10;
            
        }
        
        for (NSInteger i = self.eatCharViewArray.count - 1; i>=0; i--) {
            NSMutableArray *views = [self.eatCharViewArray objectAtIndex:i];
            for (NSInteger j = views.count-1; j>=0; j--) {
                UIView *v = [views objectAtIndex:j];
                [self bringSubviewToFront:v];
            }
            
        }
        
        BOOL needAdd  = ((numofword + self.charViewArray.count) == 14) ? TRUE : FALSE;
        
        for (NSInteger i = 0;i<self.charViewArray.count;i++) {
            UIView *v = [self.charViewArray objectAtIndex:i];
            if ( needAdd && (i == self.charViewArray.count-1)) {
                beginx += 7 + (self.cardSize.width * LEFTSHADE * (1 - LEFTSHADESHOW));
            }
            v.frame = CGRectMake(beginx, 15, cardw, cardh);
            
            
            beginx += self.cardMargin;
            beginx += cardw;
        }
        
        for (NSInteger i = self.charViewArray.count - 1; i>=0; i--) {
            UIView *v = [self.charViewArray objectAtIndex:i];
            NSLog(@"frame:%@",NSStringFromCGRect(v.frame));
            [self bringSubviewToFront:v];
        }
        
    }
    
    
    [self bringSubviewToFront:self.wordInfoView];
    
}

-(PopView *) popViewByType:(AnimalType) type{
    PopView *pop = [[PopView alloc] initWithFrame:CGRectMake((self.frame.size.width - POP_SIZE_W) / 2, (self.frame.size.height - POP_SIZE_H) / 2, POP_SIZE_W, POP_SIZE_H) withType:type superView:self];
    return pop;
}
#pragma mark =======================================begin
#pragma mark =======================================begin
#pragma mark =======================================begin

-(void) firstInit{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *tmp = [NSMutableArray array];
        [tmp addObjectsFromArray:self.charArray];
        NSDictionary *dic = [[MajHelper shareHelper] start:tmp];
        dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
        dic_tingArray = [dic objectForKey:@"tingarray"];
        dic_huArray = [dic objectForKey:@"huarray"];
        dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
        dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
        dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
        dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
        
        
        if (dic_error == 0) {
        }else
            [self save_clean];
        
        if (dic_error == 1) {
            [dic_resultArray removeAllObjects];
            dic_resultArray = [dic objectForKey:@"tingarray"];
            [self save_copy];
        }
        if (dic_error == 0 || dic_error == 1) {
            BOOL isting = (dic_error==1);
            BOOL ishu = (dic_error == 0);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resetControlByisEat:false isting:isting ishu:ishu isguo:YES];
            });
            
        }
        
    });
    
}
#pragma mark - 出牌操作
-(void) addCharFromPerson:(NSString *) acha FromLibrary:(NSString *)achaLibrary{
    
    
    
    if (_tingSet) {//听状态 下自动操作
        
        self.save_step_tingOtherChar = acha;
        self.save_step_tingCacheLibraryChar = achaLibrary;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([_tingNeedChar containsObject:acha] || [acha isEqualToString:WNKEY]) {
                
                self.save_step = 1;
                
//                [self setupTingData_ByHuChar:acha];
//                NSLog(@"鸡胡");
//                [self.charArray addObject:acha];
//                [self cardToIn:acha];
                
                if (self.deskDirect == DeskDirect_TOP) {
                    
                    [self setupTingData_ByHuChar:acha];
                    NSLog(@"鸡胡");
                    [self.charArray addObject:acha];
                    [self cardToIn:acha];
                    
                    NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
                    if (targetword != nil && targetword.count>0) {
                        [dic_preWordsArray addObjectsFromArray:targetword];
                    }
                    [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
                }else{
                    [self resetControlByisEat:NO isting:NO ishu:TRUE isguo:TRUE];
                }
                
            }else
                if ([_tingNeedChar containsObject:achaLibrary] || [achaLibrary isEqualToString:WNKEY]) {
//                    self.save_step = 2;
                    [self setupTingData_ByHuChar:achaLibrary];
                    NSLog(@"自摸胡");
                    [self.charArray addObject:achaLibrary];
                    [self cardToIn:achaLibrary];
                    
                    if (self.deskDirect == DeskDirect_TOP) {
                        NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
                        if (targetword != nil && targetword.count>0) {
                            [dic_preWordsArray addObjectsFromArray:targetword];
                        }
                        
                        [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
                    }else{
                        [self resetControlByisEat:NO isting:NO ishu:TRUE isguo:TRUE];
                    }
                    
                    
                }else{
                    [self.charArray addObject:achaLibrary];
                    [self cardToIn:achaLibrary];
                    
                    [self performSelector:@selector(actionOut:) withObject:achaLibrary afterDelay:0.5];
                    
                }
        });
        
    }
    
    else{//玩家操作
        
        //<<<<<<< .mine
        //    self.eatCharFromOther = acha;
        //    self.eatCharFromLibrary = achaLibrary;
        //
        //    BOOL theSame = [acha isEqualToString:achaLibrary];
        //
        //    NSMutableArray *tmp = [NSMutableArray array];
        //    [tmp addObjectsFromArray:self.charArray];
        //    [tmp addObject:acha];
        //    NSDictionary *dic = [[MajHelper shareHelper] start:tmp];
        //    dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
        //    dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
        //    dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
        //    dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
        //    dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
        //
        //        if (dic_error == 0) {
        //        }else
        //            [self save_clean];
        //
        //        if (dic_error == 1) {
        //            [dic_resultArray removeAllObjects];
        //            dic_resultArray = [dic objectForKey:@"tingarray"];
        //            [self save_copy];
        //        }
        //
        //
        //
        //
        //
        ////    NSDictionary *eatDic = [self canEat:dic_correctString byCHar:acha inArray:eatTmp];
        //    NSMutableDictionary *eatDic = [self canEatFromAreadlyWords:dic_preWordsArray lastChars:dic_lastCharArray byChar:acha allChars:tmp];
        //    dic_eatDic = eatDic;
        //
        //        NSMutableDictionary *eatDicAll = [self canEatFromLibrary:[[MajHelper shareHelper] getWordsArray] allchars:self.charArray bychar:acha];
        //        dic_eatDicAll = eatDicAll;
        //
        //
        //
        //        self.stepFromOtherOrLibrary = 1;
        //
        //
        //    BOOL iseat =FALSE;
        //    BOOL iseatall =FALSE;
        //    BOOL ishu =FALSE;
        //    BOOL isting=FALSE;
        //
        //        iseatall = [[eatDicAll objectForKey:@"eat"] boolValue];
        //
        //    if ([[eatDic objectForKey:@"eat"] boolValue] ) {
        //        iseat = TRUE;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self setLogoInfo:dic];
        //        });
        //    }else{
        //
        //    }
        //    if (dic_error == 0) {
        //        ishu = TRUE;
        //    }
        //    if (dic_error==1) {
        //        isting = TRUE;
        //    }
        //
        //    if (self.deskDirect == DeskDirect_TOP) { //电脑
        //        if (iseat) {
        //            NSLog(@"吃");
        //            [self.charArray addObject:acha];
        //            [self cardToIn:acha];
        //            NSString *word = [eatDic objectForKey:@"eatword"];
        //            [self actionEat:word];
        //            NSString *c0 = [dic_lastCharArray objectAtIndex:0];
        //            [self actionOut:c0];
        //            PopView*pop=  [self popViewByType:AnimalType_CHI];
        //            [pop show];
        //            if (isting) {
        //                //因为不计算，prewordsArray里会多出已经吃过的
        //                NSInteger index = [dic_preWordsArray indexOfObject:word];
        //                if (index != NSNotFound) {
        //                    [dic_preWordsArray removeObjectAtIndex:index];
        //                }
        //                _tingSet = TRUE;
        ////                _tingNeedChar = [dic_needCharArray objectAtIndex:0];
        ////                _tingLastChar = [dic_lastCharArray objectAtIndex:0];
        //                NSString *targetChar = c0;
        //                [self setupTingData_getNeedAndLastArray:targetChar];
        //                [self actionTing];
        //                PopView*pop=  [self popViewByType:AnimalType_TING];
        //                pop.finishedBlock = ^(id bean){
        //                    [self beginAnimalTing:pop];
        //                };
        //                [pop show];
        //            }
        //
        //        }
        //        else{
        //            [self.charArray addObject:achaLibrary];
        //            [self cardToIn:achaLibrary];
        //=======
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //>>>>>>> .r1699
            
            
            if (_deskDirect == DeskDirect_BOTTOM) {
                for (NSString * charc in self.charArray) {
                    NSLog(@"c:%@",charc);
                }
                NSLog(@"");
            }
            
            self.eatCharFromOther = acha;
            self.eatCharFromLibrary = achaLibrary;
            
            BOOL theSame = [acha isEqualToString:achaLibrary];
            
            NSMutableArray *tmp = [NSMutableArray array];
            [tmp addObjectsFromArray:self.charArray];
            [tmp addObject:acha];
            NSDictionary *dic = [[MajHelper shareHelper] start:tmp];
            dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
            dic_tingArray = [dic objectForKey:@"tingarray"];
            dic_huArray = [dic objectForKey:@"huarray"];
            dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
            dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
            dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
            dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
            //<<<<<<< .mine
            
            if (dic_error == 0) {
            }else
                [self save_clean];
            
            
            //=======
            
            //>>>>>>> .r1699
            if (dic_error == 1) {
                [dic_resultArray removeAllObjects];
                dic_resultArray = [dic objectForKey:@"tingarray"];
                [self save_copy];
            }
            
            //    NSDictionary *eatDic = [self canEat:dic_correctString byCHar:acha inArray:eatTmp];
            NSMutableDictionary *eatDic = [self canEatFromAreadlyWords:dic_preWordsArray lastChars:dic_lastCharArray byChar:acha allChars:tmp];
            dic_eatDic = eatDic;
            
            NSMutableDictionary *eatDicAll = [self canEatFromLibrary:[[MajHelper shareHelper] getWordsArray] allchars:self.charArray bychar:acha];
            dic_eatDicAll = eatDicAll;
            
            
            
            //<<<<<<< .mine
            //                        if (is-eat || iseatall) {
            //                              [self resetControlByisEat:(iseat || iseatall) isting:NO ishu:NO isguo:TRUE];
            //                        }else{
            //                            if (!alreadPostCard) {
            //                                [self resetControlByisEat:NO isting:NO ishu:YES isguo:TRUE];
            //                            }else{
            //                                [self resetControlByisEat:NO isting:YES ishu:NO isguo:TRUE]; //组装
            //                                [self setupResultWhenHu2Ting];
            //                            }
            //                            //此处更新存储 ，如果是"会er"做特殊处理
            //                        }
            
            //=======
            self.stepFromOtherOrLibrary = 1;
            //>>>>>>> .r1699
            
            
            BOOL iseat =FALSE;
            BOOL iseatall =FALSE;
            BOOL ishu =FALSE;
            BOOL isting=FALSE;
            
            iseatall = [[eatDicAll objectForKey:@"eat"] boolValue];
            
            //<<<<<<< .mine
            
            
            //        }
            //        else{
            //
            //            self.stepFromOtherOrLibrary = 2;
            //
            //            [self.charArray addObject:achaLibrary];
            //            [self cardToIn:achaLibrary];
            //            dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //
            //
            //
            //            NSMutableArray *tmp = [NSMutableArray array];
            //            [tmp addObjectsFromArray:self.charArray];
            //            NSDictionary *dic = [[MajHelper shareHelper] start:tmp];
            //
            //            dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
            //            dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
            //            dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
            //            dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
            //            dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
            //
            //                            if (dic_error == 0) {
            //                            }else
            //                                [self save_clean];
            //
            //                            if (dic_error == 1) {
            //                                [dic_resultArray removeAllObjects];
            //                                dic_resultArray = [dic objectForKey:@"tingarray"];
            //                                [self save_copy];
            //                            }
            //
            
            //=======
            if ([[eatDic objectForKey:@"eat"] boolValue] ) {
                iseat = TRUE;
                //>>>>>>> .r1699
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setLogoInfo:dic];
                });
            }else{
                
            }
            if (dic_error == 0) {
                ishu = TRUE;
            }
            if (dic_error==1) {
                isting = TRUE;
            }
            
            
            if (self.deskDirect == DeskDirect_TOP) { //电脑
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue() , ^{//电脑延时1秒出牌
                    if (iseat) {//电脑吃的状态下操作
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSLog(@"吃");
                            
                            [self.charArray addObject:acha];
                            [self cardToIn:acha];
                            NSString *word = [eatDic objectForKey:@"eatword"];
                            [self actionEat:word];
                            NSString *c0 = [dic_lastCharArray objectAtIndex:0];
                            [self actionOut:c0];
                            PopView*pop=  [self popViewByType:AnimalType_CHI];
                            [pop show];
                            if (isting) {
                                
                                //因为不计算，prewordsArray里会多出已经吃过的
                                NSInteger index = [dic_preWordsArray indexOfObject:word];
                                if (index != NSNotFound) {
                                    [dic_preWordsArray removeObjectAtIndex:index];
                                }
                                _tingSet = TRUE;
                                //                _tingNeedChar = [dic_needCharArray objectAtIndex:0];
                                //                _tingLastChar = [dic_lastCharArray objectAtIndex:0];
                                NSString *targetChar = c0;
                                [self setupTingData_getNeedAndLastArray:targetChar];
                                [self actionTing];
                                PopView*pop=  [self popViewByType:AnimalType_TING];
                                pop.finishedBlock = ^(id bean){
                                    [self beginAnimalTing:pop];
                                };
                                [pop show];
                            }
                        });
                        
                    }
                    else{//电脑普通出牌
                        
                        [self.charArray addObject:achaLibrary];
                        [self cardToIn:achaLibrary];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            NSMutableArray *tmptmp = [NSMutableArray array];
                            [tmptmp addObjectsFromArray:self.charArray];
                            NSDictionary *dic = [[MajHelper shareHelper] start:tmptmp];
                            dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
                            dic_tingArray = [dic objectForKey:@"tingarray"];
                            dic_huArray = [dic objectForKey:@"huarray"];
                            dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
                            dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
                            dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
                            dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
                            
                            
                            if (dic_error == 1) {
                                [dic_resultArray removeAllObjects];
                                dic_resultArray = [dic objectForKey:@"tingarray"];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self setLogoInfo:dic];
                            });
                            
                            BOOL iseat =FALSE;
                            BOOL ishu =FALSE;
                            BOOL isting=FALSE;
                            
                            if (dic_error == 0) {
                                ishu = TRUE;
                            }
                            if (dic_error==1) {
                                isting = TRUE;
                            }
                            
                            
                            if (isting) {
                                _tingSet = TRUE;
                                //                _tingNeedChar = [dic_needCharArray objectAtIndex:0];
                                //                _tingLastChar = [dic_lastCharArray objectAtIndex:0];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSMutableArray *targetArray = [[dic_resultArray objectAtIndex:0] objectForKey:@"last"];
                                    NSString *targetChar ;
                                    if (targetArray.count>0) {
                                        targetChar = [targetArray objectAtIndex:0];
                                        [self setupTingData_getNeedAndLastArray:targetChar];
                                    }
                                    
                                    [self actionTing];
                                    PopView*pop=  [self popViewByType:AnimalType_TING];
                                    pop.finishedBlock = ^(id bean){
                                        [self beginAnimalTing:pop];
                                    };
                                    [pop show];
                                });
                                
                            }
                            
                            if (ishu) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSLog(@"胡");
                                    NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
                                    if (targetword != nil && targetword.count>0) {
                                        [dic_preWordsArray addObjectsFromArray:targetword];
                                    }
                                    
                                    PopView*pop=  [self popViewByType:AnimalType_HU];
                                    [pop show];
                                    [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
                                });
                                
                                
                            }
                            else{
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),dispatch_get_main_queue() , ^{
                                    NSString *c0 = [dic_lastCharArray objectAtIndex:0];
                                    
                                    if (self.charArray.count != self.charViewArray.count) {
                                        NSLog(@"error");
                                    }
                                    [self actionOut:c0];
                                });
                                
                                
                            }
                            
                        });
                        
                        
                    }
                    
                });
                
            }
            else{//玩家操作
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //<<<<<<< .mine
                    
                    
                    //=======
                    if (self.didRefreshWordView) {
                        self.didRefreshWordView(self.charArray);
                    }
                    if (iseat || ishu || iseatall) {
                        
                        if (iseat || iseatall) {
                            [self resetControlByisEat:(iseat || iseatall) isting:NO ishu:NO isguo:TRUE];
                        }else{
                            if (!alreadPostCard) {
                                [self resetControlByisEat:NO isting:NO ishu:YES isguo:TRUE];
                            }else{
                                [self setupResultWhenHu2Ting];
                                [self resetControlByisEat:NO isting:YES ishu:NO isguo:TRUE]; //组装
                                
                            }
                            //此处更新存储 ，如果是"会er"做特殊处理
                        }
                        
                        NSMutableArray *earray = [NSMutableArray array];
                        if (iseatall) {
                            NSArray *all = [dic_eatDicAll objectForKey:@"eatword"];
                            [earray addObjectsFromArray:all];
                        }
                        [self freshEatView:earray];
                        
                        
                        
                        
                    }  else{
                        
                        if (_deskDirect == DeskDirect_BOTTOM) {
                            NSLog(@"");
                        }
                        
                        self.stepFromOtherOrLibrary = 2;
                        
                        [self.charArray addObject:achaLibrary];
                        [self cardToIn:achaLibrary];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            
                            
                            
                            NSMutableArray *tmp = [NSMutableArray array];
                            [tmp addObjectsFromArray:self.charArray];
                            NSDictionary *dic = [[MajHelper shareHelper] start:tmp];
                            dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
                            dic_tingArray = [dic objectForKey:@"tingarray"];
                            dic_huArray = [dic objectForKey:@"huarray"];
                            dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
                            dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
                            dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
                            dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
                            
                            
                            
                            if (dic_error == 0) {
                            }else
                                [self save_clean];
                            
                            if (dic_error == 1) {
                                [dic_resultArray removeAllObjects];
                                dic_resultArray = [dic objectForKey:@"tingarray"];
                                [self save_copy];
                            }
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self setLogoInfo:dic];
                                self.borderState = TRUE;
                            });
                            
                            BOOL iseat =FALSE;
                            BOOL ishu =FALSE;
                            BOOL isting=FALSE;
                            
                            if (dic_error == 0) {
                                ishu = TRUE;
                            }
                            if (dic_error==1) {
                                isting = TRUE;
                                //                tingState = TRUE;
                                
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (ishu) {
                                    if (!_tingSet) {
                                        [self setupResultWhenHu2Ting];
                                        [self resetControlByisEat:false isting:YES ishu:FALSE isguo:YES]; //组装
                                        
                                    }else{
                                        [self resetControlByisEat:false isting:FALSE ishu:ishu isguo:NO];
                                        
                                    }
                                }else
                                    [self resetControlByisEat:false isting:isting ishu:ishu isguo:NO];
                                
                                //                                if (ishu) {
                                //                                    if (!_tingSet) {
                                //                                        [self resetControlByisEat:false isting:YES ishu:FALSE isguo:NO];
                                //                                    }else{
                                //                                        [self resetControlByisEat:false isting:FALSE ishu:ishu isguo:NO];
                                //                                    }
                                //                                }else
                                //                                    [self resetControlByisEat:false isting:isting ishu:ishu isguo:NO];
                            });
                            
                        });
                    }
                    
                });
                
            }
            
        });
        
    }//
}

#pragma mark ”听“ 提示集数据

-(void) setupTingData_getNeedAndLastArray:(NSString *) chuChar{
    if (_tingNeedChar == nil) {
        _tingNeedChar = [NSMutableArray array];
    }else
        [_tingNeedChar removeAllObjects];
    
    if (_tingLastChar == nil) {
        _tingLastChar = [NSMutableArray array];
    }else
        [_tingLastChar removeAllObjects];
    
    for (NSDictionary * tmp in dic_resultArray) {
        NSMutableArray *tmpaaa = [tmp objectForKey:@"last"];
        if ([tmpaaa containsObject:chuChar]) {
            NSLog(@"");
        }
        if ([[tmp objectForKey:@"last"] containsObject:chuChar]) {
            id needa = [tmp objectForKey:@"need"];
            if (needa != nil && [needa isKindOfClass:[NSArray class]]) {
                NSArray *needArray = (NSArray *) needa;
                [_tingNeedChar addObjectsFromArray:needArray];
            }
            
            id lasta = [tmp objectForKey:@"last"];
            if (lasta != nil && [lasta isKindOfClass:[NSArray class]]) {
                NSArray *lastArray = (NSArray *) lasta;
                [_tingLastChar addObjectsFromArray:lastArray];
            }
        }
        
    }
    
}
-(void) setupTingData_ByHuChar:(NSString *) huChar{
    
    
    if ([huChar isEqualToString:WNKEY]) {
        NSDictionary *tmp = [dic_resultArray objectAtIndex:0];
        id needa = [tmp objectForKey:@"need"];
        if (needa != nil && [needa isKindOfClass:[NSArray class]]) {
            NSArray *needArray = (NSArray *) needa;
            [_tingNeedChar addObjectsFromArray:needArray];
        }
        
        huChar = [_tingNeedChar objectAtIndex:0];
    }
    {
        
        NSDictionary *dic;
        for (NSInteger i = 0; i<dic_resultArray.count; i++) {
            NSDictionary *tmp = [dic_resultArray objectAtIndex:i];
            if ([[tmp objectForKey:@"need"] containsObject:huChar]) {
                dic = tmp;
                break;
            }
        }
        if (dic) {
            dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
            dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
            dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
            dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
        }else{
            
        }
    }
}
-(void) freshUIWhenTingState{
    NSMutableArray *lastArrayTmp = [NSMutableArray array];
    NSMutableArray *needArrayTmp = [NSMutableArray array];
    
    for (NSInteger i = 0; i<dic_resultArray.count; i++) {
        NSDictionary *dic = [dic_resultArray objectAtIndex:i];
        NSArray *lastArray = [dic objectForKey:@"last"];
        NSString *lastChar;
        if (lastArray.count >0) {
            lastChar = [lastArray objectAtIndex:0];
        }
        NSArray *needArray =[dic objectForKey:@"need"];
        NSString *needChar ;
        if (needArray.count>0) {
            needChar = [needArray objectAtIndex:0];
        }
        if (lastChar) {
            [lastArrayTmp addObject:lastChar];
        }
        if (needChar) {
            [needArrayTmp addObject:needChar];
        }
    }
    
    NSMutableArray *cardViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i<lastArrayTmp.count; i++) {
        NSString *cc = [lastArrayTmp objectAtIndex:i];
        for (NSInteger j = self.charViewArray.count-1; j>=0; j--) {
            CardView *view = [self.charViewArray objectAtIndex:j];
            if ([[view charV] isEqualToString:cc]) {
                [cardViewArray addObject:view];
                //                break;
            }
        }
    }
    
    if (self.tingLayerViewArray == nil) {
        self.tingLayerViewArray = [NSMutableArray array];
    }else
        [self.tingLayerViewArray removeAllObjects];
    
    [self.tingLayerViewArray addObjectsFromArray:cardViewArray];
    
    
    
    for (NSInteger i = 0; i<self.charViewArray.count; i++) {
        CardView *tmp = [self.charViewArray objectAtIndex:i];
        if ([cardViewArray containsObject:tmp]) {
            
            [tmp showTingRenminder:YES];
            [tmp showTingLayer:NO];
        }else{
            
            [tmp showTingLayer:YES];
            [tmp showTingRenminder:NO];
        }
    }
}

-(void) moveLayerForCard{
    for (CardView * card in self.charViewArray) {
        [card showTingLayer:NO];
    }
}
-(void) moveReminderViewForCard{
    for (CardView *card in self.charViewArray) {
        [card showTingRenminder:NO];
    }
}


-(void) setupResultWhenHu2Ting{
    
    /**
    
    //加上上次ting的
    BOOL needFlag = TRUE;
    if (ss_dic_error == NSNotFound) {
        needFlag = FALSE;
    }
    if (ss_dic_correctString == nil) {
        needFlag = FALSE;
    }
    
    NSMutableArray *ss_tmp_array ;
    if (needFlag) {
        ss_tmp_array = [NSMutableArray array];
        [ss_tmp_array addObject:ss_dic_correctString];
        [ss_tmp_array addObjectsFromArray:ss_dic_preWordsArray];
    }
    
    
    
    
    NSMutableArray *targetPreWords = [NSMutableArray array];
    if (ss_dic_correctString != nil) {
        [targetPreWords addObject:ss_dic_correctString];
    }
    if (ss_dic_preWordsArray != nil && ss_dic_preWordsArray.count>0) {
        [targetPreWords addObjectsFromArray:ss_dic_preWordsArray];
    }
    
    NSMutableArray *dealed  = [NSMutableArray array];
    for (NSInteger i = 0; i<self.charViewArray.count; i++) {
        CardView *cTmp = [self.charViewArray objectAtIndex:i];
        NSString *cCharTmp = [cTmp charV];
        if ([cCharTmp isEqualToString:WNKEY]) {
            continue;
        }
        if ([dealed containsObject:cCharTmp]) {
            continue;
        }
        [dealed addObject:cCharTmp];
        
        for (NSInteger ii = 0; ii<targetPreWords.count; ii++) {
            NSString *word = [targetPreWords objectAtIndex:ii];
            NSRange index = [word rangeOfString:cCharTmp];
            if (index.location == NSNotFound) {
                continue;
            }
            NSMutableDictionary *tmpDic = [self genDicWithChars:word withLastAndNeedChar:cCharTmp withPreWordNotIncludeAtIndex:ii withAllWordsArray:targetPreWords];
            if (dic_resultArray == nil) {
                dic_resultArray = [NSMutableArray array];
            }
            [dic_resultArray addObject:tmpDic];
            
            
            if ([cCharTmp isEqualToString:@"a"]) {
                NSLog(@"");
            }
            
            if (needFlag) {
                if ([word isEqualToString:ss_dic_correctString]) {
                    if ([self isSameAllWords:ss_tmp_array withTargetArray:targetPreWords]) {
                        
                        
                        NSString *add_tmp_last_str  = nil;
                        for (NSInteger tmpi = 0; tmpi<ss_dic_resultArray.count; tmpi++) {
                            
                            NSMutableDictionary *tiDic = [ss_dic_resultArray objectAtIndex:tmpi];
                            NSMutableArray *add_tmp_need = [tiDic objectForKey:@"need"];
                            NSString *add_tmp_need_str = nil;
                            if (add_tmp_need.count>0) {
                                add_tmp_need_str = [add_tmp_need objectAtIndex:0];
                            }
                            
                            if ([add_tmp_need_str isEqualToString:cCharTmp]) {
                                NSMutableArray *add_tmp_last = [tiDic objectForKey:@"last"];
                                if (add_tmp_last.count>0) {
                                    add_tmp_last_str = [add_tmp_last objectAtIndex:0];
                                    break;
                                }
                                
                            }
                            
                        }
                        
                        if (add_tmp_last_str != nil) {
                            for (NSInteger tmpj = 0; tmpj<ss_dic_resultArray.count; tmpj++) {
                                NSMutableDictionary *tjDic = [ss_dic_resultArray objectAtIndex:tmpj];
                                NSMutableArray *j_last = [tjDic objectForKey:@"last"];
                                NSMutableArray *j_need = [tjDic objectForKey:@"need"];
                                if ([j_last containsObject:add_tmp_last_str] && (![j_need containsObject:cCharTmp])) {
                                    NSMutableDictionary *todic = [NSMutableDictionary dictionaryWithDictionary:tjDic];
                                    NSMutableArray *new_last = [NSMutableArray arrayWithObject:cCharTmp];
                                    [todic setObject:new_last forKey:@"last"];
                                    [dic_resultArray addObject:todic];
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    NSLog(@"");
    
    **/
    
    
    
    
  NSMutableArray *tmp=  [[MajHelper shareHelper] cacalHu:self.charArray withHuWordsArray:dic_huArray withTingWordsArray:dic_tingArray];
    [dic_resultArray addObjectsFromArray:tmp];
}

-(void) setupResultWhenHu2Ting_2{
    
    
}

//{
//    chars = eyes;
//    error = 0;
//    last =     (
//    "i"
//    );
//    need =     (
//    "a"
//    );
//    prewords =     (
//                    bed,
//                    day,
//                    eyes
//                    );
//
//    chars = eyes;
//    error = 0;
//    last =     (
//    "i"
//    );
//    need =     (
//    "r"
//    );
//    prewords =     (
//                    bed,
//                    day,
//                    eyes
//                    );
//
//}

-(BOOL) isSameAllWords:(NSMutableArray *) sourceArray withTargetArray:(NSMutableArray *) targetArray{
    
    if (sourceArray.count != targetArray.count) {
        return false;
    }
    
    [sourceArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    
    [targetArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    
    
    
    
    BOOL same = true;
    for (NSInteger i = 0; i < sourceArray.count; i++) {
        
        id w1 = [sourceArray objectAtIndex:i];
        id w2 = [targetArray objectAtIndex:i];
        
        if (![w1 isEqualToString:w2]) {
            same = false;
            break;
        }
    }
    return same;
}

-(NSMutableDictionary *) genDicWithChars:(NSString *) chars withLastAndNeedChar:(NSString *) clanc withPreWordNotIncludeAtIndex:(NSInteger) index withAllWordsArray:(NSMutableArray *) allWords{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:chars forKey:@"chars"];
    [result setObject:@(1) forKey:@"error"];
    [result setObject:[NSMutableArray arrayWithObject:clanc] forKey:@"last"];
    [result setObject:[NSMutableArray arrayWithObject:clanc] forKey:@"need"];
    
    NSMutableArray *prewords = [NSMutableArray array];
    for (NSInteger i = 0; i<allWords.count; i++) {
        if (i != index) {
            [prewords addObject:[allWords objectAtIndex:i]];
        }
    }
    [result setObject:prewords forKey:@"prewords"];
    return result;
}

-(void) showTingInfoViewForCard:(CardView *) card{
    if (self.tingInfoView == nil || self.tingInfoView.superview == nil) {
        [self addSubview:self.tingInfoView];
    }
    [self.tingInfoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *charc = [card charV];
    
    
    NSMutableArray *lastArrayTmp = [NSMutableArray array];
    NSMutableArray *needArrayTmp = [NSMutableArray array];
    for (NSInteger i = 0; i<dic_resultArray.count; i++) {
        NSDictionary *dic = [dic_resultArray objectAtIndex:i];
        NSArray *lastArray = [dic objectForKey:@"last"];
        NSString *lastChar ;
        if (lastArray.count >0) {
            lastChar = [lastArray objectAtIndex:0];
        }
        NSArray *needArray =[dic objectForKey:@"need"];
        NSString *needChar ;
        if (needArray.count>0) {
            needChar = [needArray objectAtIndex:0];
        }
        if (lastChar) {
            [lastArrayTmp addObject:lastChar];
        }
        if (needChar) {
            [needArrayTmp addObject:needChar];
        }
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i<lastArrayTmp.count; i++) {
        if ([charc isEqualToString:[lastArrayTmp objectAtIndex:i]]) {
            if (i<needArrayTmp.count) {
                NSString *targetTMp = [needArrayTmp objectAtIndex:i];
                if (![result containsObject:targetTMp]) {
                    [result addObject:targetTMp];
                }
                
            }
        }
    }
    
    float marx = 0;
    float mary = 0;
    
    for (NSInteger i = 0; i<result.count; i++) {
        NSString *cA = [result objectAtIndex:i];
        CardView *cardtmp = [[CardView alloc] initWithFrame:CGRectMake(marx, mary, self.tingInfoCardSize.width, self.tingInfoCardSize.height) withChar:cA isBack:NO];
        [self.tingInfoView addSubview:cardtmp];
        [self.tingInfoView sendSubviewToBack:cardtmp];
        marx += self.tingInfoCardSize.width;
        if (i == 0) {
            marx += self.tingInfoCardMargin;
        }
    }
    self.tingInfoView.frame = CGRectMake(0, 0, self.tingInfoCardSize.width * result.count, self.tingInfoCardSize.height);
    self.tingInfoView.center = CGPointMake(card.center.x, card.frame.origin.y - self.tingInfoCardSize.height);
    
}
-(void) hiddenTingInfoViewForCard:(CardView *) card{
    [self.tingInfoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tingInfoView removeFromSuperview];
    self.tingInfoView = nil;
}


-(NSMutableDictionary *) canEatFromAreadlyWords:(NSMutableArray *) words lastChars:(NSMutableArray *) chars byChar:(NSString *) bychar allChars:(NSMutableArray *) allChars{
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    BOOL caneat = FALSE;
    NSString *eatWord;
    if ([chars indexOfObject:bychar] != NSNotFound) {
        [returnDic addEntriesFromDictionary:@{@"eat":[NSNumber numberWithBool:caneat]}];
        return returnDic;
        //        return @{@"eat":[NSNumber numberWithBool:caneat]};
    }
    
    for (NSInteger i = 0; i<words.count; i++) {
        NSString *word = [words objectAtIndex:i];
        if ([word containsString:bychar]) {
            caneat = TRUE;
            eatWord = word;
            break;
        }
        
    }
    
    if (caneat) {
        [returnDic addEntriesFromDictionary:@{@"eat":[NSNumber numberWithBool:caneat],@"eatword":eatWord}];
    }else{
        [returnDic addEntriesFromDictionary:@{@"eat":[NSNumber numberWithBool:caneat]}];
    }
    return returnDic;
    
}

-(NSMutableDictionary *) canEatFromLibrary:(NSMutableArray *) words allchars:(NSMutableArray *) chars bychar:(NSString *) bychar{
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    NSMutableArray *returnWords = [NSMutableArray array];
    
    NSMutableArray *tmpChars = [NSMutableArray array];
    [tmpChars addObjectsFromArray:chars];
    [tmpChars addObject:bychar];
    
    for (NSInteger i = 0; i<words.count; i++) {
        NSString *word  =  [words objectAtIndex:i];
        
        if ([[MajHelper shareHelper] checkVailWord:word.length chars:tmpChars.count]) {
            if ([word containsString:bychar]) {
                NSDictionary *dic =   [[MajHelper shareHelper] compareWord:word inArray:tmpChars useWNKey:YES];
                NSInteger error = [[dic objectForKey:@"error"] integerValue];
                if (error == 0) {
                    [returnWords addObject:word];
                }
            }
            
        }
    }
    
    if (returnWords.count>0) {
        [returnDic addEntriesFromDictionary:@{@"eat":[NSNumber numberWithBool:TRUE],@"eatword":returnWords}];
    }else
        [returnDic addEntriesFromDictionary:@{@"eat":[NSNumber numberWithBool:FALSE]}];
    return returnDic;
    
    
    
}


-(void) actionEatWithAll:(NSString *) eatWord{
    
    BOOL iseat = FALSE;
    BOOL iseatall = FALSE;
    BOOL ishu =FALSE;
    BOOL isting=FALSE;
    
    iseat = [[dic_eatDic objectForKey:@"eat"] boolValue];
    iseatall =[[dic_eatDicAll objectForKey:@"eat"] boolValue];
    
    if (dic_error == 0) {
        ishu = TRUE;
    }
    if (dic_error==1) {
        isting = TRUE;
    }
    
    if ([dic_preWordsArray containsObject:eatWord]) {
        [self resetControlByisEat:NO isting:NO ishu:NO isguo:NO];
        [self.charArray addObject:self.eatCharFromOther];
        [self cardToIn:self.eatCharFromOther];
        //        NSString *word = [dic_eatDic objectForKey:@"eatword"];
        [self actionEat:eatWord];
        if (isting) {
            //            tingState = TRUE;
            
            //把吃的单词从ting结果中删除，刷新的时候避免找不到单词
            for (NSInteger i = 0; i<dic_resultArray.count; i++) {
                NSDictionary *tmp = [dic_resultArray objectAtIndex:i];
                NSMutableArray *prewords = [tmp objectForKey:@"prewords"];
                NSInteger index = [prewords indexOfObject:eatWord];
                if (index != NSNotFound) {
                    [prewords removeObjectAtIndex:index];
                }else{
                    NSString *chars = [tmp objectForKey:@"chars"];
                    
                }
            }
            
            [self resetControlByisEat:NO isting:YES ishu:NO isguo:NO];
        }
        
    }else{
        [self resetControlByisEat:NO isting:NO ishu:NO isguo:NO];
        [self.charArray addObject:self.eatCharFromOther];
        [self cardToIn:self.eatCharFromOther];
        //        NSString *word = [dic_eatDic objectForKey:@"eatword"];
        [self actionEat:eatWord];
    }
    
}

#pragma mark 点击按钮
-(void) actionControl:(UIButton *) button{ //tag+1000
    
    
    
    BOOL ishu =FALSE;
    BOOL isting=FALSE;
    if (dic_error == 0) {
        ishu = TRUE;
    }
    if (dic_error==1) {
        isting = TRUE;
    }
    
    
    switch (button.tag-1000) {
        case 0: //吃
        {
            
            
            if (self.selectedEatWord == nil) {
                if (self.didError) {
                    self.didError(@"请先选择要吃的单词");
                    return;
                }
            }
            
            {
                self.eatView.hidden = YES;
                
                NSString *word = self.selectedEatWord;
                [self actionEatWithAll:word];
                
                for (UIView *v in [self.eatView subviews]) {
                    if (v == _eatViewBackground || v == _eatViewReminder) {
                        continue;
                    }
                    [v.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [v removeFromSuperview];
                }
                
                self.selectedEatWord = nil;
                
            }
            
            {
                if (self.didRefreshWordView) {
                    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.charArray];
                    self.didRefreshWordView(tmp);
                }
            }
            
            
            
            
        }
            break;
        case 100://组
        {
            
            //            self.borderState = !self.borderState;
            NSMutableArray *tmp = [NSMutableArray array];
            for (NSInteger i = 0; i<self.charViewArray.count; i++) {
                CardView *cv = [self.charViewArray objectAtIndex:i];
                if (cv.isUpState) {
                    [tmp addObject:cv];
                }
            }
            [self.charViewArray removeObjectsInArray:tmp];
            [self.charViewArray insertObjects:tmp atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tmp.count)]];
            [self actionDownForDoubleClick];
            [self resetFrame];
        }
            break;
        case 1://听
            preTingState = TRUE;
            if ( dic_resultArray.count > 1) {
                self.eatView.hidden = YES;
                [self resetControlByisEat:NO isting:NO ishu:NO isguo:NO];
                [self freshUIWhenTingState];
                
                [self tingOperByButton:button];
                
                
            }else
            {
                self.eatView.hidden = YES;
                
                [self resetControlByisEat:NO isting:NO ishu:NO isguo:NO];
                
                //            _tingNeedChar = [dic_needCharArray objectAtIndex:0];
                //            _tingLastChar = [dic_lastCharArray objectAtIndex:0];
                NSMutableArray *targetArray = [[dic_resultArray objectAtIndex:0] objectForKey:@"last"];
                if (targetArray.count>0) {
                    NSString* targetChar = [targetArray objectAtIndex:0];
                    [self setupTingData_getNeedAndLastArray:targetChar];
                    tingPopChar = targetChar;
                }
                
                NSString *tmpLastChar = [_tingLastChar objectAtIndex:0];
                
                NSInteger index = [self.charArray indexOfObject:tmpLastChar];
                if (index != NSNotFound) {
                    CardView *targetCV;
                    for (NSInteger i = 0; i<self.charViewArray.count; i++) {
                        CardView *tmp = [self.charViewArray objectAtIndex:i];
                        if ([tmp.charV isEqualToString:tmpLastChar]) {
                            targetCV = tmp;
                            break;
                        }
                    }
                    if (targetCV) {
                        [self.charArray removeObjectAtIndex:index];
                        [targetCV removeFromSuperview];
                        [self.charViewArray removeObject:targetCV];
                    }
                    
                    [self cardToOutView:tmpLastChar];
                    [self resetFrame];
                }
                [self performSelector:@selector(callBack:) withObject:tmpLastChar afterDelay:0.1];
                
                _tingSet = TRUE;
                [self actionTing];
                
                [self tingOperByButton:button];
                
            }
            break;
        case 2://胡
        {
            
            
            [AnimalView stop];
            self.eatView.hidden = YES;
            //            [self resetControlByisEat:NO isting:NO ishu:NO isguo:NO];
            if (_tingSet) {
                
                
                NSString *targetChar = self.save_step==1? self.save_step_tingOtherChar : self.save_step_tingCacheLibraryChar;
                
                if (self.save_step == 1) {
                    [self setupTingData_ByHuChar:self.save_step_tingOtherChar];
                    NSLog(@"鸡胡");
                    [self.charArray addObject:self.save_step_tingOtherChar];
                    [self cardToIn:self.save_step_tingOtherChar];
                    self.save_step = 0;
                }
                
                
                
                
//                NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
//                if (targetword != nil && targetword.count>0) {
//                    [dic_preWordsArray addObjectsFromArray:targetword];
//                }
                
                NSDictionary *targetDic;
                for (NSDictionary * tmpDic in dic_resultArray) {
                    NSArray *tmpArr = [tmpDic objectForKey:@"need"];
                    NSArray *popArr = [tmpDic objectForKey:@"last"];
                    if (tmpArr.count>0 && popArr.count>0) {
                        NSString *cc = [tmpArr objectAtIndex:0];
                        NSString *pop = [popArr objectAtIndex:0];
                        if ([cc isEqualToString:targetChar] && [tingPopChar isEqualToString:pop]) {
                            targetDic = tmpDic;
                            break;
                        }
                    }
                }
                if (targetDic) {
                    NSMutableArray *tArray = [NSMutableArray array];
                    [tArray addObjectsFromArray:[targetDic objectForKey:@"prewords"]];
                    [tArray addObject:[targetDic objectForKey:@"chars"]];
                    
                    [dic_preWordsArray removeAllObjects];
                    [dic_preWordsArray addObjectsFromArray:tArray];
                }else{
                    
                    NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
                    if (targetword != nil && targetword.count>0) {
                        [dic_preWordsArray addObjectsFromArray:targetword];
                    }

                }
                
                
                
                
                [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
            }else
                if (self.stepFromOtherOrLibrary == 1) {
                    [self.charArray addObject:self.eatCharFromOther];
                    [self cardToIn:self.eatCharFromOther];
                    NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
                    if (targetword != nil && targetword.count>0) {
                        [dic_preWordsArray addObjectsFromArray:targetword];
                    }
                    
                    [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
                }else{
                    NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
                    if (targetword != nil && targetword.count>0) {
                        [dic_preWordsArray addObjectsFromArray:targetword];
                    }
                    [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
                }
            
        }
            break;
        case 3://过
        {
            //            tingState = FALSE;
            
            
            
            
            self.selectedEatWord = nil;
            [AnimalView stop];
            self.eatView.hidden = YES;
            
            [self resetControlByisEat:NO isting:NO ishu:NO isguo:NO];
            
            if (_tingSet) {
                if (self.save_step == 1) {
                    [self.charArray addObject:self.save_step_tingCacheLibraryChar];
                    [self cardToIn:self.save_step_tingCacheLibraryChar];
                    
                    [self performSelector:@selector(actionOut:) withObject:self.save_step_tingCacheLibraryChar afterDelay:0.5];
                    self.save_step = 0;
                }else
                [self performSelector:@selector(actionOut:) withObject:[self.charArray lastObject] afterDelay:0.5];
            }else
                if (self.stepFromOtherOrLibrary == 1) {
                    [self actionGuo:self.eatCharFromLibrary];
                }
            
        }
            break;
            
        default:
            break;
    }
    
    [button removeAnimalAll];
}

-(void) save_copy{
    ss_dic_error = dic_error;
    ss_dic_correctString = dic_correctString;
    
    if (ss_dic_lastCharArray == nil) {
        ss_dic_lastCharArray = [NSMutableArray array];
    }else
        [ss_dic_lastCharArray removeAllObjects];
    [ss_dic_lastCharArray addObjectsFromArray:dic_lastCharArray];
    
    if (ss_dic_needCharArray == nil) {
        ss_dic_needCharArray = [NSMutableArray array];
    }else
        [ss_dic_needCharArray removeAllObjects];
    [ss_dic_needCharArray addObjectsFromArray:dic_needCharArray];
    //    ss_dic_needCharArray =dic_needCharArray;
    
    if (ss_dic_preWordsArray == nil) {
        ss_dic_preWordsArray = [NSMutableArray array];
    }else
        [ss_dic_preWordsArray removeAllObjects];
    //    ss_dic_preWordsArray  = dic_preWordsArray;
    [ss_dic_preWordsArray addObjectsFromArray:dic_preWordsArray];
    
    if (ss_dic_resultArray == nil) {
        ss_dic_resultArray = [NSMutableArray array];
    }else
        [ss_dic_resultArray removeAllObjects];
    
    [ss_dic_resultArray addObjectsFromArray:dic_resultArray];
    //    ss_dic_resultArray = dic_resultArray;
}
-(void) save_clean{
    ss_dic_error = NSNotFound;
    ss_dic_correctString = nil;
    [ss_dic_lastCharArray removeAllObjects];
    [ss_dic_needCharArray removeAllObjects];
    [ss_dic_preWordsArray removeAllObjects];
    [ss_dic_resultArray removeAllObjects];
    ss_dic_lastCharArray = nil ;
    ss_dic_needCharArray =nil;
    ss_dic_preWordsArray  = nil;
    ss_dic_resultArray = nil;
}

#pragma ting-flag-click
-(void) tingOperByButton:(UIButton *) button{
    UIButton *tmp = [self createTingButton];
    CGRect frame = CGRectMake(self.controlView.frame.origin.x + button.frame.origin.x, self.controlView.frame.origin.y, button.frame.size.width, button.frame.size.height);
    tmp.frame = frame;
    [self addSubview:tmp];
    [tmp addTarget:self action:@selector(actionTingButtonFlag:) forControlEvents:UIControlEventTouchUpInside];
    [self beginAnimalTing:tmp];
}

-(void) actionTingButtonFlag:(UIButton *) button{
    
    if (!_tingSet) {
        return;
    }
    
    if (_tingFlagView != nil) {
        self.tingFlagView.hidden = ! self.tingFlagView.hidden;
    }else
    {
        
        if (_tingFlagView == nil) {
            [self addSubview:self.tingFlagView];
        }
        
        [self.tingFlagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSString *charc = tingPopChar;
        
        
        NSMutableArray *lastArrayTmp = [NSMutableArray array];
        NSMutableArray *needArrayTmp = [NSMutableArray array];
        for (NSInteger i = 0; i<dic_resultArray.count; i++) {
            NSDictionary *dic = [dic_resultArray objectAtIndex:i];
            NSArray *lastArray = [dic objectForKey:@"last"];
            NSString *lastChar ;
            if (lastArray.count >0) {
                lastChar = [lastArray objectAtIndex:0];
            }
            NSArray *needArray =[dic objectForKey:@"need"];
            NSString *needChar ;
            if (needArray.count>0) {
                needChar = [needArray objectAtIndex:0];
            }
            if (lastChar) {
                [lastArrayTmp addObject:lastChar];
            }
            if (needChar) {
                [needArrayTmp addObject:needChar];
            }
        }
        
        NSMutableArray *result = [NSMutableArray array];
        for (NSInteger i = 0; i<lastArrayTmp.count; i++) {
            if ([charc isEqualToString:[lastArrayTmp objectAtIndex:i]]) {
                if (i<needArrayTmp.count) {
//                    [result addObject:[needArrayTmp objectAtIndex:i]];
                    NSString *targetTMp = [needArrayTmp objectAtIndex:i];
                    if (![result containsObject:targetTMp]) {
                        [result addObject:targetTMp];
                    }

                }
            }
        }
        
        float marx = 0;
        float mary = 0;
        
        for (NSInteger i = 0; i<result.count; i++) {
            NSString *cA = [result objectAtIndex:i];
            CardView *cardtmp = [[CardView alloc] initWithFrame:CGRectMake(marx, mary, self.tingInfoCardSize.width, self.tingInfoCardSize.height) withChar:cA isBack:NO];
            [self.tingFlagView addSubview:cardtmp];
            [self.tingFlagView sendSubviewToBack:cardtmp];
            marx += self.tingInfoCardSize.width;
            if (i == 0) {
                marx += self.tingInfoCardMargin;
            }
            
            __weak PersonView *wself = self;
            [cardtmp addClickBlock:^(NSInteger tag) {
                NSLog(@"");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *cc = [cardtmp charV];
                    [wself sortCardByChar:cc];
                });
                
            }];
        }
        self.tingFlagView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y + self.headerView.frame.size.height - self.tingInfoCardSize.height, self.tingInfoCardSize.width * result.count, self.tingInfoCardSize.height);
        
    }
}

-(void) sortCardByChar:(NSString *) cc{
    //    11
    
    //    if (TRUE) {
    //        return;
    //    }
    
    
    //找到最后一个char
    
    
    NSDictionary *dic;
    for (NSDictionary * tmp in dic_resultArray) {
        if ([tmp objectForKey:@"need"] != nil && [[tmp objectForKey:@"need"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [tmp objectForKey:@"need"];
            if (array.count>0) {
                NSString *tmpchar = [array objectAtIndex:0];
                if ([tmpchar isEqualToString:cc]) {
                    dic = tmp;
                    break;
                }
            }
        }
    }
    
    if (dic == nil) {
        return;
    }
    
    NSMutableArray *words = [NSMutableArray array];
    [words addObjectsFromArray:[dic objectForKey:@"prewords"]];
    
    NSString *word = [dic objectForKey:@"chars"];
    NSString *charr = [[dic objectForKey:@"need"] objectAtIndex:0];
    BOOL alread = FALSE;
    NSMutableString *mustring = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i<word.length; i++) {
        NSString *sub = [word substringWithRange:NSMakeRange(i, 1)];
        if ([sub isEqualToString:charr] && (!alread)) {
            alread = TRUE;
        }
        [mustring appendString:sub];
    }
    [words addObject:mustring];
    
    
    NSMutableArray *newCharViewArray = [NSMutableArray array];
    for (NSInteger i = 0; i<words.count; i++) {
        NSString *ww = [words objectAtIndex:i];
        for (NSInteger j = 0; j<ww.length; j++) {
            NSString *jChar = [ww substringWithRange:NSMakeRange(j, 1)];
            BOOL have = NO;
            
            for (NSInteger z = 0; z<self.charViewArray.count; z++) {
                CardView *zCard = [self.charViewArray objectAtIndex:z];
                NSString *zchar = [zCard charV];
                
                if ([zchar isEqualToString:jChar]) {
                    if ([newCharViewArray containsObject:zCard]) {
                        continue;
                    }else{
                        [newCharViewArray addObject:zCard];
                        have = TRUE;
                        break;
                    }
                }
            }
            
            if (!have) {
                
            }
            
        }
    }
    
    
    
    
//    [self.charViewArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        CardView *c1 = (CardView *)obj1;
//        CardView *c2 = (CardView *)obj2;
//        return [[c1 charV] compare:[c2 charV] options:NSNumericSearch];
//    }];
    
    for (CardView * c in newCharViewArray) {
        [self.charViewArray removeObject:c];
        [self.charViewArray insertObject:c atIndex:0];
        
        
    }
    
    [self.charViewArray replaceObjectsInRange:NSMakeRange(0, newCharViewArray.count) withObjectsFromArray:newCharViewArray];
    
    
//    NSInteger cal = 0;
//    for (NSInteger i = 0; i<words.count; i++) {
//        NSString *ww = [words objectAtIndex:i];
//        for (NSInteger j = 0; j<ww.length; j++) {
//            NSString *jChar = [ww substringWithRange:NSMakeRange(j, 1)];
//            
//            for (NSInteger z = 0;z<self.charViewArray.count;z++) {
//                if (z<cal) {
//                    continue;
//                }
//                CardView *card = [self.charViewArray objectAtIndex:z];
//                if ([[card charV] isEqualToString:jChar]) {
//                    self.charViewArray
//                }
//            }
//            
//            
//        }
//    }
    
    
    [self resetFrame];
}

-(UIView *)tingFlagView {
    if (_tingFlagView == nil) {
        _tingFlagView = [[UIButton alloc] init];
        _tingFlagView.backgroundColor = [UIColor clearColor];
        
    }
    return _tingFlagView;
}

-(UIButton *) createHuButton{
    UIImage *img = [UIImage imageNamed:@"hu"];
    UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
    tmp.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [tmp setImage:img forState:UIControlStateNormal];
    return tmp;
}
-(void) beginAnimal:(UIButton *) tmp{
    [UIView animateWithDuration:0.5 animations:^{
        tmp.center = CGPointMake(self.headerView.frame.origin.x + self.headerView.frame.size.width, self.headerView.frame.origin.y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            tmp.transform = CGAffineTransformScale(tmp.transform, 1.4, 1.4);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                tmp.transform = CGAffineTransformScale(tmp.transform, 0.01, 0.01);
            } completion:^(BOOL finished) {
                [tmp removeFromSuperview];
            }];
        }];
    }];
}
-(UIButton *) createTingButton{
    UIImage *img = [UIImage imageNamed:@"ting"];
    UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
    tmp.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [tmp setImage:img forState:UIControlStateNormal];
    return tmp;
}
-(void) beginAnimalTing:(UIView *) tmp{
    dispatch_async(dispatch_get_main_queue(), ^{
        float targetw = 30;
        [UIView animateWithDuration:0.2 animations:^{
            CGPoint point = CGPointMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y + self.headerView.frame.size.height);
            tmp.frame = CGRectMake(point.x - targetw/2, point.y - targetw * 0.67, targetw, targetw);
            NSLog(@"ting frame : %@" ,NSStringFromCGRect(tmp.frame));
            
        } completion:^(BOOL finished) {
        }];
    });
    
}

-(void) successful{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSString *word in dic_preWordsArray) {
            [self actionEat:word];
        }
        [self callbackHU:@"1"];
    });
    
    
}

-(void) resetControlByisEat:(BOOL) iseat isting:(BOOL) isting ishu:(BOOL) ishu isguo:(BOOL) isguo{
    UIButton *buttonEat = [_controlView viewWithTag:1000+0];
    UIButton *buttonZu = [_controlView viewWithTag:1000+100];
    UIButton *buttonTing = [_controlView viewWithTag:1000+1];
    UIButton *buttonHu = [_controlView viewWithTag:1000+2];
    UIButton *buttonGuo = [_controlView viewWithTag:1000+3];
    
    
    buttonZu.enabled = YES;
    [buttonZu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    if (iseat) {
        [buttonEat setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        buttonEat.enabled = YES;
    }else
    {
        [buttonEat setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        buttonEat.enabled = FALSE;
    }
    if (isting) {
        [buttonTing setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        buttonTing.enabled = YES;
    }else
    {
        [buttonTing setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        buttonTing.enabled = NO;
    }
    
    if (ishu) {
        [buttonHu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        buttonHu.enabled = YES;
    }else
    {
        [buttonHu setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        buttonHu.enabled = NO;
    }
    
    if (isguo) {
        [buttonGuo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        buttonGuo.enabled = YES;
    }else
    {
        [buttonGuo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        buttonGuo.enabled = YES;
    }
    
    //RESET-frame
    
    NSMutableArray *buttons = [NSMutableArray array];
    if (iseat) {
        buttonEat.hidden = NO;
        [buttons addObject:buttonEat];
    }else{
        buttonEat.hidden = YES;
    }
    if (isting) {
        buttonTing.hidden = NO;
        [buttons addObject:buttonTing];
    }else{
        buttonTing.hidden = YES;
    }
    if (ishu) {
        buttonHu.hidden = NO;
        [buttons addObject:buttonHu];
        [AnimalView addAnimalToView:buttonHu];
    }else{
        buttonHu.hidden = YES;
    }
    if (iseat || isting || ishu) {
        buttonGuo.hidden = NO;
        [buttons addObject:buttonGuo];
    }else{
        buttonGuo.hidden = YES;
    }
    if (buttons.count>0) {
        NSLog(@"");
    }
    
    float beginx = self.controlView.frame.size.width-( buttonHu.frame.size.width * buttons.count + 39.0/3 * (buttons.count - 1));
    NSLog(@"%@",NSStringFromCGRect(self.controlView.frame));
    
    
    
    for (NSInteger i = 0;i<buttons.count;i++) {
        UIView *v = [buttons objectAtIndex:i];
        v.frame = CGRectMake(beginx, 0, v.frame.size.width, v.frame.size.height);
        NSLog(@"%@",NSStringFromCGRect(v.frame));
        beginx += v.frame.size.width;
        beginx += 39.0/3;
        
        //        UIButton *buttonEat = [_controlView viewWithTag:1000+0];
        //        UIButton *buttonZu = [_controlView viewWithTag:1000+100];
        //        UIButton *buttonTing = [_controlView viewWithTag:1000+1];
        //        UIButton *buttonHu = [_controlView viewWithTag:1000+2];
        //        UIButton *buttonGuo = [_controlView viewWithTag:1000+3];
        if (v.tag == 1000 && buttons.count == 2) {
            [v addAnimalByType:AnimalType_CHI];
        }
        if (v.tag == 1000 + 1) {
            [v addAnimalByType:AnimalType_TING];
        }
        if (v.tag == 1000 + 2) {
            [v addAnimalByType:AnimalType_HU];
        }
        
    }
    
    if (buttons.count>0) {
        controlState = TRUE;
    }else{
        controlState = FALSE;
    }
}

-(void) resultEatShow{
    
    
}
-(void) actionEat:(NSString *) word{
    
    if (_tingSet) {
        NSLog(@"eat数量: %@  %zd==%zd",word,self.charArray.count,self.charViewArray.count);
    }
    
    if (self.charArray.count < word.length) {
        NSLog(@"");
    }
    
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i<word.length; i++) {
        NSString *wchar = [word substringWithRange:NSMakeRange(i, 1)];
        BOOL havechar = FALSE;
        CardView *deleteView ;
        for (NSInteger j = 0; j<self.charViewArray.count; j++) {
            CardView *cv = [self.charViewArray objectAtIndex:j];
            if ([cv.charV isEqualToString:wchar]) {
                
                NSString *cvchar = cv.charV;
                NSInteger index = [self.charArray indexOfObject:cvchar];
                if (index != NSNotFound) {
                    [self.charArray removeObjectAtIndex:index];
                    
                    [views addObject:cv];
                    deleteView = cv;
                    [cv setEatBackGround];
                    havechar = TRUE;
                    break;
                }
                
            }
        }
        if (!havechar) {
            for (NSInteger j = 0 ; j<self.charViewArray.count; j++) {
                CardView *cv = [self.charViewArray objectAtIndex:j];
                if ([cv.charV isEqualToString:WNKEY]) {
                    
                    NSString *cvchar = cv.charV;
                    NSInteger index = [self.charArray indexOfObject:cvchar];
                    [self.charArray removeObjectAtIndex:index];
                    [cv setBackToNo];
                    cv.placeChar = wchar;
                    [views addObject:cv];
                    deleteView = cv;
                    [cv setEatBackGround];
                    break;
                }
            }
        }
        if (deleteView) {
            [self.charViewArray removeObject:deleteView];
        }
    }
    
    
    
    if (self.eatCharArray == nil) {
        self.eatCharArray = [NSMutableArray array];
    }
    if (self.eatCharViewArray == nil) {
        self.eatCharViewArray = [NSMutableArray array];
    }
    [self.eatCharArray addObject:word];
    [self.eatCharViewArray addObject:views];
    
    [self resetFrame];
}
-(void) actionTing{
    self.tingView.hidden = NO;
}
-(void) actionHu{}
-(void) actionGuo:(NSString *) achaLibrary{
    
    
    self.stepFromOtherOrLibrary = 2;
    
    
    NSInteger num = 0;
    for (NSInteger i = 0; i<self.eatCharViewArray.count; i++) {
        NSMutableArray *tmp = [self.eatCharViewArray objectAtIndex:i];
        num += tmp.count;
    }
    
    num += self.charViewArray.count;
    
    if (num == SUCCESS_CARD_COUNT) {
        return;
    }
    
    [self.charArray addObject:achaLibrary];
    [self cardToIn:achaLibrary];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        
        NSMutableArray *tmp = [NSMutableArray array];
        [tmp addObjectsFromArray:self.charArray];
        NSDictionary *dic = [[MajHelper shareHelper] start:tmp];
        dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
        dic_tingArray = [dic objectForKey:@"tingarray"];
        dic_huArray = [dic objectForKey:@"huarray"];
        dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
        dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
        dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
        dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
        
        
        if (dic_error == 0) {
        }else
            [self save_clean];
        
        if (dic_error == 1) {
            [dic_resultArray removeAllObjects];
            dic_resultArray = [dic objectForKey:@"tingarray"];
            [self save_copy];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLogoInfo:dic];
            self.borderState = TRUE;
        });
        
        BOOL iseat =FALSE;
        BOOL ishu =FALSE;
        BOOL isting=FALSE;
        
        if (dic_error == 0) {
            ishu = TRUE;
            
        }
        if (dic_error==1) {
            isting = TRUE;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self resetControlByisEat:false isting:isting ishu:ishu isguo:NO];
            if (ishu) {
                if (_tingSet) {
                    [self resetControlByisEat:false isting:isting ishu:ishu isguo:NO];
                }else
                {
                    [self setupResultWhenHu2Ting];
                    [self resetControlByisEat:false isting:YES ishu:NO isguo:NO]; //组装
                    
                }
                
            }else
                [self resetControlByisEat:false isting:isting ishu:ishu isguo:NO];
            
            
        });
        
    });
}
-(void) actionOut:(NSString *) c0{
    
    if (self.deskDirect == DeskDirect_TOP) {
        NSInteger index = [self.charArray indexOfObject:c0];
        if (index != NSNotFound) {
            [self.charArray removeObjectAtIndex:index];
            CardView *cv;
            for (NSInteger i = self.charViewArray.count-1; i>=0; i--) {
                CardView *card = [self.charViewArray objectAtIndex:i];
                if ([card.charV isEqualToString:c0]) {
                    cv = card;
                    break;
                }
            }
            if (cv != nil) {
                [self.charViewArray removeObject:cv];
                [cv removeFromSuperview];
                
            }else{
                NSLog(@"应该打出:%@ in %@",c0,self.charArray);
                
            }
        }
        
    }
    else{
        
        if (_tingSet) {
            [self.charArray removeLastObject];
            UIView *tingview = [self.charViewArray lastObject];
            [tingview removeFromSuperview];
            [self.charViewArray removeLastObject];
        }else{
            NSInteger index = [self.charArray indexOfObject:c0];
            if (index != NSNotFound) {
                [self.charArray removeObjectAtIndex:index];
                //                [self.currentSelectedView removeFromSuperview];
                //                [self.charViewArray removeObject:self.currentSelectedView];
                //                self.currentRemovedIndex = self.currentSelectedIndex;
                //                self.currentSelectedView = nil;
                //                self.currentSelectedIndex = -1;
                [self.currentNeedRemoveView removeFromSuperview];
                [self.charViewArray removeObject:self.currentNeedRemoveView];
                [self.selectedCharViewArray removeAllObjects];
                
            }
            
        }
    }
    [self cardToOutView:c0];
    [self resetFrame];
    
    [self performSelector:@selector(callBack:) withObject:c0 afterDelay:0.1];
}



-(void) cardToOutView:(NSString *) c0{
    
    NSInteger rowNum = 3;
    NSInteger rowofCard = 15;
    
    
    
    if (self.outViewArray == nil) {
        self.outViewArray = [NSMutableArray array];
    }
    
    
    CardView *imgv = [[CardView alloc] initWithFrame:CGRectZero withChar:c0 isBack:NO];
    
    float hh = self.outCardSize.height;
    float ww =self.outCardSize.width;
    float beginx = 0;
    NSInteger cardNum = self.outViewArray.count;
    BOOL isRowBegin = cardNum % rowofCard == 0;
    self.lastOutCardReminderIv.hidden = NO;
    if (self.deskDirect == DeskDirect_BOTTOM) {
        imgv.frame = CGRectMake(beginx + cardNum % rowofCard *( ww + (isRowBegin ? 0: self.outCardMargin)), self.outView.frame.size.height-hh - cardNum/rowofCard * hh, ww, hh);
        self.lastOutCardReminderIv.frame = CGRectMake(imgv.frame.origin.x + (imgv.frame.size.width/2 - self.lastOutCardReminderIv.frame.size.width/2)+3, CGRectGetMinY(imgv.frame) - self.lastOutCardReminderIv.frame.size.height-2, self.lastOutCardReminderIv.frame.size.width, self.lastOutCardReminderIv.frame.size.height);
        
        if (self.lastOutCardReminderIv.frame.origin.y<0) {
            _outView.contentSize = CGSizeMake(_outView.frame.size.width, self.lastOutCardReminderIv.frame.size.height+hh*(cardNum/rowofCard+1));
            [UIView animateWithDuration:0.5 animations:^{
                
                _outView.contentOffset = CGPointMake(0, -10*(cardNum/rowofCard+1));
                
            } completion:^(BOOL finished) {
                
            }];
            _outView.scrollEnabled = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:CLEARREMINDER object:@"bottom"];
        
    }else{
        imgv.frame = CGRectMake(beginx + cardNum % rowofCard *( ww + (isRowBegin ? 0: self.outCardMargin)), cardNum/rowofCard * hh, ww, hh);
        
        self.lastOutCardReminderIv.frame = CGRectMake(imgv.frame.origin.x + (imgv.frame.size.width/2 - self.lastOutCardReminderIv.frame.size.width/2)+3, CGRectGetMaxY(imgv.frame) + self.lastOutCardReminderIv.frame.size.height- 10, self.lastOutCardReminderIv.frame.size.width, self.lastOutCardReminderIv.frame.size.height);
        self.lastOutCardReminderIv.transform = CGAffineTransformMakeScale(1.0,-1.0);
        
        if (self.lastOutCardReminderIv.frame.origin.y+self.lastOutCardReminderIv.frame.size.height > _outView.frame.size.height) {
            NSLog(@"lastOutCardReminderIv.frame.origin.y = %f",self.lastOutCardReminderIv.frame.origin.y);
            _outView.contentSize = CGSizeMake(_outView.frame.size.width, 10+self.lastOutCardReminderIv.frame.size.height+hh*(cardNum/rowofCard+1));
            [UIView animateWithDuration:0.5 animations:^{
                
                _outView.contentOffset = CGPointMake(0, 10*(cardNum/rowofCard+3));
                
            } completion:^(BOOL finished) {
                
            }];
            _outView.scrollEnabled = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:CLEARREMINDER object:@"top"];
    }
    NSLog(@"%@",NSStringFromCGRect(imgv.frame));
    
    
    
    
    [_outView addSubview:imgv];
    [_outView sendSubviewToBack:imgv];
    [self.outViewArray addObject:c0];
    
    
    
}


//添加card to self.charViewArray
-(void) cardToIn:(NSString *) c0{
    
    CardView *tmp = [self.charViewArray lastObject];
    float cardw = self.cardSize.width;
    float cardh = self.cardSize.height;
    NSLog(@"frame %@===%@",NSStringFromCGRect(tmp.bounds),NSStringFromCGSize(self.cardSize));
    CardView *tmpv = [[CardView alloc] initWithFrame:CGRectMake(tmp.frame.origin.x+tmp.frame.size.width, tmp.frame.origin.y, tmp.frame.size.width, tmp.frame.size.height) withChar:c0 isBack:self.deskDirect == DeskDirect_TOP];
    //    tmpv.tag = self.currentRemovedIndex==-1 ? (100+13) : self.currentRemovedIndex;
    if (_deskDirect == DeskDirect_BOTTOM) {
        UIPanGestureRecognizer *longGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [tmpv addGestureRecognizer:longGesture];
    }
    NSLog(@"%@",NSStringFromCGRect(tmpv.frame));
    __weak CardView *wtmpv = tmpv;
    [tmpv addClickBlock:^(NSInteger tag) {
        //        if (self.currentSelectedIndex == tag - 100) {
        //            return ;
        //        }
        //        if (self.currentSelectedIndex == -1) {
        //            self.currentSelectedIndex = tag - 100;
        //            self.currentSelectedView = tmpv;
        //            [self setUP:self.currentSelectedView];
        //        }else{
        //            if (self.borderState) {
        //                NSInteger index = [self indexofCrad:tmpv];
        //                NSInteger sindex = [self indexofCrad:self.currentSelectedView];
        //                if (index != NSNotFound && sindex != NSNotFound) {
        //                    if (sindex>index) {
        //                        [self.charViewArray removeObject:self.currentSelectedView];
        //                        [self.charViewArray insertObject:self.currentSelectedView atIndex:index];
        //                    }else{
        //                        [self.charViewArray removeObject:self.currentSelectedView];
        //                        [self.charViewArray insertObject:self.currentSelectedView atIndex:index-1];
        //                    }
        //                    [self resetFrame];
        //                    self.currentSelectedView = nil;
        //                    self.currentSelectedIndex = -1;
        //
        //                }
        //            }else
        //            {
        //                [self setDown:self.currentSelectedView];
        //                self.currentSelectedIndex = tag - 100;
        //                self.currentSelectedView = tmpv;
        //                [self setUP:self.currentSelectedView];
        //            }
        //        }
        
        if (wtmpv.isUpState) {
            [self.selectedCharViewArray removeObject:wtmpv];
            [self setDown:wtmpv];
            if (preTingState) {
                [self hiddenTingInfoViewForCard:wtmpv];
            }
            
        }else{
            [self.selectedCharViewArray addObject:wtmpv];
            [self setUP:wtmpv];
            if (preTingState) {
                [self showTingInfoViewForCard:wtmpv];
            }
            
        }
    }];
    
    [tmpv addDoubleClickBlock:^(NSInteger tag) {
//        if (controlState) {
//            [self moveFinished];
//            _moveCardView = nil;
//            _operCardView = nil;
//            
//            return;
//        }
//        
//        if (preTingState && (![self.tingLayerViewArray containsObject:tmpv])) {
//            [self moveFinished];
//            _moveCardView = nil;
//            _operCardView = nil;
//            
//            return;
//        }
//        
//        if (![self.selectedCharViewArray containsObject:wtmpv]) {
//            [self.selectedCharViewArray addObject:wtmpv];
//        }
//        [self actionMethod];
        
        
        if (controlState) {
            [self moveFinished];
            _moveCardView = nil;
            _operCardView = nil;
            
            return;
        }
        
        if (preTingState && (![self.tingLayerViewArray containsObject:tmpv])) {
            [self moveFinished];
            _moveCardView = nil;
            _operCardView = nil;
            
            return;
        }
        
        
        [self actionDownForDoubleClick];
        [self.selectedCharViewArray addObject:tmpv];
        [self actionMethod];
        
        alreadPostCard = TRUE;
        
        if (preTingState) {
            //                tingState = FALSE;
            _tingSet = TRUE;
            [self moveLayerForCard];
            
            if ([tmpv isKindOfClass:[CardView class]]) {
                CardView *ctmp =(CardView *) tmpv;
                [self setupTingData_getNeedAndLastArray:[ctmp charV]];
                tingPopChar = [ctmp charV];
                
                [self hiddenTingInfoViewForCard:(CardView *)tmpv];
            }
            [self moveReminderViewForCard];
            
        }

        
    }];
    
    if (_tingSet) {
        self.currentNeedRemoveView = tmpv;
    }
    
    [self.charViewArray addObject:tmpv];
    [self addSubview:tmpv];
    [self resetFrame];
    [self bringSubviewToFront:self.wordInfoView];
}

-(void) callBack:(NSString *) c0{
    
    if (_deskDirect == DeskDirect_BOTTOM) {
        NSLog(@"");
    }
    
    if (self.didOutCardBlock) {
        self.didOutCardBlock(c0);
    }
}

#pragma mark "胡"
-(void) callbackHU:(NSString *) huCount{
    if (self.didFinishedBlock) {
        self.didFinishedBlock(self.userinfo);
    }
}


-(void) finishedClear{
    
    self.save_step_tingOtherChar = nil;
    self.save_step_tingCacheLibraryChar = nil;
    
    self.save_step = 0;
    
    
    alreadPostCard = FALSE;
    dic_error = 0;
    dic_correctString = nil;
    [dic_lastCharArray removeAllObjects] ;
    [dic_needCharArray removeAllObjects] ;
    [dic_preWordsArray removeAllObjects] ;
    [dic_eatDic removeAllObjects];
    
    [_charArray removeAllObjects];
    [_charViewArray removeAllObjects];
    [_selectedCharViewArray removeAllObjects];
    
    _shuaiziNum = 0;
    [_aButton removeFromSuperview];
    _aButton = nil;
    
    //    _currentSelectedIndex = -1;
    //    _currentRemovedIndex = -1;
    //    [_currentSelectedView removeFromSuperview];
    //    _currentSelectedView = nil;
    
    [_currentNeedRemoveView removeFromSuperview];
    _currentNeedRemoveView = nil;
    
    _tingSet = false ;
    [_tingNeedChar removeAllObjects];
    _tingNeedChar = nil;
    [_tingLastChar removeAllObjects];
    _tingLastChar = nil;
    
    [_controlView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_controlView removeFromSuperview];
    _controlView = nil;
    [_outView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_outView removeFromSuperview];
    _outView = nil;
    [_wordInfoView removeFromSuperview];
    _wordInfoView = nil;
    [_outViewArray removeAllObjects];
    
    [_eatView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_eatView removeFromSuperview];
    _eatView = nil;
    
    
    [_eatCharArray removeAllObjects];
    [_eatCharViewArray removeAllObjects];
    _eatCharFromOther = nil;
    _eatCharFromLibrary = nil;
    
    
    
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}



- (void)buttonLongPressed:(UIPanGestureRecognizer *)sender
{
    
    CardView *btn = (CardView *)sender.view;
    float btnw = btn.frame.size.width;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
        
        [self actionDownForDoubleClick];
        
        _moveCardView = btn;
        _operCardView = btn;
        
        [self bringSubviewToFront:btn];
        
        _startPoint = [sender locationInView:sender.view];
        _originPoint = btn.center;
        
        _beginPoint = [sender translationInView:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            btn.alpha = 1.0;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [sender locationInView:sender.view];
        
        //        CGFloat currentx = newPoint.x;
        //        CGFloat move = _operCardView.frame.origin.x - _moveLastX;
        //
        //        NSLog(@"now:%f===move:%f",currentx,move);
        //
        //        //currentx - _moveLastX;
        ////        NSLog(@"currentx:%f===lastx:%f======move:%f",currentx,_moveLastX,move);
        //
        //
        //        _operCardView.frame = CGRectMake(_operCardView.frame.origin.x+newPoint.x, _operCardView.frame.origin.y, _operCardView.frame.size.width, _operCardView.frame.size.height);
        //
        //        if (fabsf(move)+_locationInView>btnw) {
        ////            _moveLastX = _operCardView.frame.origin.x;
        ////            _locationInView = 0;
        //
        ////            if (move<0) {
        ////                [self moveCard:_operCardView isLeft:YES];
        ////            }else{
        ////                [self moveCard:_operCardView isLeft:NO];
        ////            }
        //        }
        
        
        
        //        CGFloat deltaX = newPoint.x-_startPoint.x;
        //        btn.center = CGPointMake(btn.center.x + deltaX, btn.center.y);
        //        NSInteger index = [self indexOfPoint:btn.center withView:btn];
        //        NSLog(@"INDEX:%zd",index);
        //        if (index<0) {
        //            _contain = NO;
        //        }else{
        //            NSInteger index1 = [self indexofCrad:btn];
        //            NSInteger index2 = index;
        //            [self moveCard:_operCardView isLeft:index1>index2 ? YES : NO index:index2];
        //
        //        }
        
        CGPoint transPoint = [sender translationInView:self];
        CGFloat transX = transPoint.x-_beginPoint.x;
        CGFloat transY = transPoint.y-_beginPoint.y;
//        NSLog(@"TX :%f-%f :  %f",transPoint.x,_beginPoint.x,transX);
//        NSLog(@"TY :%f-%f :  %f",transPoint.y,_beginPoint.y,transY);
        
        if (transY<0-(self.cardSize.height)) {
            _isCardUpDirect = TRUE;
        }else{
            _isCardUpDirect = FALSE;
        }
        {
            CGFloat deltaX = newPoint.x-_startPoint.x;
            CGFloat deltaY = newPoint.y-_startPoint.y;
//            NSLog(@"X :%f-%f :  %f",newPoint.x,_startPoint.x,deltaX);
//            NSLog(@"Y :%f-%f :  %f",newPoint.y,_startPoint.y,deltaY);
            btn.center = CGPointMake(btn.center.x + deltaX, btn.center.y + deltaY);
            NSInteger index = [self indexOfPoint:btn.center withView:btn];
            NSLog(@"INDEX:%zd",index);
            if (index<0) {
                _contain = NO;
            }else{
                NSLog(@"=====================================change");
                NSLog(@"=====================================change");
                NSLog(@"=====================================change");
                NSLog(@"=====================================change");
                NSLog(@"=====================================change");
                NSInteger index1 = [self indexofCrad:btn];
                NSInteger index2 = index;
                [self moveCard:_operCardView isLeft:index1>index2 ? YES : NO index:index2];
                
            }
        }
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"end...............");
        
        if (controlState) {
            [self moveFinished];
            _moveCardView = nil;
            _operCardView = nil;
            
            return;
        }
        
        if (preTingState && (![self.tingLayerViewArray containsObject:sender.view])) {
            [self moveFinished];
            _moveCardView = nil;
            _operCardView = nil;
            
            return;
        }
        
        if (self.isCardUpDirect) {
            [self actionDownForDoubleClick];
            [self.selectedCharViewArray addObject:sender.view];
            [self actionMethod];
            self.isCardUpDirect = FALSE;
            
            alreadPostCard = TRUE;
            
            if (preTingState) {
                //                tingState = FALSE;
                _tingSet = TRUE;
                [self moveLayerForCard];
                
                if ([sender.view isKindOfClass:[CardView class]]) {
                    CardView *ctmp =(CardView *) sender.view;
                    [self setupTingData_getNeedAndLastArray:[ctmp charV]];
                    tingPopChar = [ctmp charV];
                    
                    [self hiddenTingInfoViewForCard:(CardView *)sender.view];
                }
                [self moveReminderViewForCard];
                
            }
            
        }else{
            
            [self moveFinished];
            _moveCardView = nil;
            _operCardView = nil;
            
            [UIView animateWithDuration:0.3 animations:^{
                btn.transform = CGAffineTransformIdentity;
                btn.alpha = 1.0;
            }];
        }
        
        
    }
}
- (NSInteger)indexOfPoint:(CGPoint)point withView:(CardView *)btn
{
    for (NSInteger i = 0;i<self.charViewArray.count;i++)
    {
        CardView *button = self.charViewArray[i];
        if (button != btn)
        {
            float minx = button.frame.origin.x;
            float maxx = button.frame.origin.x + button.frame.size.width;
            if (point.x>minx && point.x<maxx) {
                return i;
            }
            
            //            if (CGRectContainsPoint(button.frame, point))
            //            {
            //                return i;
            //            }
        }
    }
    return -1;
}

-(NSInteger) indexofCrad:(CardView *) card{
    
    for (NSInteger i = 0; i<self.charViewArray.count; i++) {
        CardView *cv = [self.charViewArray objectAtIndex:i];
        if (cv == card) {
            return i;
        }
    }
    return NSNotFound;
}
-(void) moveCard:(CardView *) card isLeft:(BOOL) isleft index:(NSInteger) index{
    
    //    NSInteger index = [self indexofCrad:card];
    
    if(isleft){
        //        if (index == 0) {
        //            return;
        //        }
        CardView *newCard = [self.charViewArray objectAtIndex:index];
        //        _operCardView.frame = CGRectMake(newCard.frame.origin.x, newCard.frame.origin.y - 60, newCard.frame.size.width, newCard.frame.size.height);
        //        _moveCardView.transform = CGAffineTransformIdentity;
        //        _moveCardView.alpha = 1.0;
        //        _moveCardView = newCard;
        //        [UIView animateWithDuration:0.3 animations:^{
        //
        //            newCard.transform = CGAffineTransformMakeScale(1.0, 1.0);
        //            newCard.alpha = 0.7;
        //        }];
        
        _moveCardView = newCard;
        //        [self.charViewArray removeObject:_operCardView];
        //        [self.charViewArray insertObject:_operCardView atIndex:index];
        NSLog(@"%@",self.charViewArray);
        [self.charViewArray exchangeObjectAtIndex:index withObjectAtIndex:index+1];
        NSLog(@"%@",self.charViewArray);
        [UIView animateWithDuration:0.3 animations:^{
            newCard.frame = CGRectMake(newCard.frame.origin.x + newCard.frame.size.width, newCard.frame.origin.y, newCard.frame.size.width, newCard.frame.size.height);
        }];
        
        
        
        
    }else{
        //        if (index == self.charViewArray.count-1) {
        //            return;
        //        }
        CardView *newCard = [self.charViewArray objectAtIndex:index];
        //        _operCardView.frame = CGRectMake(newCard.frame.origin.x, newCard.frame.origin.y - 60, newCard.frame.size.width, newCard.frame.size.height);
        //        _moveCardView.transform = CGAffineTransformIdentity;
        //        _moveCardView.alpha = 1.0;
        //        _moveCardView = newCard;
        //        [UIView animateWithDuration:0.3 animations:^{
        //
        //            newCard.transform = CGAffineTransformMakeScale(1.0, 1.0);
        //            newCard.alpha = 0.7;
        //        }];
        
        _moveCardView = newCard;
        //        [self.charViewArray removeObject:_operCardView];
        //        [self.charViewArray insertObject:_operCardView atIndex:index];
        [self.charViewArray exchangeObjectAtIndex:index withObjectAtIndex:index-1];
        [UIView animateWithDuration:0.3 animations:^{
            
            newCard.frame = CGRectMake(newCard.frame.origin.x - newCard.frame.size.width, newCard.frame.origin.y, newCard.frame.size.width, newCard.frame.size.height);
        }];
        
    }
}
-(void) moveFinished{
    
    //    if (_operCardView != _moveCardView) {
    //        NSInteger oIndex = [self indexofCrad:_operCardView];
    //        NSInteger index = [self indexofCrad:_moveCardView];
    //        if (oIndex != NSNotFound && index != NSNotFound) {
    //            [self.charViewArray removeObject:_operCardView];
    //            [self.charViewArray insertObject:_operCardView atIndex:index];
    //            [self resetFrame];
    //        }
    //
    //    }
    
    //    if (_moveCardView) {
    //        NSInteger oIndex = [self indexofCrad:_operCardView];
    //        NSInteger index = [self indexofCrad:_moveCardView];
    //        if (oIndex != NSNotFound && index != NSNotFound) {
    //            [self.charViewArray removeObject:_operCardView];
    //            [self.charViewArray insertObject:_operCardView atIndex:index];
    //            [self resetFrame];
    //            _moveCardView = nil;
    //            _operCardView = nil;
    //    }
    //    }else{
    //        [self resetFrame];
    //    }
    
    [self resetFrame];
    _moveCardView = nil;
    _operCardView = nil;
}

-(void) moveAnimalView:(CardView *) card  index:(NSInteger) index direct:(BOOL) isleft{
    if (isleft) {
        
    }
}

-(void) resultView{
    NSDictionary *dic;
    dic_error = [[dic objectForKey:@"error"] integerValue];//还手率
    dic_tingArray = [dic objectForKey:@"tingarray"];
    dic_huArray = [dic objectForKey:@"huarray"];
    dic_correctString = [dic objectForKey:@"chars"]; //剩余字母需要拼的单词 ，分开
    dic_lastCharArray = [dic objectForKey:@"last"];//用不到的字母
    dic_needCharArray = [dic objectForKey:@"need"];//需要的字母
    dic_preWordsArray = [dic objectForKey:@"prewords"];//已经组成的单词
    
    
}

#pragma mark 吃提示

-(UIView *)eatView{
    if (_eatView == nil) {
        _eatView = [[UIView alloc] initWithFrame:CGRectZero];
        _eatViewBackground = [[UIImageView alloc] initWithFrame:_eatView.bounds];
        [_eatView addSubview:_eatViewBackground];
        _eatViewReminder = [[UIImageView alloc] initWithFrame:_eatView.bounds];
        [_eatView addSubview:_eatViewReminder];
    }
    return _eatView;
}


-(void) freshEatView:(NSMutableArray *) words{
    
    [self bringSubviewToFront:self.eatView];
    self.eatView.hidden = NO;
    for (UIView *v in [self.eatView subviews]) {
        if (v == _eatViewBackground || v == _eatViewReminder) {
            continue;
        }
        [v.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [v removeFromSuperview];
    }
    
    NSInteger maxlen = 3; //最多提示3个
    
    NSMutableArray *array = [NSMutableArray array];
    if (words.count>maxlen) {
        [array addObjectsFromArray:[words subarrayWithRange:NSMakeRange(0, maxlen)]];
    }else
        [array addObjectsFromArray:words];
    
    UIImage *reminder = [UIImage imageNamed:@"reminder"];
    float topMarginY = 10 + reminder.size.height;
    float innerMarginY = 5 + reminder.size.height;
    float rightMarginX =  12+5;
    float leftMarginX = 10 ;
    
    float maxHeight = self.selectedCardSize.height * array.count;
    maxHeight += 2 * topMarginY;
    maxHeight += (array.count-1) * innerMarginY;
    
    float maxWidth = 0;
    NSInteger maxnum = 0;
    for (NSString *word in array) {
        if (word.length>maxnum) {
            maxnum = word.length;
        }
    }
    maxWidth = self.selectedCardSize.width + (self.selectedCardSize.width + self.selectedCardMargin) * (maxnum - 1);
    maxWidth += leftMarginX;
    maxWidth += rightMarginX;
    
    
    
    
    float mary = topMarginY;
    float buttonw = self.selectedCardSize.width;
    float buttonh = self.selectedCardSize.height;
    
    UIButton *chiButton = [self.controlView viewWithTag:1000];
    self.eatView.frame =CGRectMake(self.controlView.frame.origin.x - maxWidth + chiButton.frame.origin.x, self.controlView.frame.origin.y - maxHeight + self.controlView.frame.size.height + SCREEN_H / 2,maxWidth, maxHeight);
    self.eatViewBackground.frame = self.eatView.bounds;
    UIImage *sourceImg = [UIImage imageNamed:@"Prompt_Master"];
    //    self.eatViewBackground.image = [sourceImg stretchableImageWithLeftCapWidth:sourceImg.size.width /2 topCapHeight:sourceImg.size.height/2];
    self.eatViewBackground.image = [sourceImg resizableImageWithCapInsets:UIEdgeInsetsMake(sourceImg.size.height*0.3, sourceImg.size.width*0.3, sourceImg.size.height*0.5, sourceImg.size.width*0.5)];
    
    self.eatViewReminder.frame = CGRectMake(0, 0, reminder.size.width, reminder.size.height);
    NSLog(@"%@",NSStringFromCGRect(self.eatViewReminder.frame));
    self.eatViewReminder.image = reminder;
    self.eatViewReminder.hidden = YES;
    
    for (NSInteger i = 0; i<array.count; i++) {
        
        NSString *word = [array objectAtIndex:i];
        float currentWidth = self.selectedCardSize.width + (self.selectedCardSize.width + self.selectedCardMargin) * (word.length - 1);
        NSMutableArray *tmpchar = [NSMutableArray array];
        [tmpchar addObjectsFromArray:self.charArray];
        [tmpchar addObject:self.eatCharFromOther];
        NSMutableArray *placeArray = [self placeCharByWord:word inCharArray:tmpchar];
        UIView *subv = [[UIView alloc] initWithFrame:CGRectMake(maxWidth - rightMarginX - currentWidth, mary, currentWidth, buttonh)];
        subv.tag = 10000+i;
        subv.backgroundColor = [UIColor clearColor];
        
        
        [subv addClickBlock:^(NSInteger tag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.selectedEatWord = word;
                self.eatViewReminder.frame = CGRectMake(subv.frame.origin.x, subv.frame.origin.y - self.eatViewReminder.frame.size.height, self.eatViewReminder.frame.size.width, self.eatViewReminder.frame.size.height);
                
                self.eatViewReminder.hidden = NO;
                
                [self actionUpByWordFromEatView:word withHui:YES notContainChar:self.eatCharFromOther];
            });
            
            
        }];
        [self.eatView addSubview:subv];
        
        if (array.count == 1) {
            self.selectedEatWord = word;
            self.eatViewReminder.frame = CGRectMake(subv.frame.origin.x, subv.frame.origin.y - self.eatViewReminder.frame.size.height, self.eatViewReminder.frame.size.width, self.eatViewReminder.frame.size.height);
            
            self.eatViewReminder.hidden = NO;
        }
        
        
        
        
        float subbeginx = 0;
        //maxWidth - ( self.selectedCardSize.width + (self.selectedCardSize.width + self.selectedCardMargin) *( word.length-1));
        
        
        for (NSInteger j = 0; j<word.length; j++) {
            NSString *c = [word substringWithRange:NSMakeRange(j, 1)];
            CardView *cv;
            NSLog(@"%@===%@",[placeArray objectAtIndex:j],self.eatCharFromOther);
            if ([[placeArray objectAtIndex:j] isEqualToString:self.eatCharFromOther]) {
                cv = [[CardView alloc ] initWithFrame:CGRectMake(subbeginx, 0, buttonw, buttonh) withChar:c isBack:NO];
                [cv setTiBackGround];
            }
            else
                if ([[placeArray objectAtIndex:j] isEqualToString:WNKEY]) {
                    cv = [[CardView alloc ] initWithFrame:CGRectMake(subbeginx, 0, buttonw, buttonh) withChar:WNKEY isBack:NO];
                    [cv setEatBackGround];
                    cv.placeChar = c;
                }else{
                    cv = [[CardView alloc ] initWithFrame:CGRectMake(subbeginx, 0, buttonw, buttonh) withChar:c isBack:NO];
                    [cv setEatBackGround];
                }
            cv.userInteractionEnabled = NO;
            
            
            cv.tag = i * 1000 + j;
            [subv addSubview:cv];
            [subv sendSubviewToBack:cv];
            subbeginx += self.selectedCardSize.width +self.selectedCardMargin;
        }
        
        mary += self.selectedCardSize.height;
        mary += innerMarginY;
        
    }
}

-(void) eatViewFreshByWords:(NSMutableArray *) words{
    [self bringSubviewToFront:self.eatView];
    self.eatView.hidden = NO;
    for (UIView *v in [self.eatView subviews]) {
        [v.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [v removeFromSuperview];
    }
    
    NSInteger maxlen = 3; //最多提示3个
    
    NSMutableArray *array = [NSMutableArray array];
    if (words.count>maxlen) {
        [array addObjectsFromArray:[words subarrayWithRange:NSMakeRange(0, maxlen)]];
    }else
        [array addObjectsFromArray:words];
    
    NSInteger spacenum = array.count + 1;
    float spacew = 10;
    float maxbuttonw = 20;
    
    NSInteger charnum = 0;
    for (NSString *word in array) {
        charnum += word.length;
    }
    float maxw = self.frame.size.width - 150;
    
    float buttonw = MIN(maxbuttonw, (maxw - spacew*spacenum) *1.0/charnum );
    float buttonh = buttonw * CARDEATH *1.0/ CARDEATW;
    
    float marx = 0;
    float mary = 0;
    float subx = 0;
    float suby = 0;
    marx  = maxw - spacew * spacenum - charnum * buttonw;
    self.eatView.frame = CGRectMake(0, self.bounds.size.height-50/3.0-self.cardSize.height-buttonh-10, self.frame.size.width - 150, buttonh);
    {
        if (self.eatborder != nil) {
            [self.eatborder removeFromSuperlayer];
        }
        self.eatborder = [CAShapeLayer layer];
        
        self.eatborder.strokeColor = [UIColor whiteColor].CGColor;
        
        self.eatborder.fillColor = nil;
        self.eatborder.path = [UIBezierPath bezierPathWithRect:CGRectMake(marx-spacew, 0, self.eatView.frame.size.width - marx, self.eatView.frame.size.height)].CGPath;
        
        self.eatborder.frame = self.bounds;
        
        self.eatborder.lineWidth = 1.0f;
        
        self.eatborder.lineCap = @"square";
        
        self.eatborder.lineDashPattern = @[@4, @2];
        
        [self.eatView.layer addSublayer:self.eatborder];
        
    }
    
    for (NSInteger i = 0; i<array.count; i++) {
        
        NSString *word = [array objectAtIndex:i];
        NSMutableArray *placeArray = [self placeCharByWord:word inCharArray:self.charArray];
        UIView *subv = [[UIView alloc] initWithFrame:CGRectMake(marx, mary, buttonw * word.length, buttonh)];
        subv.tag = 10000+i;
        subv.backgroundColor = [UIColor clearColor];
        [subv addClickBlock:^(NSInteger tag) {
            self.eatView.hidden = YES;
            NSInteger wordindex = tag - 10000;
            NSString *word = [array objectAtIndex:wordindex];
            [self actionEatWithAll:word];
            
            for (UIView *v in [self.eatView subviews]) {
                [v.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [v removeFromSuperview];
            }
            
        }];
        [self.eatView addSubview:subv];
        for (NSInteger j = 0; j<word.length; j++) {
            NSString *c = [word substringWithRange:NSMakeRange(j, 1)];
            CardView *cv;
            if ([[placeArray objectAtIndex:j] isEqualToString:WNKEY]) {
                cv = [[CardView alloc ] initWithFrame:CGRectMake(subx, suby, buttonw, buttonh) withChar:WNKEY isBack:NO];
                [cv setEatBackGround];
                cv.placeChar = c;
            }else{
                cv = [[CardView alloc ] initWithFrame:CGRectMake(subx, suby, buttonw, buttonh) withChar:c isBack:NO];
                [cv setEatBackGround];
            }
            
            
            cv.tag = i * 1000 + j;
            [subv addSubview:cv];
            subx += buttonw;
        }
        [placeArray removeAllObjects];
        marx += buttonw*word.length;
        marx += spacew;
        subx = 0;
    }
    
    
}

-(NSMutableArray *) placeCharByWord:(NSString *) word inCharArray:(NSMutableArray *) charArray{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *chars = [NSMutableArray array];
    [chars addObjectsFromArray:charArray];
    
    for (NSInteger i = 0; i<word.length; i++) {
        NSString *tmp = [word substringWithRange:NSMakeRange(i, 1)];
        NSInteger index = [chars indexOfObject:tmp];
        if (index != NSNotFound) {
            [result addObject:tmp];
            [chars removeObjectAtIndex:index];
            
        }else{
            [result addObject:WNKEY];
            NSInteger key = [chars indexOfObject:WNKEY];
            if (key != NSNotFound) {
                [chars removeObjectAtIndex:key];
            }
        }
    }
    
    [chars removeAllObjects];
    return result;
}


#pragma mark 虚线
-(void)setBorderState:(BOOL)borderState{
    //    if (_borderState != borderState) {
    //        _borderState = borderState;
    //        if (_borderState) {
    //            self.border.lineWidth = 1.0f;
    //        }else{
    //            self.border.lineWidth = 0.0f;
    //        }
    //        self.borderInfo.hidden = !self.borderState;
    //
    //    }
}
-(CAShapeLayer *)border{
    
    if (_border == nil) {
        _border = [CAShapeLayer layer];
        
        _border.strokeColor = [UIColor whiteColor].CGColor;
        
        _border.fillColor = nil;
        
        CGRect rect;
        if (self.deskDirect == DeskDirect_TOP) {
            rect = CGRectMake(150, 0, SCREEN_W - 150, self.frame.size.height);
        }else
            rect = CGRectMake(0, self.frame.size.height - 100, SCREEN_W - 150, 100);
        _border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
        
        _border.frame = self.bounds;
        
        _border.lineWidth = 0.0f;
        
        _border.lineCap = @"square";
        
        _border.lineDashPattern = @[@4, @2];
        
        [self.layer addSublayer:_border];
        
    }
    return _border;
}

-(UILabel *)borderInfo{
    
    if (_borderInfo == nil) {
        _borderInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-100, self.frame.size.width, 15)];
        CGRect rect;
        if (self.deskDirect == DeskDirect_TOP) {
            rect = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 15);
            _borderInfo.frame = rect;
        }
        
        
        _borderInfo.font = [UIFont systemFontOfSize:10];
        _borderInfo.textAlignment = NSTextAlignmentCenter;
        _borderInfo.textColor = [UIColor redColor];
        _borderInfo.text = @"组模式下 选中一张牌,然后点击另外一张牌，可以将选中牌移动到其前面";
        [self addSubview:_borderInfo];
    }
    return _borderInfo;
}


#pragma mark double-click
-(void) actionUpForDoubleClick:(NSString *) c{
    
    for (CardView * card in self.charViewArray) {
        NSLog(@"card.char==:%@",[card charV]);
        if (!card.isUpState && [[card charV] isEqualToString:c]) {
            [self setUP:card];
        }
    }
    
}

-(void) actionDownForDoubleClick{
    [self.selectedCharViewArray removeAllObjects];
    for (CardView * card in self.charViewArray) {
        if (card.isUpState) {
            [self setDown:card];
        }
    }
}

#pragma mark 点击单词列表，将单词所含字符弹起
-(void) actionUpByWord:(NSString *) word{
    [self actionDownForDoubleClick];
    for (NSInteger i = 0;i<word.length;i++) {
        NSString *charv = [word substringWithRange:NSMakeRange(i, 1)];
        for (CardView * card in self.charViewArray) {
            if ([[card charV] isEqualToString:charv]) {
                [self setUP:card];
                [self.selectedCharViewArray addObject:card];
                break;
            }
        }
    }
}
#pragma mark 点击"吃"列表，将单词所含字符弹起,包含“会儿”
//吃的牌不在charViewArray显示，所以要去掉吃的牌
-(void) actionUpByWordFromEatView:(NSString *) word withHui:(BOOL) isHui notContainChar:(NSString *) eat{
    [self actionDownForDoubleClick];
    BOOL expert = FALSE;
    for (NSInteger i = 0;i<word.length;i++) {
        NSString *charv = [word substringWithRange:NSMakeRange(i, 1)];
        if ([charv isEqualToString:eat] && (!expert)) {
            expert = TRUE;
            continue;
        }
        BOOL contain = FALSE;
        for (CardView * card in self.charViewArray) {
            if ([[card charV] isEqualToString:charv] && (!card.isUpState)) {
                [self setUP:card];
                [self.selectedCharViewArray addObject:card];
                contain = TRUE;
                break;
            }
            
        }
        if (!contain && isHui) {
            for (CardView * card in self.charViewArray) {
                if ([[card charV] isEqualToString:WNKEY] && (!card.isUpState)) {
                    [self setUP:card];
                    [self.selectedCharViewArray addObject:card];
                    break;
                }
                
            }
        }
    }
}

-(CGSize)cardSize{
    
    if (CGSizeEqualToSize(_cardSize, CGSizeZero)) {
        UIImage *cardimg = [UIImage imageNamed:@"charback"];
        float scale = _deskDirect == DeskDirect_TOP?0.6:1.0;
        _cardSize.width = cardimg.size.width * scale / IP6PLUSRATE;
        _cardSize.height = cardimg.size.height * scale / IP6PLUSRATE;
        
    }
    return _cardSize;
}
-(CGSize)outCardSize{
    if (CGSizeEqualToSize(_outCardSize, CGSizeZero)) {
        UIImage *cardimg = [UIImage imageNamed:@"charback"];
        float scale = 0.6;
        _outCardSize.width = cardimg.size.width * scale / IP6PLUSRATE;
        _outCardSize.height = cardimg.size.height * scale / IP6PLUSRATE;
        
    }
    return _outCardSize;
}
-(CGSize)eatCardSize{
    
    if (CGSizeEqualToSize(_eatCardSize, CGSizeZero)) {
        UIImage *cardimg = [UIImage imageNamed: @"charback"];
        _eatCardSize.width = cardimg.size.width * 0.6 / IP6PLUSRATE;
        _eatCardSize.height = cardimg.size.height * 0.6 / IP6PLUSRATE;
        
    }
    return _eatCardSize;
}
-(CGSize)selectedCardSize{
    if (CGSizeEqualToSize(_selectedCardSize, CGSizeZero)) {
        UIImage *cardimg = [UIImage imageNamed: @"charback"];
        _selectedCardSize.width = cardimg.size.width * 0.6 / IP6PLUSRATE;
        _selectedCardSize.height = cardimg.size.height * 0.6 / IP6PLUSRATE;
    }
    return _selectedCardSize;
}
-(CGSize)tingInfoCardSize{
    if (CGSizeEqualToSize(_tingInfoCardSize, CGSizeZero)) {
        _tingInfoCardSize.width = self.cardSize.width * 0.4;
        _tingInfoCardSize.height = self.cardSize.height * 0.4;
    }
    return _tingInfoCardSize;
}
-(float)tingInfoCardMargin{
    if (_tingInfoCardMargin == 0) {
        _tingInfoCardMargin =0-( self.tingInfoCardSize.width * LEFTSHADE * (1 - LEFTSHADESHOW) );
    }
    return _tingInfoCardMargin;
}
-(float)selectedCardMargin{
    if (_selectedCardMargin == 0) {
        _selectedCardMargin =0-( self.selectedCardSize.width * LEFTSHADE * (1 - LEFTSHADESHOW) );
    }
    return _selectedCardMargin;
}
-(float)cardMargin{
    if (_cardMargin == 0) {
        _cardMargin =0-( self.cardSize.width * LEFTSHADE * (1 - LEFTSHADESHOW) );
    }
    return _cardMargin;
}

-(float)eatCardMargin{
    if (_eatCardMargin == 0) {
        _eatCardMargin =0-( self.eatCardSize.width * LEFTSHADE * (1 - LEFTSHADESHOW) );
    }
    return _eatCardMargin;
}
-(float)outCardMargin{
    if (_outCardMargin == 0) {
        _outCardMargin =0-( self.outCardSize.width * LEFTSHADE * (1 - LEFTSHADESHOW) );
    }
    return _outCardMargin;
}

-(float)sortCardBeginMarx{
    
    float result = 0.0f;
    NSInteger wordnum = 0;
    if (self.eatCharViewArray.count>0) {
        for (NSInteger i = 0; i<self.eatCharViewArray.count; i++) {
            NSArray *tmp = [self.eatCharViewArray objectAtIndex:i];
            result +=( self.eatCardSize.width + (tmp.count-1) * (self.eatCardSize.width + self.eatCardMargin) );
            result += 10;
            wordnum += tmp.count;
        }
        
    }
    if (self.charViewArray.count>0) {
        result += self.cardSize.width + (self.charViewArray.count - 1) * (self.cardSize.width + self.cardMargin);
    }
    
    if (wordnum + self.charViewArray.count == 14) {
        result += 7;
        result -= self.cardMargin;
    }
    
    _sortCardBeginMarx = (SCREEN_W - result) / 2.0;
    
    return _sortCardBeginMarx;
}




@end








//if (_tingSet) {//听状态 下自动操作
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //            if ([acha isEqualToString:_tingNeedChar] || [acha isEqualToString:WNKEY]) {
//        
//        NSLog(@"need==========%@===========================%@",self.deskDirect == DeskDirect_TOP ? @"电脑" : @"人",_tingNeedChar);
//        
//        if ([_tingNeedChar containsObject:acha] || [acha isEqualToString:WNKEY]) {
//            
//            self.save_step1_tingCacheLibraryChar = achaLibrary;
//            
//            [self setupTingData_ByHuChar:acha];
//            NSLog(@"鸡胡");
//            [self.charArray addObject:acha];
//            
//            [self cardToIn:acha];
//            
//            if (self.deskDirect == DeskDirect_TOP) {
//                NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
//                if (targetword != nil && targetword.count>0) {
//                    [dic_preWordsArray addObjectsFromArray:targetword];
//                }
//                [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
//            }else{
//                [self resetControlByisEat:NO isting:NO ishu:TRUE isguo:TRUE];
//            }
//            
//        }else
//            if ([_tingNeedChar containsObject:achaLibrary] || [achaLibrary isEqualToString:WNKEY]) {
//                self.save_step2_tingCacheLibraryChar = achaLibrary;
//                [self setupTingData_ByHuChar:achaLibrary];
//                NSLog(@"自摸胡");
//                [self.charArray addObject:achaLibrary];
//                [self cardToIn:achaLibrary];
//                
//                if (self.deskDirect == DeskDirect_TOP) {
//                    NSArray *targetword = [dic_correctString componentsSeparatedByString:@","];
//                    if (targetword != nil && targetword.count>0) {
//                        [dic_preWordsArray addObjectsFromArray:targetword];
//                    }
//                    
//                    [self performSelector:@selector(successful) withObject:nil afterDelay:0.5];
//                }else{
//                    [self resetControlByisEat:NO isting:NO ishu:TRUE isguo:TRUE];
//                }
//                
//                
//            }else{
//                [self.charArray addObject:achaLibrary];
//                [self cardToIn:achaLibrary];
//                
//                [self performSelector:@selector(actionOut:) withObject:achaLibrary afterDelay:0.5];
//                
//            }
//    });
//    
//}
