//
//  VSLimitTVAccessoryView.m
//  monoz
//
//  Created by vison on 16/11/9.
//  Copyright © 2016年 jp.co.sample. All rights reserved.
//

#import "VSLimitTVAccessoryView.h"

@interface VSLimitTVAccessoryView ()
@property (weak, nonatomic) IBOutlet UILabel *currentLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLengthLabel;
@end

@implementation VSLimitTVAccessoryView

- (void)updateTotalLength:(NSInteger)totalLength {
    self.totalLengthLabel.text = [NSString stringWithFormat:@"%ld", totalLength];
}

- (void)updateCurrentLength:(NSInteger)currentLength {
    self.currentLengthLabel.text = [NSString stringWithFormat:@"%ld", currentLength];
}

- (IBAction)action_done:(UIButton *)sender {
    if (self.DoneBlock) {
        self.DoneBlock();
    }

}
@end
