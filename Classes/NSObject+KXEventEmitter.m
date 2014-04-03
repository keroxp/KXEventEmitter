//
//  NSObject+KXEventEmitter.m
//  KXEventEmitter
//
//  Created by keroxp on 2014/03/01.
//  Copyright (c) 2014年 keroxp. All rights reserved.
//

#import "NSObject+KXEventEmitter.h"
#import <objc/message.h>

static const char * oncesKey = "me.keroxp.app:EventEmitterOncesKey";
static const char * handlersKey = "me.keroxp.app:EventEmitterHandlersKey";


@implementation NSObject (KXEventEmitter)

- (NSMutableDictionary*)onceDictionary
{
    NSMutableDictionary *onced = objc_getAssociatedObject(self, &oncesKey);
    if (!onced) {
        onced = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &oncesKey, onced, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return onced;
}

- (NSMutableDictionary*)handlerDictionary
{
    NSMutableDictionary *handlers = objc_getAssociatedObject(self, &handlersKey);
    if (!handlers) {
        handlers = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &handlersKey, handlers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return handlers;
}

- (void)kx_on:(NSString *)event handler:(KXEventEmitterHandler)handler
{
    [self kx_on:event handler:handler from:nil];
}

- (void)kx_on:(NSString *)event handler:(KXEventEmitterHandler)handler from:(id)from
{
    [self kx_on:event handler:handler from:from center:[NSNotificationCenter defaultCenter]];
}

- (void)kx_on:(NSString *)event handler:(KXEventEmitterHandler)handler from:(id)from center:(NSNotificationCenter *)center
{
    [[self handlerDictionary] setObject:[handler copy] forKey:event];
    [center addObserver:self selector:@selector(_notificationProxy:) name:event object:from];
}

- (void)kx_on:(NSString *)event selector:(SEL)selector
{
    [self kx_on:event selector:selector from:nil];
}

- (void)kx_on:(NSString *)event selector:(SEL)selector from:(id)from;
{
    [self kx_on:event selector:selector from:from center:[NSNotificationCenter defaultCenter]];
}

- (void)kx_on:(NSString *)event selector:(SEL)selector from:(id)from center:(NSNotificationCenter *)center
{
    [[self handlerDictionary] setObject:NSStringFromSelector(selector) forKey:event];
    [center addObserver:self selector:@selector(_notificationProxy:) name:event object:from];
}

- (void)kx_once:(NSString *)event handler:(KXEventEmitterHandler)handler
{
    [self kx_once:event handler:handler from:nil];
}

- (void)kx_once:(NSString *)event handler:(KXEventEmitterHandler)handler from:(id)from;
{
    [self kx_once:event handler:handler from:from center:[NSNotificationCenter defaultCenter]];
}

- (void)kx_once:(NSString *)event handler:(KXEventEmitterHandler)handler from:(id)from center:(NSNotificationCenter *)center
{
    [[self onceDictionary] setObject:@YES forKey:event];
    [self kx_on:event handler:handler from:from center:center];
}

- (void)kx_once:(NSString *)event selector:(SEL)selector
{
    [self kx_once:event selector:selector from:nil];
}

- (void)kx_once:(NSString *)event selector:(SEL)selector from:(id)from
{
    [self kx_once:event selector:selector from:from center:[NSNotificationCenter defaultCenter]];
}

- (void)kx_once:(NSString *)event selector:(SEL)selector from:(id)from center:(NSNotificationCenter *)center
{
    [[self onceDictionary] setObject:@YES forKey:event];
    [self kx_on:event selector:selector from:from center:center];
}

- (void)_notificationProxy:(NSNotification*)not
{
    NSString *name = [not name];
    BOOL once = [[[self onceDictionary] objectForKey:name] boolValue];
    id handler = [[self handlerDictionary] objectForKey:name];
    if (once) {
        [[self onceDictionary] removeObjectForKey:name];
        [[self handlerDictionary] removeObjectForKey:name];
        [self kx_off:name];
    }
    if ([handler isKindOfClass:[NSString class]]) {
        // sel
        SEL sel = NSSelectorFromString(handler);
        objc_msgSend(self, sel, not);
    }else if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]){
        // block
        KXEventEmitterHandler _handler = (KXEventEmitterHandler)handler;
        _handler(not);
    }
}

- (void)kx_off
{
    [self kx_offCenter:[NSNotificationCenter defaultCenter]];
}

- (void)kx_offCenter:(NSNotificationCenter *)center
{
    [center removeObserver:self];
}

- (void)kx_off:(NSString *)event
{
    [self kx_off:event center:[NSNotificationCenter defaultCenter]];
}

- (void)kx_off:(NSString *)event center:(NSNotificationCenter *)center
{
    [center removeObserver:self name:event object:nil];
}

- (void)kx_emit:(NSString *)event
{
    [self kx_emit:event userInfo:nil];
}

- (void)kx_emit:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    [self kx_emit:event userInfo:userInfo center:[NSNotificationCenter defaultCenter]];
}

- (void)kx_emit:(NSString *)event userInfo:(NSDictionary *)userInfo center:(NSNotificationCenter *)center
{
    [center postNotificationName:event object:self userInfo:userInfo];
}

@end