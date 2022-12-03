#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CachedVideoPlayerPlugin.h"
#import "messages.h"

FOUNDATION_EXPORT double cached_video_playerVersionNumber;
FOUNDATION_EXPORT const unsigned char cached_video_playerVersionString[];

