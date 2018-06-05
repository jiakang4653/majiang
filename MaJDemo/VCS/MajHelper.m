//
//  WordViewController.m
//  MasonryABC
//
//  Created by ly on 2017/1/6.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "MajHelper.h"






#import <objc/runtime.h>

@implementation UIColor(HEXCOLOR)

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end

@implementation NSObject (CategoryNSObject)

#pragma mark Associated Methods:

- (id) associateValue:(id)value withKey:(NSString *)aKey {
    
    objc_setAssociatedObject( self, (__bridge void *)aKey, value, OBJC_ASSOCIATION_RETAIN );
    return self;
}

- (id) associatedValueForKey:(NSString *)aKey {
    
    return objc_getAssociatedObject( self, (__bridge void *)aKey );
}


@end

@implementation UIView(CLICKTAG)

-(void)addClickBlock:(imageViewBlock)block{
    [self associateValue:block withKey:@"block"];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *res = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickme)];
//    res.delegate = self;
    [self addGestureRecognizer:res];
    [self associateValue:res withKey:@"singleGes"];
    [self dealGesture];
}
-(void) clickme{
    NSLog(@"单击....");
    imageViewBlock block = [self associatedValueForKey:@"block"];
    if (block) {
        block(self.tag);
    }
}


-(void)addDoubleClickBlock:(imageViewBlock)block{

    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    [self associateValue:block withKey:@"douleBlock"];
    [self associateValue:doubleTapGestureRecognizer withKey:@"doubleGes"];
    //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
    [self dealGesture];
    
}
-(void) doubleTap:(UITapGestureRecognizer *) ges{
    NSLog(@"双击....");
    imageViewBlock block = [self associatedValueForKey:@"douleBlock"];
    if (block) {
        block(self.tag);
    }
    
}
//使双击手势检测完毕再检测单击手势
-(void) dealGesture{
    if ([self associatedValueForKey:@"singleGes"] && [self associatedValueForKey:@"doubleGes"]) {
        [[self associatedValueForKey:@"singleGes"] requireGestureRecognizerToFail:[self associatedValueForKey:@"doubleGes"]];
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 判断是不是UIButton的类
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
@end

@interface MajHelper()

@property (nonatomic,strong) NSMutableDictionary *wordsLibraryDictionary;
@property (nonatomic,strong) NSMutableArray *wordsLibraryArray;
@property (nonatomic,strong) NSMutableArray *charsLibraryArray;
@property (nonatomic,strong) NSMutableDictionary *wordTranslationDic;

@end

@implementation NSMutableArray(ADDNUMBER)

-(void) addNumber:(NSInteger) number{
    [self addObject:[NSNumber numberWithInteger:number]];
}
- (NSMutableArray *)shuffle
{
    NSInteger count = [self count];
    for (int i = 0; i < count; ++i) {
        int n = (arc4random() % (count - i)) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return self;
}

@end

#import <AVFoundation/AVFoundation.h>
@interface MajHelper ()
{
    AVAudioPlayer *auplayer;
}
@end

@implementation MajHelper

static MajHelper *helper;
+(instancetype) shareHelper{
    if (helper == nil) {
        helper = [[MajHelper alloc] init];
    }
    return helper;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initWordLibrary];
        [self initCharLibrary];
        
    }
    return self;
}

-(void) initWordLibrary{
    
    
    
    self.wordsLibraryArray = [NSMutableArray array];
    self.wordTranslationDic = [NSMutableDictionary  dictionary];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wordssss" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",dataStr);
//    NSArray *chars = [dataStr componentsSeparatedByString:@"\U00002028"];
    NSArray *charsss = [dataStr componentsSeparatedByString:@"\r"];
    NSMutableArray *chars = [NSMutableArray array];
    for (NSString *ss in charsss) {
        if (![ss isEqualToString:@""]) {
            [chars addObject:ss];
        }
    }
    for (NSInteger i = 0; i<chars.count; i++) {
        NSString *st = [chars objectAtIndex:i];
        NSArray *tmp = [st componentsSeparatedByString:@" "];
        if (tmp.count>0) {
            [self.wordsLibraryArray addObject:[[tmp objectAtIndex:0] lowercaseString]];
            [self.wordTranslationDic setObject:[tmp lastObject] forKey:[tmp firstObject]];
        }
    }
    
    
    
    
    
    
    self.wordsLibraryDictionary = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i<self.wordsLibraryArray.count; i++) {
        NSString *word = [self.wordsLibraryArray objectAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"%zd",word.length];
        if ([self.wordsLibraryDictionary objectForKey:key] == nil) {
            NSMutableArray *tmp = [NSMutableArray array];
            [self.wordsLibraryDictionary setObject:tmp forKey:key];
            [tmp addObject:word];
        }else{
            NSMutableArray *tmp = [self.wordsLibraryDictionary objectForKey:key];
//            if (tmp.count>9) {
//                continue;
//            }
            [tmp addObject:word];
        }
    }
    
    
    [self.wordsLibraryArray removeAllObjects];
    NSArray *allkeystmp = [self.wordsLibraryDictionary allKeys];
    NSMutableArray *allkeysSort = [NSMutableArray array];
    [allkeysSort addObjectsFromArray:allkeystmp];
    [allkeysSort sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger int1 = [obj1 integerValue];
        NSInteger int2 = [obj2 integerValue];
        return int1>int2;
    }];
    for (NSInteger i =0; i<allkeysSort.count; i++) {
        NSString *key = [allkeysSort objectAtIndex:i];
        NSArray *value = [self.wordsLibraryDictionary objectForKey:key];
        [self.wordsLibraryArray addObjectsFromArray:value];
    }
    
    [self.wordsLibraryArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
}

