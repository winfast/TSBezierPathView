//
//  TSCenterColumnarView.m
//  Pods-TSBezierPathView_Example
//
//  Created by QinChuancheng on 2019/7/18.
//

#import "TSCenterColumnarView.h"
#import <Masonry/Masonry.h>
#import "TSBezierLineView.h"

@interface TSCenterColumnarView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray<UILabel *> *labelsArray;

@end


@implementation TSCenterColumnarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self viewsLayout];
    }
    return self;
}

- (void)viewsLayout
{
    self.scrollerView = UIScrollView.alloc.init;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView.delegate = self;
    [self addSubview:self.scrollerView];
    [self.scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    
    self.pathView = TSColumnarBezierPathView.alloc.init;
    self.pathView.backgroundColor = UIColor.whiteColor;
    [self.scrollerView addSubview:self.pathView];
    [self.pathView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollerView.mas_width);
        make.height.mas_equalTo(self.scrollerView.mas_height);
    }];
}

- (NSMutableArray *)labelsArray
{
    if (!_labelsArray) {
        _labelsArray = NSMutableArray.alloc.init;
    }
    return _labelsArray;
}

- (void)commit
{
//    if (self.pathView.pathType == CSBezierPathTypeCircle) {
//        [self.pathView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//            make.width.mas_equalTo(self.scrollerView.mas_width);
//            make.height.mas_equalTo(self.scrollerView.mas_height);
//        }];
//        [self.pathView commit];
//        return;
//    }
    [self.pathView commit];
    NSInteger count = self.pathView.axisYValue.count;
    CGFloat moveX = self.pathView.moveAxisX + self.pathView.columnarMoveX;
    //获取View的宽度
    CGFloat width = 2 * moveX + (self.pathView.columnarWidth + self.pathView.columnarSpace)*count - self.pathView.columnarSpace;
    if (width < UIScreen.mainScreen.bounds.size.width) {
        [self.pathView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(self.scrollerView.mas_height);
        }];
    }
    else {
        [self.pathView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(self.scrollerView.mas_height);
        }];
    }
    NSInteger selelectedIndex = self.pathView.selectedIndex;
    NSMutableArray *buttonsArray = NSMutableArray.alloc.init;
    [self.labelsArray removeAllObjects];
    for (NSInteger index = 0; index < self.pathView.axisYValue.count; ++index) {
        NSString *strItem = @"";
        if (index < self.labelTextsArray.count) {
            strItem = self.labelTextsArray[index];
        }
        UILabel *label = UILabel.alloc.init;
        label.backgroundColor = UIColor.clearColor;
        label.textColor = TSColor(0x888888);
        label.numberOfLines = 3;
        label.font = [UIFont systemFontOfSize:12];
        label.tag = index;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = strItem;
        if (index == selelectedIndex) {
            label.textColor = TSColor(0x333333);
            label.text = NSLocalizedString((self.type == 0) ? @"本周" : @"本月", nil);
        }
       // [label addTapGestureAction:@selector(clickLabel:) withTarget:self];
        
        [self.pathView addSubview:label];
        if (self.type == 0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(50);
            }];
        }
        else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(self.pathView.columnarWidth);
            }];
        }
        
        [self.labelsArray addObject:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.clearColor;
        btn.tag = index;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.pathView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(self.pathView.columnarWidth);
        }];
        [buttonsArray addObject:btn];
    }
    if (self.type == 0) {
        [self.labelsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:self.pathView.columnarWidth * 2 leadSpacing:moveX - 16 tailSpacing:moveX - 16];
    }
    else {
        [self.labelsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:self.pathView.columnarSpace leadSpacing:moveX tailSpacing:moveX];
    }
    [buttonsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:self.pathView.columnarSpace leadSpacing:self.pathView.moveAxisX tailSpacing:self.pathView.moveAxisX];
    
    [self scrollerToCenter:NO];
}

