//
//  Beans.h
//  MaJDemo
//
//  Created by ly on 2017/3/16.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Beans : NSObject
@end

@interface UserInfoVO : NSObject
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *score;
@end

@interface WordVO : NSObject
@property (nonatomic,strong) NSString *wordString;
@property (nonatomic,strong) NSAttributedString *showString;
@property (nonatomic,strong) NSString *translationWord;
@property (nonatomic) float rate;
@property (nonatomic) BOOL selected;
@property (nonatomic,assign) CGSize size;
@end
