# VSInputView
Limit of input count in UITextField and UITextView!
### Preview gif
![image](https://github.com/visoon/VSInputView/blob/master/VSInputView.gif)
<br>
<br>


### Usage
####  UITextField
```c
    self.VSTextField.maxLength = 20;
    //show a accessory view to show the limit of inputing text.
    self.VSTextField.showLimitLengthAccessoryView = YES;
    self.VSTextField.placeholder = @"This is textField!";
```

####  UITextView
```c
    self.VSTextView.maxLength = 30;
    self.VSTextView.placeHolder = @"This is textView!";
    self.VSTextView.showLimitLengthAccessoryView = YES;
```
### Core codes
```c
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

```
