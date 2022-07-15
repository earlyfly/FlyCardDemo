//
//  FlyCardView.m
//  FlyCardDemo
//
//  Created by trs on 2022/7/13.
//

#import "FlyCardView.h"
#import "Masonry/Masonry.h"
#import "FlyCardItem.h"
#import "FlyCardConfig.h"

@interface FlyCardView ()<FlyCardItemDelegate>

@property (nonatomic, assign) NSInteger count;// 常态下显示的item个数
@property (nonatomic, assign) CGFloat cardSpacing;// 底部排列间距

@property (nonatomic, copy) NSArray *cardViews;// items数组缓存列表
@property (nonatomic, strong) FlyCardItem *tempCardView;// 当下滑时，要添加的item

@end

@implementation FlyCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _count = 3;
        _cardSpacing = 10;
        [self setupView];
    }
    return self;
}

- (void)addCardItem:(FlyCardItem *)item {
    // 设置当前添加的item无偏移
//    item.transform = CGAffineTransformIdentity;
    
    // 重新配置items数组缓存列表
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self.cardViews subarrayWithRange:NSMakeRange(0, self.cardViews.count - 1)]];
    [tempArr insertObject:item atIndex:0];
    self.tempCardView = self.cardViews.lastObject;
    self.tempCardView.transform = CGAffineTransformMakeTranslation(0, -Screen_H);
    self.cardViews = tempArr.copy;
    
    // 刷新
    for (int i = 0; i < self.cardViews.count; i++) {
        UIView *view = self.cardViews[i];
        view.userInteractionEnabled = i == 0;
        [UIView animateWithDuration:.3f animations:^{
            if (view != item) {
                    [view mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(self).inset(i * self->_cardSpacing);
                        make.top.equalTo(self).inset(i * self->_cardSpacing);
                        make.bottom.equalTo(self).inset((self.count - 1 - i) * self->_cardSpacing);
                    }];
                    
                    [self setNeedsLayout];
                    [self layoutIfNeeded];
            } else {
                view.transform = CGAffineTransformIdentity;
            }
        }];
    }
}

- (FlyCardItem *)lastCardItem {
    self.tempCardView.transform = CGAffineTransformMakeTranslation(0, -Screen_H/2);
    [self bringSubviewToFront:self.tempCardView];
    [self.tempCardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).inset((self.count - 1) * self->_cardSpacing);
    }];
    return self.tempCardView;
}

- (void)didMoveOut:(FlyCardItem *)item {
    item.transform = CGAffineTransformIdentity;
    [self sendSubviewToBack:item];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self.cardViews subarrayWithRange:NSMakeRange(1, self.cardViews.count - 1)]];
    [tempArr addObject:item];
    self.cardViews = tempArr.copy;
    
    for (int i = 0; i < self.cardViews.count; i++) {
        UIView *view = self.cardViews[i];
        view.userInteractionEnabled = i == 0;
        if (view != item) {
            [UIView animateWithDuration:.1f animations:^{
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self).inset(i * self->_cardSpacing);
                    make.top.equalTo(self).inset(i * self->_cardSpacing);
                    make.bottom.equalTo(self).inset((self.count - 1 - i) * self->_cardSpacing);
                }];
                
                [self setNeedsLayout];
                [self layoutIfNeeded];
            }];
        } else {
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self).inset(i * self->_cardSpacing);
                make.top.equalTo(self).inset(i * self->_cardSpacing);
                make.bottom.equalTo(self).inset((self.count - 1 - i) * self->_cardSpacing);
            }];
        }
    }
}

- (void)setupView {
    for (int i = 0; i < self.cardViews.count; i++) {
        UIView *view = self.cardViews[i];
        view.userInteractionEnabled = i == 0;
        [self insertSubview:view atIndex:0];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).inset(i * _cardSpacing);
            make.top.equalTo(self).inset(i * _cardSpacing);
            make.bottom.equalTo(self).inset((self.count - 1 - i) * _cardSpacing);
        }];
    }
}

- (NSArray *)cardViews {
    if(!_cardViews) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.count; i++) {
            FlyCardItem *view = [[FlyCardItem alloc] init];
            view.delegate = self;
            UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
            view.backgroundColor = randomColor;
            [tempArr addObject:view];
        }
        _cardViews = tempArr.copy;
    }
    return _cardViews;
}

- (FlyCardItem *)tempCardView {
    if (!_tempCardView) {
        _tempCardView = [[FlyCardItem alloc] init];
        _tempCardView.delegate = self;
        UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        _tempCardView.backgroundColor = randomColor;
        [self addSubview:_tempCardView];
        [_tempCardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self).inset((self.count - 1 ) * _cardSpacing);
        }];
    }
    return _tempCardView;
}

@end
