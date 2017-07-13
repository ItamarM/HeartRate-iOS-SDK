//
//  Results.m
//  Heartbeat
//
//  Created by michael leybovich on 10/8/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import "Result.h"

@interface Result()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;

@end

@implementation Result

#define ALL_RESULTS_KEY @"Result_All"

#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define BPM_KEY @"bpm"


+ (NSArray *)allResults
{
    NSMutableArray *allResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        Result *result = [[Result alloc] initFromPropertyList:plist];
        [allResults addObject:result];
    }
    
    return allResults;
}

- (NSComparisonResult)compareByDate:(Result *)result
{
    return [result.end compare:self.end];
}

- (NSComparisonResult)compareByBpm:(Result *)result
{
    return [@(self.bpm) compare:@(result.bpm)];
}

- (NSComparisonResult)compareByDuration:(Result *)result
{
    return [@(self.duration) compare:@(result.duration)];
}



// convenience initializer
- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _bpm = [resultDictionary[BPM_KEY] intValue];
            
            if (!_start || !_end) self = nil;
        }
    }
    return self;
}

- (void)synchronize
{
    NSMutableDictionary *mutableResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableResultsFromUserDefaults)
        mutableResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    mutableResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)deleteFromResults
{
    NSMutableDictionary *mutableResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableResultsFromUserDefaults)
        mutableResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    [mutableResultsFromUserDefaults removeObjectForKey:[self.start description]];
    [[NSUserDefaults standardUserDefaults] setObject:mutableResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{ START_KEY : self.start, END_KEY : self.end, BPM_KEY : @(self.bpm) };
}

// designated initializer
- (id)init
{
    self = [super init];
    
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setBpm:(int)bpm
{
    _bpm = bpm;
    self.end = [NSDate date];
    [self synchronize];
}

@end
