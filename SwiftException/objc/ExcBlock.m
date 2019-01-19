//
//  ExcBlock.m
//  SwiftRuntimeException
//
//  Created by Mitsuhau Emoto on 2019/01/18.
//  Copyright © 2019 Mitsuhau Emoto. All rights reserved.
//

#import "ExcBlock.h"

@implementation ExcBlock

+ (void)executeBlock:(Block)block completion:(Completion)completion
{
    @try {
        NSLog(@"execute block");
        block();
    } @catch (NSException *exception) {
        NSLog(@"exception = %@", exception);
        completion(exception);
    } @finally {
    }
}

@end
