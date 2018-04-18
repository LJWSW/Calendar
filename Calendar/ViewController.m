//
//  ViewController.m
//  Calendar
//
//  Created by huiyou on 2018/3/13.
//  Copyright © 2018年 huiyou. All rights reserved.
//

#import "ViewController.h"

#import "SignCollectionView.h"

#import <Masonry.h>

#define G_SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width
#define G_SCREEN_HEIGHT            [UIScreen mainScreen].bounds.size.height
#define G_SCREEN_WIDTHSCALE        G_SCREEN_WIDTH / 750              //屏幕宽对比750的比例

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface ViewController ()

@property (nonatomic, strong) UIView *weekView;

@property (nonatomic, strong) SignCollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.weekView];
    
    NSArray *arrTitles = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < 7; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH / 7.0 * i, 0, G_SCREEN_WIDTH / 7.0, 100 * G_SCREEN_WIDTHSCALE)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:(i == 0 || i == 6) ? RGBCOLOR(255, 129, 126) : RGBCOLOR(170, 170, 170) forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        [btn setTitle:arrTitles[i] forState:UIControlStateNormal];
        [self.weekView addSubview:btn];
    }
    
    [self.collectionView bindDataWithMonth:[NSDate date]];
}

#pragma mark - Lazying --------------------------------

- (UIView *)weekView
{
    if (!_weekView)
    {
        _weekView = [UIView new];
        _weekView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_weekView];
        [_weekView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(20 );
            make.height.mas_equalTo(100 * G_SCREEN_WIDTHSCALE);
        }];
        
        UIView *lineTop = [[UIView alloc] init];
        lineTop.backgroundColor = RGBCOLOR(120, 120, 120);
        [_weekView addSubview:lineTop];
        [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_weekView);
            make.height.mas_equalTo(1);
        }];
        
        UIView *lineBottom = [[UIView alloc] init];
        lineBottom.backgroundColor = RGBCOLOR(120, 120, 120);
        [_weekView addSubview:lineBottom];
        [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(_weekView);
            make.height.mas_equalTo(1);
        }];
        
    }
    return _weekView;
}

- (SignCollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[SignCollectionView alloc] initWithFrame:CGRectMake(0, 100 * G_SCREEN_WIDTHSCALE + 20, G_SCREEN_WIDTH, 800 * G_SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = RGBCOLOR(247, 247, 247);
        _collectionView.allowsSelection = NO;
        _collectionView.bounces = NO;
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
