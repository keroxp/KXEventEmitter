//
//  KXEventEmitterTests.m
//  KXEventEmitterTests
//
//  Created by keroxp on 2014/03/01.
//  Copyright (c) 2014年 keroxp. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+KXEventEmitter.h"

@interface KXEventEmitterTests : XCTestCase

@end

@implementation KXEventEmitterTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEventEmitter
{
    [self once:@"hoge" selector:@selector(handler:)];
    [self once:@"fuga" handler:^(NSNotification *n) {
        XCTAssert([n.name isEqualToString:@"fuga"], );
    }];
    NSObject *em = [NSObject new];
    [em emit:@"hoge"];
    [em emit:@"fuga"];
    NSObject *em2 = [NSObject new];
    [self on:@"var" handler:^(NSNotification *n) {
        XCTAssert(n.object == em2, );
    } from:em2];
    [em emit:@"var"];
    [em2 emit:@"var"];
}

- (void)handler:(NSNotification*)not
{
    XCTAssert([[not name] isEqualToString:@"hoge"], );
}


@end
