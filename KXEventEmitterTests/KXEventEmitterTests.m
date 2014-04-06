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
    [self kx_once:@"hoge" selector:@selector(handler:)];
    [self kx_once:@"fuga" handler:^(NSNotification *n) {
        XCTAssert([n.name isEqualToString:@"fuga"], );
    }];
    NSObject *em = [NSObject new];
    [em kx_emit:@"hoge"];
    [em kx_emit:@"fuga"];
    NSObject *em2 = [NSObject new];
    [self kx_on:@"var" handler:^(NSNotification *n) {
        XCTAssert(n.object == em2, );
    } from:em2];
    [em kx_emit:@"var"];
    [em2 kx_emit:@"var"];
}

- (void)handler:(NSNotification*)not
{
    XCTAssert([[not name] isEqualToString:@"hoge"], );
}

- (void)testExclusiveEvent
{
    NSNotificationCenter *nc = [NSNotificationCenter new];
    NSObject *emitter = [NSObject new];
    NSObject *other = [NSObject new];
    __block BOOL called = NO;
    [self kx_once:@"hoge" handler:^(NSNotification *n) {
        called = !called;
    } from:nil center:nc];
    [other kx_once:@"hoge" handler:^(NSNotification *n) {
        XCTFail(@"should not be called");
    } from:nil];
    [emitter kx_emit:@"hoge" userInfo:nil center:nc];
    XCTAssertTrue(called, );
    [emitter kx_emit:@"hoge" userInfo:nil center:nc];
    XCTAssertTrue(called, @"once");
}

- (void)testObserve
{
    UIView *v = [UIView new];
    __block BOOL called = NO;
    [self kx_observe:v keyPath:@"tag" handler:^(id object, NSString *keyPath, NSDictionary *change) {
        XCTAssert(object == v,);
        XCTAssert([keyPath isEqualToString:@"tag"], );
        XCTAssert([change[NSKeyValueChangeNewKey] unsignedIntegerValue] == 1, );
        called = YES;
    }];
    v.tag = 1;
    XCTAssertTrue(called, );
}

- (void)testObserveOnce
{
    UIView *v = [UIView new];
    __block BOOL called = NO;
    [self kx_observeOnce:v keyPath:@"tag" handler:^(id object, NSString *keyPath, NSDictionary *change) {
        called = !called;
    }];
    v.tag = 1;
    XCTAssertTrue(called, );
    v.tag = 2;
    XCTAssertTrue(called, );
}

@end

