//
//  WordCellCollectionViewCell.m
//  MaJDemo
//
//  Created by ly on 2017/3/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "WordCellCollectionViewCell.h"


@implementation WordCellCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (_imgBack == nil) {
            _imgBack = [UIImage imageNamed:@"help_bar"];
            
        }
        if (_imgBackSelected == nil) {
            _imgBackSelected = [UIImage imageNamed:@"help_bar_selct"];
        }
        if (_imgAudio == nil) {
            _imgAudio =[UIImage imageNamed:@"audio"];
        }
        
        if (_backiv == nil) {
            _backiv = [[UIImageView alloc] initWithFrame:CGRectZero];
            _backiv.frame = self.bounds;
            _backiv.image = _imgBack;
            [self.contentView addSubview:_backiv];
        }
        
        if (_audioButton == nil) {
            _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _audioButton.frame = CGRectZero;
            [_audioButton addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_audioButton];
        }
        
        if (_wordLabel == nil) {
            _wordLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
            _wordLabel.backgroundColor = [UIColor clearColor];
            _wordLabel.textAlignment = NSTextAlignmentLeft;
            _wordLabel.font = [UIFont systemFontOfSize:14];
            _wordLabel.textColor = [UIColor colorWithHexString:@"505050"];
            [self.contentView addSubview:_wordLabel];
        }
        
        if (_descLabel == nil) {
            _descLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
            _descLabel.backgroundColor = [UIColor clearColor];
            _descLabel.font = [UIFont systemFontOfSize:14];
            _descLabel.textColor = [UIColor colorWithHexString:@"505050"];
            _descLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_descLabel];
        }
        
        
        float marx = 9;
//        NSLog(@"%@",NSStringFromCGRect(self.frame));
        
        _audioButton.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
        marx += _imgAudio.size.width;
        marx += 3;
        _wordLabel.frame = CGRectMake(marx, 0, self.frame.size.width - marx, self.frame.size.height);
        _descLabel.frame = CGRectMake(self.frame.size.width/2 - 9, 0, self.frame.size.width/2, self.frame.size.height);
        [_audioButton setImage:_imgAudio forState:UIControlStateNormal];
        

    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    if (_imgBack == nil) {
    _imgBack = [UIImage imageNamed:@"help_bar"];
       
    }
    if (_imgBackSelected == nil) {
        _imgBackSelected = [UIImage imageNamed:@"help_bar_selct"];
    }
    _imgBack = [_imgBack stretchableImageWithLeftCapWidth:floorf(_imgBack.size.width/2) topCapHeight:floorf(_imgBack.size.height/2)];
    _imgBackSelected = [_imgBackSelected stretchableImageWithLeftCapWidth:floorf(_imgBackSelected.size.width/2) topCapHeight:floorf(_imgBackSelected.size.height/2)];

    if (_imgAudio == nil) {
    _imgAudio =[UIImage imageNamed:@"audio"];
    }
    
    if (_backiv == nil) {
        _backiv = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backiv.frame = self.bounds;
        _backiv.image = _imgBack;
        [self.contentView addSubview:_backiv];
    }
    
    if (_audioButton == nil) {
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioButton.frame = CGRectZero;
        [_audioButton addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_audioButton];
    }
    
    if (_wordLabel == nil) {
        _wordLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
        _wordLabel.backgroundColor = [UIColor clearColor];
        _wordLabel.textAlignment = NSTextAlignmentLeft;
        _wordLabel.font = [UIFont systemFontOfSize:14];
        _wordLabel.textColor = [UIColor colorWithHexString:@"505050"];
        [self.contentView addSubview:_wordLabel];
    }
    
    if (_descLabel == nil) {
        _descLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = [UIColor colorWithHexString:@"505050"];
        _descLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_descLabel];
    }
    
    
    float marx = 9;
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
    
    _audioButton.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
    marx += _imgAudio.size.width;
    marx += 3;
    _wordLabel.frame = CGRectMake(marx, 0, self.frame.size.width - marx, self.frame.size.height);
    _descLabel.frame = CGRectMake(self.frame.size.width/2 - 9, 0, self.frame.size.width/2, self.frame.size.height);
    
    [_audioButton setImage:_imgAudio forState:UIControlStateNormal];
    
}


-(void) config:(WordVO *) word{
    
    
    _saveWord = word.wordString;
    NSLog(@"cellframe%@,celltag%ld,wordsize%@",NSStringFromCGRect(self.frame),(long)self.tag,NSStringFromCGSize(word.size));
    _wordLabel.attributedText = word.showString;
    _descLabel.tag = [self.cellTag integerValue];
    
    _descLabel.numberOfLines = 0;

    self.bounds = CGRectMake(0, 0, word.size.width, word.size.height);
    _backiv.frame = self.bounds;
    float marx = 9;
    _audioButton.frame = CGRectMake(0, 0, _imgBack.size.height, _imgBack.size.height);
    marx += _imgAudio.size.width;
    marx += 3;
    _wordLabel.frame = CGRectMake(marx, 0, self.frame.size.width - marx, _imgBack.size.height);
    _descLabel.frame = CGRectMake(self.frame.size.width/2-5, 0, self.frame.size.width/2, self.frame.size.height);
    _descLabel.text = word.translationWord;
    CGFloat labelHeight = [_descLabel sizeThatFits:CGSizeMake(_descLabel.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / _descLabel.font.lineHeight);
    NSLog(@"count%zd,%@",[count integerValue],_descLabel.text);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_descLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    if ([count integerValue] == 1) {
        _descLabel.frame = CGRectMake(self.frame.size.width/2 - 9, 0, self.frame.size.width/2, _imgBack.size.height);
    }else if([count integerValue] == 2){
        if (_descLabel.frame.size.height == _imgBack.size.height) {
            
        }else{
           [paragraphStyle setLineSpacing:10];
        }
       
    }else if([count integerValue] == 4){
        if (_descLabel.frame.size.height == _imgBack.size.height) {
            
        }else{
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, [_descLabel.text length])];
        }
        
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_descLabel.text length])];
    _descLabel.attributedText = attributedString;
    if (word.selected) {
        _backiv.image = _imgBackSelected;
    }else
        _backiv.image = _imgBack;
    
    
    
}
-(void) actionButton:(UIButton *) button{

    NSLog(@"button click ==== %@",_saveWord);
    if (self.buttonClickBlock) {
        self.buttonClickBlock(_saveWord);
    }
}
@end
