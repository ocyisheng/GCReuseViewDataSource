//
//  DTReuseViewDataSource.m
//  DatuYZ
//
//  Created by gao on 17/4/6.
//  Copyright © 2017年 大途宏安. All rights reserved.
//

#import "DTReuseViewDataSource.h"
#import "DTReuseViewDataSourceFlowLayoutCell.h"
static NSString *const DTReuseViewDataSourceCellClassNameKey   = @"CellClassNameKey";
static NSString *const DTReuseViewDataSourceCellSectionKey     = @"CellSectionKey";
static NSString *const DTReuseViewDataSourceCellNumberKey      = @"CellNumerbKey";
static NSString *const DTReuseViewDataSourceCellRangeKey       = @"CellRangeKey";
@interface DTReuseViewDataSource ()
@property (nonatomic,copy) DTReuseViewDataSourceConfigCellBlock configCellBlock;
@property (nonatomic,weak) NSObject<DTReuseViewDataSourceProtocol> *child;
///每个section中每种cell的起始位置
/*数据调用会出错不一定按照顺序调用回调方法，导致indexpath 与 rangeOfCellInSecionsDic 不匹配造成出错*/
@property (nonatomic,strong) NSMutableDictionary  *rangeOfCellInSecionsDic;
@property (nonatomic,strong) id data;
@end
@implementation DTReuseViewDataSource

