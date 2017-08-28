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

#import <KakaoLink/KLKTemplate.h>

NS_ASSUME_NONNULL_BEGIN

@class KLKContentObject;
@class KLKLinkObject;
@class KLKButtonObject;

@class KLKLinkBuilder;

/*!
 * @class KLKListTemplate
 * @abstract 여러 개의 컨텐츠를 리스트 형태로 보여줄 수 있는 메시지 템플릿입니다.
 * @discussion 리스트 템플릿은 메시지 상단에 노출되는 헤더 타이틀과, 컨텐츠 목록, 버튼 등으로 구성됩니다. 헤더와 컨텐츠 각각의 링크를 가질 수 있습니다. 피드 템플릿과 마찬가지로 하나의 기본 버튼을 가지며 임의의 버튼을 설정할 수 있습니다.
 */
@interface KLKListTemplate : KLKTemplate

/*!
 * @property headerTitle
 * @abstract 리스트 상단에 노출되는 헤더 타이틀. (최대 200자)
 */
@property (copy, nonatomic) NSString *headerTitle;

/*!
 * @property headerLink
 * @abstract 헤더 타이틀 내용에 해당하는 링크 정보.
 */
@property (copy, nonatomic) KLKLinkObject *headerLink;

/*!
 * @property contents
 * @abstract 리스트에 노출되는 컨텐츠 목록. (최소 2개, 최대 3개)
 */
@property (copy, nonatomic) NSArray<KLKContentObject *> *contents;

/*!
 * @property buttonTitle
 * @abstract 기본 버튼 타이틀("자세히 보기")을 변경하고 싶을 때 설정.
 */
@property (copy, nonatomic, nullable) NSString *buttonTitle;

/*!
 * @property buttons
 * @abstract 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용. (최대 2개)
 */
@property (copy, nonatomic, nullable) NSArray<KLKButtonObject *> *buttons;

@end

@interface KLKListTemplate (Constructor)

+ (instancetype)listTemplateWithHeaderTitle:(NSString *)headerTitle
                                 headerLink:(KLKLinkObject *)headerLink
                                   contents:(NSArray<KLKContentObject *> *)contents;
- (instancetype)initWithHeaderTitle:(NSString *)headerTitle
                         headerLink:(KLKLinkObject *)headerLink
                           contents:(NSArray<KLKContentObject *> *)contents;

@end

@interface KLKListTemplateBuilder : NSObject

@property (copy, nonatomic) NSString *headerTitle;
@property (copy, nonatomic) KLKLinkObject *headerLink;
@property (copy, nonatomic) NSMutableArray<KLKContentObject *> *contents;
@property (copy, nonatomic, nullable) NSString *buttonTitle;
@property (copy, nonatomic, nullable) NSMutableArray<KLKButtonObject *> *buttons;

- (void)addContent:(KLKContentObject *)content;
- (void)addButton:(KLKButtonObject *)button;
- (KLKListTemplate *)build;

@end

@interface KLKListTemplate (ConstructorWithBuilder)

+ (instancetype)listTemplateWithBuilderBlock:(void (^)(KLKListTemplateBuilder *listTemplateBuilder))builderBlock;
+ (instancetype)listTemplateWithBuilder:(KLKListTemplateBuilder *)builder;
- (instancetype)initWithBuilder:(KLKListTemplateBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
