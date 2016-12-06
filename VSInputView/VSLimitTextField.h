//
//  VSLimitTextField.h
//  monoz
//
//  Created by vison on 16/11/9.
//  Copyright © 2016年 jp.co.sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSLimitTextField : UITextField
/**
 *  default is NSIntegerMax, and it will be invalid if less than or equal to 0
 */
@property (nonatomic, assign)NSInteger maxLength;
/**
 *  if `manxLength` setted, it will be maxLength - currentLength, otherwise NSIntegerMax
 */
@property (nonatomic, assign, readonly)NSInteger canInputLength;
/**
 *  if show limit accessory view, default is NO.
 */
@property (nonatomic, assign)BOOL showLimitLengthAccessoryView;
@end
