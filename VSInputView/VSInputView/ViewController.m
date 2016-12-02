//
//  ViewController.m
//  VSInputView
//
//  Created by 王翔 on 11/30/16.
//  Copyright © 2016 vison. All rights reserved.
//

#import "ViewController.h"
#import "VSLimitTextField.h"
#import "VSLimitTextView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet VSLimitTextField *VSTextField;
@property (weak, nonatomic) IBOutlet VSLimitTextView *VSTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VSTextField.maxLength = 20;
    self.VSTextField.showLimitLengthAccessoryView = YES;
    self.VSTextField.placeholder = @"This is textField!";
    
    
    self.VSTextView.maxLength = 30;
    self.VSTextView.placeHolder = @"This is textView!";
    self.VSTextView.showLimitLengthAccessoryView = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
