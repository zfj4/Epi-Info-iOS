//
//  TimeField.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "TimeField.h"
#include "TimePicker.h"

@implementation TimeField
@synthesize columnName = _columnName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFormFieldValue:(NSString *)formFieldValue
{
    if ([formFieldValue isEqualToString:@"(null)"])
        return;
    
    [self setText:formFieldValue];
}

- (BOOL)becomeFirstResponder
{
    CGRect finalFrame = [[self superview] superview].frame;
    CGRect initialframe = CGRectMake(finalFrame.origin.x, finalFrame.origin.y - finalFrame.size.height, finalFrame.size.width, finalFrame.size.height);
    
    TimePicker *tp = [[TimePicker alloc] initWithFrame:initialframe AndTimeField:self];
    [[[[self superview] superview] superview] addSubview:tp];
    [self resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [tp setFrame:finalFrame];
    } completion:^(BOOL finished){
    }];
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
