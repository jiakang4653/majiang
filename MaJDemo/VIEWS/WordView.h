//
//  WordView.h
//  MaJDemo
//
//  Created by ly on 2017/3/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WordView : UIView
@property (nonatomic,copy) void (^cellClickBlock)(NSString *word);
@property (nonatomic,copy) void (^audioClickBlock)(NSString *word);

-(void) show;
-(void) reloadData:(NSMutableArray *) chars;
-(instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *) ws;
@end
