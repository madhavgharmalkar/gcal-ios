//
//  GcResultToday.m
//  gcal
//
//  Created by Gopal on 21.2.2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GcResultToday.h"
#import "gc_func.h"
#import "GcDayFestival.h"
#import "GCGregorianTime.h"

@implementation GcResultToday


-(void)recalc
{
	[self calcDate:self.current];
}

-(GCDisplaySettings *)disp
{
	return disp;
}

-(void)calcDate:(GCGregorianTime *)vc
{
	self.current = vc;
    GCGregorianTime * vc2 = [vc addDays:-9];
	
	[_calend CalculateCalendar:vc2 count:19];
		
}

-(void)setDay:(GCGregorianTime *)vc
{
	if ([_calend FindDate:vc] >= 0)
	{
		self.current = vc;
	}
	else
	{
		[self calcDate:vc];
	}
}

-(void)setNextDay
{
	GCGregorianTime * vc2 = [self.current nextDay];
	
	if ([_calend FindDate:vc2] < 0)
	{
		[self calcDate:vc2];
	}
	else {
		self.current = vc2;
	}

}

-(void)setPrevDay
{
	GCGregorianTime * vc2 = [self.current previousDay];
	
	if ([_calend FindDate:vc2] < 0)
	{
		[self calcDate:vc2];
	}
	else {
		self.current = vc2;
	}
}

