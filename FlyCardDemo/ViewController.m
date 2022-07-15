//
//  ViewController.m
//  FlyCardDemo
//
//  Created by trs on 2022/7/13.
//

#import "ViewController.h"
#import "FlyCardView.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FlyCardView *view = [[FlyCardView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(30);
        make.top.bottom.equalTo(self.view).inset(100);
    }];
    
}


@end
