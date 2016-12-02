//
//  VSLimitTVAccessoryView.h
//  monoz
//
//  Created by vison on 16/11/9.
//  Copyright © 2016年 jp.co.sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSLimitTVAccessoryView : UIView
- (void)updateCurrentLength:(NSInteger)currentLength;
- (void)updateTotalLength:(NSInteger)totalLength;
@property (nonatomic, strong)void(^DoneBlock)(void);
@end
