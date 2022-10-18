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

#import "Classes/GpsViewController.h"
#import "Classes/GVChangeDateViewController.h"
#import "Classes/GVChangeLocationDlg.h"
#import "Classes/GVHelpIntroViewController.h"
#import "Classes/DayResultsView.h"

#import "GCAL-Swift.h"

@implementation MainViewController


#pragma mark -
#pragma mark System Overrides

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.view.userInteractionEnabled = NO;
    [super viewDidLoad];
}

-(void)releaseDialogs
{
    self.chdDlg1 = nil;
    self.chlDlg1 = nil;
    self.findDlg1 = nil;
    self.setDlg1 = nil;
    self.gpsDlg1 = nil;
    self.chdDlg1 = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [self releaseDialogs];
}


#pragma mark -
#pragma mark User Interface actions

-(void)onShowGps:(id)sender
{
    if (self.gpsDlg1 == nil)
    {
        self.gpsDlg1 = [[GpsViewController alloc] initWithNibName:@"GpsViewController" bundle:nil];
    }
    
    self.gpsDlg1.view.frame = self.mainView.bounds;
    [self.mainView addSubview:self.gpsDlg1.view];
}

-(void)onShowLocationDlg:(id)sender
{
    if (self.chlDlg1 == nil)
    {
        self.chlDlg1 = [[GVChangeLocationDlg alloc] initWithNibName:@"GVChangeLocationDlg" bundle:nil];
    }
    
    CGRect rect = self.mainView.bounds;
    self.chlDlg1.view.frame = rect;
    [self.mainView addSubview:self.chlDlg1.view];
}

-(void)onShowDateChangeView:(id)sender {
    ChangeDateViewController *vc = [ChangeDateViewController new];
    [self presentViewController:vc animated:YES completion:nil];
    
//    if (self.chdDlg1 == nil)
//    {
//        self.chdDlg1 = [[GVChangeDateViewController alloc] initWithNibName:@"GVChangeDateViewController" bundle:nil];
//        self.chdDlg1.mainController = self;
//    }
//
//    self.chdDlg1.view.frame = self.mainView.bounds;
//    [self.mainView addSubview:self.chdDlg1.view];
}   

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

-(IBAction)displayActionSheet:(id)sender {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil
                                   message:@"Choose Option"
                                   preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* goToDateAction = [UIAlertAction actionWithTitle:@"Go to date" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        [self onShowDateChangeView:nil];
    }];
    
    UIAlertAction* selectLocation = [UIAlertAction actionWithTitle:@"Change location (select)" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        [self onShowLocationDlg:nil];
    }];
    
    UIAlertAction* gpsLocation = [UIAlertAction actionWithTitle:@"Change location (GPS)" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        [self onShowGps:nil];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
       handler:^(UIAlertAction * action) {
    }];
    
    [actionSheet addAction:goToDateAction];
    [actionSheet addAction:selectLocation];
    [actionSheet addAction:gpsLocation];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(IBAction)onSettingsButton:(id)sender
{
    [self actionSettings:sender];
}

-(IBAction)actionPrevDay:(id)sender
{
	[self.calcToday setPrevDay];
	[self.myWebView loadHTMLString:[self.calcToday formatTodayHtml]
					  baseURL:nil];
}

