//
//  VSLimitTextView.m
//  monoz
//
//  Created by vison on 16/11/8.
//  Copyright © 2016年 jp.co.sample. All rights reserved.
//

#import "VSLimitTextView.h"
#import "VSLimitTVAccessoryView.h"
#import <objc/runtime.h>

@interface VSLimitTextView ()<UITextViewDelegate>
@property (nonatomic, assign) NSInteger preInputLocation;
@property (nonatomic, weak) id<UITextViewDelegate> childDelegate;

@property (nonatomic, strong) VSLimitTVAccessoryView *accessoryView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation VSLimitTextView
@synthesize maxLength = _maxLength;

#pragma mark - init
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDefaultInfo];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultInfo];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
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

- (void)initDefaultInfo {
    [super setDelegate:self];
    self.layoutManager.allowsNonContiguousLayout = NO;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    self.childDelegate = delegate;
}


#pragma mark - private methods

- (void)vs_limitText {
    if (self.maxLength == NSIntegerMax) {
        return;
    }
    NSInteger currentInputLocation = [self vs_getCurrentInputLocation];
    NSInteger inputLength = currentInputLocation - self.preInputLocation;
    
    if (self.text.length > [self allowMaxLength]) {
        NSMutableString *selfText = [self.text mutableCopy];
        NSInteger needDeleteLength = self.text.length - [self allowMaxLength];
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
    [self.accessoryView updateCurrentLength:[self allowMaxLength] - self.canInputLength];
    [self.accessoryView updateTotalLength:self.maxLength];
}

- (NSInteger)allowMaxLength {
    return self.maxLength + self.allowOverLength;
}

#pragma mark - delegate

- (void)textViewDidChange:(UITextView *)textView {
    [self vs_limitText];
    if (self.showLimitLengthAccessoryView && self.maxLength != NSIntegerMax) {
        [self vs_updateAccessoryView];
    }
    
    
    if ([self.childDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.childDelegate textViewDidChange:textView];
    }
}


#pragma mark - Method forwarding

+ (BOOL)isInstanceMethodSelector:(SEL)selector inProtocol:(Protocol *)protocol {
    struct objc_method_description requiredMethod = protocol_getMethodDescription(protocol, selector, YES, YES);
    struct objc_method_description optionalMethod = protocol_getMethodDescription(protocol, selector,  NO, YES);
    
    return (requiredMethod.name != NULL || optionalMethod.name != NULL);
}

- (id)forwardingTargetForSelector:(SEL)selector {
    BOOL isDelegateSelector = [[self class] isInstanceMethodSelector:selector
                                                          inProtocol:@protocol(UITextViewDelegate)];
    if (isDelegateSelector && [self.childDelegate respondsToSelector:selector]) {
        return self.childDelegate;
    }
    
    return [super forwardingTargetForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)selector {
    BOOL isDelegateSelector = [[self class] isInstanceMethodSelector:selector
                                                          inProtocol:@protocol(UITextViewDelegate)];
    if (isDelegateSelector && [self.childDelegate respondsToSelector:selector]) {
        return YES;
    }
    return [super respondsToSelector:selector];
}

#pragma mark - getter / setter
- (NSInteger)canInputLength {
    if ([self allowMaxLength]) {
        NSInteger subLength = [self allowMaxLength] - self.text.length;
        if (subLength > 0) {
            return subLength;
        }
        return 0;
    }
    return NSIntegerMax;
}

- (VSLimitTVAccessoryView *)accessoryView {
    if (!_accessoryView) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"VSInputView.bundle"]];
        _accessoryView = [bundle loadNibNamed:NSStringFromClass([VSLimitTVAccessoryView class]) owner:self options:nil][0]; ;
        _accessoryView.bounds = CGRectMake(0, 0, 0, 40);
        __weak typeof(self) weakself = self;
        [_accessoryView setDoneBlock:^{
            [weakself resignFirstResponder];
        }];
    }
    return _accessoryView;
}

- (NSInteger)maxLength {
    if (_maxLength <= 0) {
        return NSIntegerMax;
    }
    return _maxLength;
}

- (NSInteger)numberOfLines {
    return (self.contentSize.height - self.textContainerInset.top - self.textContainerInset.bottom) / self.font.lineHeight;
} 

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.textColor = [UIColor grayColor];
        _placeHolderLabel.numberOfLines = 0;
    }
    _placeHolderLabel.font = self.font;
    return _placeHolderLabel;
}

- (void)setShowLimitLengthAccessoryView:(BOOL)showLimitLengthAccessoryView {
    _showLimitLengthAccessoryView = showLimitLengthAccessoryView;
    if (showLimitLengthAccessoryView) {
        self.inputAccessoryView = self.accessoryView;
    } else {
        self.inputAccessoryView = nil;
    }
}

- (void)setAllowOverLength:(NSInteger)allowOverLength {
    if (allowOverLength <= 0) {
        _allowOverLength = 0;
    }
    _allowOverLength = allowOverLength;
}

- (void)setMaxLength:(NSInteger)maxLength {
    if (maxLength <= 0) {
        _maxLength = NSIntegerMax;
    }
    _maxLength = maxLength;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
    [self.placeHolderLabel sizeToFit];
    [self addSubview:self.placeHolderLabel];
    [self setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
}
@end
