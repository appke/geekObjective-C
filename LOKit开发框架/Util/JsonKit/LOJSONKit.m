//
//  LOJSONKit.m
//  Foundation
//
//  Created by Keldon on 16-6-7.
//  Copyright (c) 2014年 Keldon. All rights reserved.
//

#import "LOJSONKit.h"

@implementation NSString(JSONCategories)

+(NSString *)stringFromJSONData:(NSData *)jsonData
{
    
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
    
}

+(NSString *)stringFromJSONData:(NSData *)jsonData options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:opt error:error];
    if (error != nil) return nil;
    return result;
}

-(NSData *)toJSON
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError* error = nil;
        id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) return nil;
        return result;
    }else{
        return [self dataUsingEncoding:NSUTF8StringEncoding];
    }
}

-(NSData *)toJSONWithoptions:(NSJSONWritingOptions)opt error:(NSError **)error
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        id result = [NSJSONSerialization dataWithJSONObject:self options:opt error:error];
        if (error != nil) return nil;
        return result;
    }else{
        return nil;
    }
}

-(NSArray *)arrayFromJSONString
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return  [NSArray arrayFromJSONData:data];
}

-(NSDictionary *)dictionaryFromJSONString
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return  [NSDictionary dictionaryFromJSONData:data];
}

@end

@implementation NSArray(JSONCategories)

+(NSArray *)arrayFromJSONData:(NSData *)jsonData
{
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
+(NSArray *)arrayFromJSONData:(NSData *)jsonData options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:opt error:error];
    if (error != nil) return nil;
    return result;
}

-(NSData *)toJSON
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError* error = nil;
        id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) return nil;
        return result;
    }else{
        return nil;//-.[NSKeyedArchiver archivedDataWithRootObject:self];
    }
}

-(NSData *)toJSONWithoptions:(NSJSONWritingOptions)opt error:(NSError **)error
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        id result = [NSJSONSerialization dataWithJSONObject:self options:opt error:error];
        if (error != nil) return nil;
        return result;
    }else{
        return nil;
    }
}

-(NSString *)JSONString
{
    NSData* data = [self toJSON];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary(JSONCategories)

+(NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData
{
    if (jsonData==nil) {
        return nil;
    }
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

+(NSDictionary *)dictionaryFromJSONData:(NSData *)jsonData options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:opt error:error];
    if (error != nil) return nil;
    return result;
}

-(NSData *)toJSON
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError* error = nil;
        id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (error != nil) return nil;
        return result;
    }else{
        return nil;//[NSKeyedArchiver archivedDataWithRootObject:self];
    }
}

-(NSData *)toJSONWithoptions:(NSJSONWritingOptions)opt error:(NSError **)error
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        id result = [NSJSONSerialization dataWithJSONObject:self options:opt error:error];
        if (error != nil) return nil;
        return result;
    }else{
        return nil;
    }
}

-(NSString *)JSONString
{
    NSData* data = [self toJSON];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end

