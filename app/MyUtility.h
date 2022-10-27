//
//  MyUtility.h
//  iSH
//
//  Created by pcl on 10/25/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyUtility : NSObject

+ (void)boot;
+ (void)configureDns;
+ (struct fd *)get_at_pwd;
+ (NSURL *)get_root;

@end

NS_ASSUME_NONNULL_END
