

#import <UIKit/UIKit.h>


@interface UIFactory : NSObject {

}

+(UITextField *)newTextField:(NSString *)placeHolderText;
+(UITextView *)newTextViewWithFrame: (CGRect)frame;
+(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
+(NSDate*)newDate:(NSString*)year month:(NSString*)month day:(NSString*)day;
+(NSDate*)newDateWithInt:(int)year month:(int)month day:(int)day;

+(UIButton *)newButtonWithTitle:(NSString *)title
					  target:(id)target
					selector:(SEL)selector
					   frame:(CGRect)frame
					   image:(UIImage *)image
				imagePressed:(UIImage *)imagePressed
			   darkTextColor:(BOOL)darkTextColor;
+ (void) showOkAlert:(NSString*)msg title:(NSString*)title;

@end
