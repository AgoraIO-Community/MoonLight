//
//  MLDataSet.m
//  MoonLightDemo
//
//  Created by LJJ on 2020/11/18.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MLDataSet.h"

@implementation MLDataSet

- (instancetype) init {
    self = [super init];
    
    if (self) {
        _values = NULL;
        
        _min = 0;
        _max = 0;
        _sum = 0;
            
        _currentIndex = 0;
        _numValues = 0;
    }
    
    return self;
}

- (instancetype) initWithContentsOfOtherDataSet:(MLDataSet *)otherDataSet {
    if (!otherDataSet) return nil;
    
    self = [self init];
    if (self) {
        _numValues = otherDataSet.numValues;
        if (_numValues == 0) return self;
        
        // Get a copy of the other values and set the current index
        CGFloat *otherValues = otherDataSet.values;
        _values = calloc(_numValues, sizeof(CGFloat));
        memcpy(_values, otherValues, _numValues * sizeof(CGFloat));
        self.currentIndex = otherDataSet.currentIndex;
        
        // Set the other class variables.
        _max = otherDataSet.max;
        _min = otherDataSet.min;
        _sum = otherDataSet.sum;
    }
    
    return self;
}

- (CGFloat) average {
    return self.sum / (CGFloat)self.numValues;
}

- (CGFloat) currentValue {
    if (_values == NULL) return 0;
    if (_currentIndex >= _numValues) return 0;
    
    return _values[_currentIndex];
}

- (void) valuesInOrder:(CGFloat *)destinationArray {
    NSInteger index = (NSInteger)self.numValues - 1;
    
    for (NSInteger i = self.currentIndex; i >= 0; i--) {
        if (index < 0) break;
        
        destinationArray[index] = self.values[i];
        index--;
    }
    
    for (NSInteger i = self.numValues - 1; i > self.currentIndex; i--) {
        if (index < 0) break;
      
        destinationArray[index] = self.values[i];
        index--;
    }
}

- (void) reset {
    for (NSInteger i = 0; i < self.numValues; i++) {
        _values[i] = 0;
    }
}

- (void) resize:(size_t)newNumValues {
    if (newNumValues == 0) {
        self.min = 0;
        self.max = 0;
        self.sum = 0;
        
        free(self.values);
        self.values = NULL;
        self.numValues = newNumValues;
        return;
    }
    
    self.sum = 0;
    
    if (self.values) {
        CGFloat *tmpValues;
        NSInteger newValIndex = (NSInteger)newNumValues - 1;
        tmpValues = calloc(newNumValues, sizeof(CGFloat));
        
        for (NSInteger i = self.currentIndex; i >= 0; i--) {
            if (newValIndex < 0) break;
            
            tmpValues[newValIndex] = self.values[i];
            self.sum += tmpValues[newValIndex];
            newValIndex--;
        }
        
        for (NSInteger i = self.numValues - 1; i > self.currentIndex; i--) {
            if (newValIndex < 0) break;
          
            tmpValues[newValIndex] = self.values[i];
            self.sum += tmpValues[newValIndex];
            newValIndex--;
        }
                
        free(self.values);
        self.values = tmpValues;
        self.currentIndex = newNumValues - 1;
    }
    else {
        self.values = calloc(newNumValues, sizeof(CGFloat));
        self.currentIndex = 0;
    }
    self.numValues = newNumValues;
}

- (void) setNextValue:(CGFloat)nextVal {
    if (!self.numValues) return;

    self.currentIndex++;
    if (self.currentIndex == self.numValues) self.currentIndex = 0;
    
    CGFloat oldValue = self.values[self.currentIndex];
    
    self.sum -= self.values[self.currentIndex];
    self.values[self.currentIndex] = nextVal;
    self.sum += self.values[self.currentIndex];

    if (oldValue == self.min || oldValue == self.max) {
        self.max = self.values[0];
        self.min = self.values[0];
        
        for (NSInteger i = 0; i < self.numValues; i++) {
            if (self.values[i] < self.min) self.min = self.values[i];
            if (self.values[i] > self.max) self.max = self.values[i];
        }
    }
        
    if (self.values[self.currentIndex] < self.min) self.min = self.values[self.currentIndex];
    if (self.values[self.currentIndex] > self.max) self.max = self.values[self.currentIndex];
    
}

- (void) setAllValues:(CGFloat)value {
    dispatch_apply(self.numValues, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        self.values[i] = value;
    });
    
    self.min = value;
    self.max = value;
    self.sum = (CGFloat)self.numValues * value;
}

- (void) addOtherDataSetValues:(MLDataSet *)otherDataSet {
    if (!otherDataSet) return;
    if (self.numValues != otherDataSet.numValues) return;
        
    if (otherDataSet.values) {
        self.max = self.values[0] + otherDataSet.values[0];
        self.min = self.values[0] + otherDataSet.values[0];
        self.sum = 0;
        
        for (NSInteger i = 0; i < self.numValues; i++) {
            self.values[i] += otherDataSet.values[i];
            
            if (self.max < self.values[i]) self.max = self.values[i];
            if (self.min > self.values[i]) self.min = self.values[i];
            self.sum += self.values[i];
        }
    }
}


- (void) subtractOtherDataSetValues:(MLDataSet *)otherDataSet {
    if (!otherDataSet) return;
    if (self.numValues != otherDataSet.numValues) return;
    
    if (otherDataSet.values) {
        self.max = self.values[0] - otherDataSet.values[0];
        self.min = self.values[0] - otherDataSet.values[0];
        self.sum = 0;

        for (NSInteger i = 0; i < self.numValues; i++) {
            self.values[i] -= otherDataSet.values[i];
            
            if (self.max < self.values[i]) self.max = self.values[i];
            if (self.min > self.values[i]) self.min = self.values[i];
            self.sum += self.values[i];
        }
    }
}

- (void) divideAllValuesBy:(CGFloat)dividend {
    if (dividend == 0) return;
    
    self.max = self.values[0] / dividend;
    self.min = self.values[0] / dividend;
    
    for (NSInteger i = 0; i < self.numValues; i++) {
        self.values[i] /= dividend;
        
        if (self.max < self.values[i]) self.max = self.values[i];
        if (self.min > self.values[i]) self.min = self.values[i];
    }
}

- (void) dealloc {
    if (_values) free(_values);
}


@end

