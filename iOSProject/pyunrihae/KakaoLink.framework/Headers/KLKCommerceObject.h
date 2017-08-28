/**
 * Copyright 2017 Kakao Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <KakaoLink/KLKParamObject.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @class KLKCommerceObject
 * @abstract 가격, 할인율 등 커머스 정보를 나타내는 오브젝트입니다.
 * @discussion 필수 파라미터로 <b>정상 가격(regularPrice)</b>을 입력해야 합니다.
 */
@interface KLKCommerceObject : KLKParamObject

/*!
 * @property regularPrice
 * @abstract 정상 가격. (Integer)
 */
@property (copy, nonatomic) NSNumber *regularPrice;

/*!
 * @property discountPrice
 * @abstract 할인 가격. (Integer)
 */
@property (copy, nonatomic, nullable) NSNumber *discountPrice;

/*!
 * @property discountRate
 * @abstract 할인율. (Integer)
 */
@property (copy, nonatomic, nullable) NSNumber *discountRate;

@end

@interface KLKCommerceObject (Constructor)

+ (instancetype)commerceObjectWithRegularPrice:(NSNumber *)regularPrice;
- (instancetype)initWithRegularPrice:(NSNumber *)regularPrice;

@end

@interface KLKCommerceBuilder : NSObject

@property (copy, nonatomic) NSNumber *regularPrice;
@property (copy, nonatomic, nullable) NSNumber *discountPrice;
@property (copy, nonatomic, nullable) NSNumber *discountRate;

- (KLKCommerceObject *)build;

@end

@interface KLKCommerceObject (ConstructorWithBuilder)

+ (instancetype)commerceObjectWithBuilderBlock:(void (^)(KLKCommerceBuilder *commerceBuilder))builderBlock;
+ (instancetype)commerceObjectWithBuilder:(KLKCommerceBuilder *)builder;
- (instancetype)initWithBuilder:(KLKCommerceBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
