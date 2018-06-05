//
//  DeskVC.m
//  MaJDemo
//
//  Created by ly on 2017/1/16.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "DeskVC.h"
#import "MajHelper.h"
#import "PersonView.h"
#import "WordView.h"


@interface DeskVC ()
{
    PersonView *topView;
    PersonView *bottomView;
    PersonView *currentPersonView;
}

@property (nonatomic,strong) MajHelper *mHelper;

@property (nonatomic,strong) UIImageView * backgroundView;
@property (nonatomic,strong) UIButton * beginButton;
@property (nonatomic,strong) ShaiziView *szView;

@property (nonatomic) NSInteger stepCount;

@property (nonatomic,strong) NSMutableArray *personArray;

//@property (nonatomic,strong) UIView *wordsView;
@property (nonatomic,strong)  UITableView *scorll;
@property (nonatomic,strong)  UICollectionView *scorllCollectView;
@property (nonatomic,strong) NSMutableArray *wordsArray;


@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *helpButton;
@property (nonatomic,strong) UIImageView * libraryImageView;
@property (nonatomic,strong) UILabel * libraryLabel;

@property (nonatomic,strong) WordView *wordsView;
@end

@implementation DeskVC
-(BOOL)shouldAutorotate{
    return  YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backgroundView];
//    [self.view addSubview:self.wordsView];

    [self setupData];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.helpButton];
    [self.view addSubview:self.libraryImageView];
    [self.view addSubview:self.libraryLabel];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clear_reminder:) name:CLEARREMINDER object:nil];

    
    NSLog(@"%f--%f",SCREEN_W,SCREEN_H);
    
    UIImage *beginimg = [UIImage imageNamed:@"beginbutton"] ;
    _beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_beginButton setImage:beginimg forState:UIControlStateNormal];
    [_beginButton addTarget:self action:@selector(beginButton:) forControlEvents:UIControlEventTouchUpInside];
    _beginButton.frame = CGRectMake((SCREEN_W - beginimg.size.width) / 2, (SCREEN_H - beginimg.size.height) /2, beginimg.size.width, beginimg.size.height);
    [self.view addSubview:_beginButton];
    
    
}
-(void)clear_reminder:(NSNotification *)notify{
    NSString *str = [notify object];
    if ([str isEqualToString:@"top"]) {
        [bottomView.lastOutCardReminderIv removeFromSuperview];
        bottomView.lastOutCardReminderIv = nil;
        topView.round_reminder_lb.hidden = YES;
    }else{
        [topView.lastOutCardReminderIv removeFromSuperview];
        topView.lastOutCardReminderIv = nil;
        bottomView.round_reminder_lb.hidden = YES;

    }
}
-(void) test{
    __block AnimalView *waterView = [[AnimalView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    [waterView setBackgroundImage:[UIImage imageNamed:@"hu"] forState:UIControlStateNormal];
    
    waterView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:waterView];
    //    self.waterView = waterView;
    
    
    [UIView animateWithDuration:2 animations:^{
        
        waterView.transform = CGAffineTransformScale(waterView.transform, 2, 2);
        
        waterView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [waterView removeFromSuperview];
    }];
}

bool zuobi = FALSE;
static NSInteger zuobiNum = 0;
-(void) nextStep:(NSString *)cha{

    dispatch_async(dispatch_get_main_queue(), ^{
        if (currentPersonView == topView) {
            [bottomView.lastOutCardReminderIv removeFromSuperview];
            bottomView.lastOutCardReminderIv = nil;
            bottomView.round_reminder_lb.hidden = NO;
            currentPersonView = bottomView;
            topView.lastOutCardReminderIv.hidden = NO;

        }else{
            [topView.lastOutCardReminderIv removeFromSuperview];
            topView.lastOutCardReminderIv = nil;
            topView.round_reminder_lb.hidden = NO;
            currentPersonView = topView;
            bottomView.lastOutCardReminderIv.hidden = NO;

        }

        NSMutableArray *tmp = [self.mHelper getCharsByNum:1];
        if (tmp.count>0) {
            NSInteger num = [self.mHelper getCharLibraryCount];
            self.libraryLabel.text = [NSString stringWithFormat:@"%zd",num];
            NSString *chalib = [tmp objectAtIndex:0];
            if (zuobi) {
                if (currentPersonView == bottomView) {
                    if (zuobiNum % 3 == 0) {
                        chalib = @"万";
                    }
                    zuobiNum++;
                }
                
//                if (currentPersonView == topView) {
//                    chalib = @"d";
//                }
            }
            
            [currentPersonView addCharFromPerson:cha FromLibrary:chalib];
        }else{
            //游戏结束 平局
            [self didPing];
        }
    });
    
    
}

-(void) didPing{
    NSString *msg;
    msg = @"平局!";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"re-Start" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mHelper finishedClear];
            [topView finishedClear];
            [bottomView finishedClear];
            [topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [topView removeFromSuperview];
            topView = nil;
            [bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [bottomView removeFromSuperview];
            bottomView = nil;
            
            
            [self setupData];
            self.beginButton.hidden = NO;
            [self.view bringSubviewToFront:self.beginButton];
            [self.view bringSubviewToFront:self.backButton];
            [self.view bringSubviewToFront:self.helpButton];
        });
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) didFinished:(id) bean{
    
    NSString *msg ;
    if ([bean isKindOfClass:[UserInfoVO class]]) {
        UserInfoVO *tmp = (UserInfoVO *) bean;
        msg = [NSString stringWithFormat:@"%@ 胜",tmp.userName];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"胡" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"re-Start" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mHelper finishedClear];
        [topView finishedClear];
        [bottomView finishedClear];
        [topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [topView removeFromSuperview];
        topView = nil;
        [bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [bottomView removeFromSuperview];
        bottomView = nil;
        
        
        [self setupData];
        self.beginButton.hidden = NO;
        [self.view bringSubviewToFront:self.beginButton];
        [self.view bringSubviewToFront:self.backButton];
        [self.view bringSubviewToFront:self.helpButton];
    });
    }]];
    [self presentViewController:alert animated:YES completion:nil];

    
    
    
}

