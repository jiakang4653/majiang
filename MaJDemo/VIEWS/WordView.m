//
//  WordView.m
//  MaJDemo
//
//  Created by ly on 2017/3/17.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "WordView.h"
#import "WordCellCollectionViewCell.h"
#import "EqualSpaceFlowLayout.h"

@interface WordView()<UICollectionViewDelegate,UICollectionViewDataSource,EqualSpaceFlowLayoutDelegate>

{
    UIView *aview;
    UICollectionView *collectViews;
    NSMutableArray *words;
    NSInteger lastSelectedIndex;
    NSMutableArray *itemSizeArr;
    CGSize originalSize;
}
@end
@implementation WordView

static NSString *const wordssscellId = @"wordcellId";
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame data:(NSMutableArray *) ws{
    self = [super initWithFrame:frame];
    if (self) {
        lastSelectedIndex = -1;
        [self freshWords:ws];
        [self setupView];
        
        
    }
    return self;
}

-(void) setupView{
    
    UIImage *closeimg = [UIImage imageNamed:@"close"];
    UIImage *backimg = [UIImage imageNamed:@"help_blank"];
    UIImage *cellimg = [UIImage imageNamed:@"help_bar"];
    aview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    aview.backgroundColor = [UIColor clearColor];
    [self addSubview:aview];
    
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backimg.size.width, backimg.size.height)];
    back.image = backimg;
    [aview addSubview:back];
    
    NSLog(@"%@",NSStringFromCGSize(closeimg.size));
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(self.bounds.size.width - closeimg.size.width, 7, closeimg.size.width, closeimg.size.height);
    [closeButton setImage:closeimg forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(actionClose:) forControlEvents:UIControlEventTouchUpInside];
    [aview addSubview:closeButton];
    
    float marcellher = 1.0;
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(cellimg.size.width, cellimg.size.height);
//    layout.minimumInteritemSpacing = 1;
//    layout.minimumLineSpacing = 1;
//    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;


    EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
    flowLayout.delegate = self;
    UIImage *image_bc = [UIImage imageNamed:@"help_blank_bc"];
    CGRect collectRect = CGRectMake((backimg.size.width - image_bc.size.width - 2 * cellimg.size.width - marcellher)/2+image_bc.size.width,(140)/3, cellimg.size.width * 2 + marcellher, self.frame.size.height - (140)/3 - 8);
    collectViews = [[UICollectionView alloc] initWithFrame:collectRect collectionViewLayout:flowLayout];
    collectViews.delegate = self;
    collectViews.dataSource = self;
    [collectViews registerClass:[WordCellCollectionViewCell class] forCellWithReuseIdentifier:wordssscellId];
    collectViews.backgroundColor = [UIColor clearColor];
    collectViews.showsVerticalScrollIndicator = NO;
    collectViews.showsHorizontalScrollIndicator = NO;
    [aview addSubview:collectViews];
    
    
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self performSelector:@selector(to_animation) withObject:nil afterDelay:0.1];
}

-(void) reloadData:(NSMutableArray *) chars{
     [chars removeObject:WNKEY];
    for (WordVO *word in words) {
        NSString *wordString = word.wordString;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:wordString];
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:chars];
        NSInteger haveNum = 0;
        for (NSInteger i = 0; i<wordString.length; i++) {
            NSString *c = [wordString substringWithRange:NSMakeRange(i, 1)];
            NSInteger index = [tmp indexOfObject:c];
            if (index != NSNotFound) {
                [tmp removeObjectAtIndex:index];
                [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"505050"] range:NSMakeRange(i, 1)];
                haveNum++;
            }else{
                [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, 1)];
            }
        }
        word.rate = haveNum * 1.0 / wordString.length;
        word.showString = att;
        
    }
    
    [words sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WordVO *w1 = obj1;
        WordVO *w2 = obj2;
        return w1.rate<w2.rate;
    }];
    [collectViews reloadData];
}

-(void) show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self performSelector:@selector(to_animation) withObject:nil afterDelay:0.01];
    [self to_animation];

}

