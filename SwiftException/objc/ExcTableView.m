//
//  ExcTableViewCell.m
//  MEOException
//
//  Created by Mitsuhau Emoto on 2019/01/19.
//  Copyright © 2019 Mitsuhau Emoto. All rights reserved.
//

#import "ExcTableView.h"

@implementation ExcTableView

- (void)exc_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                  withRowAnimation:(UITableViewRowAnimation)animation
                         excCompletion:(ExcCompletion)excCompletion{
    
    @try {
        [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    } @catch (NSException *exception) {
        excCompletion(exception);
    } @finally {
    }
    
}

@end