-(NSMutableArray *) getWordsArray{
    return self.wordsLibraryArray;
}
-(NSDictionary *) getWordTranslationDic{
    return  self.wordTranslationDic;
}
-(NSInteger) getCharLibraryCount{
    return self.charsLibraryArray.count;
}

-(void) initCharLibrary{
    if (self.charsLibraryArray == nil) {
        self.charsLibraryArray = [NSMutableArray array];
    }
    if (self.charsLibraryArray.count != 0) {
        [self.charsLibraryArray removeAllObjects];
    }

//    NSArray *chara = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
      NSArray *chara = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    NSString *key = WNKEY;
    NSArray *charb = @[@"e",@"t",@"a",@"o",@"i",@"s"];
    
    for (NSInteger i = 0; i<4; i++) {
        [self.charsLibraryArray addObjectsFromArray:chara];
    }
    for (NSInteger i = 0; i<4; i++) {
        [self.charsLibraryArray addObjectsFromArray:charb];
    }
    for (NSInteger i = 0; i<8; i++) {
        [self.charsLibraryArray addObject:key];
    }
    
    [self.charsLibraryArray shuffle];
}

-(NSMutableArray *) getCharsByNum:(NSInteger) num{
    NSMutableArray *array = [NSMutableArray array];
    if (self.charsLibraryArray.count < num) {
        return array;
    }
    NSArray *sub = [self.charsLibraryArray subarrayWithRange:NSMakeRange(0, num)];
    [array addObjectsFromArray:sub];
    [self.charsLibraryArray removeObjectsInRange:NSMakeRange(0, num)];
    return array;
}