-(void) didError:(id) bean{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:bean preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    return;

}

-(void) setupData{
    
    

    UserInfoVO *topPerson = [[UserInfoVO alloc] init];
    topPerson.userName = @"AlphaGo";
    topPerson.score = @"++++";
    topView = [[PersonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H /2-20) withDirect:DeskDirect_TOP];
    [self.view addSubview:topView];
    [_personArray addObject:topView];
    __weak DeskVC *dself = self;
    topView.didOutCardBlock = ^(NSString *cha){
        
        [dself nextStep:cha];
    };
    topView.didFinishedBlock = ^(id bean){
        [dself didFinished:bean];
    };
    [topView setupHeaderViewData:topPerson];
    
    
    UserInfoVO *bottomPerson = [[UserInfoVO alloc] init];
    bottomPerson.userName = @"洋葱头";
    bottomPerson.score = @"5800";
    bottomView = [[PersonView alloc] initWithFrame:CGRectMake(0, SCREEN_H - (SCREEN_H/2)-20, SCREEN_W, SCREEN_H /2+20) withDirect:DeskDirect_BOTTOM];
    [self.view addSubview:bottomView];
    [_personArray addObject:bottomView];
    bottomView.didOutCardBlock = ^(NSString *cha){
        [dself nextStep:cha];
    };
    bottomView.didFinishedBlock = ^(id bean){
        [dself didFinished:bean];
    };
    bottomView.didError = ^(id bean){
        [dself didError:bean];
    };
    bottomView.didRefreshWordView = ^(NSMutableArray *chars){
        [dself performSelector:@selector(sortByChars:) withObject:chars afterDelay:0.01];
    };
    [bottomView setupHeaderViewData:bottomPerson];
    

}

