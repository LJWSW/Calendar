//
//  SignCollectionView.m
//  Calendar
//
//  Created by huiyou on 2018/3/13.
//  Copyright © 2018年 huiyou. All rights reserved.
//

#import "SignCollectionView.h"

#import "SignCollectionViewCell.h"

#import <Masonry.h>

#define G_SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width
#define G_SCREEN_HEIGHT            [UIScreen mainScreen].bounds.size.height
#define G_SCREEN_WIDTHSCALE        G_SCREEN_WIDTH / 750

@interface SignCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>
// 这月总共有几天
@property (nonatomic, assign) NSInteger days;
// 这月第一天在collection里面第几个cell
@property (nonatomic, assign) NSInteger firstLocation;
//今天几号
@property (nonatomic, assign) NSInteger today;

// 农历数据
@property (nonatomic, strong) NSMutableArray *marrNongLiDay;

//@property (nonatomic, assign) NSInteger selectNum;

//@property (nonatomic, assign) NSInteger selectRow;

//@property (nonatomic, assign) BOOL isSelect;

@end

@implementation SignCollectionView

- (NSMutableArray *)marrNongLiDay
{
    if (!_marrNongLiDay)
    {
        _marrNongLiDay = [NSMutableArray array];
    }
    return _marrNongLiDay;
}

#pragma mark - Life --------------------------------
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.delegate = self;
        self.dataSource = self;
        
//        [self reloadData];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource ---------------
// 分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
// 组个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

// 设置元素与内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strId = @"SignCollectionViewCell";
    [self registerClass:[SignCollectionViewCell class] forCellWithReuseIdentifier:strId];
    
    SignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:strId forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:strId forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row > self.firstLocation - 2 && indexPath.row < self.days + self.firstLocation - 1)
    {
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row - self.firstLocation + 2];
        cell.lblNongLi.text = self.marrNongLiDay[indexPath.row - self.firstLocation + 1];
    }
    else
    {
        cell.lblTitle.text = @"";
    }
    return cell;
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((G_SCREEN_WIDTH - 5) / 7, 100 * G_SCREEN_WIDTHSCALE);
}

#pragma mark - Function ----------------------
// 绑定月份 告诉页面这个月的形式 包括从第几天开始第几天结束
- (void)bindDataWithMonth:(NSDate *)date
{
//    self.selectRow = 43;
    
    //这里date拿到的是完整的日期数据
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    self.days = [self getNumberOfDaysInMonth:[self getMonthBeginAndEndWith:strDate]];
    self.firstLocation = [[self getweekDayWithDate:[self getMonthBeginAndEndWith:strDate]] integerValue];
    
//    [self reloadData];
    
}

//返回给定月份的第一天   dateStr形式 ： 2017-09
- (NSDate *)getMonthBeginAndEndWith:(NSString *)dateStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate = [format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2]; //设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    if (ok)
    {
        endDate = [beginDate dateByAddingTimeInterval:interval - 1];
    }
    else
    {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 =  [formatter dateFromString:beginString];
    
    return date1;
}

// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSString *strDate = [format stringFromDate:[NSDate date]];
    
    self.marrNongLiDay = nil;
    for (int i = 1; i<= range.length; i++)
    {
        NSString *str = [self getChineseCalendarWithDate:[NSString stringWithFormat:@"%@-%02d",strDate,i]];
        
        [self.marrNongLiDay addObject:[str componentsSeparatedByString:@"_"].lastObject];
        
    }
    
    return range.length;
}

//指定日期的星期 1 是星期日
- (id)getweekDayWithDate:(NSDate *) date
{
    
    NSDate *date1 =[NSDate date];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"MM"];
    if ([[formatter1 stringFromDate:date1] integerValue] == [[formatter1 stringFromDate:date] integerValue]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd"];
        NSInteger currentDay=[[formatter stringFromDate:date1] integerValue];
        self.today = currentDay;
    }else{
        self.today = -1;
    }
    
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    return @([comps weekday]);
    
}

//日期阳历转换为农历；
-(NSString*)getChineseCalendarWithDate:(NSString*)date
{
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSDate *dateTemp = nil;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    dateTemp = [dateFormater dateFromString:date];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:dateTemp];
    
//    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    if ([m_str isEqualToString:@"正月"] & [d_str isEqualToString:@"初一"]) //春节
    {
        d_str = @"春节";
    }
    else if ([m_str isEqualToString:@"正月"] & [d_str isEqualToString:@"十五"]) //元宵
    {
        d_str = @"元宵";
    }
//    else if ([m_str isEqualToString:@""] & [d_str isEqualToString:@""]) //清明
//    {
//
//    }
    else if ([m_str isEqualToString:@"五月"] & [d_str isEqualToString:@"初五"]) //端午
    {
        d_str = @"端午";
    }
    else if ([m_str isEqualToString:@"七月"] & [d_str isEqualToString:@"初七"]) //七夕
    {
        d_str = @"七夕";
    }
    else if ([m_str isEqualToString:@"八月"] & [d_str isEqualToString:@"十五"]) //中秋
    {
        d_str = @"中秋";
    }
    else if ([m_str isEqualToString:@"九月"] & [d_str isEqualToString:@"初九"]) //重阳
    {
        d_str = @"重阳";
    }
    else if ([m_str isEqualToString:@"腊月"] & [d_str isEqualToString:@"初八"]) //腊八
    {
        d_str = @"腊八";
    }
    else if ([m_str isEqualToString:@"腊月"] & [d_str isEqualToString:@"三十"]) //除夕
    {
        d_str = @"除夕";
    }
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    NSLog(@"农历日期：%@",chineseCal_str);
    
    return chineseCal_str;
}





@end
