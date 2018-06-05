//
//  EqualSpaceFlowLayout.m
//  UICollectionViewDemo
//
//  Created by CHC on 15/5/12.
//  Copyright (c) 2015年 CHC. All rights reserved.
//

#import "EqualSpaceFlowLayout.h"

@interface EqualSpaceFlowLayout()
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@end

@implementation EqualSpaceFlowLayout
- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 1;
        self.minimumLineSpacing = 1;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    
    return self;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    BOOL issingle = YES;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yNextOffset = self.sectionInset.top;
    CGFloat contentsize_y = self.sectionInset.top;
    CGFloat contentsize_x = self.sectionInset.left;
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
//        if (idx > ((itemCount)/2)) {
//            xOffset = (itemSize.width + self.minimumInteritemSpacing)+self.sectionInset.left;
//            contentsize_x = xOffset;
//            UICollectionViewLayoutAttributes *layoutAttributes =
//            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//            
//            layoutAttributes.frame = CGRectMake(xOffset, yNextOffset, itemSize.width, itemSize.height);
//            [_itemAttributes addObject:layoutAttributes];
//            yNextOffset += ( self.minimumLineSpacing + itemSize.height);
//            
//        }
//        else
//        {
//            UICollectionViewLayoutAttributes *layoutAttributes =
//            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//            
//            layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
//            [_itemAttributes addObject:layoutAttributes];
//            yOffset += (self.minimumLineSpacing + itemSize.height);
//            contentsize_y += yOffset;
//            
//        }
        
        
        if (issingle) {
            issingle = NO;
            xOffset = self.sectionInset.left;
            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
            [_itemAttributes addObject:layoutAttributes];
            yOffset += (self.minimumLineSpacing + itemSize.height);
            
        }else{
            
            issingle = YES;
            xOffset = (itemSize.width + self.minimumInteritemSpacing)+self.sectionInset.left;
            UICollectionViewLayoutAttributes *layoutAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            layoutAttributes.frame = CGRectMake(xOffset, yNextOffset, itemSize.width, itemSize.height);
            [_itemAttributes addObject:layoutAttributes];
            yNextOffset += (self.minimumLineSpacing + itemSize.height);
            
        }
        

        if (idx == itemCount - 1) {
            
            contentsize_y = yOffset>yNextOffset?yOffset:yNextOffset;
            
        }
    }
    self.collectionView.contentSize = CGSizeMake(contentsize_x, contentsize_y);
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}
@end
