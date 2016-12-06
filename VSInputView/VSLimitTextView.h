//
//  VSLimitTextView.h
//  monoz
//
//  Created by vison on 16/11/8.
//  Copyright © 2016年 jp.co.sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSLimitTextView : UITextView

/**
 *  default is NSIntegerMax, and it will be invalid if less than or equal to 0
 */
@property (nonatomic, assign)NSInteger maxLength;

/**
 *  the length that allowed over maxLength, default is 0.
 */
@property (nonatomic, assign)NSInteger allowOverLength;

/**
 *  if `manxLength` setted, it will be maxLength - currentLength, otherwise NSIntegerMax
 */
@property (nonatomic, assign, readonly)NSInteger canInputLength;

/**
 *  return
 */
@property (nonatomic, assign, readonly)NSInteger numberOfLines;

/**
 *  if show limit accessory view, default is NO.
 */
@property (nonatomic, assign)BOOL showLimitLengthAccessoryView;

/**
 *  set place holder text
 */
@property (nonatomic, copy)NSString *placeHolder;
@end