- (NSDictionary *)start:(NSMutableArray *) charArray {
  
    
    NSMutableArray *result = [self prepareChar:charArray useKey:YES];
    
    
    //去掉result中last相同的项目
    
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i<result.count; i++) {
        NSMutableArray *lastArray = [[result objectAtIndex:i] lastObject];
        if (lastArray.count==0) {
            NSMutableArray *wordArray = [[result objectAtIndex:i] objectAtIndex:0];
            NSMutableString *mu = [[NSMutableString alloc] init];
            for (NSInteger j = 0; j<wordArray.count; j++) {
                [mu appendString:[wordArray objectAtIndex:j]];
                if (j != wordArray.count-1) {
                    [mu appendString:@","];
                }
            }
            
            [returnDic setObject:[NSNumber numberWithInteger:0] forKey:@"error"];
            [returnDic setObject:mu forKey:@"prewords"];
            break;
        }
    }
    if (returnDic.allKeys.count != 0) {
        return returnDic;
    }
    
    
    //保存听多个结果
    NSMutableArray *tingArray = [NSMutableArray array];
    NSMutableArray *existCharArray = [NSMutableArray array];
    
    NSMutableArray *huArray = [NSMutableArray array];
    
    NSMutableArray *dealArray = [self deleteSameInArray:result];
    
    NSInteger error = NSNotFound;
    for (NSInteger i = 0; i<dealArray.count; i++) {
        NSMutableArray *cuArray = [dealArray objectAtIndex:i];
       NSDictionary *joinWord = [self compareChar:[cuArray lastObject]];
        if ([[joinWord objectForKey:@"error"] integerValue]<error) {
            error = [[joinWord objectForKey:@"error"] integerValue];
            NSLog(@"error:%zd",error);
            [returnDic removeAllObjects];
            [returnDic addEntriesFromDictionary:joinWord];
            [returnDic setObject:[cuArray objectAtIndex:0] forKey:@"prewords"];
        }
        
        
        
        [existCharArray removeAllObjects];
        //保存听多个结果
//        if ([[joinWord objectForKey:@"error"] integerValue] == 1) {
        if ([joinWord objectForKey:@"tingarray"]  != nil) {
             id tingArrTmp = [joinWord objectForKey:@"tingarray"];
            if (tingArrTmp != nil && [tingArrTmp isKindOfClass:[NSArray class]]) {
                NSArray *tmp = (NSArray *) tingArrTmp;
                if (tmp.count>0) {
                    for (NSInteger ii = 0 ; ii<tmp.count; ii++) {
                        NSDictionary *dicTmp = [tmp objectAtIndex:ii];
                        NSArray *needArray = [dicTmp objectForKey:@"need"];
                        if (needArray.count>0) {
                            NSString *cc = [needArray objectAtIndex:0];
                            if ([existCharArray containsObject:cc]) {
                                
                            }else{
                                [existCharArray addObject:cc];
                                NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
                                [newDic setObject:[cuArray objectAtIndex:0] forKey:@"prewords"];
                                [tingArray addObject:newDic];
                            }
                        }
                        
                    }
                
                }
                
            }
        }
        
        
//        if ([[joinWord objectForKey:@"error"] integerValue] == 0) {
        if ([joinWord objectForKey:@"huarray"]  != nil) {
            NSMutableArray *huTmp = [joinWord objectForKey:@"huarray"];
            for (NSInteger hu = 0; hu<huTmp.count; hu++) {
                NSArray *words = [[huTmp objectAtIndex:hu] componentsSeparatedByString:@","];
                NSMutableArray *addTmp = [NSMutableArray arrayWithArray:words];
                [addTmp addObjectsFromArray:[cuArray objectAtIndex:0]];
                [huArray addObject:addTmp];
            }
            [huTmp removeAllObjects];
            
        }
        
        
    }
   
    if (tingArray && tingArray.count>0) {
        [returnDic setObject:tingArray forKey:@"tingarray"];
        [existCharArray removeAllObjects];
        
    }else{
        [tingArray removeAllObjects];
        [existCharArray removeAllObjects];
    }
    
    if (huArray && huArray.count>0) {
        //去重复操作
        [returnDic setObject:huArray forKey:@"huarray"];
        
    }else
    {
        [huArray removeAllObjects];
    }
   
    NSLog(@"%@",returnDic);
    
    return returnDic;
    
}