-(void) beginButton:(UIButton *) button{
    
    
    
    self.beginButton.hidden = YES;
    NSMutableArray * p1 = [self.mHelper getCharsByNum:13];
    NSMutableArray * p2 = [self.mHelper getCharsByNum:14];
    
    _libraryLabel.text = [NSString stringWithFormat:@"%zd",[self.mHelper getCharLibraryCount]];
    
    [p2 sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
//    [p1 removeAllObjects];
//    
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
//    
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
//    
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
//    
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
//    
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
//    [p1 addObject:@"z"];
    
//    [p2 removeObjectAtIndex:0];
//    [p2 removeObjectAtIndex:0];
//    [p2 removeObjectAtIndex:0];
//    [p2 removeObjectAtIndex:0];
//    [p2 addObject:@"万"];
//    [p2 addObject:@"万"];
//    [p2 addObject:@"万"];
//    [p2 addObject:@"万"];
    
//    [p1 removeObjectAtIndex:0];
//    [p1 removeObjectAtIndex:0];
//    [p1 addObject:@"万"];
//    [p1 addObject:@"万"];
    
    
    
    
    
//    [p2 removeAllObjects];
//    [p2 addObject:@"d"];
//    [p2 addObject:@"e"];
//    [p2 addObject:@"b"];
//    
//    [p2 addObject:@"e"];
//    [p2 addObject:@"y"];
//    [p2 addObject:@"e"];
//    [p2 addObject:@"s"];
//    
//    [p2 addObject:@"e"];
//    [p2 addObject:@"y"];
//    [p2 addObject:@"e"];
//    [p2 addObject:@"s"];
//    
//    [p2 addObject:@"d"];
//    [p2 addObject:@"z"];
//    [p2 addObject:@"y"];
    
#pragma  mark - 排序
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSMutableArray * tmpP2 = [NSMutableArray arrayWithArray:[p2 sortedArrayUsingComparator:sort]];
    
    [bottomView setChar:p2];
    [topView setChar:p1];
    currentPersonView = bottomView;
    

//    [self refreshWordView];
    [self sortByChars:p2];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIButton *)backButton{
    if (_backButton == nil) {
        UIImage *img = [UIImage imageNamed:@"Return"];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:img forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.frame = CGRectMake(15, 15, img.size.width, img.size.height);
    }
    return _backButton;
}

-(void) actionBack:(UIButton *) button{
    NSLog(@"action back");
}

-(UIButton *)helpButton{
    if (_helpButton == nil) {
        UIImage *img = [UIImage imageNamed:@"help"];
        _helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setImage:img forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(actionHelp:) forControlEvents:UIControlEventTouchUpInside];
        _helpButton.frame = CGRectMake(15, self.backButton.frame.origin.y + self.backButton.frame.size.height + 23, img.size.width, img.size.height);
    }
    return _helpButton;
}

-(void) actionHelp:(UIButton *) button{
    NSLog(@"action help");
    [self.wordsView show];
}

-(UIImageView *)libraryImageView{
    if (_libraryImageView == nil) {
        _libraryImageView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"charback"];
        _libraryImageView.image = img;
        _libraryImageView.frame = CGRectMake(self.backButton.frame.origin.x + self.backButton.frame.size.width + 5, 15, img.size.width * 0.4 , img.size.height * 0.4 );
    }
    return _libraryImageView;
}

-(UILabel *)libraryLabel {
    if (_libraryLabel == nil) {
        _libraryLabel = [[UILabel alloc] init];
        _libraryLabel.backgroundColor = [UIColor clearColor];
        _libraryLabel.textAlignment = NSTextAlignmentLeft;
        _libraryLabel.font = [UIFont systemFontOfSize:14];
        _libraryLabel.textColor = [UIColor colorWithHexString:@"FFF445"];
        _libraryLabel.frame = CGRectMake(self.libraryImageView.frame.origin.x + self.libraryImageView.frame.size.width + 5, 15, 40, self.libraryImageView.frame.size.height);
        
    }
    return _libraryLabel;
}


-(UIImageView *) backgroundView{
    
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backgroundView.image = [UIImage imageNamed:@"bgr"];
    }
    return _backgroundView;
    
}

