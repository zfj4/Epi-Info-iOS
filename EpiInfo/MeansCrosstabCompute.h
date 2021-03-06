//
//  MeansCrosstabCompute.h
//  EpiInfo
//
//  Created by John Copeland on 9/11/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedResources.h"
#import "EpiInfoNumberFormatter.h"

@interface MeansCrosstabCompute : NSObject
+(NSArray *)doT:(NSArray *)tInputs;
+(NSArray *)doANOVA:(NSArray *)tInputs andKruakalWallisWithHorizontalFrequencies:(NSArray *)horizontalFrequencies AndVerticalFrequencies:(NSArray *)verticalFrequencies AndLocalFrequencies:(NSArray *)allLocalFrequencies AndRecordCount:(float)recordCount;
@end
