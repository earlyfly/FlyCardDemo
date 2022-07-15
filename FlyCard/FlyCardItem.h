//
//  FlyCardItem.h
//  FlyCardDemo
//
//  Created by trs on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FlyCardItem;
@protocol FlyCardItemDelegate <NSObject>

@required

/// 拖拽动画结束后，移出回调
/// @param item 需要移出的Item
- (void)didMoveOut:(FlyCardItem *)item;

/// 拖拽动画结束后，需要添加Item的回调
/// @param item 需要添加的Item
- (void)addCardItem:(FlyCardItem *)item;

/// 拖拽开始时，获取需要添加的Item对象回调
- (FlyCardItem *)lastCardItem;

@end

@interface FlyCardItem : UIView

// 代理
@property (nonatomic, weak) id<FlyCardItemDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
