#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include <Cocoa/Cocoa.h>
// module produced of objective-c interfaces of this Target swift code.

#import "QLLinkedIdeas-Swift.h"

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
 Generate a preview for file

 This function's job is to create preview for designated file
 ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
  @autoreleasepool {
    CGSize canvasSize = NSMakeSize(800, 600);

    NSLog(@"Quicklook Init! %@, contentType %@", url, contentTypeUTI);

    DocumentManager *manager = [[DocumentManager alloc] init];

    manager.url = (__bridge NSURL *)url;
    manager.contentTypeUTI = (__bridge NSString *)contentTypeUTI;

    [NSKeyedUnarchiver setClass:[DocumentData class] forClassName:@"LinkedIdeas.DocumentData"];
    [NSKeyedUnarchiver setClass:[Concept class] forClassName:@"LinkedIdeas.Concept"];
    [NSKeyedUnarchiver setClass:[Link class] forClassName:@"LinkedIdeas.Link"];

    // Preview will be drawn in a vectorized context
    CGContextRef cgContext = QLPreviewRequestCreateContext(preview, *(CGSize *)&canvasSize, false, NULL);

    NSLog(@"Quick look generator %@", url);

    if(cgContext) {
      NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)cgContext flipped:NO];

      if (context) {
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:context];

        [manager processDocumentWithCanvasSize:canvasSize context:context];


        [NSGraphicsContext restoreGraphicsState];
      }
      QLPreviewRequestFlushContext(preview, cgContext);
      CFRelease(cgContext);
    }
  }
  return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
  // Implement only if supported
}