-(void) freshWords:(NSMutableArray *) ws{
    if (words == nil) {
        words = [NSMutableArray array];
    }else
        [words removeAllObjects];
    [words addObjectsFromArray:ws];
    if (itemSizeArr == nil) {
        itemSizeArr = [NSMutableArray array];
    }
    UIImage *cellimgs = [UIImage imageNamed:@"help_bar"];
    originalSize = cellimgs.size;
    for (int i = 0; i < words.count; i++) {
       WordVO *word = [words objectAtIndex:i];
        word.size = cellimgs.size;
    }

}

-(void) actionClose:(UIButton *) button{
    [self removeFromSuperview];
}

-(void) to_animation{
    
        {
            CAKeyframeAnimation * animation;
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            
            animation.duration = 0.5;
            
            animation.delegate = self;
            
            animation.removedOnCompletion = YES;
            
            animation.fillMode = kCAFillModeForwards;
            
            
            
            NSMutableArray *values = [NSMutableArray array];
            
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
            
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
            
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            
            
            
            animation.values = values;
            
            animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
            
            [aview.layer addAnimation:animation forKey:nil];
            [self addSubview:aview];
        }
    
}

#pragma mark delegagte
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WordCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:wordssscellId forIndexPath:indexPath];
    
    cell.cellTag = [NSNumber numberWithInteger:indexPath.row];
    [cell config:[words objectAtIndex:indexPath.row]];
    [cell setNeedsLayout];
    cell.buttonClickBlock = ^(NSString *word){
        if (self.audioClickBlock) {
            self.audioClickBlock(word);
        }
    };
    cell.translationClickBlock = ^(NSNumber *height,NSNumber*tag,NSString *word){
      
        
    };
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did");
    NSInteger index = indexPath.row;
    
    for (NSInteger i = 0 ;i<words.count;i++) {
        WordVO *tmp = [words objectAtIndex:i];
        if (i == index) {
            tmp.selected = TRUE;
        }else
            tmp.selected = FALSE;
    }
    
    NSArray *indexPaths;
    if (lastSelectedIndex == -1) {
        NSIndexPath *p1 = [NSIndexPath indexPathForRow:index inSection:0];
        indexPaths = @[p1];
    }else{
        if (index == lastSelectedIndex) {
        NSIndexPath *p1 = [NSIndexPath indexPathForRow:index inSection:0];
            indexPaths = @[p1];
        }else{
        NSIndexPath *p1 = [NSIndexPath indexPathForRow:index inSection:0];
        NSIndexPath *p2 = [NSIndexPath indexPathForRow:lastSelectedIndex inSection:0];
            indexPaths = @[p1,p2];
        }
        
    }
    [collectionView reloadItemsAtIndexPaths:indexPaths];
    
    
    if (self.cellClickBlock) {
        self.cellClickBlock([[words objectAtIndex:indexPath.row] wordString]);
    }
    lastSelectedIndex = index;
    
    
    
    WordCellCollectionViewCell *cell = (WordCellCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    for (int i = 0; i < words.count; i++) {
        WordVO *itemData = [words objectAtIndex:i];
        if (i == indexPath.row && [cell.cellTag integerValue] == indexPath.row) {
            CGFloat labelHeight = [cell.descLabel sizeThatFits:CGSizeMake(cell.descLabel.frame.size.width, MAXFLOAT)].height;
            NSNumber *count = @((labelHeight) / cell.descLabel.font.lineHeight);

            if (cell.frame.size.height == (originalSize.height*2+1)) {
                itemData.size = originalSize;
            }else{
                itemData.size = CGSizeMake(originalSize.width,originalSize.height*2+1);
            }
            
            if ([count integerValue] == 1) {
                itemData.size = originalSize;
            }
        }else{
            itemData.size = originalSize;
        }
    }
    [collectViews reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return words.count;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WordVO *word = [words objectAtIndex:[indexPath row]];
    return word.size;
}


@end
