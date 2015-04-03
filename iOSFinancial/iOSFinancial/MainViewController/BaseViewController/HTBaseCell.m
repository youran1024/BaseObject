//
//  HTBaseCell.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseCell.h"
#import "UIImage+Stretch.h"

@interface HTBaseCell ()

@property (nonatomic, strong)   UIView *highLightView;

@end

@implementation HTBaseCell

+ (BOOL)isNib
{
    return YES;
}

+ (UITableViewCellStyle)tableViewCellStyle
{
    return UITableViewCellStyleDefault;
}

+ (CGFloat)fixedHeight
{
    return 74.0f;
}

+ (HTBaseCell *)newCell
{
    BOOL isNib = [self isNib];

    NSString *cellName = NSStringFromClass([self class]);
    
    if (isNib) {
        return [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] lastObject];
    }
    
    return [[[self class] alloc] initWithStyle:[self tableViewCellStyle] reuseIdentifier:cellName];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectedBackgroundView = self.highLightView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = self.highLightView;
    }
    
    return self;
}

- (void)configWithSource:(id)source
{
    
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    _selectedBackgroundColor = selectedBackgroundColor;
    self.highLightView.backgroundColor = selectedBackgroundColor;
}

- (UIView *)highLightView
{
    if (!_highLightView) {
        _highLightView = [[UIView alloc] initWithFrame:self.bounds];
        UIColor *color = self.selectedBackgroundColor ? _selectedBackgroundColor : [UIColor redColor];
        _highLightView.backgroundColor = color;
    }
    
    return _highLightView;
}

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}


@end