-(UIView *) wordsView{
    if (_wordsView == nil) {
//        float ww = 150;
//        float hh = SCREEN_H - 100;
//        float buttonw = 30;
//        float buttonh = 30;
//        _wordsView = [[UIView alloc] initWithFrame:CGRectMake(0-ww+buttonw, 20, ww, hh)];
//        _wordsView.backgroundColor = [UIColor clearColor];
//        _scorll = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ww-buttonw, hh)];
//        _scorll.showsVerticalScrollIndicator = NO;
//        _scorll.showsHorizontalScrollIndicator = NO;
//        _scorll.backgroundColor = [UIColor clearColor];
//        _scorll.delegate = self;
//        _scorll.dataSource = self;
//        [_wordsView addSubview:_scorll];
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(ww - buttonw, 0, buttonw, buttonh);
//        [button setTitle:@"单词" forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:12];
//        [button addTarget:self action:@selector(actionWordView:) forControlEvents:UIControlEventTouchUpInside];
//        [_wordsView addSubview:button];
        
        
        UIImage *blankimg = [UIImage imageNamed:@"help_blank"];
        UIImage *closeimg = [UIImage imageNamed:@"close"];
        float vieww = blankimg.size.width + closeimg.size.width / 2;
        float viewh =blankimg.size.height;
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSString *word in [self.mHelper getWordsArray]) {
            WordVO *vo = [[WordVO alloc] init];
            vo.wordString = word;
            vo.showString= [[NSAttributedString alloc] initWithString:word];
            vo.translationWord = [[self.mHelper getWordTranslationDic] objectForKey:word];
            [tmp addObject:vo];
        }
        _wordsView = [[WordView alloc] initWithFrame:CGRectMake((SCREEN_W - vieww)/2, (SCREEN_H - viewh) / 2, vieww,viewh ) data:tmp];
        __weak DeskVC *dself = self;
        _wordsView.audioClickBlock = ^(NSString *word){
        
            [dself.mHelper playAudio:word];
        };
        _wordsView.cellClickBlock = ^(NSString *word){
           [bottomView actionUpByWord:word];
        };
        
    }
    return _wordsView;
}

-(void) actionWordView:(UIButton *) button{
//    float ww = 150;
//    float hh = SCREEN_H - 100;
//    float buttonw = 30;
//    float buttonh = 30;
//    [UIView animateWithDuration:0.2 animations:^{
//        if (_wordsView.frame.origin.x == 0) {
//            _wordsView.frame = CGRectMake(0-ww+buttonw, 20, ww, hh);
//        }else{
//            _wordsView.frame = CGRectMake(0, 20, ww, hh);
//        }
//    }];
    
    
    
}

-(ShaiziView *)szView{
    if (_szView == nil) {
        float ww = 45;
        _szView = [[ShaiziView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - ww) / 2, (self.view.bounds.size.height - ww) / 2, ww, ww)];
        _szView.EndBlock = ^(NSNumber *number){
            NSLog(@"last point %zd",[number integerValue]);
        };
    }
    return _szView;
}

-(MajHelper *)mHelper{
    if (_mHelper == nil) {
//        _mHelper = [[MajHelper alloc] init];
        _mHelper = [MajHelper shareHelper];
    }
    return _mHelper;
}



#pragma mark words-view

