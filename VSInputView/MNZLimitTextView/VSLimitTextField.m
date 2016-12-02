//
//  VSLimitTextField.m
//  monoz
//
//  Created by vison on 16/11/9.
//  Copyright © 2016年 jp.co.sample. All rights reserved.
//

#import <objc/runtime.h>
#import "VSLimitTVAccessoryView.h"
#import "VSLimitTextField.h"

@interface VSLimitTextField () <UITextFieldDelegate>
@property (nonatomic, assign) NSInteger preInputLocation;
@property (nonatomic, weak) id<UITextFieldDelegate> childDelegate;
@property (nonatomic, strong) VSLimitTVAccessoryView *accessoryView;
@end

@implementation VSLimitTextField
@synthesize maxLength = _maxLength;

#pragma mark - init
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDefaultInfo];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultInfo];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultInfo];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.showLimitLengthAccessoryView) {
        [self vs_updateAccessoryView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initDefaultInfo {
    [super setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFildChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.childDelegate = delegate;
}

- (void)textFildChanged:(NSNotification *)notification {
    if (!notification.object || ![notification.object isEqual:self]) {
        return;
    }

    [self vs_limitText];
    if (self.showLimitLengthAccessoryView && self.maxLength != NSIntegerMax) {
        [self vs_updateAccessoryView];
    }
}

#pragma mark - private methods

- (void)vs_limitText {
    if (self.maxLength == NSIntegerMax) {
        return;
    }
    NSInteger currentInputLocation = [self vs_getCurrentInputLocation];
    NSInteger inputLength = currentInputLocation - self.preInputLocation;
    
    if (self.text.length > self.maxLength) {
        NSMutableString *selfText = [self.text mutableCopy];
        NSInteger needDeleteLength = self.text.length - self.maxLength;
        //calculate the range of need to be delete in whole text
        NSRange needDeleteRange = NSMakeRange(self.preInputLocation + (inputLength - needDeleteLength), needDeleteLength);
        [selfText deleteCharactersInRange:needDeleteRange];
        self.text = selfText;
    }
    self.preInputLocation = [self vs_getCurrentInputLocation];
}

- (NSInteger)vs_getCurrentInputLocation {
    return [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
}

- (void)vs_updateAccessoryView {
    [self.accessoryView updateCurrentLength:self.maxLength - self.canInputLength];
    [self.accessoryView updateTotalLength:self.maxLength];
}

#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.childDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.childDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

#pragma mark - Method forwarding

+ (BOOL)isInstanceMethodSelector:(SEL)selector inProtocol:(Protocol *)protocol {
    struct objc_method_description requiredMethod = protocol_getMethodDescription(protocol, selector, YES, YES);
    struct objc_method_description optionalMethod = protocol_getMethodDescription(protocol, selector, NO, YES);

    return (requiredMethod.name != NULL || optionalMethod.name != NULL);
}

- (id)forwardingTargetForSelector:(SEL)selector {
    BOOL isDelegateSelector = [[self class] isInstanceMethodSelector:selector
                                                          inProtocol:@protocol(UITextFieldDelegate)];
    if (isDelegateSelector && [self.childDelegate respondsToSelector:selector]) {
        return self.childDelegate;
    }

    return [super forwardingTargetForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)selector {
    BOOL isDelegateSelector = [[self class] isInstanceMethodSelector:selector
                                                          inProtocol:@protocol(UITextFieldDelegate)];
    if (isDelegateSelector && [self.childDelegate respondsToSelector:selector]) {
        return YES;
    }
    return [super respondsToSelector:selector];
}

#pragma mark - getter / setter
- (NSInteger)canInputLength {
    if (self.maxLength) {
        NSInteger subLength = self.maxLength - self.text.length;
        if (subLength > 0) {
            return subLength;
        }
        return 0;
    }
    return NSIntegerMax;
}

- (NSInteger)maxLength {
    if (_maxLength <= 0) {
        return NSIntegerMax;
    }
    return _maxLength;
}

- (VSLimitTVAccessoryView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([VSLimitTVAccessoryView class]) owner:self options:nil][0];
        _accessoryView.bounds = CGRectMake(0, 0, 0, 40);
        __weak typeof(self) weakself = self;
        [_accessoryView setDoneBlock:^{
          [weakself resignFirstResponder];
        }];
    }
    return _accessoryView;
}

- (void)setShowLimitLengthAccessoryView:(BOOL)showLimitLengthAccessoryView {
    _showLimitLengthAccessoryView = showLimitLengthAccessoryView;
    if (showLimitLengthAccessoryView) {
        self.inputAccessoryView = self.accessoryView;
    } else {
        self.inputAccessoryView = nil;
    }
}

- (void)setMaxLength:(NSInteger)maxLength {
    if (maxLength <= 0) {
        _maxLength = NSIntegerMax;
    }
    _maxLength = maxLength;
}

@end
