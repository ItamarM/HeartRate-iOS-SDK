//
//  Results.h
//  Heartbeat
//
//  Created by michael leybovich on 10/8/13.
//  Copyright (c) 2013 michael leybovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

+ (NSArray *)allResults;
- (NSComparisonResult)compareByDate:(Result *)result;
- (NSComparisonResult)compareByBpm:(Result *)result;
- (NSComparisonResult)compareByDuration:(Result *)result;

- (void)deleteFromResults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int bpm;

@end
