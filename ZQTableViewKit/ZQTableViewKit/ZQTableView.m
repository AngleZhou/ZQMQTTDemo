//
//  ZQTableView.m
//  ZQTableView
//
//  Created by Zhou Qian on 16/9/5.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import "ZQTableView.h"



@interface ZQTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) NSArray *arrData;
@end

@implementation ZQTableView

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStyleGrouped)];
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 48;
        self.sectionFooterHeight = 0.01;
        self.sectionHeaderHeight = 10;
    }
    return self;
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSections {
    if (self.arrSection) {
        return [self.arrSection count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrDataSource) {
        if ([self numberOfSections] == 1) {//一元数组
            return [self.arrDataSource count];
        }
        else {//多元数组
            return [[self.arrDataSource objectAtIndex:section] count];
        }
        
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = [UITableViewCell class];
    NSString *identifier = NSStringFromClass([UITableViewCell class]);
    
    if (self.customCellName) {
        cellClass = NSClassFromString(self.customCellName);
        identifier = self.customCellName;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    if (self.configueCellBlock) {
        self.configueCellBlock(cell);
    }
    
    return cell;
    
}

#pragma mark - UITableView Delegate


@end
