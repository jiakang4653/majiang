//
//  WordCellCollectionViewCell.h
//  MaJDemo
//
//  Created by ly on 2017/3/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordCellCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *backiv;
@property(nonatomic,strong) UIButton *audioButton;
@property(nonatomic,strong) UILabel *wordLabel;
@property(nonatomic,strong) UILabel *descLabel;
@property(nonatomic,strong) NSString *saveWord;
@property(nonatomic,strong) UIImage *imgBack ;
@property(nonatomic,strong) UIImage *imgBackSelected ;
@property(nonatomic,strong) UIImage *imgAudio;
@property(nonatomic,strong) NSNumber *cellTag;
@property (nonatomic,copy,readwrite) void (^buttonClickBlock)(NSString *word);
@property (nonatomic,copy,readwrite) void (^translationClickBlock)(NSNumber *height,NSNumber *celltag,NSString *word);
-(void) config:(WordVO *) word;
-(void)awakeFromNib;
@end
