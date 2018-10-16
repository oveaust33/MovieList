
//v2.0 :15/04/23

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadingView : NSObject
{
    NSObject *delgate;
    UIViewController *superViewController;
    
   
}


@property(strong,nonatomic) UIView *superView;
@property(strong,nonatomic) UIView *mainView;
@property(strong,nonatomic) NSString* loadingText;
@property(strong,nonatomic) UIActivityIndicatorView *indicator;
@property  BOOL permitted;
@property  BOOL isShowing;
@property BOOL landscape;

- (void)initWithText:(NSString*) loadingText Delegate:(NSObject*)delegate;
- (void)initWithText:(NSString*)loadingText Delegate:(NSObject*)delegate Landscape:(BOOL)landscape;

+(void)Show;
+(void)Close;

@end
