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

- (void)on:(NSString *)event handler:(KXEventEmitterHandler)handler
{
    [self once:event handler:handler from:nil];
}

- (void)on:(NSString *)event handler:(KXEventEmitterHandler)handler from:(id)from
{
    [[self handlerDictionary] setObject:[handler copy] forKey:event];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_notificationProxy:) name:event object:from];
}

- (void)on:(NSString *)event selector:(SEL)selector
{
    [self on:event selector:selector from:nil];
}

- (void)on:(NSString *)event selector:(SEL)selector from:(id)from;
{
    [[self handlerDictionary] setObject:NSStringFromSelector(selector) forKey:event];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_notificationProxy:) name:event object:from];
}

- (void)once:(NSString *)event handler:(KXEventEmitterHandler)handler
{
    [self once:event handler:handler from:nil];
}

- (void)once:(NSString *)event handler:(KXEventEmitterHandler)handler from:(id)from;
{
    [[self onceDictionary] setObject:@YES forKey:event];
    [self on:event handler:handler from:from];
}

- (void)once:(NSString *)event selector:(SEL)selector
{
    [self once:event selector:selector from:nil];
}

- (void)once:(NSString *)event selector:(SEL)selector from:(id)from
{
    [[self onceDictionary] setObject:@YES forKey:event];
    [self on:event selector:selector from:from];
}

- (void)_notificationProxy:(NSNotification*)not
{
    NSString *name = [not name];
    BOOL once = [[[self onceDictionary] objectForKey:name] boolValue];
    id handler = [[self handlerDictionary] objectForKey:name];
    if ([handler isKindOfClass:[NSString class]]) {
        // sel
        SEL sel = NSSelectorFromString(handler);
        objc_msgSend(self, sel, not);
    }else if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]){
        // block
        KXEventEmitterHandler _handler = (KXEventEmitterHandler)handler;
        _handler(not);
    }
    if (once) {
        [[self onceDictionary] removeObjectForKey:name];
        [[self handlerDictionary] removeObjectForKey:name];
        [self off:name];
    }
}

- (void)off
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)off:(NSString *)event
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:event object:nil];
}

- (void)emit:(NSString *)event
{
    [self emit:event userInfo:nil];
}

- (void)emit:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:self userInfo:userInfo];
}

@end