//
//  DTReuseViewDataSourceBaseConfig.h
//  DatuYZ
//
//  Created by gao on 2017/5/8.
//  Copyright © 2017年 大途弘安. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTReuseViewDataSourceBaseConfigProtocol <NSObject>

@required

/**
 给cell配置数据的协议方法

 @param cell DTReuseViewDataSourceCell的子类 或 UICollectionView的子类
 @param data 当是DTReuseViewDataSourceCell的子类时与DTReuseViewDataSoucrceCellContainerViewType有关;
 */
- (void)reusableCell:(id)cell configData:(id)data;
@end
@interface DTReuseViewDataSourceBaseConfig : NSObject
@property (nonatomic,weak)NSObject<DTReuseViewDataSourceBaseConfigProtocol> *child;
@end
