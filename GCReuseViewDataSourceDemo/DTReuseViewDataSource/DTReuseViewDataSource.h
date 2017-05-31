//
//  DTReuseViewDataSource.h
//  DatuYZ
//
//  Created by gao on 17/4/6.
//  Copyright © 2017年 大途宏安. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DTReuseViewDataSourceBaseConfig.h"
/**
 数据源配置协议
 */
@protocol DTReuseViewDataSourceProtocol <NSObject>
@required

/**
 section的个数
 */
- (NSInteger)numbersOfSection;

/**
 对应section中cell的种类数
 
 @param section 当前section
 @return 种类数
 */
- (NSInteger)kindsOfCellsInSection:(NSInteger)section;

/**
 对应section中该类cell的数据

 @param section 当前section
 @param cellKindsNumber cell种类的编码<cell种类的编码是从上到下依次编码；多个相同且相邻的是一类；相同但是不相邻是另一类>
 @return 该类cell的数据
 */
- (NSArray *)arrayForCellAtSection:(NSInteger)section
                   cellKindsNumber:(NSInteger)cellKindsNumber;

/**
 对应section中该类cell的类名

 @param section 当前section
 @param cellKindsNumber cell种类的编码
 @return 类名
 */
- (NSString *)classNameForCellAtSection:(NSInteger)section
                        cellKindsNumber:(NSInteger)cellKindsNumber;

@optional

/**
 对应section中该类cell配置数据需要的配置对象

 @param section 当前section
 @param cellKindsNumber cell种类编码
 @return 遵循协议的配置对象
 */
- (id<DTReuseViewDataSourceBaseConfigProtocol>)dataConfigForCellAtSection:(NSInteger)section
                                                          cellKindsNumber:(NSInteger)cellKindsNumber
                                                            cellClassName:(NSString *)className;
@end

/*
 1,可以在这个回调中使用数据更新cell
 2,作为tableview的dataSource时，cell是DTReuseViewDataSourceCell的子类；其中当section中有DTReuseViewDataSourceFlowLayoutCell的子类时，这时的cell是CollectionViewCell；
 3,indexPathRowData 是当前cell对应的数据
 */
typedef void(^DTReuseViewDataSourceConfigCellBlock)(id cell, id indexPathRowData);
@interface DTReuseViewDataSource : NSObject<UITableViewDataSource,UICollectionViewDataSource>

/**
 传入的数据
 */
@property (nonatomic ,strong,readonly) id data;

/**
 使用原始数据和Cell配置回调生成DataSource
 @param data 原始数据(字典数组都可)
 @param aConfigureCellBlock 包含Cell和对应数据的回调
 */
-(instancetype)initWithData:(id)data updataCellWithConfigureCellBlock:(DTReuseViewDataSourceConfigCellBlock)aConfigureCellBlock;

/**
 选中Cell对应的data
 @param indexPath 选中Cell的indexpath
 */
- (id)dataWithSelectedIndexPath:(NSIndexPath *)indexPath;

/**
 添加数据
 @param data 必须是和初始化的Data类型一致，是字典都是字典<注意字典的key是否有相同的>；是数组都是数组；
 */
- (void)addData:(id)data;

/**
更新数据

 @param data 数组 或 字典
 */
- (void)updataData:(id)data;
@end
