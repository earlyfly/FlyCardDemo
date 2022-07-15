//
//  FlyCardItem.m
//  FlyCardDemo
//
//  Created by trs on 2022/7/13.
//

#import "FlyCardItem.h"
#import "FlyCardConfig.h"

typedef enum : NSUInteger {
    FlyCardMoveNone,
    FlyCardMoveHorizon,
    FlyCardMoveVertical,
} FlyCardMoveDiraction;

@interface FlyCardItem ()

@property (nonatomic, assign) FlyCardMoveDiraction currentDiraction;
@property (nonatomic, strong) FlyCardItem *addItem;


@end

@implementation FlyCardItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.000].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.cornerRadius = 10;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:pan];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.addItem = nil;
            self.currentDiraction = FlyCardMoveNone;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint movePoint = [pan translationInView:pan.view];
            if (self.currentDiraction == FlyCardMoveNone) {
                if (fabs(movePoint.x) > fabs(movePoint.y)) { // 横向拖动
                    self.currentDiraction = FlyCardMoveHorizon;
                } else {
                    self.currentDiraction = FlyCardMoveVertical;
                }
            }
            
            if (self.currentDiraction == FlyCardMoveHorizon) { // 横向拖动
                    [UIView animateWithDuration:.25f animations:^{
                        self.transform =  CGAffineTransformMakeTranslation(movePoint.x, 0);
                    }];
            } else if (self.currentDiraction == FlyCardMoveVertical){
                
                if (movePoint.y >0 && self.delegate && [self.delegate respondsToSelector:@selector(lastCardItem)]) {
                    self.transform =  CGAffineTransformIdentity;
                    self.addItem = [self.delegate lastCardItem];
                    self.addItem.transform = CGAffineTransformMakeTranslation(0, -Screen_H/2+movePoint.y);
                    return;
                }
                
                if (self.addItem) {
                    self.addItem.transform = CGAffineTransformMakeTranslation(0, -Screen_H);
                    self.addItem = nil;
                }
                
                
                [UIView animateWithDuration:.25f animations:^{
                    self.transform =  CGAffineTransformMakeTranslation(0, movePoint.y);
                }];
                
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint movePoint = [pan translationInView:pan.view];
            if (self.currentDiraction == FlyCardMoveHorizon && fabs(movePoint.x) >= 100) {
                [UIView animateWithDuration:.25f animations:^{
                    self.transform =  CGAffineTransformMakeTranslation(movePoint.x > 0 ? Screen_W : -Screen_W, 0);
                } completion:^(BOOL finished) {
                    [self moveOutHandler];
                }];
            } else if (self.currentDiraction == FlyCardMoveVertical && fabs(movePoint.y) >= 100) {
                if (self.addItem) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(addCardItem:)]) {
                        [self.delegate addCardItem:self.addItem];
                    }
                    return;
                }
                
                
                [UIView animateWithDuration:.25f animations:^{
                    self.transform =  CGAffineTransformMakeTranslation(0, movePoint.y > 0 ? Screen_H : -Screen_H);
                } completion:^(BOOL finished) {
                    [self moveOutHandler];
                }];
            } else{
                
                // 还原
                [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:.6f initialSpringVelocity:.7f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (self.addItem) {
                        self.addItem.transform = CGAffineTransformMakeTranslation(0, -Screen_H);
                    } else {
                        self.transform = CGAffineTransformIdentity;
                    }
                } completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGPoint movePoint = [pan translationInView:pan.view];
            NSLog(@"Cancel --- %@", NSStringFromCGPoint(movePoint));
        }
            break;
        default:
            break;
    }
}

// 滑动拖拽移出动画后的回调
- (void)moveOutHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMoveOut:)]) {
        [self.delegate didMoveOut:self];
    }
}

@end