-(void) refreshWordView{
    if (self.wordsArray == nil) {
        self.wordsArray = [NSMutableArray array];
    }
    [self.wordsArray removeAllObjects];
    [self.wordsArray addObjectsFromArray:[self.mHelper getWordsArray]];
    [self.scorll reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(tableView.frame.size.width - 10 - 40, 2, 40, 20);
        [button addTarget:self action:@selector(actionAudio:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 0.3;
        [button setTitle:@"play" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:8];
        button.tag = 10;
        [cell addSubview:button];
    }
    UIButton *but =(UIButton *) [cell viewWithTag:10];
    [but associateValue:[[self.wordsArray objectAtIndex:indexPath.row] lowercaseString] withKey:@"word"];
    cell.textLabel.text = [[self.wordsArray objectAtIndex:indexPath.row] lowercaseString];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self.mHelper playAudio:[self.wordsArray objectAtIndex:indexPath.row]];
    [bottomView actionUpByWord:[self.wordsArray objectAtIndex:indexPath.row]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wordsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 24;
}
-(void) actionAudio:(UIButton *) button{
    [self.mHelper playAudio:[button associatedValueForKey:@"word"]];
}


-(void) sortByChars:(NSMutableArray *) chars{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:chars];
    [self.wordsView reloadData:array];
    
}

-(NSMutableArray *) cacalHu:(NSMutableArray *) withCharArray withHuWordsArray:(NSMutableArray *) withHuArray withTingWordsArray:(NSMutableArray *) withTingArray{
    
//    {
//        chars = dry;
//        error = 1;
//        last =     (
//                    z
//                    );
//        need =     (
//                    r
//                    );
//        prewords =     (
//                        bed,
//                        eyes,
//                        eyes
//                        );
//    }
    
    
//target:
    
//    {
//        chars = dry;
//        error = 1;
//        last =     (
//                    i
//                    );
//        need =     (
//                    r
//                    );
//        prewords =     (
//                        bed,
//                        eyes,
//                        eyes
//                        );
//    },
    
    
    //1ed eyes eyes d1y   d1y
    
    //bed eyes eyes day   day
    //ded eyes eyas dry   dry
    
    //bed eyes eye. dzy
    //bed eyes eyes day   z.a z.r a.s
    
    //ced eyes eyes dry
    
    
    
    
    
    
    
    
    
//    if ([charArray containsObject:WNKEY]) {
//        
//        
//        
//    }else{
//        
//        NSMutableArray *chArray = [NSMutableArray arrayWithArray:charArray];
//        NSMutableArray *hArray = [NSMutableArray arrayWithArray:huArray];
//        if (huArray.count>1) {
//            
//            for (NSInteger i = 0; i<hArray.count; i++) {
//                
//            }
//        }else{
//            
//        }
//        
//    }
    
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    NSMutableArray *huArray = [NSMutableArray arrayWithArray:withHuArray];
    NSMutableArray *charArray = [NSMutableArray arrayWithArray:withCharArray];
    
    NSMutableArray *tingArray = [NSMutableArray array];
    NSMutableArray *containArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i<charArray.count; i++) {
        NSString *cc = [charArray objectAtIndex:i];
        if (![cc isEqualToString:WNKEY]) {
          NSMutableDictionary * dic =  [self addWithSelfChar:cc withHuArray:huArray withNotInArray:containArray];
            if (dic) {
                [returnArray addObject:dic];
            }
        }
    }
    
    for (NSInteger i = 0; i<tingArray.count; i++) {
        NSMutableDictionary *tmp = [tingArray objectAtIndex:i];
        if (tmp) {
            [returnArray addObject:tmp];
        }
    }
    
    return returnArray;
}

-(NSMutableDictionary *) addWithSelfChar:(NSString *) cc withHuArray:(NSMutableArray *) withHuArray withNotInArray:(NSMutableArray *) containArray{

    if ([containArray containsObject:cc]) {
        return nil;
    }else
        [containArray addObject:cc];
    
    NSMutableDictionary *returnDic ;
    
    NSMutableArray *tmpa = [NSMutableArray arrayWithArray:withHuArray];
    NSInteger index = NSNotFound;
    NSString  *targetWord;
    for (NSInteger j = 0; j<tmpa.count; j++) {
        NSString *word = [tmpa objectAtIndex:j];
        if ([word containsString:cc]) {
            index = j;
            targetWord = word;
            break;
        }
    }
    if (index != NSNotFound) {
        NSString *chars = targetWord;
        NSMutableArray *last = [NSMutableArray arrayWithObject:cc];
        NSMutableArray *need = [NSMutableArray arrayWithObject:cc];
        [tmpa removeObjectAtIndex:index];
        
        if (!returnDic) {
            returnDic = [NSMutableDictionary dictionary];
        }
        [returnDic setObject:chars forKey:@"chars"];
        [returnDic setObject:last forKey:@"last"];
        [returnDic setObject:need forKey:@"need"];
        [returnDic setObject:tmpa forKey:@"prewords"];
        
        
    }
    
    return returnDic;
}





@end
