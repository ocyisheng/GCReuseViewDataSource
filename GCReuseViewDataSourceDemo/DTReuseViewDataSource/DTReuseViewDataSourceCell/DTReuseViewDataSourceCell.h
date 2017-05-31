//
//  DTReuseViewDataSourceCell.h
//  DatuYZ
//
//  Created by gao on 2017/4/19.
//  Copyright © 2017年 大途宏安. All rights reserved.
//

#import <UIKit/UIKit.h>

// DEBUG 模式下打印日志 当前行数 所在文件
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)

#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


typedef NS_ENUM(NSInteger, DTReuseViewDataSoucrceCellContainerViewType) {
    
    //普通的自定义tableViewCell,数据配置时的data是字典
    DTReuseViewDataSoucrceCellContainerViewTypeDefaut = 1,
    
    //tableViewCell上有banner，数据配置时的data是数组
    DTReuseViewDataSoucrceCellContainerViewTypeBanner,
    
    //tableViewCell上有CollectionView，数据配置时的data是数组
    DTReuseViewDataSoucrceCellContainerViewTypeCollectionView
};

/**
 TableViewCell 中包含的子视图类型协议
 */
@protocol DTReuseViewDataSoucrceCellContainerViewTypeProtocol <NSObject>
@required

/**
 TableViewCell 中包含的子视图类型协议
 @return 枚举
 */
+ (DTReuseViewDataSoucrceCellContainerViewType)containerViewType;

@end
@interface DTReuseViewDataSourceCell : UITableViewCell
@property (nonatomic,weak)NSObject<DTReuseViewDataSoucrceCellContainerViewTypeProtocol> *child;
@end
