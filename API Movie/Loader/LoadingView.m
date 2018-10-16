

#import "LoadingView.h"

@implementation LoadingView


static LoadingView *loadingView=nil;

- (void)initWithText:(NSString*) loadingText Delegate:(NSObject*)delegate{

    loadingView=[self init];
    _landscape=NO;
    
    [self initializeWithText:loadingText Delegate:delegate];
}

- (void)initWithText:(NSString*)loadingText Delegate:(NSObject*)delegate Landscape:(BOOL)landscape{
    
    loadingView=[self init];
    _landscape=landscape;
    
    [self initializeWithText:loadingText Delegate:delegate];
}

-(void)initializeWithText:(NSString*) loadingText Delegate:(NSObject*)delegate{
   
    self.permitted=NO;
    self.isShowing=NO;
    
    if (loadingView){
        delgate=delegate;
        loadingView.loadingText=loadingText;
        
        if([delegate isKindOfClass:[UIViewController class]]){
            superViewController=(UIViewController*)delegate;
            self.superView=superViewController.view;
            self.permitted=YES;
        }
        
        else if([delegate isKindOfClass:[UIView class]]){
            superViewController=nil;
            self.superView=(UIView*)delegate;
            self.permitted=YES;
        }
        
        if(self.permitted)
            [self createLoadingView];
        
    }
}

+(void)Show{
    if(loadingView.permitted && !loadingView.isShowing){
        loadingView.isShowing=YES;
      
        [loadingView.superView addSubview:loadingView.mainView];
        [loadingView.superView bringSubviewToFront:loadingView.mainView];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
}


+(void)Close{
    if(loadingView.permitted && loadingView.isShowing){
         loadingView.isShowing=NO;
        [loadingView.indicator stopAnimating];
        [loadingView.mainView removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (void)createLoadingView{
    
    if(self.mainView)
        return;
    
    CGRect mainFrame=[[UIScreen mainScreen] bounds];
    
    if(_landscape)
        mainFrame=CGRectMake(mainFrame.origin.x, mainFrame.origin.y, mainFrame.size.height, mainFrame.size.width);
   
    int widthMax=mainFrame.size.width-20;
    
    CGRect Rect_Lbl;
    
   //iOS 6 issue
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0){
        Rect_Lbl = [self.loadingText boundingRectWithSize:CGSizeMake(widthMax, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                                context:nil];
    }
    else{
        Rect_Lbl=CGRectMake(0, 0, widthMax-79, 20);
    }
    
    float x_lbl=51;
    
    if(Rect_Lbl.size.width+x_lbl+8>widthMax)
        Rect_Lbl.size.width=widthMax-x_lbl-8;
    
    float width=Rect_Lbl.size.width+x_lbl+8, height=70;
    //width=width>300.0?300.0:width;
    UIView *loadView = [[UIView alloc] init];
    
    if(superViewController){
        if(!superViewController.navigationController.navigationBarHidden){
            [loadView setFrame:CGRectMake(mainFrame.size.width/2-width/2, mainFrame.size.height/2-(height*1.5), width, height)];
        }
        else{
            [loadView setFrame:CGRectMake(mainFrame.size.width/2-width/2,_landscape?(mainFrame.size.height/2-height/2): mainFrame.size.height/2-(height*1), width, height)];
        }
    }
    

    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, loadView.frame.size.width, loadView.frame.size.height)];
    backView.layer.cornerRadius=8.0;
    backView.clipsToBounds=YES;
    backView.layer.backgroundColor=[[UIColor blackColor]CGColor];
    backView.alpha=0.7;
    [loadView addSubview:backView];
    
    UILabel *lblText=[[UILabel alloc] initWithFrame:CGRectMake(x_lbl, 0, Rect_Lbl.size.width, loadView.frame.size.height)];
    lblText.text=loadingView.loadingText;
    lblText.numberOfLines=3;
    lblText.font=[UIFont fontWithName:@"Helvetica" size:14];
    lblText.textColor=[UIColor whiteColor];
    [loadView addSubview:lblText];
    
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //indicator.layer.backgroundColor=[[UIColor blackColor]CGColor];
    [self.indicator setColor:[UIColor blackColor]];
    self.indicator.center = CGPointMake(27, 35);
    [self.indicator startAnimating];
    
    [loadView addSubview:self.indicator];
    
    self.mainView=loadView;

}



@end