//去掉数组中last中元素相同的项目
-(NSMutableArray *) deleteSameInArray:(NSMutableArray *) sourceArray{

    NSMutableArray *stringArray = [NSMutableArray array];
    NSMutableArray *resutnArray = [NSMutableArray array];
    for (NSInteger i = 0; i<sourceArray.count; i++) {
        NSMutableArray *lastArray = [[sourceArray objectAtIndex:i] lastObject];
        [lastArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        NSMutableString *mu = [[NSMutableString alloc] init];
        for (NSInteger j = 0; j<lastArray.count; j++) {
            [mu appendString:[lastArray objectAtIndex:j]];
        }
        if (![stringArray containsObject:mu]) {
            [stringArray addObject:mu];
            [resutnArray addObject:[sourceArray objectAtIndex:i]];
        }
    }

    return resutnArray;
}

#pragma mark 剩余字母有效分组
-(void) wordLenGroup:(NSInteger) len min:(NSInteger) min max:(NSInteger) max  toArray:(NSMutableArray *) toArray currentLoopArray:(NSMutableArray *) currentArray{
    
    if (currentArray == nil) {
        currentArray = [NSMutableArray array];
    }
 
    NSMutableArray *loops = [self getMaxLoop:len max:max min:min];
    if (loops.count == 0 ) {
        [currentArray removeAllObjects];
        return;
    }
    for (NSInteger index = 0; index<loops.count; index++) {
        NSInteger i = [[loops objectAtIndex:index] integerValue];
        NSInteger last = len - i;
        if (last == 0 && currentArray.count==0) {
            NSMutableArray*  newarray = [NSMutableArray array];
            [newarray addObjectsFromArray:currentArray];
            [newarray addNumber:i];
            [toArray addObject:newarray];
            [currentArray removeAllObjects];
            
            break;
        }else
        if (last>=min && last<=max) {
            NSMutableArray*  newarray = [NSMutableArray array];
            NSMutableArray*  newarray2 = [NSMutableArray array];
            [newarray2 addObjectsFromArray:currentArray];
            [newarray2 addNumber:i];
            [newarray addObjectsFromArray:newarray2];
            [newarray2 addNumber:last];
            [toArray addObject:newarray2];
          
            if (last>min) {
            [self wordLenGroup:last min:min max:max toArray:toArray currentLoopArray:newarray];
            }else{

                continue;
            }
            
            
        }else
            if (last<min) {
                [currentArray removeAllObjects];
                
            }else
                if (last>max) {
                    NSMutableArray *newarray = [NSMutableArray array];
                    [newarray addObjectsFromArray:currentArray];
                    [newarray addNumber:i];
                    
                    [self wordLenGroup:last min:min max:max toArray:toArray currentLoopArray:newarray];
                }
    }
    
    
}


-(NSMutableArray *) getMaxLoop:(NSInteger) len max:(NSInteger) max min:(NSInteger) min{
    
   NSMutableArray* resultArray = [NSMutableArray array];
    
    for (NSInteger i = min; i<=max; i++) {
      NSInteger  last = len - i;
        
        if(last<min){
            if (last==0) {
                [resultArray addNumber:i];
            }
        }
        else{
            
                if (i>(len - i)) {
                    
                }else
                    [resultArray addNumber:i];
            }
            
        
    }
    return resultArray;
    
}

#pragma mark 处理单词库
-(void) setupWordsLibrary{}

#pragma mark 匹配算法

//第一步过滤匹配的单词
//比较数组 移除最小匹配的

#pragma mark 算法2
-(NSMutableArray *) prepareChar:(NSMutableArray *) charArray useKey:(BOOL) useKey{

    NSMutableArray *toArray = [NSMutableArray array];
    [self compare2:charArray useKey:YES toArray:toArray];
    if (toArray.count==0) {
        //一个符合单词都没有
        NSMutableArray *noResult = [NSMutableArray array];
        [noResult addObject:[NSMutableArray array]];
        [noResult addObject:charArray];
        NSMutableArray *result = [NSMutableArray array];
        [result addObject:noResult];
        return result;
    }else{
        NSMutableArray *tmp = [NSMutableArray array];
        NSMutableArray *tmp2 = [NSMutableArray array];
        NSMutableArray*result = [self compareLoop:toArray toArray:tmp useWNKey:YES otherArray:tmp2];
        return result;
    }

    return nil;
}
-(void) compare2:(NSMutableArray *) charArray useKey:(BOOL) useKey toArray:(NSMutableArray *) toArray{

    for (NSInteger i = 0; i<self.wordsLibraryArray.count; i++) {
        NSString *word = [self.wordsLibraryArray objectAtIndex:i];
        NSLog(@"单词:%@",word);
        
        NSDictionary* error = [self compareWord:word inArray:charArray useWNKey:useKey];
        if ([[error objectForKey:@"error"] integerValue] == 0) {
            NSMutableArray *lastArray = [error objectForKey:@"chars"];
            NSMutableArray *maxloops = [self getMaxLoop:lastArray.count max:MAX_WORD_LEN min:MIN_WORD_LEN];
            if (maxloops.count>0) {//验证剩余字母有效
                NSMutableArray *tmp = [NSMutableArray array];
                [toArray addObject:tmp];
                [tmp addObject:[NSMutableArray arrayWithObject:word]];
                [tmp addObject:lastArray];
            }else{
                
            }
            
        }else{
        }
    }
}

//otherarray:剩余字母没有包含单词，但是可能剩余字母比较少，保存起来统一比较
-(NSMutableArray *) compareLoop:(NSMutableArray *) sourceArray toArray:(NSMutableArray *) toArray  useWNKey:(BOOL)useKey otherArray:(NSMutableArray *) otherArray{

    BOOL isContinue = FALSE;
    for (NSInteger i = 0; i<sourceArray.count; i++) {
        NSMutableArray *currentArray = [sourceArray objectAtIndex:i];
        NSMutableArray *charArray = [currentArray lastObject];
        BOOL currentLoopFlag = FALSE;
        for (NSInteger j = 0; j<self.wordsLibraryArray.count; j++) {
             NSString *word = [self.wordsLibraryArray objectAtIndex:j];
            NSLog(@"word:%@=%zd",word,charArray.count);
            NSDictionary* error = [self compareWord:word inArray:charArray useWNKey:useKey];
            if ([[error objectForKey:@"error"] integerValue] == 0) {
                
                NSMutableArray *lastArray = [error objectForKey:@"chars"];
                NSMutableArray *maxloops = [self getMaxLoop:lastArray.count max:MAX_WORD_LEN min:MIN_WORD_LEN];
                if (maxloops.count>0) {//验证剩余字母有效
                    isContinue = YES;
                    currentLoopFlag = TRUE;
                    NSMutableArray *tmp = [NSMutableArray array];
                    NSMutableArray *words  = [NSMutableArray array];
                    [words addObjectsFromArray:[currentArray objectAtIndex:0]];
                    [words addObject:word];
                    [tmp addObject:words];
                    [tmp addObject:lastArray];
                    [toArray addObject:tmp];
                }else{
                    
                }

                }
            else{
               
                
                }
                
        }
        if (!currentLoopFlag) {
             [otherArray addObject:currentArray];
        }
    }
    
    if (isContinue) {
        NSLog(@"继续======");
      return   [self compareLoop:toArray toArray:[NSMutableArray array] useWNKey:useKey otherArray:otherArray];
    }else{
        NSLog(@"结束======");
        if (otherArray.count>0) {
            [sourceArray addObjectsFromArray:otherArray];
        }
        [self compareArrayAndMove:sourceArray];
        NSMutableArray *resultArray = [NSMutableArray array];
        [resultArray addObjectsFromArray:sourceArray];
        
        return resultArray;
    }
    return nil;
}

-(void) compareArrayAndMove:(NSMutableArray *) toArray{
    
    //算法2
//    NSMutableArray *words;
//    NSMutableArray *lasts;
//    for (NSInteger i = 0; i<toArray.count; i++) {
//        NSMutableArray *wTmp = [[toArray objectAtIndex:i] objectAtIndex:0];
//        NSMutableArray *lastTmp = [[toArray objectAtIndex:i] objectAtIndex:1];
//        if (words==nil) {
//            words = wTmp;
//            lasts = [[toArray objectAtIndex:i] objectAtIndex:1];
//        }
//        if (lastTmp.count<lasts.count) {
//            words = wTmp;
//            lasts = [[toArray objectAtIndex:i] objectAtIndex:1];
//        }
//    }
//
//    [toArray removeAllObjects];
//    NSMutableArray *tmp = [NSMutableArray array];
//    [tmp addObject:words];
//    [tmp addObject:lasts];
//    [toArray addObject:tmp];
//
//    NSLog(@"");
}



//第二步匹配剩余字母,返回还手最小的单词组合
-(NSDictionary *) compareChar:(NSMutableArray *) charArray {
    
    NSInteger error = NSNotFound;
    NSString *minString;
    NSMutableArray *needArray;
    NSMutableArray *lastCharArray;
    
    //“听” 时候 多个结果的保存
    BOOL isTing = FALSE;
    NSMutableArray *tingArray;
    
    BOOL isHu = FALSE;
    NSMutableArray *huArray;
    
    NSMutableArray *result = [NSMutableArray array];
    [self wordLenGroup:charArray.count min:MIN_WORD_LEN max:MAX_WORD_LEN toArray:result currentLoopArray:nil];
    
    //去重复操作

    NSLog(@"%@",result);

    for (NSInteger i = 0; i<result.count; i++) { //group
        NSMutableArray *group = [result objectAtIndex:i];
        NSMutableArray *joinWords = [self joinWord:group];
        
        NSLog(@"=============join-words-count:%zd",joinWords.count);
        
        
        
        for (NSInteger j = 0; j<joinWords.count; j++) {
            NSString *joinWord = [joinWords objectAtIndex:j];
           NSDictionary *detail = [self compareWord:[joinWord stringByReplacingOccurrencesOfString:@"," withString:@""] inArray:charArray useWNKey:YES];
            NSInteger err = [[detail objectForKey:@"error"] integerValue];
            
            if (err == 0) {
                NSLog(@"index:%zd",j);
            }
            
            if (err<error) {
                error = err;
                minString = joinWord;
                needArray = [detail objectForKey:@"need"];
                lastCharArray = [detail objectForKey:@"chars"];
            }
            
            if (err == 1) {
                isTing = TRUE;
                if (!tingArray) {
                    tingArray = [NSMutableArray array];
                }
            }
            
            if (isTing  && err == 1) {
 
                    NSDictionary *tingTmpDic =
                    @{@"error":[NSNumber numberWithInteger:1],@"chars":joinWord,@"need":[detail objectForKey:@"need"],@"last":[detail objectForKey:@"chars"]};
                    [tingArray addObject:tingTmpDic];

            }
            
            if (err == 0) {
                isHu = TRUE;
                if (!huArray) {
                    huArray = [NSMutableArray array];
                }
            }
            
            if (isHu && err == 0) {
                [huArray addObject:joinWord];
            }
            
        }
        
        [joinWords removeAllObjects];
    }
    
    NSMutableDictionary *rDic = [NSMutableDictionary dictionaryWithDictionary:
//    NSDictionary *rDic =
                                 @{@"error":[NSNumber numberWithInteger:error],@"chars":minString,@"need":needArray,@"last":lastCharArray}
                                 ];
    if (tingArray && tingArray.count>0) {
        [rDic setObject:tingArray forKey:@"tingarray"];
    }
    if (huArray && huArray.count>0) {
        [rDic setObject:huArray forKey:@"huarray"];
    }
    return rDic;
}
-(NSMutableArray *) joinWord:(NSMutableArray *) group{
    
    NSMutableArray *join = [NSMutableArray array];
    for (NSInteger i = 0; i<group.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%zd",[[group objectAtIndex:i] integerValue]];
        NSMutableArray *words = [self.wordsLibraryDictionary objectForKey:key];
        if (join.count==0) {
            [join addObjectsFromArray:words];
        }else{
            NSMutableArray *longArray = [NSMutableArray array];
            for (NSInteger m = 0; m<join.count; m++) {
                for (NSInteger n =0; n<words.count; n++) {
                    NSString *newWord = [NSString stringWithFormat:@"%@,%@",[join objectAtIndex:m],[words objectAtIndex:n]];
                    [longArray addObject:newWord];
                }
            }
            [join removeAllObjects];
            [join addObjectsFromArray:longArray];
        }
        
    }
    
    return join;
}

-(NSDictionary *) compareWord:(NSString *) word inArray:(NSMutableArray *) charArray useWNKey:(BOOL) useKey{

    NSMutableArray *newCharArray = [NSMutableArray arrayWithArray:charArray];
    NSMutableArray *needCharArray = [NSMutableArray array];
    NSInteger error = 0;
    for (NSInteger i = 0; i<word.length; i++) {
        NSString *s = [word substringWithRange:NSMakeRange(i, 1)];
        NSInteger index = [newCharArray indexOfObject:s];
        if (index != NSNotFound) {
            [newCharArray removeObjectAtIndex:index];
        }else{
            if (useKey) {
                NSInteger keyIndex = [newCharArray indexOfObject:WNKEY];
                if (keyIndex != NSNotFound) {
                [newCharArray removeObjectAtIndex:keyIndex];
                }else{
                    error++;
                    [needCharArray addObject:s];
                }
            }else
            {
                error++;
                [needCharArray addObject:s];
            }
        }
    }
    return @{@"error":[NSNumber numberWithInteger:error],@"chars":newCharArray,@"need":needCharArray};
}

//前提 error=1
// abcdfe
// abcdfg
-(NSMutableArray *) compareAllWord:(NSString *) word inArray:(NSMutableArray *) charArray useWNKey:(BOOL) useKey{
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSMutableArray *newCharArray = [NSMutableArray arrayWithArray:charArray];
    NSMutableArray *needCharArray = [NSMutableArray array];
    NSString *placeChar ;
    NSInteger error = 0;
    for (NSInteger i = 0; i<word.length; i++) {
        NSString *s = [word substringWithRange:NSMakeRange(i, 1)];
        NSInteger index = [newCharArray indexOfObject:s];
        if (index != NSNotFound) {
            [newCharArray removeObjectAtIndex:index];
        }else{
            NSInteger keyIndex = [newCharArray indexOfObject:WNKEY];
            if (keyIndex != NSNotFound) {
                placeChar = s;
                [newCharArray removeObjectAtIndex:keyIndex];
            }else{
                error++;
                [needCharArray addObject:s];
            }
        }
    }
    
    return resultArray;
}


-(BOOL) checkVailWord:(NSInteger) wordlen chars:(NSInteger) charslen{
    
    NSInteger last = charslen - wordlen;
    
    return last == 0 ? TRUE : ([self getMaxLoop:last max:MAX_WORD_LEN min:MIN_WORD_LEN].count>0);
    
}



-(void) finishedClear{
    [self initCharLibrary];
}



#pragma mark play-audio
-(void) playAudio:(NSString *) autioName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:autioName ofType:@"mp3"];
    if (filePath) {
        auplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
        auplayer.volume = 1.0;
        [auplayer play];
    }
    
}



