//
//  MCPlaceHolderTextView.m
//  HealthChat3.0
//
//  Created by maomao on 12-12-11.
//  Copyright (c) 2012年 maomao. All rights reserved.
//

#import "PlaceHolderTextView.h"


@interface MCPlaceHolderTextView () {
    BOOL _placeHolderVisible;
    BOOL _hasSetPlaceHolderVisible;
}

@property(nonatomic, strong)    UILabel *placeHolderLabel;
@property (nonatomic, assign)   BOOL shouldDrawPlaceHold;

@end

@implementation MCPlaceHolderTextView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    if (!_placeholderColor) {
        
    }
    
    if (!_hasSetPlaceHolderVisible) {
        _placeHolderVisible = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
    }
    return self;
}

- (void)setPlaceHolderVisible:(BOOL)hidden {
    _hasSetPlaceHolderVisible = YES;
    _placeHolderVisible = hidden;
    [self reloadVisibleState];
}

- (void)textChanged:(NSNotification *)notification {
    [self reloadVisibleState];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (_placeholder != placeholder) {
        if (self.ellipsisState) {
            //  不截取
        } else {
            if (placeholder.length > 20) {
                placeholder = [placeholder substringToIndex:20];
                placeholder = [placeholder stringByAppendingString:@"..."];
            }
        }
        
        _placeholder = placeholder;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)reloadVisibleState {
    
    if (!self.text.length && self.placeholder.length && _placeHolderVisible) {
        _placeHolderLabel.hidden = NO;
        _shouldDrawPlaceHold = YES;
    } else {
        _placeHolderLabel.hidden = YES;
        _shouldDrawPlaceHold = NO;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGRect dractRect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
    dractRect.origin.x = 6;
    
    if (self.placeholder.length && self.text.length > 0) {
        [_placeholder drawInRect:dractRect withAttributes:@{NSFontAttributeName:self.font,
                                                            NSForegroundColorAttributeName:self.placeholderColor}];
    }
    
    [super drawRect:rect];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
