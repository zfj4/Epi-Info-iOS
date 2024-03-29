//
//  TimePicker.m
//  EpiInfo
//
//  Created by John Copeland on 5/30/14.
//

#import "TimePicker.h"
#import "BlurryView.h"

@implementation TimePicker
@synthesize timeField = _timeField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:bv];
        
        NSMutableArray *hours = [NSMutableArray arrayWithArray:@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"]];
        hoursLV = [[LegalValues alloc] initWithFrame:CGRectMake(10, 10, 300, 180) AndListOfValues:hours];
        [hoursLV setPicked:@"00"];
        [hoursLV setViewToAlertOfChanges:self];
        [bv addSubview:hoursLV];
        
        NSMutableArray *minutes = [NSMutableArray arrayWithArray:@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09"]];
        for (int i = 10; i < 60; i++)
            [minutes addObject:[NSString stringWithFormat:@"%d", i]];
        minutesLV = [[LegalValues alloc] initWithFrame:CGRectMake(10, 200, 140, 180) AndListOfValues:minutes];
        [minutesLV setPicked:@"1"];
        [minutesLV setViewToAlertOfChanges:self];
        [bv addSubview:minutesLV];
        
        UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(bv.frame.size.width / 2.0 - 140, frame.size.height - 280, 120, 40)];
        [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [noButton.layer setMasksToBounds:YES];
        [noButton.layer setCornerRadius:4.0];
        [noButton addTarget:self action:@selector(removeSelfFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:noButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(bv.frame.size.width / 2.0 + 20, frame.size.height - 280, 120, 40)];
        [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
        [okButton setTitle:@"Okay" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [okButton.layer setMasksToBounds:YES];
        [okButton.layer setCornerRadius:4.0];
        [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:okButton];

        [hoursLV.picker setFrame:CGRectMake(0, 0, 140, 162)];
        [hoursLV setFrame:CGRectMake(10, 10, 140, 180)];
        
        UILabel *colon = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 10, 160)];
        [colon setText:@":"];
        [colon setTextAlignment:NSTextAlignmentCenter];
        [colon setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24]];
        [bv addSubview:colon];

        [minutesLV.picker setFrame:CGRectMake(10, 0, 120, 162)];
        [minutesLV setFrame:CGRectMake(170, 10, 140, 180)];
        
        [noButton setFrame:CGRectMake(noButton.frame.origin.x, 180, noButton.frame.size.width, noButton.frame.size.height)];
        [okButton setFrame:CGRectMake(okButton.frame.origin.x, 180, okButton.frame.size.width, okButton.frame.size.height)];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndTimeField:(UITextField *)timeField
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self setTimeField:timeField];
        
        int hour = 0;
        int minute = 0;
        
        if (timeField.text.length > 0)
        {
            hour = [[timeField.text substringToIndex:2] intValue];
            minute = [[timeField.text substringFromIndex:3] intValue];
        }
        else
        {
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH:mm:ss"];
            NSString *timeString = [outputFormatter stringFromDate:[NSDate date]];
            hour = [[timeString substringToIndex:2] intValue];
            minute = [[timeString substringFromIndex:3] intValue];
        }
        
        [hoursLV.picker selectRow:hour inComponent:0 animated:NO];
        if (hour < 10)
            [hoursLV setPicked:[NSString stringWithFormat:@"0%d", hour]];
        else
            [hoursLV setPicked:[NSString stringWithFormat:@"%d", hour]];
        [minutesLV.picker selectRow:minute inComponent:0 animated:NO];
        if (minute < 10)
            [minutesLV setPicked:[NSString stringWithFormat:@"0%d", minute]];
        else
            [minutesLV setPicked:[NSString stringWithFormat:@"%d", minute]];
    }
    return self;
}

- (void)okButtonPressed
{
    int hour = [hoursLV.picked intValue];
    int minute = [minutesLV.picked intValue];
    
    NSString *time = @"";
    
    if (hour < 10)
        time = @"0";
    time = [time stringByAppendingString:[NSString stringWithFormat:@"%d:", hour]];
    if (minute < 10)
        time = [time stringByAppendingString:@"0"];
    time = [time stringByAppendingString:[NSString stringWithFormat:@"%d", minute]];
    
    [self.timeField setText:time];
    
    [self removeSelfFromSuperview];
}

- (void)removeSelfFromSuperview
{
    CGRect finalFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:finalFrame];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
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
