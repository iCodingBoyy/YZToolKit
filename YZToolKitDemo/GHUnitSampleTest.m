//
//  GHUnitSampleTest.m
//  YZToolKitDemo
//
//  Created by 马远征 on 14-5-8.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@interface GHUnitSampleTest : GHTestCase

@end

@implementation GHUnitSampleTest
- (void)testStrings
{
    NSString *string1 = @"a string";
    GHTestLog(@"I can log to the GHUnit test console: %@", string1);
    // Assert string1 is not NULL, with no custom error description
   
    // Assert equal objects, add custom error description
    NSString *string2 = @"a string";
    GHAssertEqualObjects(string1, string2, @"A custom error message. string1 should be equal to: %@.", string2);
}

@end