-(instancetype)initWithData:(id)data updataCellWithConfigureCellBlock:(DTReuseViewDataSourceConfigCellBlock)aConfigureCellBlock{
    self = [super init];
    if (self) {
        self.data = data;
        self.configCellBlock =  aConfigureCellBlock;
        if ([self conformsToProtocol:@protocol(DTReuseViewDataSourceProtocol)]) {
            self.child = (id<DTReuseViewDataSourceProtocol>)self;
        } else {
            NSException *exception = [[NSException alloc] initWithName:NSStringFromClass([self class]) reason:@"FlowLayoutCell子类没有实现FlowLayoutDelegate协议" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}
- (id)dataWithSelectedIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self p_classNameWithCellKindsNumberStrAtIndexPath:indexPath];
    NSString *cellNumber = dic[DTReuseViewDataSourceCellNumberKey];
    NSRange cellRange = NSRangeFromString(dic[DTReuseViewDataSourceCellRangeKey]);
    NSUInteger correctRow = indexPath.row - cellRange.location;
    NSArray *sectionRow = [self.child arrayForCellAtSection:indexPath.section cellKindsNumber:[cellNumber integerValue]];
    return sectionRow[correctRow];
}
- (void)addData:(id)data{
    if ([data isKindOfClass:[NSArray class]]) {
        //单一的数组
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:self.data];
        [muArr addObjectsFromArray:data];
        self.data = [muArr copy];
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        //单一的字典
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.data];
        [muDic setValuesForKeysWithDictionary:data];
        self.data = [muDic copy];
    }
}
- (void)updataData:(id)data{
    self.data = data;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self p_classNameWithCellKindsNumberStrAtIndexPath:indexPath];
    NSString *className = dic[DTReuseViewDataSourceCellClassNameKey];
    NSString *cellNumber = dic[DTReuseViewDataSourceCellNumberKey];
    DTReuseViewDataSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:className forIndexPath:indexPath];
    NSArray *sectionRow = [self.child arrayForCellAtSection:indexPath.section cellKindsNumber:[cellNumber integerValue]];
    if ([[cell.child class] containerViewType] == DTReuseViewDataSoucrceCellContainerViewTypeCollectionView) {
        if ([cell isKindOfClass:[DTReuseViewDataSourceFlowLayoutCell class]]) {
            DTReuseViewDataSourceFlowLayoutCell *flowCell = (DTReuseViewDataSourceFlowLayoutCell*)cell;
            [flowCell updateItemsWithDataSource:sectionRow itemUpadateBlock:^(id item, NSIndexPath *flowIndexPath,id indexPathRowData) {
                [self p_configData:indexPathRowData cell:item section:indexPath.section cellKindsNumber:[cellNumber integerValue]];
                self.configCellBlock(item,indexPathRowData);
            }];
        }
    }else if ([[cell.child class] containerViewType] == DTReuseViewDataSoucrceCellContainerViewTypeBanner){
         [self p_configData:sectionRow cell:cell section:indexPath.section cellKindsNumber:[cellNumber integerValue]];
        self.configCellBlock(cell,sectionRow);
    }else if ([[cell.child class] containerViewType] == DTReuseViewDataSoucrceCellContainerViewTypeDefaut){
        NSRange cellRange = NSRangeFromString(dic[DTReuseViewDataSourceCellRangeKey]);
        NSUInteger correctRow = indexPath.row - cellRange.location;
        //这个是tableviewCell
         [self p_configData:sectionRow[correctRow] cell:cell section:indexPath.section cellKindsNumber:[cellNumber integerValue]];
       self.configCellBlock(cell,sectionRow[correctRow]);
    }else{
        
    }
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self p_numberOfItemsInSection:section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self p_numbersOfSection];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self p_classNameWithCellKindsNumberStrAtIndexPath:indexPath];
    NSString *className = dic[DTReuseViewDataSourceCellClassNameKey];
    NSString *cellNumber = dic[DTReuseViewDataSourceCellNumberKey];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
    NSArray *sectionRow = [self.child arrayForCellAtSection:indexPath.section cellKindsNumber:[cellNumber integerValue]];
    [self p_configData:sectionRow[indexPath.row] cell:cell section:indexPath.section cellKindsNumber:[cellNumber integerValue]];
    self.configCellBlock(cell,sectionRow[indexPath.row]);
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  [self p_numbersOfSection];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self p_numberOfItemsInSection:section];
}
#pragma mark - private func
- (NSInteger)p_numberOfItemsInSection:(NSInteger)section{
    NSInteger cellKinds = [self.child kindsOfCellsInSection:section];
    NSInteger numberOfitems = 0;
    NSMutableDictionary *cellRangeDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < cellKinds; i ++) {
        NSUInteger location = numberOfitems;
        NSString *clsaaName = [self.child classNameForCellAtSection:section cellKindsNumber:i];
        if ([[NSClassFromString(clsaaName) class] isSubclassOfClass:[UICollectionViewCell class]]) {
            numberOfitems += [[self.child arrayForCellAtSection:section cellKindsNumber:i] count];
        }else{
            //当是自定义包含collectionView的cell时，只有一个cell即可
            //collectionViewCell 的混合也需要添加判断
            if ([[NSClassFromString(clsaaName) class] containerViewType] == DTReuseViewDataSoucrceCellContainerViewTypeCollectionView) {
                numberOfitems ++;
            }else if ([[NSClassFromString(clsaaName) class] containerViewType] == DTReuseViewDataSoucrceCellContainerViewTypeBanner){
                numberOfitems ++;
            }else if([[NSClassFromString(clsaaName) class] containerViewType] == DTReuseViewDataSoucrceCellContainerViewTypeDefaut){
                numberOfitems += [[self.child arrayForCellAtSection:section cellKindsNumber:i] count];
            }
        }
        NSRange range = NSMakeRange(location, numberOfitems);
        NSString *key = [self p_keyWithCellClassName:clsaaName section:section cellKindsNumber:i];
        [cellRangeDic setObject:NSStringFromRange(range) forKey:key];
            }
    NSString *key = @(section).stringValue;
    [self.rangeOfCellInSecionsDic setValue:cellRangeDic forKey:key];
    
    return numberOfitems;
}
- (NSInteger)p_numbersOfSection{
    NSInteger sections = [self.child numbersOfSection];
    
    if (!_rangeOfCellInSecionsDic) {
        _rangeOfCellInSecionsDic = [NSMutableDictionary dictionary];
        
        /*
         key = cell类名__section__cellKindsNumber
         @{@"cell1__0__0":ragestring1,@"cell2__0__1":ragestring2},
         @{@"cell3__1__0":ragestring3,@"cell4__1__1":ragestring4},
         */
    }
    return sections;
}
- (NSString *)p_keyWithCellClassName:(NSString *)className section:(NSInteger)section cellKindsNumber:(NSInteger)cellKindsNumber{
    //cell3__1__0
    return [NSString stringWithFormat:@"%@__%ld__%ld",className,section,cellKindsNumber];
}
- (NSDictionary *)p_classNameWithCellKindsNumberStrAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellRangeDic = self.rangeOfCellInSecionsDic[@(indexPath.section).stringValue];
    __block NSString *cellClassName ;
    __block NSString *cellKindsNumberStr;
    __block NSString *cellSectionStr;
    __block NSString *cellRangeStr;
    [cellRangeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *attribues = [key componentsSeparatedByString:@"__"];
        NSString *classsName = attribues[0];
        cellSectionStr = attribues[1];
        cellKindsNumberStr = attribues[2];
        cellRangeStr = obj;
        NSRange range = NSRangeFromString(cellRangeStr);
        if ((indexPath.section == [cellSectionStr integerValue]) && indexPath.row >= range.location &&indexPath.row < (range .location + range.length)) {
            cellClassName = classsName;
            *stop = YES;
        }
    }];
    if (cellClassName == nil) {
        NSException *exception = [[NSException alloc] initWithName:NSStringFromClass([self class]) reason:@"没有获取正确的CellClassName" userInfo:nil];
        @throw exception;
    }
    return @{DTReuseViewDataSourceCellClassNameKey:cellClassName,
             DTReuseViewDataSourceCellSectionKey:cellSectionStr,
             DTReuseViewDataSourceCellNumberKey:cellKindsNumberStr,
             DTReuseViewDataSourceCellRangeKey:cellRangeStr};
}
///给cell配置数据
- (void)p_configData:(id)data cell:(id)cell section:(NSInteger)section cellKindsNumber:(NSInteger)cellKindsNumber{
    if ([self.child respondsToSelector:@selector(dataConfigForCellAtSection:cellKindsNumber:cellClassName:)]) {
        id<DTReuseViewDataSourceBaseConfigProtocol> baseDataConfig = [self.child dataConfigForCellAtSection:section cellKindsNumber:cellKindsNumber cellClassName:NSStringFromClass([cell class])];
        if ([baseDataConfig respondsToSelector:@selector(reusableCell:configData:)]) {
           [baseDataConfig reusableCell:cell configData:data];
        }
    }
}
@end
