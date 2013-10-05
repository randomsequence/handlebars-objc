//
//  HBExecutionContext.m
//  handlebars-objc
//
//  Created by Bertrand Guiheneuf on 10/4/13.
//
//  The MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HBExecutionContext.h"
#import "HBHelperRegistry.h"
#import "HBPartialRegistry.h"
#import "HBTemplate.h"
#import "HBTemplate_Private.h"

@implementation HBExecutionContext

+ (instancetype) globalExecutionContext
{
    static dispatch_once_t pred;
    static HBExecutionContext* _globalExecutionContext = nil;
    
    dispatch_once(&pred, ^{
        _globalExecutionContext = [[HBExecutionContext alloc] init];
    });
    
    return _globalExecutionContext;
}


#pragma mark -
#pragma mark Helpers

- (HBHelperRegistry*) helpers
{
    @synchronized(self) {
        if (_helpers) return _helpers;
        _helpers = [HBHelperRegistry new];
    }
    return _helpers;
}

#pragma mark -
#pragma mark Partials

- (HBPartialRegistry*) partials
{
    @synchronized(self) {
        if (_partials) return _partials;
        _partials = [HBPartialRegistry new];
    }
    return _partials;
}

#pragma mark -
#pragma mark Instanciating templates

- (HBTemplate*) templateWithString:(NSString*)string
{
    HBTemplate* template = [[HBTemplate alloc] initWithString:string];
    if ([[self class] globalExecutionContext] != self) {
        template.sharedExecutionContext = self;
    }
    return [template autorelease];
}


@end