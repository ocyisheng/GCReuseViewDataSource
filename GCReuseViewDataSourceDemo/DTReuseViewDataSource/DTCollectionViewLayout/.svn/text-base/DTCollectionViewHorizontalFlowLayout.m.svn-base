//
//  DTCollectionViewHorizontalFlowLayout.m
//  DatuYZ
//
//  Created by gao on 2017/5/12.
//  Copyright © 2017年 大途弘安. All rights reserved.
//

#import "DTCollectionViewHorizontalFlowLayout.h"

//struct DTRect {
//    NSUInteger column;//列
//    NSUInteger row;//行
//};
//typedef struct DTRect DTRect;
//DTRect DTRectMake(NSUInteger row,NSUInteger column){
//    DTRect rect ;
//    rect.row = row;
//    rect.column = column;
//    return rect;
//}
@interface DTCollectionViewHorizontalFlowLayout ()

@property (nonatomic,strong) NSMutableArray *arrributesArray;
@property (nonatomic,strong) NSMutableArray *maxHeightArray;
@property (nonatomic,assign) CGFloat xMargin;
@property (nonatomic,assign) CGFloat yMargin;

@property (nonatomic,assign) NSInteger currentSection;//根据滑动的proposedContentOffset 获取当前的section
@end
@implementation DTCollectionViewHorizontalFlowLayout
//1。刷新数据的时候调用
- (void)prepareLayout{
    [super prepareLayout];
    //初始化容器
    [self.maxHeightArray removeAllObjects];
    //移除之前所有的布局对象
    [self.arrributesArray removeAllObjects];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.directionalLockEnabled = YES;
    //创建每个cell对应的布局对象
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section ++) {
        CGFloat maxY = 0;
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:section]; row ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            //获取布局属性并添加
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.arrributesArray addObject:attributes];
            //筛选每个section的最大高度
            if (CGRectGetMaxY(attributes.frame) >maxY) {
                maxY = CGRectGetMaxY(attributes.frame);
            }
        }
        //每个section的最大高度添加到数
        [self.maxHeightArray addObject:@(maxY)];
    }
}
///2.cell的布局对象
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *arrribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    arrribute.frame = [self framForCellAtIndexPath:indexPath];
    //计算行列数
    return arrribute;
}
///3.拖动后最终停止的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    self.currentSection = proposedContentOffset.x / CGRectGetWidth(self.collectionView.frame);
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}
///4.contentSize 所有section的布局区域
- (CGSize)collectionViewContentSize{
    //需要知道当前的section，再返回最
    CGFloat contentHeight = [self.maxHeightArray[self.currentSection] floatValue] + self.sectionInset.bottom;
    CGFloat contentWidth = CGRectGetWidth(self.collectionView.frame) *  ([self.collectionView numberOfSections] );
    return CGSizeMake(contentWidth, contentHeight);
}
///5.
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.arrributesArray;
}
/*
 
 以上代理方法，调用按排列顺序依次调用；调用次数不定 3.4.5<和拖动有关>
 */
#pragma mark - private func
- (NSInteger)maxColumn{
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    return (width - self.sectionInset.left - self.sectionInset.right + self.xMargin) /(self.xMargin + self.itemSize.width);
}
- (CGRect)framForCellAtIndexPath:(NSIndexPath *)indexPath{
    //最大列数
    NSInteger column = [self maxColumn];
    //列数索引
    NSInteger yushuRow = indexPath.row % column;
    //行数索引
    NSInteger shangRow = indexPath.row / column;
    CGFloat cell_W = self.itemSize.width;
    CGFloat cell_H = self.itemSize.height;
    CGFloat cell_X = self.sectionInset.left + yushuRow * ([self xMaxMargin] + cell_W ) + CGRectGetWidth(self.collectionView.frame) *indexPath.section;
    CGFloat cell_Y = self.sectionInset.top + shangRow * (self.yMargin +  cell_H );
    
    return CGRectMake(cell_X, cell_Y, cell_W, cell_H);
}
- (CGFloat)xMaxMargin{
    return (CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left- self.sectionInset.right-self.itemSize.width * [self maxColumn])/(CGFloat)([self maxColumn] - 1);
}

#pragma mark - getter func
- (CGFloat)xMargin{
    if (!_xMargin) {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            NSException * exception = [[NSException alloc]initWithName:NSStringFromClass([self class]) reason:@"使用该布局不应设置scrollDirection==UICollectionViewScrollDirectionVertical" userInfo:nil];
            @throw exception;
        }
        _xMargin = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? self.minimumLineSpacing :self.minimumInteritemSpacing;
    }
    return _xMargin;
}

- (CGFloat)yMargin{
    if (!_yMargin) {
        _yMargin = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? self.minimumInteritemSpacing : self.minimumLineSpacing;
    }
    return _yMargin;
}
- (NSMutableArray *)arrributesArray{
    if (!_arrributesArray) {
        _arrributesArray = [NSMutableArray array];
    }
    return _arrributesArray;
}
- (NSMutableArray *)maxHeightArray{
    if (!_maxHeightArray) {
        _maxHeightArray = [[NSMutableArray alloc]initWithCapacity:[self.collectionView numberOfSections]];
    }
    return _maxHeightArray;
}
@end
