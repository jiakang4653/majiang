//
//  PersonView.h
//  MaJDemo
//
//  Created by ly on 2017/1/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShaiziView.h"
#import "AnimalView.h"



@interface PersonView : UIView

//-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame  withDirect:(DeskDirect) dd;

@property (nonatomic,copy) void (^didOutCardBlock)(NSString *cha);
@property (nonatomic,copy) void (^didFinishedBlock)(id bean);
@property (nonatomic,copy) void (^didError)(id bean);
@property (nonatomic,copy) void (^didRefreshWordView)(NSMutableArray *chars);
@property (nonatomic,strong) UIImageView *lastOutCardReminderIv;//提示箭头
@property (nonatomic,strong) UILabel *round_reminder_lb;//出牌回合


-(void) setDirect:(DeskDirect)deskDirect;
-(void) setChar:(NSMutableArray *)charArray;
-(void)setShuaiziNum:(NSInteger)shuaiziNum;
-(void) addCharFromPerson:(NSString *) acha FromLibrary:(NSString *)achaLibrary;

-(void) finishedClear;

-(void) actionUpByWord:(NSString *) word;

-(void) setupHeaderViewData:(UserInfoVO *) userinfo;
@end