-(NSString *)formatTodayText
{
	NSString * str2, * str3;

	NSMutableString * str = [[NSMutableString alloc] init];
	
	//int nFestClass;
	int i = [_calend FindDate:self.current];
	if (i < 0) return @"";
	
	GCCalendarDay * p = [_calend dayAtIndex:i];
	if (!p) return @"";
	
	[str appendFormat:@"%@ [%@]\r\n\r\n[%@]\r\n  %@, %@ %@\r\n  %@ %@, %d Gaurabda\r\n\r\n",
				[_myLocation city], [_myLocation country], [self.current longDateString],
				[_gstr GetTithiName:p.astrodata.nTithi], [_gstr GetPaksaName:p.astrodata.nPaksa],
				[_gstr string:20],
				[_gstr GetMasaName:p.astrodata.nMasa], [_gstr string:22], p.astrodata.nGaurabdaYear];
	
	if (p.isEkadasiParana)
	{
		[str appendFormat:@"%@\n", [p GetTextEP:_gstr]];
	}
	
	// adding mahadvadasi
	// adding spec festivals
	
	if (p.festivals && [p.festivals count] > 0)
	{
		for(GcDayFestival * pdf in p.festivals)
		{
			if (pdf.group < 0 || [disp canShowFestivalClass:pdf.group])
			{
				[str appendFormat:@"   %@\n", pdf.name];
			}
		}
	}
	
	[str appendFormat:@"\n"];
	
	if (disp.sankranti && p.sankranti_zodiac >= 0)
	{
		//double h1, m1;
		//m1 = modf(p->sankranti_day.shour*24, &h1);
		[str appendFormat:@"---------- %@ %@ (%@ %@ %@ %d %@, %@ %@) ----------"
					, [_gstr GetSankrantiName:p.sankranti_zodiac]
					, [_gstr string:56]
					, [_gstr string:111]
					, [_gstr GetSankrantiNameEn:p.sankranti_zodiac]
					, [_gstr string:852]
					, p.sankranti_day.day, [_gstr GetMonthAbr:p.sankranti_day.month]
					, [p.sankranti_day shortTimeString]
					, [_gstr GetDSTSignature:p.nDST]];
	}
	
	if (disp.ksaya && p.was_ksaya)//(m_dshow.m_info_ksaya) && (pvd->was_ksaya))
	{
		GCGregorianTime * dd = [p.date copy];
		if (p.ksaya_day1 < 0.0) dd = [dd previousDay];
		str2 = [NSString stringWithFormat:@"%d %@, %@", dd.day
				, [_gstr GetMonthAbr:dd.month]
				, [_gstr hoursToString:p.ksaya_time1*24]];
		
		//				if (pvd->ksaya_time2 < 0.0)
		//					m = modf(fabs(1.0 + pvd->ksaya_time2)*24, &h);
		//				else
		dd = [p.date copy];
		if (p.ksaya_day2 < 0.0)
			dd = [dd previousDay];
		str3 = [NSString stringWithFormat:@"%d %@, %@", dd.day
				, [_gstr GetMonthAbr:dd.month]
				, [_gstr hoursToString:p.ksaya_time2*24]];
		
		[str appendFormat:@"%@ %@ %@ %@ %@ (%@)\n"
			, [_gstr string:89], [_gstr string:850]
			, str2, [_gstr string:851], str3, [_gstr GetDSTSignature:p.nDST]];
	}
	// adding fasting
	if (disp.vriddhi && p.is_vriddhi)
	{
		[str appendFormat:@"%@", [_gstr string:90]];
		[str appendFormat:@"\n"];
	}
	
	
	if (p.nCaturmasya & CMASYA_PURN_MASK)
	{
		[str appendFormat:@"%@ [PURNIMA SYSTEM]\n"
					, [_gstr string:107 + (p.nCaturmasya & CMASYA_PURN_MASK_DAY)
						   + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]];
		if ((p.nCaturmasya & CMASYA_PURN_MASK_DAY) == 0x1)
		{
			[str appendFormat:@"%@", [_gstr string:110 + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]];
		}
	}
	
	if (p.nCaturmasya & CMASYA_PRAT_MASK)
	{
		[str appendFormat:@"%@ [PRATIPAT SYSTEM]\n"
					, [_gstr string:107 + ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8)
						   + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]];
		if ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) == 0x100)
		{
			[str appendFormat:@"%@", [_gstr string:110 + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]];
		}
	}
	
	if (p.nCaturmasya & CMASYA_EKAD_MASK)
	{
		[str appendFormat:@"%@ [EKADASI SYSTEM]\r\n"
					, [_gstr string:107 + ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16)
						   + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]
					];
		if ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) == 0x10000)
		{
			[str appendFormat:@"%@", [_gstr string:110 + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]];
		}
	}
	[str appendFormat:@"\n"];
	// tithi at arunodaya
	if (disp.arun_tithi)//m_dshow.m_tithi_arun)
	{
		[str appendFormat:@"%@: %@\n", [_gstr string:98], [_gstr GetTithiName:p.astrodata.nTithiArunodaya]];
	}
	
	//"Arunodaya Time",//1
	if (disp.arunodaya)//m_dshow.m_arunodaya)
	{
		[str appendFormat:@"%@ %d:%02d (%@)\n", [_gstr string:99], p.astrodata.sun.arunodaya.hour
					, p.astrodata.sun.arunodaya.minute, [_gstr GetDSTSignature:p.nDST]];
	}
	
	//"Moonrise Time",//4
	if (disp.moonrise)
	{
		if (p.moonrise.hour < 0)
		{
			[str appendFormat:@"%@", [_gstr string:136]];
		}
		else
		{
			[str appendFormat:@"%@ %d:%02d (%@)", [_gstr string:53], p.moonrise.hour
						, p.moonrise.minute, [_gstr GetDSTSignature:p.nDST]];
		}
		[str appendFormat:@"\n"];
	}
	//"Moonset Time",//5
	if (disp.moonset)
	{
		if (p.moonrise.hour < 0)
			[str appendFormat:@"%@", [_gstr string:137]];
		else
		{
			[str appendFormat:@"%@ %d:%02d (%@)", [_gstr string:54], p.moonset.hour
						, p.moonset.minute, [_gstr GetDSTSignature:p.nDST]];
		}
		[str appendFormat:@"\n"];
	}
	///"Sun Longitude",//9
	if (disp.sun_long)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@: %f (*)\n", [_gstr string:100], p.astrodata.sun.longitude_deg];
	}
	//"Moon Longitude",//10
	if (disp.moon_long)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@: %f (*)\r\n", [_gstr string:101], p.astrodata.moon.longitude_deg];
	}
	//"Ayanamsha value",//11
	if (disp.ayanamsa)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@ %f (%@) (*)\r\n", [_gstr string:102], p.astrodata.msAyanamsa, GetAyanamsaName(GetAyanamsaType())];
	}
	//"Julian Day",//12
	if (disp.julian)//m_dshow.m_sun_long)
	{
		[str appendFormat:@"%@ %f (*)\r\n", [_gstr string:103], p.astrodata.jdate];
	}
	
	[str appendFormat:@"\r\n%@ %d:%02d %@, %@: %@, %@: %@, %@: %@.\r\n",
			[_gstr string:51],
			p.astrodata.sun.rise.hour, p.astrodata.sun.rise.minute, 
			[_gstr GetDSTSignature:p.nDST],
			[_gstr string:15], [_gstr GetNaksatraName:p.astrodata.nNaksatra],
			[_gstr string:104], [_gstr GetYogaName:p.astrodata.nYoga],
			[_gstr string:105], [_gstr GetSankrantiName:p.astrodata.nRasi]];
	[str appendFormat:@"%@ %d:%02d %@\r\n", [_gstr string:52], p.astrodata.sun.set.hour, p.astrodata.sun.set.minute
		, [_gstr GetDSTSignature:p.nDST]];
	
	return str;
}

