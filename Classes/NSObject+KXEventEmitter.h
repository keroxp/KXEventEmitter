//
//  NSObject+KXEventEmitter.h
//  KXEventEmitter
//
//  Created by keroxp on 2014/03/01.
//  Copyright (c) 2014年 keroxp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KXEventEmitterHandler)(NSNotification* n);
typedef void (^KXEventEmitterKeyValueChangeHandler)(id object, NSString *keyPath, NSDictionary *change);
@interface NSObject (KXEventEmitter)

- (void)kx_on:(NSString*)event handler:(KXEventEmitterHandler)handler;
- (void)kx_on:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from;
- (void)kx_on:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from center:(NSNotificationCenter*)center;
- (void)kx_on:(NSString*)event selector:(SEL)selector;
- (void)kx_on:(NSString*)event selector:(SEL)selector from:(id)from;
- (void)kx_on:(NSString*)event selector:(SEL)selector from:(id)from center:(NSNotificationCenter*)center;
- (void)kx_once:(NSString*)event handler:(KXEventEmitterHandler)handler;
- (void)kx_once:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from;
- (void)kx_once:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from center:(NSNotificationCenter*)center;
- (void)kx_once:(NSString*)event selector:(SEL)selector;
- (void)kx_once:(NSString*)event selector:(SEL)selector from:(id)from;
- (void)kx_once:(NSString*)event selector:(SEL)selector from:(id)from center:(NSNotificationCenter*)center;

- (void)kx_off:(NSString*)event;
- (void)kx_off;
- (void)kx_off:(NSString*)event center:(NSNotificationCenter*)center;
- (void)kx_offCenter:(NSNotificationCenter*)center;

- (void)kx_emit:(NSString*)event;
- (void)kx_emit:(NSString*)event userInfo:(NSDictionary*)userInfo;
- (void)kx_emit:(NSString*)event userInfo:(NSDictionary*)userInfo center:(NSNotificationCenter*)center;

- (void)kx_observe:(id)object keyPath:(NSString*)keyPath handler:(KXEventEmitterKeyValueChangeHandler)handler;
- (void)kx_observeOnce:(id)object keyPath:(NSString*)keyPath handler:(KXEventEmitterKeyValueChangeHandler)handler;
- (void)kx_stopObserving:(id)object;
- (void)kx_stopObserving:(id)object forKeyPath:(NSString*)keyPath;

@end
