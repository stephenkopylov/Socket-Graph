#import "UIAlertController+Window.h"
#import <objc/runtime.h>
#import "AlertViewController.h"

@interface UIAlertController (Window)

@property (nonatomic, strong) UIWindow *alertWindow;

@end


@implementation UIAlertController (Window)

@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow *)alertWindow
{
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIWindow *)alertWindow
{
    return objc_getAssociatedObject(self, @selector(alertWindow));
}


- (void)show
{
    [self show:YES];
}


- (void)show:(BOOL)animated
{
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[AlertViewController alloc] init];
    self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end