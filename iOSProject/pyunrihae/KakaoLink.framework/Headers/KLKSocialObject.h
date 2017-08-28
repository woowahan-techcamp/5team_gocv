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
 * @class KLKSocialObject
 * @abstract 좋아요 수, 댓글 수 등의 소셜 정보를 표현하기 위해 사용되는 오브젝트입니다.
 * @discussion 5개의 속성 중 최대 3개만 표시해 줍니다. 우선순위는 <b>Like > Comment > Shared > View > Subscriber</b> 입니다.
 */
@interface KLKSocialObject : KLKParamObject

/*!
 * @property likeCount
 * @abstract 컨텐츠의 좋아요 수
 */
@property (copy, nonatomic, nullable) NSNumber *likeCount;

/*!
 * @property commnentCount
 * @abstract 컨텐츠의 댓글 수
 */
@property (copy, nonatomic, nullable) NSNumber *commnentCount;

/*!
 * @property sharedCount
 * @abstract 컨텐츠의 공유 수
 */
@property (copy, nonatomic, nullable) NSNumber *sharedCount;

/*!
 * @property viewCount
 * @abstract 컨텐츠의 조회 수
 */
@property (copy, nonatomic, nullable) NSNumber *viewCount;

/*!
 * @property subscriberCount
 * @abstract 컨텐츠의 구독 수
 */
@property (copy, nonatomic, nullable) NSNumber *subscriberCount;

@end

@interface KLKSocialBuilder : NSObject

@property (copy, nonatomic, nullable) NSNumber *likeCount;
@property (copy, nonatomic, nullable) NSNumber *commnentCount;
@property (copy, nonatomic, nullable) NSNumber *sharedCount;
@property (copy, nonatomic, nullable) NSNumber *viewCount;
@property (copy, nonatomic, nullable) NSNumber *subscriberCount;

- (KLKSocialObject *)build;

@end

@interface KLKSocialObject (ConstructorWithBuilder)

+ (instancetype)socialObjectWithBuilderBlock:(void (^)(KLKSocialBuilder *socialBuilder))builderBlock;
+ (instancetype)socialObjectWithBuilder:(KLKSocialBuilder *)builder;
- (instancetype)initWithBuilder:(KLKSocialBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
