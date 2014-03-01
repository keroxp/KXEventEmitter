//
//  NSObject+KXEventEmitter.h
//  KXEventEmitter
//
//  Created by keroxp on 2014/03/01.
//  Copyright (c) 2014年 keroxp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KXEventEmitterHandler)(NSNotification* n);

@interface NSObject (KXEventEmitter)

- (void)kx_on:(NSString*)event handler:(KXEventEmitterHandler)handler;
- (void)kx_on:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from;
- (void)kx_on:(NSString*)event selector:(SEL)selector;
- (void)kx_on:(NSString*)event selector:(SEL)selector from:(id)from;
- (void)kx_once:(NSString*)event handler:(KXEventEmitterHandler)handler;
- (void)kx_once:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from;
- (void)kx_once:(NSString*)event selector:(SEL)selector;
- (void)kx_once:(NSString*)event selector:(SEL)selector from:(id)from;

- (void)kx_off:(NSString*)event;
- (void)kx_off;

- (void)kx_emit:(NSString*)event;
- (void)kx_emit:(NSString*)event userInfo:(NSDictionary*)userInfo;

@end
