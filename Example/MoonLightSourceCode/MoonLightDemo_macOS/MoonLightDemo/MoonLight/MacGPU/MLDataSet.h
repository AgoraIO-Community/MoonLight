//
//  MLDataSet.h
//
//  Created by LJJ on 2020/11/18.
//  Copyright © 2020 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MLDataSet : NSObject

@property (nonatomic, assign) CGFloat *values;
@property (nonatomic, assign) size_t numValues;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat sum;

- (instancetype) initWithContentsOfOtherDataSet:(MLDataSet *)otherDataSet;

- (CGFloat) average;
- (CGFloat) currentValue;
- (void) valuesInOrder:(CGFloat *)destinationArray;

- (void) reset;
- (void) resize:(size_t)newNumValues;
- (void) setNextValue:(CGFloat)nextVal;
- (void) setAllValues:(CGFloat)value;
- (void) addOtherDataSetValues:(MLDataSet *)otherDataSet;
- (void) subtractOtherDataSetValues:(MLDataSet *)otherDataSet;
- (void) divideAllValuesBy:(CGFloat)dividend;

@end

NS_ASSUME_NONNULL_END


