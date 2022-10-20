//
//  MainViewController.h
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright 2010 GPSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>

@class GCStrings;
@class GcLocation;
@class GCEngine;
@class HUScrollView;
@class VUScrollView;
@class GcResultToday;
@class GCDisplaySettings;
@class DayResultsView;
@class GVChangeLocationIntro;
@class GVSelectFindMethod;
@class GpsViewController;
@class GVChangeLocationDlg;
@class GVHelpIntroViewController;
@class GCGregorianTime;

@interface MainViewController : UIViewController 
{
}

@property IBOutlet GCEngine * theEngine;
//@property IBOutlet HUScrollView * scrollViewH;
@property IBOutlet VUScrollView * scrollViewV;
@property IBOutlet UIScrollView * scrollViewD;
@property IBOutlet DayResultsView * dayView;
@property UIButton * nextDay;
@property UIButton * prevDay;
@property UIView * mainView;
@property IBOutlet WKWebView * myWebView;
@property GcResultToday * calcToday;
@property GCDisplaySettings * theSettings;

//@property GVChangeLocationIntro * locDlg1;
@property GVSelectFindMethod * findDlg1;
@property UINavigationController * setDlg1;
@property GpsViewController * gpsDlg1;
@property GVChangeLocationDlg * chlDlg1;
@property GVHelpIntroViewController * helpDlg;

-(IBAction)actionPrevDay:(id)sender;
-(IBAction)actionNextDay:(id)sender;
-(IBAction)actionToday:(id)sender;
-(IBAction)actionSettings:(id)sender;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(IBAction)onSettingsButton:(id)sender;
-(void)setNewLocation:(NSManagedObject *)location;
-(IBAction)actionNormalView:(id)sender;

-(void)setCurrentDay:(int)day month:(int)month year:(int)year;
-(void)releaseDialogs;
-(void)showDateSingle:(GCGregorianTime *)dateToShow;

// User actions
-(void)onShowDateChangeView;
-(void)onShowLocationDlg;
-(void)onShowGps;

@end
