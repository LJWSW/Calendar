//
//  SignCollectionViewCell.m
//  Calendar
//
//  Created by huiyou on 2018/3/13.
//  Copyright © 2018年 huiyou. All rights reserved.
//

#import "SignCollectionViewCell.h"

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation SignCollectionViewCell

- (UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [UILabel new];
        _lblTitle.textColor = [UIColor blackColor];
        _lblTitle.font = [UIFont systemFontOfSize:10];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_lblTitle];
        [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(5);
            make.height.mas_equalTo(12);
        }];
    }
    return _lblTitle;
}

- (UILabel *)lblNongLi
{
    if (!_lblNongLi)
    {
        _lblNongLi = [UILabel new];
        _lblNongLi.textColor = RGBCOLOR(170, 170, 170);
        _lblNongLi.font = [UIFont systemFontOfSize:12];
        _lblNongLi.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_lblNongLi];
        [_lblNongLi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.lblTitle.mas_bottom).offset(5);
        }];
    }
    return _lblNongLi;
}

- (UIImageView *)imgBg
{
    if (!_imgBg)
    {
        _imgBg = [UIImageView new];
        _imgBg.contentMode = UIViewContentModeScaleAspectFit;
        _imgBg.clipsToBounds = YES;
        _imgBg.image = [UIImage imageNamed:@""];
        _imgBg.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_imgBg];
        [_imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(self);
            make.width.height.mas_equalTo(5);
        }];
    }
    return _imgBg;
}

@end