-(IBAction)actionNextDay:(id)sender
{
	[self.calcToday setNextDay];
	[self.myWebView loadHTMLString:[self.calcToday formatTodayHtml]
					  baseURL:nil];
	
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

-(void)setRecalculationPage
{
    self.view.hidden = YES;
	//[myWebView loadHTMLString:@"<html><head></head><body bgcolor=\"4A4A4A\"><p align=center style='font-size:12pt;font-family:Verdana;color:white'><br><br>Calculating..</p></body></html>"
	//				  baseURL:nil];
}

-(IBAction)actionToday:(id)sender
{
	if (self.calcToday != nil && self.myWebView != nil)
	{
		[self setRecalculationPage];
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

-(IBAction)actionSettings:(id)sender
{
    if (self.setDlg1 == nil)
    {
        UIBarButtonItem * rbItem = [[UIBarButtonItem alloc] initWithTitle:@"Calendar"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(actionNormalView:)];

        // create nac controller and register in this controller
        SettingsViewTableController * settingsTable = [[SettingsViewTableController alloc] initWithStyle: UITableViewStyleGrouped];
        settingsTable.title = @"Display Settings";
        settingsTable.navigationItem.leftBarButtonItem = rbItem;
        settingsTable.tableView.rowHeight = 60;
        settingsTable.appDispSettings = self.theSettings;
        
        //settingsTable.navigationItem
        self.setDlg1 = [[UINavigationController alloc] initWithRootViewController:settingsTable];
        [settingsTable setNavigParent:self.setDlg1];
        
    }
    
	[self.setDlg1 viewWillAppear:YES];
	[self.mainView addSubview:self.setDlg1.view];
	[self.mainView bringSubviewToFront:self.setDlg1.view];
    self.setDlg1.view.frame = self.mainView.frame;
	[self.setDlg1 viewDidAppear:YES];
}

-(NSString *)firstCountryWithCode:(NSString *)code inContext:(NSManagedObjectContext *)ctx
{
	NSFetchRequest * freq = [[NSFetchRequest alloc] init];
	[freq setEntity:[NSEntityDescription entityForName:@"LGroup" inManagedObjectContext:ctx]];
	[freq setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"code = \"%@\"", code]]];
	[freq setSortDescriptors:nil];
	NSArray * tzones = [ctx executeFetchRequest:freq error:NULL];
	if (tzones != nil && [tzones count] > 0)
	{
		return (NSString *)[[tzones objectAtIndex:0] valueForKey:@"title"];
	}
	return @"";
}


-(void)setNewLocation:(NSManagedObject *)location
{
	BalaCalAppDelegate * deleg = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext * ctx = [deleg managedObjectContext];
	
	// set new location
	NSString * tzone = (NSString *)[location valueForKey:@"tzone"];
	NSString * parentCode = (NSString *)[location valueForKey:@"parentCode"];
	NSArray * parentCodeComponents = [parentCode componentsSeparatedByString:@"."];
	if ([parentCodeComponents count] > 0)
		parentCode = (NSString *)[parentCodeComponents objectAtIndex:0];
	
    GcLocation * locationData = [GcLocation new];
    
	locationData.city = [location valueForKey:@"title"];
	locationData.country = [self firstCountryWithCode:parentCode inContext:ctx];
	locationData.latitude = [[location valueForKey:@"latitude"] doubleValue];
	locationData.longitude = [[location valueForKey:@"longitude"] doubleValue];
	locationData.timeZone = [NSTimeZone timeZoneWithName:tzone];
	if (locationData.timeZone == nil)
		locationData.timeZone = [NSTimeZone systemTimeZone];
    
    BalaCalAppDelegate * appdelegate = (BalaCalAppDelegate *)[[UIApplication sharedApplication] delegate];

    [appdelegate setLocationData:locationData];

	/*NSFetchRequest * freq = [[[NSFetchRequest alloc] init] autorelease];
	[freq setEntity:[NSEntityDescription entityForName:@"LTimezone" inManagedObjectContext:ctx]];
	[freq setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"title = \"%@\"", tzone]]];
	[freq setSortDescriptors:nil];
	NSArray * tzones = [ctx executeFetchRequest:freq error:NULL];
	if (tzones != nil && [tzones count] > 0)
	{
		NSManagedObject * tzobj = (NSManagedObject *)[tzones objectAtIndex:0];
		myLocation.start_month = [[tzobj valueForKey:@"start_month"] intValue];
		myLocation.start_monthday = [[tzobj valueForKey:@"start_month_day"] intValue];
		myLocation.start_weekday = [[tzobj valueForKey:@"start_week_day"] intValue];
		myLocation.start_order   = [[tzobj valueForKey:@"start_month_week"] intValue];
		myLocation.end_month = [[tzobj valueForKey:@"end_month"] intValue];
		myLocation.end_monthday = [[tzobj valueForKey:@"end_month_day"] intValue];
		myLocation.end_weekday = [[tzobj valueForKey:@"end_week_day"] intValue];
		myLocation.end_order   = [[tzobj valueForKey:@"end_month_week"] intValue];
		//myLocation.tzone = [[tzobj valueForKey:@"offset"] intValue] / 60.0;
		//myLocation.bias  = [[tzobj valueForKey:@"bias"] intValue] / 60.0;
		//myLocation.timezoneName = [NSString stringWithFormat:@"%@ %@", 
								   //[gstrings GetTextTimeZone:myLocation.tzone], 
								   //[location valueForKey:@"tzone"]];
	}*/
	
	// close settings window
	[self performSelectorOnMainThread:@selector(actionNormalView:) withObject:nil waitUntilDone:NO];
}

@end
