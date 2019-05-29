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

#import "../StarPrinting/Printable.h"
#import "../StarPrinting/PrintCommands.h"
#import "../StarPrinting/PrintData.h"
#import "../StarPrinting/Printer.h"
#import "../StarPrinting/PrintParser.h"
#import "../StarPrinting/PrintTextFormatter.h"
#import "../StarPrinting/StarPrinting.h"

FOUNDATION_EXPORT double StarPrintingVersionNumber;
FOUNDATION_EXPORT const unsigned char StarPrintingVersionString[];

