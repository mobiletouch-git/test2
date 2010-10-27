
#import "UIFactory.h"

@implementation UIFactory

+(UITextField *)newTextField:(NSString *)placeHolderText;
{
	
	UITextField *returnTextField = [[UITextField alloc] init];
    returnTextField.borderStyle = UITextBorderStyleNone;
    returnTextField.textColor = [UIColor blackColor];
	returnTextField.font = [UIFont systemFontOfSize:13.0];
    returnTextField.placeholder = placeHolderText;
    returnTextField.backgroundColor = [UIColor whiteColor];
	
	returnTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
	returnTextField.keyboardType = UIKeyboardTypeDefault;
	returnTextField.returnKeyType = UIReturnKeyDone;	
	returnTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	[returnTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	return returnTextField;
}

+(UITextView *)newTextViewWithFrame: (CGRect)frame{
	UITextView *returnTextView = [[UITextView alloc] initWithFrame:frame];
	returnTextView.textColor = [UIColor blackColor];
	returnTextView.font = [UIFont systemFontOfSize:13.0];
    returnTextView.backgroundColor = [UIColor whiteColor];
	returnTextView.keyboardType = UIKeyboardTypeDefault;
	returnTextView.returnKeyType = UIReturnKeyDone;	
	returnTextView.autocorrectionType = UITextAutocorrectionTypeNo;

	return returnTextView;
	
	
}

+(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	
	UIFont *font;
	if (bold) {
		font = [UIFont boldSystemFontOfSize:fontSize];
	} else {
		font = [UIFont systemFontOfSize:fontSize];
	}
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

+(NSDate*)newDate:(NSString*)year month:(NSString*)month day:(NSString*)day
{
	NSDateComponents* components=[[[NSDateComponents alloc]init] autorelease]; 
	[components setDay:[day intValue]]; 
	[components setMonth:[month intValue]]; 
	[components setYear:[year intValue]];
	
	NSCalendar *gregorian = [[NSCalendar alloc] 
							 initWithCalendarIdentifier:NSGregorianCalendar]; 
	return [gregorian dateFromComponents:components];
}

+(NSDate*)newDateWithInt:(int)year month:(int)month day:(int)day
{
	NSDateComponents* components=[[[NSDateComponents alloc]init] autorelease]; 
	[components setDay:day]; 
	[components setMonth:month]; 
	[components setYear:year];
	
	NSCalendar *gregorian = [[NSCalendar alloc] 
							 initWithCalendarIdentifier:NSGregorianCalendar]; 
	return [gregorian dateFromComponents:components];
}

+(UIButton *)newButtonWithTitle:	(NSString *)title
					  target:(id)target
					selector:(SEL)selector
					   frame:(CGRect)frame
					   image:(UIImage *)image
				imagePressed:(UIImage *)imagePressed
			   darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	//		UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	//		button.frame = frame;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	[button setShowsTouchWhenHighlighted:NO];
	
	return button;
}

+ (void) showOkAlert:(NSString*)msg title:(NSString*)title
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:msg
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	
	[alertView show];
	[alertView release];	
}


@end
