//
//  WordViewController.h
//  MasonryABC
//
//  Created by ly on 2017/1/6.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^imageViewBlock)(NSInteger tag);

@interface UIColor(HEXCOLOR)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end

@interface NSObject (CategoryNSObject)

- (id) associateValue:(id)value withKey:(NSString *)aKey;
- (id) associatedValueForKey:(NSString *)aKey;

@end

@interface UIView(CLICKTAG)<UIGestureRecognizerDelegate>
-(void) addClickBlock:(imageViewBlock) block;
-(void) addDoubleClickBlock:(imageViewBlock) block;
@end

@interface NSMutableArray(ADDNUMBER)
-(void) addNumber:(NSInteger) number;
- (NSMutableArray *)shuffle;
@end

@interface MajHelper : NSObject
+(instancetype) shareHelper;
-(void) initWordLibrary; //词库
-(void) initCharLibrary; //牌库
- (NSDictionary *)start:(NSMutableArray *) charArray;
-(NSMutableArray *) getCharsByNum:(NSInteger) num;
-(NSDictionary *) compareWord:(NSString *) word inArray:(NSMutableArray *) charArray useWNKey:(BOOL) useKey;
-(NSMutableArray *) getWordsArray;
-(NSDictionary *) getWordTranslationDic;
-(NSInteger) getCharLibraryCount;
-(void) finishedClear;
-(BOOL) checkVailWord:(NSInteger) wordlen chars:(NSInteger) charslen;
-(void) playAudio:(NSString *) autioName;

-(NSMutableArray *) cacalHu:(NSMutableArray *) withCharArray withHuWordsArray:(NSMutableArray *) withHuArray withTingWordsArray:(NSMutableArray *) withTingArray;
@end