- (void)scrollerToCenter:(BOOL)animate
{
    NSInteger count = self.pathView.axisYValue.count;
    //获取View的宽度
    CGFloat width = 2 * (self.pathView.moveAxisX + self.pathView.columnarMoveX) + (self.pathView.columnarWidth + self.pathView.columnarSpace)*count - self.pathView.columnarSpace;
    
    NSInteger selectedIndex = self.pathView.selectedIndex;
    CGFloat axisX = self.pathView.moveAxisX + self.pathView.columnarMoveX;
    CGFloat startX = axisX + selectedIndex * (self.pathView.columnarSpace + self.pathView.columnarWidth);
    CGFloat moveX = self.pathView.columnarWidth * 0.5;
    if (startX + moveX < UIScreen.mainScreen.bounds.size.width * 0.5) {
        
    }
    else if(startX + moveX + UIScreen.mainScreen.bounds.size.width * 0.5 > width){
    }
    else {
        CGFloat offsetX = startX + moveX - UIScreen.mainScreen.bounds.size.width * 0.5;
        [self.scrollerView setContentOffset:CGPointMake(offsetX, 0) animated:animate];
    }
}

//重新计算停止的地方
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = self.pathView.columnarWidth + self.pathView.columnarSpace;
    CGFloat offsetX = offset.x;
    NSInteger page = roundf(offsetX / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

//停止滑动的时候刷新UI
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        CGFloat pageSize = self.pathView.columnarWidth + self.pathView.columnarSpace;
        CGFloat offsetX = scrollView.contentOffset.x - (UIScreen.mainScreen.bounds.size.width * 0.5 - self.pathView.columnarWidth * 0.5 ) + 0.5 * UIScreen.mainScreen.bounds.size.width;
        NSInteger page = roundf(offsetX / pageSize);
        if (page < 0 || page >= self.labelsArray.count) {
            return;
        }
    
        self.pathView.selectedIndex = page;
        [self.pathView commit];
        [self.labelsArray setValue:TSColor(0x888888) forKey:@"textColor"];
        [self.labelsArray[page] setTextColor:TSColor(0x333333)];
        if (self.selectedcolumnar) {
            self.selectedcolumnar(page);
        }
    }
}

//停止滑动的时候刷新UI
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageSize = self.pathView.columnarWidth + self.pathView.columnarSpace;
    CGFloat offsetX = scrollView.contentOffset.x - (UIScreen.mainScreen.bounds.size.width * 0.5 - self.pathView.columnarWidth * 0.5 ) + 0.5 * UIScreen.mainScreen.bounds.size.width;
    NSInteger page = roundf(offsetX / pageSize);
    if (page < 0 || page >= self.labelsArray.count) {
        return;
    }
    
    if (page == 14) {
        NSLog(@"rizhi");
    }
    
    
    self.pathView.selectedIndex = page;
    [self.pathView commit];
    [self.labelsArray setValue:TSColor(0x888888) forKey:@"textColor"];
    NSLog(@"page3 = %d",page);
    [self.labelsArray[page] setTextColor:TSColor(0x333333)];
    if (self.selectedcolumnar) {
        self.selectedcolumnar(page);
    }
}

- (void)clickBtn:(id)sender
{
    NSInteger index = [sender tag];
    self.pathView.selectedIndex = index;
    [self.pathView commit];
    [self.labelsArray setValue:TSColor(0x888888) forKey:@"textColor"];
    NSLog(@"clickBtn = index = %d",index);
    [self.labelsArray[index] setTextColor:TSColor(0x333333)];
    [self scrollerToCenter:YES];
    if (self.selectedcolumnar) {
        self.selectedcolumnar(index);
    }
}

- (void)clickLabel:(id)sender
{
    UITapGestureRecognizer *ges = (UITapGestureRecognizer *)sender;
    UIView *view = [ges view];
    NSInteger index = [view tag];
    self.pathView.selectedIndex = index;
    [self.pathView commit];
    [self.labelsArray setValue:TSColor(0x888888) forKey:@"textColor"];
    NSLog(@"clickLabel = index = %d",index);
    [self.labelsArray[index] setTextColor:TSColor(0x333333)];
    [self scrollerToCenter:YES];
    if (self.selectedcolumnar) {
        self.selectedcolumnar(index);
    }
}

@end
