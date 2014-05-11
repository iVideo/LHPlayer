//
//  GYJCustomNaviSegment.m
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-5-2.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import "GYJCustomNaviSegment.h"

@interface GYJCustomNaviSegment ()
{
    UILabel *_segment1;
    UILabel *_segment2;
    NSArray *_itemsArray;
}
@end

@implementation GYJCustomNaviSegment
- (id)initWithItems:(NSArray *)itemsArray{
    self = [super init];
    if (self) {
        _itemsArray = itemsArray;
        
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self.layer setCornerRadius:3.0];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _segment1 = [UILabel makeLabelWithStr:itemsArray[0] fontSize:15.0 textColor:IM_NAVI_PINK superView:self];
        _segment1.userInteractionEnabled = YES;
        _segment1.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segmentTapped:)];
        [_segment1 addGestureRecognizer:tap1];
        
        _segment2 = [UILabel makeLabelWithStr:itemsArray[1] fontSize:15.0 textColor:[UIColor whiteColor] superView:self];
        _segment2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segmentTapped:)];
        [_segment2 addGestureRecognizer:tap2];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _segment1.frame = CGRectMake(0.0, 0.0, self.bounds.size.width/2, self.bounds.size.height);
    _segment2.frame = CGRectMake(CGRectGetMaxX(_segment1.bounds), 0.0, self.bounds.size.width/2, self.bounds.size.height);
}

- (void)segmentTapped:(UIGestureRecognizer*)recognizer{
    if ([recognizer.view isEqual:_segment1]) {
        if (self.selectedIndex != 0) {
            _segment1.backgroundColor = [UIColor whiteColor];
            _segment1.textColor = IM_NAVI_PINK;
            _segment2.backgroundColor = [UIColor clearColor];
            _segment2.textColor = [UIColor whiteColor];
            _selectedIndex = 0;
            if (self.segmentSelectedBlock) {
                self.segmentSelectedBlock(self.selectedIndex);
            }
        }
        
    }else if ([recognizer.view isEqual:_segment2]){
        if (self.selectedIndex != 1) {
            _segment2.backgroundColor = [UIColor whiteColor];
            _segment2.textColor = IM_NAVI_PINK;
            _segment1.backgroundColor = [UIColor clearColor];
            _segment1.textColor = [UIColor whiteColor];
            _selectedIndex = 1;
            if (self.segmentSelectedBlock) {
                self.segmentSelectedBlock(self.selectedIndex);
            }
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (self.selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        if (self.selectedIndex == 0) {
            _segment1.backgroundColor = [UIColor whiteColor];
            _segment1.textColor = IM_NAVI_PINK;
            _segment2.backgroundColor = [UIColor clearColor];
            _segment2.textColor = [UIColor whiteColor];
        }else{
            _segment2.backgroundColor = [UIColor whiteColor];
            _segment2.textColor = IM_NAVI_PINK;
            _segment1.backgroundColor = [UIColor clearColor];
            _segment1.textColor = [UIColor whiteColor];
        }
        if (self.segmentSelectedBlock) {
            self.segmentSelectedBlock(self.selectedIndex);
        }
    }
}

@end
