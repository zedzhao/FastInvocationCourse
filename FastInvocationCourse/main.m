//
//  main.m
//  FastInvocationCourse
//
//  Created by Kun on 15/3/18.
//  Copyright (c) 2015年 Kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "FastInvocationObject.h"

void fooMethod(id obj, SEL _cmd)
{
    NSLog(@"Doing foo");
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        FastInvocationObject *object = [[FastInvocationObject alloc] init];
        [object foo];
        
    }
    return 0;
}