#pragma mark tool==

-(NSMutableArray *) cacalHu:(NSMutableArray *) withCharArray withHuWordsArray:(NSMutableArray *) withHuArray withTingWordsArray:(NSMutableArray *) withTingArray{
    
    
           //bed eyes eyes d.g
    
    //hu   //bed eyes eyes dog
    
    //Ti   //bed eyes eyes bed
           //bed eyes eyes dog
           //red eyes eyes day
           //red eyes eyes dog
    
    
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
    
    NSMutableArray *tingArray = [NSMutableArray arrayWithArray:withTingArray];
    NSMutableArray *containArray = [NSMutableArray array];
    
    
    //找到会所代替的字母
    NSMutableArray *xResultArray = [NSMutableArray array];
   
    for (NSInteger i = 0; i<huArray.count; i++) {
         NSMutableArray *xCharArray = [NSMutableArray arrayWithArray:withCharArray];
        NSMutableArray *ihuArray = [huArray objectAtIndex:i];
        for (NSInteger j = 0; j<ihuArray.count; j++) {
            NSString *word = [ihuArray objectAtIndex:j];
            for (NSInteger z = 0; z<word.length; z++) {
                NSString *zChar = [word substringWithRange:NSMakeRange(z, 1)];
                if ([xCharArray containsObject:zChar]) {
                    NSInteger xindex = [xCharArray indexOfObject:zChar];
                    if (xindex != NSNotFound) {
                        [xCharArray removeObjectAtIndex:xindex];
                    }
                    
                }else
                {
                    if (![xResultArray containsObject:zChar]) {
                        [xResultArray addObject:zChar];
                    }
                    
                    NSInteger xHuiIndex = [xCharArray indexOfObject:WNKEY];
                    if (xHuiIndex != NSNotFound) {
                        [xCharArray removeObjectAtIndex:xHuiIndex];
                    }
                    
                }
            }
        }
    }
    
    
    
    for (NSInteger i = 0; i<charArray.count; i++) {
        NSString *cc = [charArray objectAtIndex:i];
        if (![cc isEqualToString:WNKEY]) {
            NSMutableArray * tmpres =  [self addWithSelfChar:cc withHuArray:huArray withNotInArray:containArray withHuiPlace:xResultArray];
            if (tmpres && tmpres.count>0) {
                [returnArray addObjectsFromArray:tmpres];
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

-(NSMutableArray *) addWithSelfChar:(NSString *) cc withHuArray:(NSMutableArray *) withHuArray withNotInArray:(NSMutableArray *) containArray withHuiPlace:(NSMutableArray *) withHuiplaceArray{
    
    
    
    if ([containArray containsObject:cc]) {
        return nil;
    }else
        [containArray addObject:cc];
    
    
    NSMutableArray *huiArray = [NSMutableArray arrayWithArray:withHuiplaceArray];
    
    
    //添加cc字符
    
    NSMutableArray *returnArray = [NSMutableArray array] ;
    
    for (NSInteger zz = 0; zz<withHuArray.count; zz++) {
        
        
        
        NSMutableDictionary *returnDic;
        NSMutableArray *aaa = [withHuArray objectAtIndex:zz];
        NSMutableArray *tmpa = [NSMutableArray arrayWithArray:aaa];
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
            
            [returnArray addObject:returnDic];
            
            for (NSInteger hui = 0; hui<huiArray.count; hui++) {
                NSString *place = [huiArray objectAtIndex:hui];
                if (![place isEqualToString:cc]) {
                    NSMutableDictionary *huiDic = [NSMutableDictionary dictionaryWithDictionary:returnDic];
                    NSMutableArray *huineed = [NSMutableArray arrayWithObject:place];
                    [huiDic setObject:huineed forKey:@"need"];
                    [returnArray addObject:huiDic];
                }
                
                
            }
        }
    
    }
    
    
    
    
    
    
    
    return returnArray;
}






@end
