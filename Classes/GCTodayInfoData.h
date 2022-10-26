//
//  GCTodayInfoData.h
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import <Foundation/Foundation.h>
@class GCCalendarDay;

@interface GCTodayInfoData : NSObject {
}

@property(strong) GCCalendarDay *calendarDay;

- (instancetype)initWithCalendarDay:(GCCalendarDay *)calendarDay;


@end
