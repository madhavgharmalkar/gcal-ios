//
//  BalaCalAppDelegate.h
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright GPSL 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainViewController.h"

@class DayResultsView;
@class HUScrollView, VUScrollView;
@class GCGregorianTime;
@class GCApplicationState;

@interface BalaCalAppDelegate : NSObject <UIApplicationDelegate> {
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic) IBOutlet UIWindow *window;
@property IBOutlet UIView * mainView;
//@property IBOutlet HUScrollView * scrollViewH;
@property IBOutlet UIScrollView * scrollViewD;
@property IBOutlet VUScrollView * scrollViewV;
@property IBOutlet DayResultsView * dayView;
@property IBOutlet UIView * menuBar;
@property (strong) NSMutableArray * defaultEvents;

@property (strong) MainViewController * mainViewCtrl;
@property (strong) NSString * lastNotificationDateTomorrow;
@property (strong) NSString * lastNotificationDateToday;
@property BOOL defaultsChangesPending;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
-(void)setGPS;

-(void)setViewMode:(NSInteger)sm;
-(void)showDate:(GCGregorianTime *)dateToShow;

// application state - we want to move all state to this object, that can be read here and in SwiftUI
@property (strong) GCApplicationState *applicationState;

@end

