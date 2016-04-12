//
//  CZGPerlinGenerator.h
//  Perlin-iOS
//
//  Created by Christopher Garrett on 5/17/11.
//  Copyright 2011 ZWorkbench, Inc. All rights reserved.

//MIT License:
//
//Copyright (C) 2011 by Christopher Z. Garrett
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
////

#import <Foundation/Foundation.h>

#define PERMUTATION_SIZE 256

@interface CZGPerlinGenerator : NSObject {
   int permut[PERMUTATION_SIZE];
}

@property (nonatomic, assign) NSUInteger octaves;
@property (nonatomic, assign) float persistence;
@property (nonatomic, assign) float zoom;

+ (CZGPerlinGenerator *) perlinGenerator;

- (float) perlinNoiseX: (float) x y: (float) y z: (float) z t: (float) t;


@end
