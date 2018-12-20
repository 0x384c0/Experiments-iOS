#import "CustomSearchController.h"

@interface CustomSearchController ()
@property (weak,nonatomic) UIViewController *vc;

@end

@implementation CustomSearchController

-(instancetype)initWithPlaceholder:(NSString*)placeholder{
    self = [self initWithSearchResultsController:nil];
    // Setup the Search Controller
    self.obscuresBackgroundDuringPresentation = NO;
    self.dimsBackgroundDuringPresentation = NO;
    self.hidesNavigationBarDuringPresentation = NO;
    self.searchBar.placeholder = placeholder;
    self.searchBar.barStyle = UISearchBarStyleMinimal;
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    searchField.returnKeyType = UIReturnKeyDone;
    return self;
}

-(void)addSelfToVC:(UIViewController*)vc{
    if (!vc.navigationItem.hidesBackButton){
        vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"]
                                                                               style:(UIBarButtonItemStylePlain)
                                                                              target:self
                                                                              action:@selector(popVc)];
    }

    vc.navigationItem.titleView = self.searchBar;
    [vc.navigationController.view layoutSubviews];
    self.vc = vc;
}
-(void)removeSelfToVC:(UIViewController *)vc{
    [self.searchBar resignFirstResponder];
    [self.searchBar removeFromSuperview];
    vc.navigationItem.titleView = nil;
    if (!vc.navigationItem.hidesBackButton){
        vc.navigationItem.leftBarButtonItem = nil;
    }
    [vc.navigationController.view layoutSubviews];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.customButtons)
        [self setCancelImage];
}

-(void)setCancelImage{
    [self.searchBar setCancelImage];
}

-(void)becomeFirstResponderAfterDelay{
    [self.searchBar performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
}

-(void)popVc{
    if (self.vc.navigationController.viewControllers.count > 1)
        [self.vc.navigationController popViewControllerAnimated:YES];
    else if ([self.vc conformsToProtocol:@protocol(UISearchBarDelegate)])
        [((id<UISearchBarDelegate>)self.vc) searchBarCancelButtonClicked:self.searchBar];
}

@end
