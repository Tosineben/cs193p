//
//  SharedDocument.h
//  SPoT
//
//  Created by Alden Quimby on 8/2/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDocument : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (SharedDocument *)sharedDocument;

- (void)useDocumentWithOperation:(void (^)(BOOL success))block;

- (void)saveDocument:(void (^)(BOOL success))completionHandler;

@end
