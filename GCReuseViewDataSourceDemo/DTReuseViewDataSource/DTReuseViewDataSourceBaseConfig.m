//
//  DTReuseViewDataSourceBaseConfig.m
//  DatuYZ
//
//  Created by gao on 2017/5/8.
//  Copyright © 2017年 大途弘安. All rights reserved.
//

#import "DTReuseViewDataSourceBaseConfig.h"

@implementation DTReuseViewDataSourceBaseConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(DTReuseViewDataSourceBaseConfigProtocol)] ) {
            self.child = (id<DTReuseViewDataSourceBaseConfigProtocol>)self;
        }else{
            NSException *exception = [[NSException alloc]initWithName:NSStringFromClass([self class]) reason:@"DTReuseViewDataSourceBaseConfig没有实现DTReuseViewDataSourceBaseConfigProtocol协议" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}
@end
