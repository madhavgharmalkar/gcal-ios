//
//  DayResultsView.m
//  GCAL
//
//  Created by Peter Kollath on 24/02/15.
//
//

#import "DayResultsView.h"
#import "GCCalculatedDaysPage.h"
#import "GCEngine.h"
#import "GCStrings.h"
#import "GcLocation.h"
#import "GCGregorianTime.h"
#import "GCCanvas.h"
#import "GCCalendarDay.h"
#import "GCCoreEvent.h"

@implementation DayResultsView


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initMyOwn];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initMyOwn];
    }
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

-(void)initMyOwn
{
//    self.viewState = DRV_MODE_FREE;
    self.userInteractionEnabled = NO;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    SEL paneDidMoveSelector = sel_registerName("paneDidMove:");
    
    if ([self.superview respondsToSelector:paneDidMoveSelector])
    {
        [self.superview performSelector:paneDidMoveSelector withObject:self];
    }
    
}


-(CGSize)calculateContentSize
{
    GCCanvas * canvas = [GCCanvas new];
    CGRect rect = self.frame;
    canvas.suppressDrawing = YES;
    
    canvas.styles = self.engine.styles;
    canvas.leftMargin = 20;
    canvas.currX = 20;
    canvas.rightMargin = rect.size.width - 20;
    canvas.engine = self.engine;
    
    [self drawSpecialFestivals:canvas];
    [self drawFestivals:canvas];
    [self drawCoreEvents:canvas];
    
    return CGSizeMake(rect.size.width, ceil(canvas.currY) + 80);

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    GCCanvas * canvas = [GCCanvas new];
    canvas.styles = self.engine.styles;
    canvas.leftMargin = 20;
    canvas.currX = 20;
    canvas.rightMargin = rect.size.width - 20;
    canvas.engine = self.engine;
    canvas.currY += 20;
    
    [self drawSpecialFestivals:canvas];
    [self drawFestivals:canvas];
    [self drawCoreEvents:canvas];

    self.drawBottom = canvas.currY + 40;
}

- (void)drawTextInRoundrect:(GCCanvas *)canvas pdf:(NSString *)pdf
                   bkgColor:(CGColorRef)bkgColor foreColor:(CGColorRef)foreColor
{
    canvas.leftMargin += 8;
    canvas.rightMargin -= 8;
    canvas.currX = canvas.leftMargin;
    CGSize size = [canvas sizeOfLine:pdf style:@"bold-1.5"];
    size.width = canvas.rightMargin - canvas.leftMargin;
    [canvas strokeRoundRect:CGRectMake(canvas.currX - 4, canvas.currY - 4, size.width + 8, size.height + 8)
             cornerDiameter:4 foregroundColor:foreColor backgroundColor:bkgColor];
    [canvas drawLine:pdf style:@"bold-1.5"];
    canvas.leftMargin -= 8;
    canvas.rightMargin += 8;
    canvas.currX = canvas.leftMargin;
    canvas.currY += 8;
}

-(void)drawSpecialFestivals:(GCCanvas *)canvas
{
    GCStrings * gstr = self.engine.myStrings;
    GCCalendarDay * p = self.data.calendarDay;
    CGColorRef bkgColor;
    CGColorRef foreColor = [UIColor blackColor].CGColor;
    int i = 0;
    
    if (p.isEkadasiParana)
    {
        // disp.specialTextColor
        // [p getHtmlDayBackground]
        NSString * text = [p GetTextEP:gstr];
        [self drawTextInRoundrect:canvas pdf:text
                         bkgColor:self.engine.h3Background.CGColor
                        foreColor:foreColor];
        canvas.currY += 4;
        i++;
    }
    
    for(GcDayFestival * pdf in p.festivals)
    {
        if (pdf.highlight == 1)
        {
            bkgColor = self.engine.h1Background.CGColor;
            [self drawTextInRoundrect:canvas pdf:pdf.name bkgColor:bkgColor foreColor:foreColor];
            canvas.currY += 4;
            i++;
        }
        else if (pdf.highlight == 2)
        {
            bkgColor = self.engine.h2Background.CGColor;
            [self drawTextInRoundrect:canvas pdf:pdf.name bkgColor:bkgColor foreColor:foreColor];
            canvas.currY += 4;
            i++;
        }
        else if (pdf.highlight == 3)
        {
            bkgColor = NULL;
            [canvas drawLine:pdf.name style:@"normal-highlight-1.5"];
            i++;
        }

    }
    
    if (i > 0)
    {
        canvas.currY += 10;
    }
}

-(void)drawFestivals:(GCCanvas *)canvas
{
    GCCalendarDay * p = self.data.calendarDay;
    BOOL hdr = NO;
   
    

    for(GcDayFestival * pdf in p.festivals)
    {
        if (pdf.highlight == 0)
        {
            if (hdr == NO)
            {
                [canvas drawSubheader:@"Festivals" style:@"normal-1"];
                hdr = YES;
            }
            [canvas drawLine:pdf.name style:@"bold-1"];
        }
    }

}

-(void)drawCoreEvents:(GCCanvas *)canvas
{
    if (self.engine.theSettings.t_core)
    {
        [canvas drawSubheader:@"Core Events" style:@"normal-1"];

        for (GCCoreEvent * ce in self.data.calendarDay.coreEvents) {
            int hr = ce.seconds / 3600;
            int mins = (ce.seconds % 3600) / 60;
            int secs = ce.seconds % 60;
            NSString * str = [NSString stringWithFormat:@"%02d:%02d:%02d %@", hr, mins, secs, ce.text];
            
            [canvas drawString:str style:@"normal-1"];
            if (ce.daylightSavingTime)
            {
                canvas.currX = canvas.rightMargin - 20;
                [canvas drawString:@"DST" style:@"location-subtitle"];
            }
            [canvas newLine];
        }
    }
}

@end
