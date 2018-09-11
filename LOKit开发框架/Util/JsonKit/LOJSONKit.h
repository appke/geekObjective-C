//
//  LOJSONKit.h
//  Foundation
//
//  Created by Keldon on 16-6-7.
//  Copyright (c) 2014年 Keldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(JSONCategories)

+(NSString *)stringFromJSONData:(NSData *)jsonData;
+(NSString *)stringFromJSONData:(NSData *)jsonData options:(NSJSONReadingOptions)opt error:(NSError **)error;

-(NSData *)toJSON;
-(NSData *)toJSONWithoptions:(NSJSONWritingOptions)opt error:(NSError **)error;

-(NSArray *)arrayFromJSONString;
-(NSDictionary *)dictionaryFromJSONString;

@end

@interface NSArray(JSONCategories)

+(NSArray *)arrayFromJSONData:(NSData *)jsonData;
+(NSArray *)arrayFromJSONData:(NSData *)jsonData options:(NSJSONReadingOptions)opt error:(NSError **)error;

-(NSData *)toJSON;
-(NSData *)toJSONWithoptions:(NSJSONWritingOptions)opt error:(NSError **)error;

-(NSString *)JSONString;

@end

@interface NSDictionary(JSONCategories)

+(NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData;
+(NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData options:(NSJSONReadingOptions)opt error:(NSError **)error;

-(NSData *)toJSON;
-(NSData *)toJSONWithoptions:(NSJSONWritingOptions)opt error:(NSError **)error;

-(NSString *)JSONString;

@end

