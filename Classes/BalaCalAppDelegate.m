//
//  BalaCalAppDelegate.m
//  BalaCal
//
//  Created by Peter Kollath on 8/7/10.
//  Copyright GPSL 2010. All rights reserved.
//

#import "BalaCalAppDelegate.h"
#import "MainViewController.h"
#import "GCStrings.h"
#import "GcLocation.h"
#import "HUScrollView.h"
#import "VUScrollView.h"
#import "GCGregorianTime.h"
#import "GCCalendarDay.h"
#import "GCTodayInfoData.h"
#import "DayResultsView.h"
#import "GCDisplaySettings.h"

#import "GCAL-Swift.h"

@implementation BalaCalAppDelegate

#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    self.defaultsChangesPending = NO;
    
    self.applicationState = [[GCApplicationState alloc] initWithAppDelegate:self];
    GCDisplaySettings *const displaySettings = self.applicationState.displaySettings;

    GCGregorianTime * dateToShow = [GCGregorianTime today];

    @try {
        UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotif) {
            NSString * itemName = [localNotif.userInfo objectForKey:@"action"];
            if ([itemName isEqualToString:@"ShowDate"])
            {
                NSString * date = [localNotif.userInfo objectForKey:@"date"];
                NSArray * cp = [date componentsSeparatedByString:@"."];
                if (cp.count == 3)
                {
                    dateToShow.year = [[cp objectAtIndex:0] intValue];
                    dateToShow.month = [[cp objectAtIndex:1] intValue];
                    dateToShow.day = [[cp objectAtIndex:2] intValue];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    self.mainViewCtrl = [[MainViewController alloc] init];
    
    UIViewController *swiftUiVc = [SwiftUIViewFactory makeSwiftUIView];
    self.window.rootViewController = swiftUiVc;
    self.mainViewCtrl.view.frame = self.mainView.frame;
    
    [self.window makeKeyAndVisible];

    self.mainViewCtrl.view = self.mainView;
    self.mainViewCtrl.scrollViewD = self.scrollViewD;
    self.mainViewCtrl.dayView = self.dayView;
    self.mainViewCtrl.scrollViewV = self.scrollViewV;
    self.mainViewCtrl.theSettings = displaySettings;
    self.mainViewCtrl.theEngine = self.applicationState.gcEngine;
    
    self.scrollViewV.engine = self.applicationState.gcEngine;
    self.dayView.engine = self.applicationState.gcEngine;
        
    CGFloat minn = MIN(self.mainView.frame.size.width, self.mainView.frame.size.height);
    CGRect oframe = self.mainViewCtrl.scrollViewV.frame;
    oframe.size.width = ceil((1 - (minn - 320)/1200.0)*minn);
    oframe.origin.x = (self.mainView.frame.size.width - oframe.size.width) / 2;
    self.mainViewCtrl.scrollViewV.frame = oframe;
    self.mainViewCtrl.scrollViewV.normalSubviewWidth = oframe.size.width;
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSInteger viewMode = [ud integerForKey:@"viewMode"];
    [self setViewMode:viewMode];

    [self showDate:dateToShow];
    [self applicationRegisterForLocalNotifications];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(userDefaultsChanged:) name:@"GCAL_resetFutureNotifications" object:nil];
    
    [self performSelector:@selector(generateFutureNotifications) withObject:nil afterDelay:0.1];
    //[self performSelectorInBackground:@selector(generateFutureNotifications) withObject:nil];
    //[self performSelector:@selector(scheduleNotificationWithItem:) withObject:@"Tomorrow is Ekadasi" afterDelay:2];
	return YES;
}

-(void)userDefaultsChanged:(NSNotification *)notification {
    [self resetFutureNotifications];
}

-(void)resetFutureNotifications
{
    self.defaultsChangesPending = YES;
    NSUserDefaults * udef = [NSUserDefaults standardUserDefaults];
    [udef setDouble:0.0 forKey:@"nextFutureCalc"];
    [udef synchronize];

    [self performSelector:@selector(generateFutureNotifications) withObject:nil afterDelay:0.1];
    //[self performSelectorInBackground:@selector(generateFutureNotifications) withObject:nil];
}

-(void)generateFutureNotifications{
    GCDisplaySettings *const displaySettings = self.applicationState.displaySettings;
    GCStrings *const gcStrings = self.applicationState.gcStrings;
    GCEngine *const gcEngine = self.applicationState.gcEngine;
    
    @try {
        NSUserDefaults * udef = [NSUserDefaults standardUserDefaults];
        NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval last = [udef doubleForKey:@"nextFutureCalc"];
        if (last > ti)
        {
            NSLog(@"Calculation for future is not necessary");
            return;
        }

//        NSArray * arr = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSMutableArray * ma = [NSMutableArray new];
//        for (UILocalNotification * ln in arr) {
//            NSLog(@"--- Notification: %@", ln.alertBody);
//            NSLog(@"    Date: %@", ln.fireDate);
//            NSLog(@"");
//        }
        
        GCGregorianTime * gc = [GCGregorianTime today];
        
        int julDay = [gc getJulianInteger];
        NSMutableString * str = [NSMutableString new];
        int type = 0;
        int julPage, julPageIndex;
        GCTodayInfoData * tid;
        NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        
        for(int i = 0; i < 30; i++)
        {
            julPage = julDay / 32;
            julPageIndex = julDay % 32;

            tid = [gcEngine requestPage:julPage view:nil itemIndex:julPageIndex];
            julDay++;
            [str setString:@""];
            type = 0;
        
            for (GcDayFestival * gdf in tid.calendarDay.festivals) {
                if (gdf.highlight > 0)
                {
                    type = 1;
                    //NSLog(@"%@ Festival %d: %@", [tid.calendarDay.date longDateString], gdf.highlight, gdf.name);
                    [str appendString:gdf.name];
                    [str appendString:@"\n"];
                }
            }
            if (type > 0 && displaySettings.note_fd_today)
            {
                UILocalNotification * note = [UILocalNotification new];
                //note.alertTitle = @"GCAL Break fast";
                note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                note.timeZone = [NSTimeZone defaultTimeZone];
                NSDateComponents * dc = [NSDateComponents new];
                GCGregorianTime * tt = tid.calendarDay.date;
                dc.timeZone = note.timeZone;
                dc.year = tt.year;
                dc.month = tt.month;
                dc.day = tt.day;
                dc.hour = tid.calendarDay.astrodata.sun.rise.hour;
                dc.minute = tid.calendarDay.astrodata.sun.rise.minute;
                note.fireDate = [calendar dateFromComponents:dc];
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"FestivalToday", @"GCALEvent", nil];
                note.userInfo = infoDict;
                note.alertAction = @"View Details";
                note.soundName = UILocalNotificationDefaultSoundName;
                [ma addObject:note];
            }
            if (type > 0 && displaySettings.note_fd_tomorrow)
            {
                UILocalNotification * note = [UILocalNotification new];
                //note.alertTitle = @"GCAL Break fast";
                note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                note.timeZone = [NSTimeZone defaultTimeZone];
                NSDateComponents * dc = [NSDateComponents new];
                GCGregorianTime * tt = tid.calendarDay.date;
                dc.timeZone = note.timeZone;
                dc.year = tt.year;
                dc.month = tt.month;
                dc.day = tt.day;
                dc.hour = 16;
                dc.minute = 0;
                note.fireDate = [[calendar dateFromComponents:dc] dateByAddingTimeInterval:-86400];
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"FestivalToday", @"GCALEvent", nil];
                note.userInfo = infoDict;
                note.alertAction = @"View Details";
                note.soundName = UILocalNotificationDefaultSoundName;
                [ma addObject:note];
            }
            
            if (tid.calendarDay.isEkadasiParana)
            {
                type = 3;
                //NSLog(@"%@ Parana: %@", tid.calendarDay.date.longDateString, [tid.calendarDay GetTextEP:self.gstrings]);
                [str appendString:[tid.calendarDay GetTextEP:gcStrings]];
                [str appendString:@"\n"];
                
                if (displaySettings.note_bf_today)
                {
                    UILocalNotification * note = [UILocalNotification new];
                    //note.alertTitle = @"GCAL Break fast";
                    note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                    note.timeZone = [NSTimeZone defaultTimeZone];
                    NSDateComponents * dc = [NSDateComponents new];
                    GCGregorianTime * tt = tid.calendarDay.date;
                    dc.timeZone = note.timeZone;
                    dc.year = tt.year;
                    dc.month = tt.month;
                    dc.day = tt.day;
                    dc.hour = (int)tid.calendarDay.hrEkadasiParanaStart;
                    dc.minute = (int)(tid.calendarDay.hrEkadasiParanaStart * 60) % 60;
                    note.fireDate = [calendar dateFromComponents:dc];
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"ParanaToday", @"GCALEvent", nil];
                    note.userInfo = infoDict;
                    note.alertAction = @"View Details";
                    note.soundName = UILocalNotificationDefaultSoundName;
                    [ma addObject:note];
                }
                if (displaySettings.note_bf_tomorrow)
                {
                    UILocalNotification * note = [UILocalNotification new];
                    //note.alertTitle = @"GCAL Break fast";
                    note.alertBody = [NSString stringWithFormat:@"%@, %@", tid.calendarDay.date.longDateString, str];
                    note.timeZone = [NSTimeZone defaultTimeZone];
                    NSDateComponents * dc = [NSDateComponents new];
                    GCGregorianTime * tt = tid.calendarDay.date;
                    dc.timeZone = note.timeZone;
                    dc.year = tt.year;
                    dc.month = tt.month;
                    dc.day = tt.day;
                    dc.hour = 19;
                    dc.minute = 0;
                    note.fireDate = [[calendar dateFromComponents:dc] dateByAddingTimeInterval:-86400];
                    //NSLog(@"fire date %@", note.fireDate);
                    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"ParanaTomorrow", @"GCALEvent", nil];
                    note.userInfo = infoDict;
                    note.alertAction = @"View Details";
                    note.soundName = UILocalNotificationDefaultSoundName;
                    note.hasAction = YES;
                    [ma addObject:note];
                }
            }
            
            

            
        }

        if (1)
        {
            julPage = julDay / 32;
            julPageIndex = julDay % 32;
            
            tid = [gcEngine requestPage:julPage view:nil itemIndex:julPageIndex];
            NSLog(@"Final notification scheduled for %@", [tid.calendarDay.date longDateString]);
            
            UILocalNotification * note = [UILocalNotification new];
            //note.alertTitle = @"GCAL Break fast";
            note.alertBody = @"Run Gaudiya Calendar to generate calendar notifications for next 30 days.";
            note.timeZone = [NSTimeZone defaultTimeZone];
            NSDateComponents * dc = [NSDateComponents new];
            GCGregorianTime * tt = tid.calendarDay.date;
            dc.timeZone = note.timeZone;
            dc.year = tt.year;
            dc.month = tt.month;
            dc.day = tt.day;
            dc.hour = 7;
            dc.minute = 0;
            note.fireDate = [calendar dateFromComponents:dc];
            //NSLog(@"fire date %@", note.fireDate);
            NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ShowDate", @"action", [NSString stringWithFormat:@"%d.%d.%d", tt.year, tt.month, tt.day], @"date", @"RunGCAL", @"GCALEvent", nil];
            note.userInfo = infoDict;
            note.alertAction = @"View Details";
            note.soundName = UILocalNotificationDefaultSoundName;
            note.hasAction = YES;
            [ma addObject:note];
        }
        
        double currNextValue = [udef doubleForKey:@"nextFutureCalc"];
        double proposedNextValue = [[NSDate date] timeIntervalSince1970] + 15*86400.0;
        if (currNextValue + 10 < proposedNextValue) {
            [udef setDouble:proposedNextValue forKey:@"nextFutureCalc"];
            [udef synchronize];
        }
        
        [[UIApplication sharedApplication] setScheduledLocalNotifications:ma];
        
    }
    @catch (NSException *exception) {
    }
    @finally {
        self.defaultsChangesPending = YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    GCDisplaySettings *const displaySettings = self.applicationState.displaySettings;
    [displaySettings writeToFile];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"");
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.mainViewCtrl actionToday:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    GCDisplaySettings *const displaySettings = self.applicationState.displaySettings;
    [displaySettings writeToFile];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    NSError *error = nil;
    if (managedObjectContext_ != nil)
    {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark -
#pragma mark OS Notification Center

- (void)applicationRegisterForLocalNotifications {
    UIApplication * app = [UIApplication sharedApplication];
    @try {
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            
            UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            
            [app registerUserNotificationSettings:mySettings];
            
//            self.lastNotificationDateTomorrow = @"";
//            self.lastNotificationDateToday = @"";
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *itemName = [notification.userInfo objectForKey:@"GCALEvent"];
    NSLog(@"In background ItemName: %@", itemName);
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil)
    {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"BalaCal" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
	NSLog(@"Path to DataContext: %@\n", modelURL);
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GCalLoc" ofType:@"sqlite"]];
	
#ifdef GCAL_DEBUG_BUILD_LOCATIONS
	NSFileManager * fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtURL:storeURL error:NULL];
#endif
	
    NSError *error = nil;
    NSDictionary * storeOptions = @{NSReadOnlyPersistentStoreOption : @YES};
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark - Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(void)setGPS {
	[self.mainViewCtrl actionNormalView:self];
//    if (self.scrollViewH.hidden == NO)
//        [self.scrollViewH reloadData];
    if (self.scrollViewD.hidden == NO)
        [self.dayView refreshDateAttachement];
    if (self.scrollViewV.hidden == NO)
        [self.scrollViewV reloadData];
    
    [self resetFutureNotifications];
}

-(void)setViewMode:(NSInteger)sm
{
    if (sm == 0)
    {
        self.mainViewCtrl.scrollViewD.hidden = NO;
        self.mainViewCtrl.scrollViewV.hidden = YES;
    }
    else if (sm == 1)
    {
        self.mainViewCtrl.scrollViewD.hidden = YES;
        self.mainViewCtrl.scrollViewV.hidden = NO;
    }
}

-(void)showDate:(GCGregorianTime *)dateToShow
{
//    if (!self.scrollViewH.hidden)
//        [self.scrollViewH showDate:dateToShow];
    if (!self.scrollViewD.hidden) {
        [self.mainViewCtrl showDateSingle:dateToShow];
    }
    if (!self.scrollViewV.hidden)
        [self.scrollViewV showDate:dateToShow];

}

@end

