    //
//  MainViewController.m
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import "MainViewController.h"
#import "Classes/SettingsViewTableController.h"
#import "Classes/BalaCalAppDelegate.h"
#import "Classes/GCGregorianTime.h"
#import "GCStrings.h"
#import "GcLocation.h"
#import "GCDisplaySettings.h"
#import "Classes/GcResultToday.h"
#import "Classes/HUScrollView.h"
#import "Classes/VUScrollView.h"

#import "Classes/DayResultsView.h"

#import "GCAL-Swift.h"

@implementation MainViewController


#pragma mark -
#pragma mark System Overrides

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.view.userInteractionEnabled = NO;
    self.mainView.userInteractionEnabled = NO;
    [super viewDidLoad];
}

#pragma mark -
#pragma mark User Interface actions

-(void)setCurrentDay:(int)day month:(int)month year:(int)year
{
    GCGregorianTime * gct = [GCGregorianTime new];
    gct.year = year;
    gct.month = month;
    gct.day = day;
    if (!self.scrollViewD.hidden)
    {
        [self showDateSingle:gct];
    }
    if (!self.scrollViewV.hidden)
        [self.scrollViewV showDate:gct];
}

-(void)showDateSingle:(GCGregorianTime *)dateToShow
{
    [self.dayView attachDate:dateToShow];
    [self.dayView refreshDateAttachement];
    self.scrollViewD.contentOffset = CGPointZero;
    self.scrollViewD.contentSize = self.dayView.frame.size;
    [self.dayView setNeedsDisplay];
}

-(void)opCalcToday
{
	@autoreleasepool {
		[self.calcToday calcDate:[GCGregorianTime today]];
		[self.myWebView loadHTMLString:[self.calcToday formatTodayHtml]
						  baseURL:nil];
	}
    self.view.hidden = NO;
}

-(void)opRecalc
{
	@autoreleasepool {
		[self.calcToday recalc];
		[self.myWebView loadHTMLString:[self.calcToday formatTodayHtml] baseURL:nil];
	}
    self.view.hidden = NO;
}

-(IBAction)actionToday:(id)sender
{
	if (self.calcToday != nil && self.myWebView != nil) {
		[self performSelectorInBackground:@selector(opCalcToday) withObject:nil];
	}

    if (!self.scrollViewD.hidden)
        [self showDateSingle:[GCGregorianTime today]];
    if (!self.scrollViewV.hidden)
        [self.scrollViewV showDate:[GCGregorianTime today]];

}

-(IBAction)actionNormalView:(id)sender
{
    [self.theSettings writeToFile];
    if (!self.scrollViewD.hidden)
    {
        [self.dayView refreshDateAttachement];
        [self.dayView setNeedsDisplay];
    }
    if (!self.scrollViewV.hidden)
        [self.scrollViewV refreshAllViews];

    [self.setDlg1 viewWillDisappear:YES];
    [self.setDlg1.view removeFromSuperview];
    [self.setDlg1 viewDidDisappear:YES];
    
    // recalculate last scheduled calendar event
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GCAL_resetFutureNotifications" object:nil]];

}

@end
