//
//  AnalysisDataObject.h
//  EpiInfo
//
//  Created by labuser on 6/24/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "sqlite3.h"
#import <Foundation/Foundation.h>

@interface AnalysisDataObject : NSObject
{
    sqlite3 *epiinfoDB;
}
@property (nonatomic, strong) NSDictionary *dataDefinitions;
@property (nonatomic, strong) NSDictionary *columnNames;
@property (nonatomic, strong) NSDictionary *dataTypes;
@property (nonatomic, strong) NSDictionary *isBinary;
@property (nonatomic, strong) NSDictionary *isOneZero;
@property (nonatomic, strong) NSDictionary *isYesNo;
@property (nonatomic, strong) NSDictionary *isTrueFalse;
@property (nonatomic, strong) NSArray *dataSet;

-(id)initWithAnalysisDataObject:(AnalysisDataObject *)analysisDataObject;
-(id)initWithCSVFile:(NSString *)pathAndFileName;
-(id)initWithStoredDataTable:(NSString *)tableName;
-(id)initWithVariablesArray:(NSMutableArray *)variables AndDataArray:(NSMutableArray *)data;
@end
