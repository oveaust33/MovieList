

#import <Foundation/Foundation.h>


@class API;

@protocol APIDelegate <NSObject>

-(void)apiDidExecute:(API*)api apiName:(NSString*)apiName data:(id)data;

@end


@interface API : NSObject<NSURLSessionDelegate> {
    
}


@property (weak, nonatomic) id <APIDelegate> delegate;


-(id)initWithUrl:(NSString*)urlString apiName:(NSString*)apiName PostData:(NSData*)data;
-(void)accessAPI:(NSString*)accessType Synchronous:(BOOL)synchronous;

@end
