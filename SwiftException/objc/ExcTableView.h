//
//  ExcTableViewCell.h
//  MEOException
//
//  Created by Mitsuhau Emoto on 2019/01/19.
//  Copyright © 2019 Mitsuhau Emoto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ExcCompletion)( NSException *exception );

@interface ExcTableView : UITableView

- (void)exc_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                  withRowAnimation:(UITableViewRowAnimation)animation
                     excCompletion:(ExcCompletion)excCompletion;

@end

NS_ASSUME_NONNULL_END
