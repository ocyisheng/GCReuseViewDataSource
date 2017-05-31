//
//  DTReuseViewDataSourceCell.m
//  DatuYZ
//
//  Created by gao on 2017/4/19.
//  Copyright © 2017年 大途宏安. All rights reserved.
//

#import "DTReuseViewDataSourceCell.h"

@implementation DTReuseViewDataSourceCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([self conformsToProtocol:@protocol(DTReuseViewDataSoucrceCellContainerViewTypeProtocol) ]) {
            self.child = (id<DTReuseViewDataSoucrceCellContainerViewTypeProtocol>)self;
            DLog(@"从Class加载：%@",NSStringFromClass([self class]));
        }else{
            NSException *exception = [[NSException alloc] initWithName:NSStringFromClass([self class]) reason:@"DTReuseViewDataSourceCell子类没有实现DTReuseViewDataSoucrceCellContainerViewTypeProtocol协议" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        if ([self conformsToProtocol:@protocol(DTReuseViewDataSoucrceCellContainerViewTypeProtocol) ]) {
            self.child = (id<DTReuseViewDataSoucrceCellContainerViewTypeProtocol>)self;
             DLog(@"从xib加载：%@",NSStringFromClass([self class]));
        }else{
            NSException *exception = [[NSException alloc] initWithName:NSStringFromClass([self class]) reason:@"DTReuseViewDataSourceCell子类没有实现DTReuseViewDataSoucrceCellContainerViewTypeProtocol协议" userInfo:nil];
            @throw exception;
        }
    }
        return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
