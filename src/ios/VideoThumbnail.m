/********* VideoThumbnail.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>


@ interface VideoThumbnail:CDVPlugin
{
    // Member variables go here.
}

-(void) buildThumbnail:(CDVInvokedUrlCommand *) command;
@end @ implementation VideoThumbnail - (void) buildThumbnail:(CDVInvokedUrlCommand *)
command
{
    CDVPluginResult *pluginResult = nil;
    __block NSString *payload = nil;
    
    NSString *videoPath =[command.arguments objectAtIndex:0];
    CGFloat width =[[command.arguments objectAtIndex:1] floatValue];
    width = width > 0 ? width : 100;
    CGFloat height =[[command.arguments objectAtIndex:2] floatValue];
    height = height > 0 ? height : 100;
    NSNumber *timestamp = [command.arguments objectAtIndex:3];
    
    NSString *saveFolder = NSTemporaryDirectory ();
    if (!videoPath || videoPath.length == 0)
    {
        payload = @"videoPath was wrong";
        pluginResult =[CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:payload];
        [self.commandDelegate sendPluginResult: pluginResult callbackId:command.
         callbackId];
        return;
    }
    
    if (![saveFolder hasSuffix:@"/"])
    {
        saveFolder =[NSString stringWithFormat:@"%@/", saveFolder];
    }
    
    NSArray *array =[videoPath componentsSeparatedByString:@"/"];
    NSString *name =[array objectAtIndex:array.count - 1];
    name =[name stringByReplacingOccurrencesOfString: @".mp4" withString:@""];
    
    NSString *savePath =[NSString stringWithFormat:@"%@thumbnail_%@.jpg", saveFolder,
                         name];
    [self.commandDelegate runInBackground:^
     {
         CDVPluginResult * pluginResult = nil;
         if (extractVideoThumbnail (videoPath, width, height, timestamp, savePath))
         {
             payload = savePath; pluginResult =[CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:payload];}
         else
         {
             payload = @"Could not save thumbnail"; pluginResult =[CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:payload];}
         
         [self.commandDelegate sendPluginResult: pluginResult callbackId:command.
          callbackId];}
     ];
    
}

BOOL
extractVideoThumbnail (NSString * theSourceVideoName,
                       CGFloat width,
                       CGFloat height,
                       NSNumber * timestamp,
                       NSString * theTargetImageName)
{
    UIImage *thumbnail;
    NSURL *url;
    NSString *revisedTargetImageName =[[theTargetImageName stringByReplacingOccurrencesOfString: @"file://" withString: @""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    url =[NSURL fileURLWithPath: [theSourceVideoName stringByReplacingOccurrencesOfString: @"file://" withString:@""]];
    
    
    
    AVAsset *videoAsset =[AVAsset assetWithURL:url];
    
    AVAssetImageGenerator *imageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
    
    CMTime midpoint = CMTimeMakeWithSeconds (0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    
    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL: [NSURL fileURLWithPath: theSourceVideoName] options:nil];
    AVAssetImageGenerator *gen =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.maximumSize = CGSizeMake (width, height);
    
    CMTime time = CMTimeMakeWithSeconds (0.0, 600);
    
    CGImageRef image =[gen copyCGImageAtTime: time actualTime: &actualTime error:&error];
    
    
    if (!image || error)
    {
        NSLog (@"%@", error);
        return NO;
    }
    thumbnail =[[UIImage alloc] initWithCGImage:image];
    CGImageRelease (image);
    
    
    // write out the thumbnail; a return of NO will be a failure.
    return[UIImageJPEGRepresentation (thumbnail, 1.0) writeToFile: revisedTargetImageName atomically:YES];
}

@end
