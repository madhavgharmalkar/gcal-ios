//
//  GCTodayInfoData.m
//  GCAL
//
//  Created by Peter Kollath on 26/02/15.
//
//

#import "GCTodayInfoData.h"

@implementation GCTodayInfoData

-(instancetype)initWithCalendarDay:(GCCalendarDay *)calendarDay {
    if (self = [super init]) {
        _calendarDay = calendarDay;
    }
    
    return self;
}

@end