-(void)calcAllTithis:(GCGregorianTime *)dayA
{
	GCGregorianTime * dayB = [dayA copy];
	dayB.shour = 0.0;
		
    GCGregorianTime * ct = [dayB copy];
    
	ab = GetPrevTithiStart([_myLocation getEarth], ct, &ct);
    self.titA = [ct copy];
    ct.shour += 0.3;
    [ct normalize];

    bc = GetNextTithiStart([_myLocation getEarth], ct, &ct);
    self.titB = [ct copy];
    ct.shour += 0.3;
    [ct normalize];

    cd = GetNextTithiStart([_myLocation getEarth], ct, &ct);
    self.titC = [ct copy];
    ct.shour += 0.3;
    [ct normalize];
	GetNextTithiStart([_myLocation getEarth], ct, &ct);
    self.titD = [ct copy];

    ct = [dayB copy];
	nak_ab = GetPrevNaksatra([_myLocation getEarth], ct, &ct);
    self.nakA = [ct copy];

    ct.shour += 0.3;
    [ct normalize];
	nak_bc = GetNextNaksatra([_myLocation getEarth], ct, &ct);
	self.nakB = [ct copy];
    
    ct.shour += 0.3;
    [ct normalize];
	nak_cd = GetNextNaksatra([_myLocation getEarth], ct, &ct);
	self.nakC = [ct copy];
    
    ct.shour += 0.3;
    [ct normalize];
	GetNextNaksatra([_myLocation getEarth], ct, &ct);
    self.nakD = [ct copy];
	
	
	double bs = [_myLocation daytimeBiasForDate:self.titB];
	timeInDST = 0;
	if (fabs(bs) > 0.01)
	{
		timeInDST = 1;
        [self.titA addDayHours:bs];
        [self.titB addDayHours:bs];
        [self.titC addDayHours:bs];
        [self.titD addDayHours:bs];

        [self.nakA addDayHours:bs];
        [self.nakB addDayHours:bs];
        [self.nakC addDayHours:bs];
        [self.nakD addDayHours:bs];
	}
}

-(NSString *)formatInitialHtml
{
	NSMutableString * f = [[NSMutableString alloc] init];
	
	GCGregorianTime * gc = [GCGregorianTime today];
	
	[f appendFormat:@"<html>\n<head>\n<title></title>"];
	[f appendFormat:@"<style>\n"];
	[_gstr addHtmlStylesDef:f display:disp];
	[f appendFormat:@"\n</style>\n"];
	[f appendFormat:@"</head>\n"];
	[f appendFormat:@"<body bgcolor=%@>\n", disp.bkgColor];
	[f appendFormat:@"<p class=SectionHead style='text-align:left'><span class=SectionHead1><b>%@</b>  %@</span><br><b>%@</b><br>\n", 
	 [gc longDateString], [gc relativeTodayString],
	 [_gstr string:gc.dayOfWeek]];
	[f appendFormat:@"<span class=SectionHead2>%@<br>%@ %@</span></p>\n", [_myLocation fullName],
	 [_myLocation.timeZone abbreviationForDate:[_myLocation dateFromGcTime:gc]],
	 [_myLocation.timeZone name]];
	[f appendFormat:@"<hr><p><b>Application is calculating current day. Please wait a moment.</b></p>"];

	return f;
}

