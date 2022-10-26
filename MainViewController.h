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
@property GcResultToday * calcToday;
@property GCDisplaySettings * theSettings;

//@property GVChangeLocationIntro * locDlg1;
@property UINavigationController * setDlg1;
@property GpsViewController * gpsDlg1;
@property GVChangeLocationDlg * chlDlg1;

-(IBAction)actionToday:(id)sender;
-(IBAction)actionNormalView:(id)sender;

-(void)showDateSingle:(GCGregorianTime *)dateToShow;

@end
