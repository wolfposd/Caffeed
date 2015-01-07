
#import <UIKit/UIKit.h>


#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
#define HUD_STATUS_COLOR		[UIColor blackColor]

#define HUD_SPINNER_COLOR		[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0.0 alpha:0.1]
#define HUD_WINDOW_COLOR		[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]

#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"progresshud-success.png"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"progresshud-error.png"]

@interface ProgressHUD : UIView


+ (ProgressHUD *)shared;

/**
 *  Dismisses the HUD
 */
+ (void)dismiss;


#pragma mark - Spinner
/**
 *  Shows HUD with Spinner
 *
 *  @param status text to display
 */
+ (void)show:(NSString *)status;
+ (void)show:(NSString *)status Interaction:(BOOL)Interaction;

#pragma mark - Success
/**
 *  Shows HUD with Success-image, auto-hides after certain time
 *
 *  @param status text to display
 */
+ (void)showSuccess:(NSString *)status;
/**
 *  Shows HUD with Success-image, auto-hides after certain time if specified
 *
 *  @param status text to display
 *  @param hide   should this hide after certain time
 */
+ (void)showSuccess:(NSString *)status hide:(BOOL) hide;
+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction;

#pragma mark - Error
/**
 *  Shows HUD with Error-image, auto-hides after certain time
 *
 *  @param status text to display
 */
+ (void)showError:(NSString *)status;
/**
 *  Shows HUD with Error-image, auto-hides after certain time if specified
 *
 *  @param status text to display
 *  @param hide   should this hide after certain time
 */
+ (void)showError:(NSString *)status hide:(BOOL) hide;
+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction;




#pragma mark - Properties
@property (nonatomic, assign) BOOL interaction;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *background;
@property (nonatomic, retain) UIToolbar *hud;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) UILabel *label;

@end
