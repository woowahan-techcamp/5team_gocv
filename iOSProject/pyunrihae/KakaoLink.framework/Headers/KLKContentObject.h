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

@class KLKLinkObject;

/*!
 * @class KLKContentObject
 * @abstract 컨텐츠의 내용을 담고 있는 오브젝트입니다. 기본 템플릿에서는 모든 메시지에 하나 이상의 컨텐츠를 가지고 있습니다.
 * @discussion 기본 템플릿에서 사용되는 컨텐츠 오브젝트는 <b>한 개의 이미지와 제목, 설명, 링크</b> 정보를 가질 수 있습니다.
 */
@interface KLKContentObject : KLKParamObject

/*!
 * @property title
 * @abstract 컨텐츠의 타이틀.
 */
@property (copy, nonatomic) NSString *title;

/*!
 * @property imageURL
 * @abstract 컨텐츠의 이미지 URL.
 */
@property (copy, nonatomic) NSURL *imageURL;

/*!
 * @property imageWidth
 * @abstract 컨텐츠의 이미지 너비. (단위: 픽셀)
 */
@property (copy, nonatomic, nullable) NSNumber *imageWidth;

/*!
 * @property imageHeight
 * @abstract 컨텐츠의 이미지 높이. (단위: 픽셀)
 */
@property (copy, nonatomic, nullable) NSNumber *imageHeight;

/*!
 * @property desc
 * @abstract 컨텐츠의 상세 설명.
 */
@property (copy, nonatomic, nullable) NSString *desc;

/*!
 * @property link
 * @abstract 컨텐츠 클릭 시 이동할 링크 정보.
 */
@property (copy, nonatomic) KLKLinkObject *link;

@end

@interface KLKContentObject (Constructor)

+ (instancetype)contentObjectWithTitle:(NSString *)title imageURL:(NSURL *)imageURL link:(KLKLinkObject *)link;
- (instancetype)initWithTitle:(NSString *)title imageURL:(NSURL *)imageURL link:(KLKLinkObject *)link;

@end

@interface KLKContentBuilder : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSURL *imageURL;
@property (copy, nonatomic, nullable) NSNumber *imageWidth;
@property (copy, nonatomic, nullable) NSNumber *imageHeight;
@property (copy, nonatomic, nullable) NSString *desc;
@property (copy, nonatomic) KLKLinkObject *link;

- (KLKContentObject *)build;

@end

@interface KLKContentObject (ConstructorWithBuilder)

+ (instancetype)contentObjectWithBuilderBlock:(void (^)(KLKContentBuilder *contentBuilder))builderBlock;
+ (instancetype)contentObjectWithBuilder:(KLKContentBuilder *)builder;
- (instancetype)initWithBuilder:(KLKContentBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
