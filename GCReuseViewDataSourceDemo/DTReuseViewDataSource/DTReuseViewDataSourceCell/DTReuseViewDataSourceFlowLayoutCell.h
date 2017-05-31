//
//  DTReuseViewDataSourceFlowLayoutCell.h
//  DatuYZ
//
//  Created by gao on 2017/4/15.
//  Copyright © 2017年 大途宏安. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DTReuseViewDataSourceCell.h"
@class DTReuseViewDataSourceFlowLayoutCell;
typedef void(^DTReuseViewDataSourceFlowLayoutCellUpdateItemBlock)(id item, NSIndexPath *flowIndexPath,id indexPathRowData);
typedef NS_ENUM(NSInteger, FlowLayoutViewScrollDirection) {
    FlowLayoutViewScrollDirectionVertical = 1,
    FlowLayoutViewScrollDirectionHorizontal
};
@protocol DTReuseViewDataSourceFlowLayoutSelectDelegate <NSObject>
@optional

/**
 选中item的代理方法

 @param flowLayoutCell 承载一个collectionView的tableViewCell
 @param item 选中的item
 @param itemData 该item对应的数据
 @param indexPath 是在collectionView中的indexPath
 */
- (void)flowlayoutCell:(DTReuseViewDataSourceFlowLayoutCell *)flowLayoutCell
         didSelectItem:(UICollectionViewCell *)item
              itemData:(NSDictionary *)itemData
             indexPath:(NSIndexPath *)indexPath;
@end

/**
 简单流式布局需要遵循的协议，须实现的协议方法；
 默认样式是一种item一个section，没有头尾，即必须实现的协议方法
 注意：只支持一种item多个section，且没有头尾！！！！！
 */
@protocol DTReuseViewDataSourceFlowLayoutProtocol <NSObject>
@required
///item 大小
- (CGSize)itemSize;
///最小的行间距
- (CGFloat)minLineSpacing;
///最小的列间距
- (CGFloat)minInteritemSpacing;
///内边距
- (UIEdgeInsets)edgeOfSection;
///滑动方向
- (FlowLayoutViewScrollDirection)scrollDirection;
///item的类名
- (NSString *)collectionViewCellClassName;
///是否是从xib加载item
- (BOOL)isXib;
@optional
- (CGSize)itemSizeWithIndexPath:(NSIndexPath *)indexPath;
- (BOOL)scrollEnble;
///背景色，默认白色
- (UIColor *)collectionViewBackgroundColor;
///section数
- (NSInteger)numberOfSections;
///对应section需要的数据
- (NSArray *)arrayForItemsAtSection:(NSInteger)section;
@end

@interface DTReuseViewDataSourceFlowLayoutCell : DTReuseViewDataSourceCell<DTReuseViewDataSoucrceCellContainerViewTypeProtocol,UICollectionViewDelegate>

@property (nonatomic ,weak) id<DTReuseViewDataSourceFlowLayoutSelectDelegate> selectDelegate;
/**
 添加的数据源；如果有多个section，使用datasource对应元素给可选方法- (NSArray *)arrayForItemsAtSection:(NSInteger)section; 赋值即可；如果只有一个section，实现@required 的方法即可
 */
@property (nonatomic,strong,readonly) NSArray *dataSource;
- (void)updateItemsWithDataSource:(NSArray *)dataSource itemUpadateBlock:(DTReuseViewDataSourceFlowLayoutCellUpdateItemBlock)updateBlock;
@end
