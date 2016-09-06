//
//  ZQTableView.h
//  ZQTableView
//
//  Created by Zhou Qian on 16/9/5.
//  Copyright © 2016年 Zhou Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQTableView : UITableView

/**
 *  如果有多个section，则不能为空
 */
@property (nonatomic, strong) NSArray * _Nullable arrSection;

/**
 *  可以是一元数组或者多元数组
 */
@property (nonatomic, strong) NSArray * _Nullable arrDataSource;

/**
 *  自定义cell的class Name
 */
@property (nonatomic, strong) NSString  * _Nullable customCellName;

/**
 *  自定义配置cell
 */
@property (nonatomic, weak) void(^ _Nullable configueCellBlock)(UITableViewCell * _Nonnull cell);

@end
