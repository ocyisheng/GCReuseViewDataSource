//
//  DTReuseViewDataSourceFlowLayoutCell.m
//  DatuYZ
//
//  Created by gao on 2017/4/15.
//  Copyright © 2017年 大途宏安. All rights reserved.
//

#import "DTReuseViewDataSourceFlowLayoutCell.h"

#import "DTCollectionViewHorizontalFlowLayout.h"
@interface DTReuseViewDataSourceFlowLayoutCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
/// 签署<DTReuseViewDataSourceFlowLayoutProtocol>的子类
@property (nonatomic, weak) NSObject<DTReuseViewDataSourceFlowLayoutProtocol> *flowLayoutChild;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (nonatomic ,copy) DTReuseViewDataSourceFlowLayoutCellUpdateItemBlock updateBlock;
@end
@implementation DTReuseViewDataSourceFlowLayoutCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([self conformsToProtocol:@protocol(DTReuseViewDataSourceFlowLayoutProtocol)]) {
            self.flowLayoutChild = (id<DTReuseViewDataSourceFlowLayoutProtocol>)self;
        } else {
            NSException *exception = [[NSException alloc] initWithName:NSStringFromClass([self class]) reason:@"DTReuseViewDataSourceFlowLayoutCell子类没有实现FlowLayoutProtocol协议" userInfo:nil];
            @throw exception;
        }
        self.backgroundColor =[ UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
}
#pragma mark - public func
- (void)updateItemsWithDataSource:(NSArray *)dataSource itemUpadateBlock:(DTReuseViewDataSourceFlowLayoutCellUpdateItemBlock)updateBlock{
    _dataSource = [dataSource mutableCopy];
    self.updateBlock = updateBlock;
}
//- (NSIndexPath *)dataSourceIndexPathForItem:(UICollectionViewCell *)item tableViewIndexPath:(NSIndexPath *)tableViewIndexPath{
//    NSIndexPath *itemIndexPath = [self.collectionView indexPathForCell:item];
//    return [NSIndexPath indexPathForItem:itemIndexPath.row inSection:tableViewIndexPath.section];
//}
#pragma mark - DTReuseViewDataSoucrceCellContainerViewTypeProtocol
+ (DTReuseViewDataSoucrceCellContainerViewType)containerViewType{
    return DTReuseViewDataSoucrceCellContainerViewTypeCollectionView;
}
#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = [self.flowLayoutChild collectionViewCellClassName];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    //预防xib cell未设置重用ID
    [cell setValue:identify forKey:@"reuseIdentifier"];
    //获取section数据
    NSArray *sectionData = self.dataSource;
    if ([self.flowLayoutChild respondsToSelector:@selector(arrayForItemsAtSection:)]) {
        if ([self.flowLayoutChild numberOfSections] >1) {
            sectionData = [self.flowLayoutChild arrayForItemsAtSection:indexPath.section];
        }
    }
    //更新cell的回调
    if (self.updateBlock) {
        self.updateBlock(cell, indexPath,sectionData[indexPath.row]);
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.flowLayoutChild respondsToSelector:@selector(arrayForItemsAtSection:)]) {
        if ([self.flowLayoutChild numberOfSections] >1) {
            return [self.flowLayoutChild arrayForItemsAtSection:section].count;
        }
    }
    return self.dataSource.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.flowLayoutChild respondsToSelector:@selector(numberOfSections)]) {
        if ([self.flowLayoutChild numberOfSections] >1) {
            return [self.flowLayoutChild numberOfSections];
        }
    }
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.flowLayoutChild respondsToSelector:@selector(itemSizeWithIndexPath:)]) {
        return [self.flowLayoutChild itemSizeWithIndexPath:indexPath];
    }
    return self.flowLayout.itemSize;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(flowlayoutCell:didSelectItem:itemData:indexPath:)]) {
        [self.selectDelegate flowlayoutCell:self didSelectItem:[self.collectionView cellForItemAtIndexPath:indexPath] itemData:self.dataSource[indexPath.row] indexPath:indexPath];
    }
}
#pragma mark - setter fucn
#pragma mark - getter func
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        if ([self.flowLayoutChild respondsToSelector:@selector(numberOfSections)]) {
            if ([self.flowLayoutChild numberOfSections] >1) {
                flowLayout = [[DTCollectionViewHorizontalFlowLayout alloc]init];
            }
        }
        if (![self.flowLayout respondsToSelector:@selector(itemSizeWithIndexPath:)]) {
             flowLayout.itemSize = [self.flowLayoutChild itemSize];
        }
        flowLayout.minimumLineSpacing = [self.flowLayoutChild minLineSpacing];
        flowLayout.minimumInteritemSpacing= [self.flowLayoutChild minInteritemSpacing];
        flowLayout.sectionInset = [self.flowLayoutChild edgeOfSection];
        flowLayout.scrollDirection = [self collectionViewScrollDirection];
        _flowLayout = flowLayout;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [self.flowLayoutChild respondsToSelector:@selector(collectionViewBackgroundColor)] ? [self.flowLayoutChild collectionViewBackgroundColor] :[UIColor whiteColor];
        [self.flowLayoutChild isXib] ? [_collectionView registerNib:[UINib nibWithNibName:[self.flowLayoutChild collectionViewCellClassName ] bundle:nil]
                                         forCellWithReuseIdentifier:[self.flowLayoutChild collectionViewCellClassName]] :
        [_collectionView registerClass:NSClassFromString([self.flowLayoutChild collectionViewCellClassName])forCellWithReuseIdentifier:[self.flowLayoutChild collectionViewCellClassName]];
        _collectionView.scrollEnabled = [self.flowLayoutChild respondsToSelector:@selector(scrollEnble)] ? [self.flowLayoutChild scrollEnble] : YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}

- (UICollectionViewScrollDirection)collectionViewScrollDirection{
    return [self.flowLayoutChild scrollDirection] == FlowLayoutViewScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal :UICollectionViewScrollDirectionVertical;
}
- (void)reloadData{
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end