-(NSString *)resolveSpecialEkadasiMessage:(GCCalendarDay *)p
{
	NSString * msgSuitable = @"(suitable for fasting)<br>";
	NSString * msgNonSuitable = @"(not suitable for fasting)<br>";
	if (p.astrodata.nTithi == 10 || p.astrodata.nTithi == 25)
	{
		return (p.nFastType == FAST_EKADASI) ? msgSuitable : msgNonSuitable
			;
	}
	else if ((p.astrodata.nTithi == 11 || p.astrodata.nTithi == 26) && p.nFastType == FAST_EKADASI)
	{
		return msgSuitable;
	}
	
	return @"";
}

-(NSString *)formatTodayHtml
{
	//NSString * str2, * str3, * str4;
	
	int i = [_calend FindDate:self.current];
	if (i < 0) return @"";
	
	GCCalendarDay * p = [_calend dayAtIndex:i];
	
	if (!p) return @"";
	
	// calc all tithis
	[self calcAllTithis:self.current];
	
	
	NSMutableString * f = [[NSMutableString alloc] init];
	
	[f appendFormat:@"<html>\n<head>\n<title></title>"];
	[f appendFormat:@"<style>\n"];
	[_gstr addHtmlStylesDef:f display:disp];
	[f appendFormat:@"\n</style>\n"];
	[f appendFormat:@"</head>\n"];
	[f appendFormat:@"<body bgcolor=%@>\n", disp.bkgColor];
	[f appendFormat:@"<p class=SectionHead style='text-align:left'><span class=SectionHead1><b>%@</b>  %@</span><br><b>%@</b><br>\n", 
		[self.current longDateString], [self.current relativeTodayString],
		[_gstr string:self.current.dayOfWeek]];
	[f appendFormat:@"<span class=SectionHead2>%@<br>%@ %@</span></p>\n", [_myLocation fullName],
	 [_myLocation.timeZone abbreviationForDate:[_myLocation dateFromGcTime:p.date]], [_myLocation.timeZone name]];
	[f appendFormat:@"<hr><p><span class=GaurHead>  %@, %@ %@</span><br><span class=GaurSubhead>%@  %@ %@, %d Gaurabda</span></p>",
			[_gstr GetTithiName:p.astrodata.nTithi], [_gstr GetPaksaName:p.astrodata.nPaksa], [_gstr string:20],
	 [self resolveSpecialEkadasiMessage:p],
			[_gstr GetMasaName:p.astrodata.nMasa], [_gstr string:22], p.astrodata.nGaurabdaYear];
	
	int prevCountFest = 0;
	
	if (p.isEkadasiParana)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"<span style=\'color:%@;font-weight:bold\'>%@</span>", 
		 disp.specialTextColor, [p GetTextEP:_gstr]];
		prevCountFest++;
	}
	
	// adding mahadvadasi
	// adding spec festivals
	
	if ([p.festivals count] > 0)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		for(GcDayFestival * pdf in p.festivals)
		{
			//if (pdf.group < 0 || [disp canShowFestivalClass:pdf.group])
			{
				if (prevCountFest > 0)
					[f appendFormat:@"<br>"];
				[f appendFormat:@"%@", pdf.name];
				prevCountFest++;
			}
		}
	}
	
	
	if (disp.sankranti && p.sankranti_zodiac >= 0)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		//double h1, m1;
		//m1 = modf(p.sankranti_day.shour*24, &h1];
		[f appendFormat:@"<span style=\'color:%@\'>%@ %@ (%@ %@ %@ %d %@, %@ %@)</span>"
				, disp.specialTextColor
				, [_gstr GetSankrantiName:p.sankranti_zodiac]
				, [_gstr string:56]
				, [_gstr string:111], [_gstr GetSankrantiNameEn:p.sankranti_zodiac]
				, [_gstr string:852]
				, p.sankranti_day.day, [_gstr GetMonthAbr:p.sankranti_day.month]
				, [p.sankranti_day shortTimeString]
				, [_gstr GetDSTSignature:p.nDST]];
		prevCountFest++;
	}
	
	if (disp.ksaya && p.was_ksaya)//(m_dshow.m_info_ksaya) && (pvd->was_ksaya))
	{
		GCGregorianTime * dd;
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		dd = p.date;
		if (p.ksaya_day1 < 0.0) dd = [dd previousDay];
		[f appendFormat:@"%@ %@ ", [_gstr string:89], [_gstr string:850]];
		[f appendFormat:@"%d %@, %@ ", dd.day, [_gstr GetMonthAbr:dd.month], [_gstr hoursToString:(p.ksaya_time1*24)]];
		dd = p.date;
		if (p.ksaya_day2 < 0.0) dd = [dd previousDay];
		[f appendFormat:@"%@ %d %@, %@", [_gstr string:851],
				dd.day, [_gstr GetMonthAbr:dd.month], [_gstr hoursToString:(p.ksaya_time2*24)]];
		[f appendFormat:@"(%@)", [_gstr GetDSTSignature:p.nDST]];
		prevCountFest++;
	}
	
	if (disp.vriddhi && p.is_vriddhi)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"%@", [_gstr string:90]];
		prevCountFest++;
	}
	
	
	if ((p.nCaturmasya & CMASYA_PURN_MASK) && disp.caturmasya == 0)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br><br>"];
		[f appendFormat:@"%@ [PURNIMA SYSTEM]"
				, [_gstr string:107 + (p.nCaturmasya & CMASYA_PURN_MASK_DAY)
					   + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]
				];
		if ((p.nCaturmasya & CMASYA_PURN_MASK_DAY) == 0x1)
		{
			[f appendFormat:@"<br>"];
			[f appendFormat:@"%@", [_gstr string:110 + ((p.nCaturmasya & CMASYA_PURN_MASK_MASA) >> 2)]];
		}
		[f appendFormat:@"<br>"];
		prevCountFest++;
	}
	
	if ((p.nCaturmasya & CMASYA_PRAT_MASK) && disp.caturmasya == 1)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br><br>"];
		[f appendFormat:@"%@ [PRATIPAT SYSTEM]"
				, [_gstr string:107 + ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) >> 8)
					   + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]
				];
		if ((p.nCaturmasya & CMASYA_PRAT_MASK_DAY) == 0x100)
		{
			[f appendFormat:@"<br>"];
			[f appendFormat:@"%@", [_gstr string:110 + ((p.nCaturmasya & CMASYA_PRAT_MASK_MASA) >> 10)]];
		}
		[f appendFormat:@"</br>"];
		prevCountFest++;
	}
	
	if ((p.nCaturmasya & CMASYA_EKAD_MASK) && disp.caturmasya == 2)
	{
		if (prevCountFest == 0)
			[f appendFormat:@"<table style=\'border-width:1pt;border-color:black;border-style:solid\'><tr><td style=\'font-size:9pt;background:%@;padding-left:25pt;padding-right:35pt;padding-top:15pt;padding-bottom:15pt;vertical-align:center\'>\n", [p getHtmlDayBackground]];
		else
			[f appendFormat:@"<br><br>"];
		[f appendFormat:@"%@ [EKADASI SYSTEM]"
				, [_gstr string:107 + ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) >> 16)
					   + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]
				];
		if ((p.nCaturmasya & CMASYA_EKAD_MASK_DAY) == 0x10000)
		{
			[f appendFormat:@"<br>"];
			[f appendFormat:@"%@", [_gstr string:110 + ((p.nCaturmasya & CMASYA_EKAD_MASK_MASA) >> 18)]];
		}
		[f appendFormat:@"<br>"];
		prevCountFest++;
	}
	
	if (prevCountFest > 0)
		[f appendFormat:@"</td></tr></table>\n"];
	
	[f appendFormat:@"<p>"];
	// tithi at arunodaya
	if (disp.arun_tithi)//m_dshow.m_tithi_arun)
	{
		[f appendFormat:@"<br>%@: %@", [_gstr string:98], [_gstr GetTithiName:p.astrodata.nTithiArunodaya]];
	}
	
	//"Arunodaya Time",//1
	if (disp.arunodaya)//m_dshow.m_arunodaya)
	{
		[f appendFormat:@"<br>%@ %d:%02d (%@)\r\n", [_gstr string:99], p.astrodata.sun.arunodaya.hour
				, p.astrodata.sun.arunodaya.minute, [_gstr GetDSTSignature:p.nDST]];
	}
	
	//"Moonrise Time",//4
	if (disp.moonrise)
	{
		[f appendFormat:@"<br>"];
		if (p.moonrise.hour < 0)
			[f appendFormat:@"%@", [_gstr string:136]];
		else
		{
			[f appendFormat:@"%@ %d:%02d (%@)", [_gstr string:53], p.moonrise.hour
					, p.moonrise.minute, [_gstr GetDSTSignature:p.nDST]];
		}
	}
	//"Moonset Time",//5
	if (disp.moonset)
	{
		if (disp.moonrise)
			[f appendFormat:@"&nbsp;&nbsp;&nbsp;"];
		else
			[f appendFormat:@"<br>"];
		if (p.moonrise.hour < 0)
			[f appendFormat:@"%@", [_gstr string:137]];
		else
		{
			[f appendFormat:@"%@ %d:%02d (%@)", [_gstr string:54], p.moonset.hour
					, p.moonset.minute, [_gstr GetDSTSignature:p.nDST]];
		}
	}
	///"Sun Longitude",//9
	if (disp.sun_long)//m_dshow.m_sun_long)
	{
		[f appendFormat:@"<br>%@: %f (*)\r\n", [_gstr string:100], p.astrodata.sun.longitude_deg];
	}
	//"Moon Longitude",//10
	if (disp.moon_long)//m_dshow.m_sun_long)
	{
		if (disp.sun_long)
			[f appendFormat:@", "];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"%@: %f (*)\r\n", [_gstr string:101], p.astrodata.moon.longitude_deg];
	}
	//"Ayanamsha value",//11
	if (disp.ayanamsa)//m_dshow.m_sun_long)
	{
		if (disp.sun_long || disp.moon_long)
			[f appendFormat:@", "];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"<br>%@ %f (%@) (*)\r\n", [_gstr string:102], p.astrodata.msAyanamsa, GetAyanamsaName(GetAyanamsaType())];
	}
	//"Julian Day",//12
	if (disp.julian)//m_dshow.m_sun_long)
	{
		if (disp.sun_long || disp.moon_long || disp.ayanamsa)
			[f appendFormat:@", "];
		else
			[f appendFormat:@"<br>"];
		[f appendFormat:@"<br>%@ %f (*)\r\n", [_gstr string:103], p.astrodata.jdate];
	}
	
	/*BEGIN GCAL 1.4.3*/
	gc_daytime tdA, tdB;
	
	if (disp.t_brahma)
	{
		tdA = p.astrodata.sun.rise;
		tdB = p.astrodata.sun.rise;
		gc_daytime_sub_minutes(&tdA, 96);
		gc_daytime_sub_minutes(&tdB, 48);
		[f appendFormat:@"<p><b>Brahma-muhurta</b> %2d:%02d - %2d:%02d</p>",
			 tdA.hour, tdA.minute, tdB.hour, tdB.minute];
	}

	[f appendFormat:@"<table border=0 cellpadding=0 width='100%%'><tr>"];
	if (disp.t_sunrise)
	{
		[f appendFormat:@"<td class=hed><p>%@<br> <span style='font-size:%@'>%2d:%02d</span></td> ",
				[_gstr string:51], disp.h2textSize, p.astrodata.sun.rise.hour, p.astrodata.sun.rise.minute ];
	}
	if (disp.t_noon)
	{
		[f appendFormat:@"<td class=hed><p>%@<br><span style='font-size:%@'>%2d:%02d</span></td>", 
		 [_gstr string:857], disp.h2textSize, p.astrodata.sun.noon.hour, p.astrodata.sun.noon.minute];
	}
	if (disp.t_sunset)
	{
		[f appendFormat:@"<td class=hed><p>%@<br><span style='font-size:%@'>%2d:%02d</span></td>", 
		[_gstr string:52], disp.h2textSize, p.astrodata.sun.set.hour, p.astrodata.sun.set.minute];
	}
	[f appendFormat:@"</tr>"];
	if (disp.t_sandhya)
	{
		[f appendFormat:@"<tr>"];
		if (disp.t_sunrise)
		{
			tdA = p.astrodata.sun.rise;
			tdB = p.astrodata.sun.rise;
			gc_daytime_sub_minutes(&tdA, 24);
			gc_daytime_add_minutes(&tdB, 24);
			[f appendFormat:@"<td class=hed2>sandhya<br><b>%2d:%02d - %2d:%02d</b></td>", tdA.hour, tdA.minute, tdB.hour, tdB.minute];
		}
		if (disp.t_noon)
		{
			tdA = p.astrodata.sun.noon;
			tdB = p.astrodata.sun.noon;
			gc_daytime_sub_minutes(&tdA, 24);
			gc_daytime_add_minutes(&tdB, 24);
			[f appendFormat:@"<td class=hed2>sandhya<br><b>%2d:%02d - %2d:%02d</b></td>", tdA.hour, tdA.minute, tdB.hour, tdB.minute];
		}
		if (disp.t_sunset)
		{
			tdA = p.astrodata.sun.set;
			tdB = p.astrodata.sun.set;
			gc_daytime_sub_minutes(&tdA, 24);
			gc_daytime_add_minutes(&tdB, 24);
			[f appendFormat:@"<td class=hed2>sandhya<br><b>%2d:%02d - %2d:%02d</b></td>", tdA.hour, tdA.minute, tdB.hour, tdB.minute];
		}
		[f appendFormat:@"</tr>"];
	}
	[f appendFormat:@"</table>"];

	
	if (disp.t_riseinfo)
	{
		[f appendFormat:@"<p><b>%@ info</b><br>Moon in the %@ %@, %@ %@, Sun in the %@ %@.</p>",
				[_gstr string:51],
				[_gstr GetNaksatraName:p.astrodata.nNaksatra], [_gstr string:15],
				[_gstr GetYogaName:p.astrodata.nYoga], [_gstr string:104],
				[_gstr GetSankrantiName:p.astrodata.nRasi], [_gstr string:105]];
	}
	
	if (disp.t_det_tithi)
	{
		[f appendFormat:@"<p><b>Tithi Details</b> (%@)<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@</p>",
		 [_myLocation timeNameForDate:self.titA],
		 [_gstr GetTithiName:ab],
		 [self.titA shortDateString], [self.titA shortTimeString],
		 [self.titB shortDateString], [self.titB shortTimeString],
		 [_gstr GetTithiName:bc],
         [self.titB shortDateString], [self.titB shortTimeString],
         [self.titC shortDateString], [self.titC shortTimeString],
		 [_gstr GetTithiName:cd],
         [self.titC shortDateString], [self.titC shortTimeString],
         [self.titD shortDateString], [self.titD shortTimeString]
		 ];
	}

	if (disp.t_det_naksatra)
	{
		[f appendFormat:@"<p><b>Naksatra Details</b> (%@)<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@"
		 "<br>%@ %@, %@ - %@, %@</p>",
		 [_myLocation timeNameForDate:self.nakA],
		 [_gstr GetNaksatraName:nak_ab],
         [self.nakA shortDateString], [self.nakA shortTimeString],
         [self.nakB shortDateString], [self.nakB shortTimeString],
		 [_gstr GetNaksatraName:nak_bc],
         [self.nakB shortDateString], [self.nakB shortTimeString],
         [self.nakC shortDateString], [self.nakC shortTimeString],
		 [_gstr GetNaksatraName:nak_cd],
         [self.nakC shortDateString], [self.nakC shortTimeString],
         [self.nakD shortDateString], [self.nakD shortTimeString]
		 ];
	}
	
	[f appendFormat:@"<hr>"];
	[f appendFormat:@"<p style='font-size:8.0pt'>%@"
//	    "<b>NOTE</b>: To change location, click on 'Current"
//		" Location' button in the toolbar. Select location and click on 'Accept' button."
//		"<br>For configuration of this page, go to Menu -&gt; Settings -&gt; Today "
//		"Display Settings."
		"<br>Generated by %@</p>", [_myLocation.timeZone description], [_gstr string:131]];
	[f appendFormat:@"</body>"];
	[f appendFormat:@"</html>"];
	/* END GCAL 1.4.3 */
	
	return f;
}

@end
