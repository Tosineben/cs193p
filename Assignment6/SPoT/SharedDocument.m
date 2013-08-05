//
//  SharedDocument.m
//  SPoT
//
//  Created by Alden Quimby on 8/2/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SharedDocument.h"

@interface SharedDocument()

@property (strong, nonatomic) UIManagedDocument *document;

@end

@implementation SharedDocument

#define SPOT_DIRECTORY @"SPoT"

- (UIManagedDocument *)document
{
    if (!_document)
    {
        NSURL *docUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        docUrl = [docUrl URLByAppendingPathComponent:SPOT_DIRECTORY];
        _document = [[UIManagedDocument alloc] initWithFileURL:docUrl];
    }
    
    return _document;
}

+ (SharedDocument *)sharedDocument
{
    __strong static SharedDocument *_sharedDoc = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDoc = [[self alloc] init];
    });
    
    return _sharedDoc;
}
    
- (void)useDocumentWithOperation:(void (^)(BOOL success))block
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]])
    {
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            self.managedObjectContext = self.document.managedObjectContext;
            block(success);
        }];
    }
    else if (self.document.documentState == UIDocumentStateClosed)
    {
        [self.document openWithCompletionHandler:^(BOOL success) {
            self.managedObjectContext = self.document.managedObjectContext;
            block(success);
        }];
    }
    else
    {
        self.managedObjectContext = self.document.managedObjectContext;
        block(YES);
    }
}

- (void)saveDocument:(void (^)(BOOL success))completionHandler
{
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:completionHandler];
}

@end
