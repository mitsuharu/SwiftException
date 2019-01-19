//
//  ExcBlock.h
//  SwiftRuntimeException
//
//  Created by Mitsuhau Emoto on 2019/01/18.
//  Copyright © 2019 Mitsuhau Emoto. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^Block)(void);
typedef void (^Completion)( NSException *exception );

@interface ExcBlock : NSObject

+ (void)executeBlock:(Block)block completion:(Completion)completion;

@end

NS_ASSUME_NONNULL_END
