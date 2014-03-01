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

- (void)on:(NSString*)event handler:(KXEventEmitterHandler)handler;
- (void)on:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from;
- (void)on:(NSString*)event selector:(SEL)selector;
- (void)on:(NSString*)event selector:(SEL)selector from:(id)from;
- (void)once:(NSString*)event handler:(KXEventEmitterHandler)handler;
- (void)once:(NSString*)event handler:(KXEventEmitterHandler)handler from:(id)from;
- (void)once:(NSString*)event selector:(SEL)selector;
- (void)once:(NSString*)event selector:(SEL)selector from:(id)from;

- (void)off:(NSString*)event;
- (void)off;

- (void)emit:(NSString*)event;
- (void)emit:(NSString*)event userInfo:(NSDictionary*)userInfo;

@end
