//
//  FastInvocationObject.m
//  FastInvocationCourse
//
//  Created by Kun on 15/3/18.
//  Copyright (c) 2015年 Kun. All rights reserved.
//

#import "FastInvocationObject.h"
#import <objc/runtime.h>

#import "FastForwardObject.h"
#import "FormalForwardObject.h"
@implementation FastInvocationObject


void fooMethod1(id obj, SEL _cmd)
{
    NSLog(@"Doing foo");
}

- (void)foomethod
{
    NSLog(@"foo method");
}


//1. +(BOOL) resolveInstanceMethos:(SEL)sel    可以override这个函数添加相应的操作，这个函数返回YES 就不会造成crash
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(foo)) {
        class_addMethod([self class], sel, (IMP)fooMethod1, "v@:");
        return NO;
    }
    
    return [super resolveInstanceMethod:sel];
}

//2. 如果上面函数返回NO，会进行 Message Forwarding(消息转发), 可以override -(id)forwardingTargetForSelector 这个方法，返回你希望让它响应的对象。

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(foo)) {
        return [[FastForwardObject alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}


//3. 如果 forwardingTargetForSelector没有对象返回， Runtime会发送 -methodSignatureForSelector: 获取函数参数和返回类型，如果返回nil，Runtime会抛出 doesNotRecognizeSelector ，程序会crash。 如果返回一个NSMethodSignature*, Runtime会创建一个NSInvocation发送给 forwardInvocation消息给目标target。
- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(foo)) {
        
        return [[[FastForwardObject alloc]init] methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = anInvocation.selector;
    if ([[[FormalForwardObject alloc] init] respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:[[FormalForwardObject alloc] init]];
    }
    else
    {
        [self doesNotRecognizeSelector:sel];
    }
}

@end
