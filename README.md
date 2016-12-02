# VSInputView
UITextField和UITextView的字数限制封装
### 预览图
![image](https://github.com/visoon/VSInputView/blob/master/VSInputView.gif)
<br>
<br>


###使用说明
####  UITextField
```c
    self.VSTextField.maxLength = 20;
    //可以控制是否显示字数限制
    self.VSTextField.showLimitLengthAccessoryView = YES;
    self.VSTextField.placeholder = @"This is textField!";
```

####  UITextView
```c
    self.VSTextView.maxLength = 30;
    //UITextView的placeholder
    self.VSTextView.placeHolder = @"This is textView!";
    //可以控制是否显示字数限制
    self.VSTextView.showLimitLengthAccessoryView = YES;
```
###核心代码
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
