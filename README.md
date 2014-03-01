KXEventEmitter
==============

An EventEmitter for objc, using NSNotificationCenter internally

# USAGE

```objc
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
 [em2 kx_emit:@"var"]
    
```
