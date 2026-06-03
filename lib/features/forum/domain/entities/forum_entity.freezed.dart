// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forum_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForumPostEntity {

 String get id; String get userId; String get title; String get content; String? get contentPreview; String get categoryId; String? get category; List<ForumMediaItem> get mediaUrls; int get upvotes; int get downvotes; int get viewCount; int get commentCount; DateTime get createdAt; ForumUserEntity get user; String? get userVote; List<ForumCommentEntity>? get comments; List<ForumUserEntity> get participants; String get status;/// Hashtag (lowercase, tanpa prefix `#`) yang diekstrak dari content.
 List<String> get tags;/// Snapshot produk yang di-mention (@produk) saat posting.
 List<ForumProductMentionEntity> get productMentions;
/// Create a copy of ForumPostEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumPostEntityCopyWith<ForumPostEntity> get copyWith => _$ForumPostEntityCopyWithImpl<ForumPostEntity>(this as ForumPostEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumPostEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentPreview, contentPreview) || other.contentPreview == contentPreview)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.productMentions, productMentions));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,title,content,contentPreview,categoryId,category,const DeepCollectionEquality().hash(mediaUrls),upvotes,downvotes,viewCount,commentCount,createdAt,user,userVote,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(participants),status,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(productMentions)]);

@override
String toString() {
  return 'ForumPostEntity(id: $id, userId: $userId, title: $title, content: $content, contentPreview: $contentPreview, categoryId: $categoryId, category: $category, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, viewCount: $viewCount, commentCount: $commentCount, createdAt: $createdAt, user: $user, userVote: $userVote, comments: $comments, participants: $participants, status: $status, tags: $tags, productMentions: $productMentions)';
}


}

/// @nodoc
abstract mixin class $ForumPostEntityCopyWith<$Res>  {
  factory $ForumPostEntityCopyWith(ForumPostEntity value, $Res Function(ForumPostEntity) _then) = _$ForumPostEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String content, String? contentPreview, String categoryId, String? category, List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, int viewCount, int commentCount, DateTime createdAt, ForumUserEntity user, String? userVote, List<ForumCommentEntity>? comments, List<ForumUserEntity> participants, String status, List<String> tags, List<ForumProductMentionEntity> productMentions
});


$ForumUserEntityCopyWith<$Res> get user;

}
/// @nodoc
class _$ForumPostEntityCopyWithImpl<$Res>
    implements $ForumPostEntityCopyWith<$Res> {
  _$ForumPostEntityCopyWithImpl(this._self, this._then);

  final ForumPostEntity _self;
  final $Res Function(ForumPostEntity) _then;

/// Create a copy of ForumPostEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? content = null,Object? contentPreview = freezed,Object? categoryId = null,Object? category = freezed,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? viewCount = null,Object? commentCount = null,Object? createdAt = null,Object? user = null,Object? userVote = freezed,Object? comments = freezed,Object? participants = null,Object? status = null,Object? tags = null,Object? productMentions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,contentPreview: freezed == contentPreview ? _self.contentPreview : contentPreview // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,mediaUrls: null == mediaUrls ? _self.mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserEntity,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<ForumCommentEntity>?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ForumUserEntity>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,productMentions: null == productMentions ? _self.productMentions : productMentions // ignore: cast_nullable_to_non_nullable
as List<ForumProductMentionEntity>,
  ));
}
/// Create a copy of ForumPostEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserEntityCopyWith<$Res> get user {
  
  return $ForumUserEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForumPostEntity].
extension ForumPostEntityPatterns on ForumPostEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumPostEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumPostEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumPostEntity value)  $default,){
final _that = this;
switch (_that) {
case _ForumPostEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumPostEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ForumPostEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String content,  String? contentPreview,  String categoryId,  String? category,  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  int viewCount,  int commentCount,  DateTime createdAt,  ForumUserEntity user,  String? userVote,  List<ForumCommentEntity>? comments,  List<ForumUserEntity> participants,  String status,  List<String> tags,  List<ForumProductMentionEntity> productMentions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumPostEntity() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.content,_that.contentPreview,_that.categoryId,_that.category,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.viewCount,_that.commentCount,_that.createdAt,_that.user,_that.userVote,_that.comments,_that.participants,_that.status,_that.tags,_that.productMentions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String content,  String? contentPreview,  String categoryId,  String? category,  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  int viewCount,  int commentCount,  DateTime createdAt,  ForumUserEntity user,  String? userVote,  List<ForumCommentEntity>? comments,  List<ForumUserEntity> participants,  String status,  List<String> tags,  List<ForumProductMentionEntity> productMentions)  $default,) {final _that = this;
switch (_that) {
case _ForumPostEntity():
return $default(_that.id,_that.userId,_that.title,_that.content,_that.contentPreview,_that.categoryId,_that.category,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.viewCount,_that.commentCount,_that.createdAt,_that.user,_that.userVote,_that.comments,_that.participants,_that.status,_that.tags,_that.productMentions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String content,  String? contentPreview,  String categoryId,  String? category,  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  int viewCount,  int commentCount,  DateTime createdAt,  ForumUserEntity user,  String? userVote,  List<ForumCommentEntity>? comments,  List<ForumUserEntity> participants,  String status,  List<String> tags,  List<ForumProductMentionEntity> productMentions)?  $default,) {final _that = this;
switch (_that) {
case _ForumPostEntity() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.content,_that.contentPreview,_that.categoryId,_that.category,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.viewCount,_that.commentCount,_that.createdAt,_that.user,_that.userVote,_that.comments,_that.participants,_that.status,_that.tags,_that.productMentions);case _:
  return null;

}
}

}

/// @nodoc


class _ForumPostEntity implements ForumPostEntity {
  const _ForumPostEntity({required this.id, required this.userId, required this.title, required this.content, this.contentPreview, required this.categoryId, this.category, final  List<ForumMediaItem> mediaUrls = const [], required this.upvotes, required this.downvotes, required this.viewCount, required this.commentCount, required this.createdAt, required this.user, this.userVote, final  List<ForumCommentEntity>? comments, final  List<ForumUserEntity> participants = const [], this.status = 'PUBLISHED', final  List<String> tags = const [], final  List<ForumProductMentionEntity> productMentions = const []}): _mediaUrls = mediaUrls,_comments = comments,_participants = participants,_tags = tags,_productMentions = productMentions;
  

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  String content;
@override final  String? contentPreview;
@override final  String categoryId;
@override final  String? category;
 final  List<ForumMediaItem> _mediaUrls;
@override@JsonKey() List<ForumMediaItem> get mediaUrls {
  if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaUrls);
}

@override final  int upvotes;
@override final  int downvotes;
@override final  int viewCount;
@override final  int commentCount;
@override final  DateTime createdAt;
@override final  ForumUserEntity user;
@override final  String? userVote;
 final  List<ForumCommentEntity>? _comments;
@override List<ForumCommentEntity>? get comments {
  final value = _comments;
  if (value == null) return null;
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ForumUserEntity> _participants;
@override@JsonKey() List<ForumUserEntity> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey() final  String status;
/// Hashtag (lowercase, tanpa prefix `#`) yang diekstrak dari content.
 final  List<String> _tags;
/// Hashtag (lowercase, tanpa prefix `#`) yang diekstrak dari content.
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Snapshot produk yang di-mention (@produk) saat posting.
 final  List<ForumProductMentionEntity> _productMentions;
/// Snapshot produk yang di-mention (@produk) saat posting.
@override@JsonKey() List<ForumProductMentionEntity> get productMentions {
  if (_productMentions is EqualUnmodifiableListView) return _productMentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_productMentions);
}


/// Create a copy of ForumPostEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumPostEntityCopyWith<_ForumPostEntity> get copyWith => __$ForumPostEntityCopyWithImpl<_ForumPostEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumPostEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentPreview, contentPreview) || other.contentPreview == contentPreview)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._mediaUrls, _mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._productMentions, _productMentions));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,userId,title,content,contentPreview,categoryId,category,const DeepCollectionEquality().hash(_mediaUrls),upvotes,downvotes,viewCount,commentCount,createdAt,user,userVote,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_participants),status,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_productMentions)]);

@override
String toString() {
  return 'ForumPostEntity(id: $id, userId: $userId, title: $title, content: $content, contentPreview: $contentPreview, categoryId: $categoryId, category: $category, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, viewCount: $viewCount, commentCount: $commentCount, createdAt: $createdAt, user: $user, userVote: $userVote, comments: $comments, participants: $participants, status: $status, tags: $tags, productMentions: $productMentions)';
}


}

/// @nodoc
abstract mixin class _$ForumPostEntityCopyWith<$Res> implements $ForumPostEntityCopyWith<$Res> {
  factory _$ForumPostEntityCopyWith(_ForumPostEntity value, $Res Function(_ForumPostEntity) _then) = __$ForumPostEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String content, String? contentPreview, String categoryId, String? category, List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, int viewCount, int commentCount, DateTime createdAt, ForumUserEntity user, String? userVote, List<ForumCommentEntity>? comments, List<ForumUserEntity> participants, String status, List<String> tags, List<ForumProductMentionEntity> productMentions
});


@override $ForumUserEntityCopyWith<$Res> get user;

}
/// @nodoc
class __$ForumPostEntityCopyWithImpl<$Res>
    implements _$ForumPostEntityCopyWith<$Res> {
  __$ForumPostEntityCopyWithImpl(this._self, this._then);

  final _ForumPostEntity _self;
  final $Res Function(_ForumPostEntity) _then;

/// Create a copy of ForumPostEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? content = null,Object? contentPreview = freezed,Object? categoryId = null,Object? category = freezed,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? viewCount = null,Object? commentCount = null,Object? createdAt = null,Object? user = null,Object? userVote = freezed,Object? comments = freezed,Object? participants = null,Object? status = null,Object? tags = null,Object? productMentions = null,}) {
  return _then(_ForumPostEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,contentPreview: freezed == contentPreview ? _self.contentPreview : contentPreview // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,mediaUrls: null == mediaUrls ? _self._mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserEntity,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<ForumCommentEntity>?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ForumUserEntity>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,productMentions: null == productMentions ? _self._productMentions : productMentions // ignore: cast_nullable_to_non_nullable
as List<ForumProductMentionEntity>,
  ));
}

/// Create a copy of ForumPostEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserEntityCopyWith<$Res> get user {
  
  return $ForumUserEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$ForumProductMentionEntity {

 String get id; String get name; String? get slug;
/// Create a copy of ForumProductMentionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumProductMentionEntityCopyWith<ForumProductMentionEntity> get copyWith => _$ForumProductMentionEntityCopyWithImpl<ForumProductMentionEntity>(this as ForumProductMentionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumProductMentionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'ForumProductMentionEntity(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class $ForumProductMentionEntityCopyWith<$Res>  {
  factory $ForumProductMentionEntityCopyWith(ForumProductMentionEntity value, $Res Function(ForumProductMentionEntity) _then) = _$ForumProductMentionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? slug
});




}
/// @nodoc
class _$ForumProductMentionEntityCopyWithImpl<$Res>
    implements $ForumProductMentionEntityCopyWith<$Res> {
  _$ForumProductMentionEntityCopyWithImpl(this._self, this._then);

  final ForumProductMentionEntity _self;
  final $Res Function(ForumProductMentionEntity) _then;

/// Create a copy of ForumProductMentionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ForumProductMentionEntity].
extension ForumProductMentionEntityPatterns on ForumProductMentionEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumProductMentionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumProductMentionEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumProductMentionEntity value)  $default,){
final _that = this;
switch (_that) {
case _ForumProductMentionEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumProductMentionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ForumProductMentionEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? slug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumProductMentionEntity() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? slug)  $default,) {final _that = this;
switch (_that) {
case _ForumProductMentionEntity():
return $default(_that.id,_that.name,_that.slug);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? slug)?  $default,) {final _that = this;
switch (_that) {
case _ForumProductMentionEntity() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return null;

}
}

}

/// @nodoc


class _ForumProductMentionEntity implements ForumProductMentionEntity {
  const _ForumProductMentionEntity({required this.id, required this.name, this.slug});
  

@override final  String id;
@override final  String name;
@override final  String? slug;

/// Create a copy of ForumProductMentionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumProductMentionEntityCopyWith<_ForumProductMentionEntity> get copyWith => __$ForumProductMentionEntityCopyWithImpl<_ForumProductMentionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumProductMentionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'ForumProductMentionEntity(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$ForumProductMentionEntityCopyWith<$Res> implements $ForumProductMentionEntityCopyWith<$Res> {
  factory _$ForumProductMentionEntityCopyWith(_ForumProductMentionEntity value, $Res Function(_ForumProductMentionEntity) _then) = __$ForumProductMentionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? slug
});




}
/// @nodoc
class __$ForumProductMentionEntityCopyWithImpl<$Res>
    implements _$ForumProductMentionEntityCopyWith<$Res> {
  __$ForumProductMentionEntityCopyWithImpl(this._self, this._then);

  final _ForumProductMentionEntity _self;
  final $Res Function(_ForumProductMentionEntity) _then;

/// Create a copy of ForumProductMentionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = freezed,}) {
  return _then(_ForumProductMentionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ForumCommentEntity {

 String get id; String get content; List<ForumMediaItem> get mediaUrls; int get upvotes; int get downvotes; DateTime get createdAt; ForumUserEntity get user; String? get userVote; List<ForumCommentEntity>? get replies;
/// Create a copy of ForumCommentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumCommentEntityCopyWith<ForumCommentEntity> get copyWith => _$ForumCommentEntityCopyWithImpl<ForumCommentEntity>(this as ForumCommentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumCommentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other.replies, replies));
}


@override
int get hashCode => Object.hash(runtimeType,id,content,const DeepCollectionEquality().hash(mediaUrls),upvotes,downvotes,createdAt,user,userVote,const DeepCollectionEquality().hash(replies));

@override
String toString() {
  return 'ForumCommentEntity(id: $id, content: $content, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, createdAt: $createdAt, user: $user, userVote: $userVote, replies: $replies)';
}


}

/// @nodoc
abstract mixin class $ForumCommentEntityCopyWith<$Res>  {
  factory $ForumCommentEntityCopyWith(ForumCommentEntity value, $Res Function(ForumCommentEntity) _then) = _$ForumCommentEntityCopyWithImpl;
@useResult
$Res call({
 String id, String content, List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, DateTime createdAt, ForumUserEntity user, String? userVote, List<ForumCommentEntity>? replies
});


$ForumUserEntityCopyWith<$Res> get user;

}
/// @nodoc
class _$ForumCommentEntityCopyWithImpl<$Res>
    implements $ForumCommentEntityCopyWith<$Res> {
  _$ForumCommentEntityCopyWithImpl(this._self, this._then);

  final ForumCommentEntity _self;
  final $Res Function(ForumCommentEntity) _then;

/// Create a copy of ForumCommentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? createdAt = null,Object? user = null,Object? userVote = freezed,Object? replies = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self.mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserEntity,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,replies: freezed == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<ForumCommentEntity>?,
  ));
}
/// Create a copy of ForumCommentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserEntityCopyWith<$Res> get user {
  
  return $ForumUserEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForumCommentEntity].
extension ForumCommentEntityPatterns on ForumCommentEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumCommentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumCommentEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumCommentEntity value)  $default,){
final _that = this;
switch (_that) {
case _ForumCommentEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumCommentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ForumCommentEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String content,  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  DateTime createdAt,  ForumUserEntity user,  String? userVote,  List<ForumCommentEntity>? replies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumCommentEntity() when $default != null:
return $default(_that.id,_that.content,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.createdAt,_that.user,_that.userVote,_that.replies);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String content,  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  DateTime createdAt,  ForumUserEntity user,  String? userVote,  List<ForumCommentEntity>? replies)  $default,) {final _that = this;
switch (_that) {
case _ForumCommentEntity():
return $default(_that.id,_that.content,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.createdAt,_that.user,_that.userVote,_that.replies);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String content,  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  DateTime createdAt,  ForumUserEntity user,  String? userVote,  List<ForumCommentEntity>? replies)?  $default,) {final _that = this;
switch (_that) {
case _ForumCommentEntity() when $default != null:
return $default(_that.id,_that.content,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.createdAt,_that.user,_that.userVote,_that.replies);case _:
  return null;

}
}

}

/// @nodoc


class _ForumCommentEntity implements ForumCommentEntity {
  const _ForumCommentEntity({required this.id, required this.content, final  List<ForumMediaItem> mediaUrls = const [], required this.upvotes, required this.downvotes, required this.createdAt, required this.user, this.userVote, final  List<ForumCommentEntity>? replies}): _mediaUrls = mediaUrls,_replies = replies;
  

@override final  String id;
@override final  String content;
 final  List<ForumMediaItem> _mediaUrls;
@override@JsonKey() List<ForumMediaItem> get mediaUrls {
  if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaUrls);
}

@override final  int upvotes;
@override final  int downvotes;
@override final  DateTime createdAt;
@override final  ForumUserEntity user;
@override final  String? userVote;
 final  List<ForumCommentEntity>? _replies;
@override List<ForumCommentEntity>? get replies {
  final value = _replies;
  if (value == null) return null;
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ForumCommentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumCommentEntityCopyWith<_ForumCommentEntity> get copyWith => __$ForumCommentEntityCopyWithImpl<_ForumCommentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumCommentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._mediaUrls, _mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other._replies, _replies));
}


@override
int get hashCode => Object.hash(runtimeType,id,content,const DeepCollectionEquality().hash(_mediaUrls),upvotes,downvotes,createdAt,user,userVote,const DeepCollectionEquality().hash(_replies));

@override
String toString() {
  return 'ForumCommentEntity(id: $id, content: $content, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, createdAt: $createdAt, user: $user, userVote: $userVote, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$ForumCommentEntityCopyWith<$Res> implements $ForumCommentEntityCopyWith<$Res> {
  factory _$ForumCommentEntityCopyWith(_ForumCommentEntity value, $Res Function(_ForumCommentEntity) _then) = __$ForumCommentEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String content, List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, DateTime createdAt, ForumUserEntity user, String? userVote, List<ForumCommentEntity>? replies
});


@override $ForumUserEntityCopyWith<$Res> get user;

}
/// @nodoc
class __$ForumCommentEntityCopyWithImpl<$Res>
    implements _$ForumCommentEntityCopyWith<$Res> {
  __$ForumCommentEntityCopyWithImpl(this._self, this._then);

  final _ForumCommentEntity _self;
  final $Res Function(_ForumCommentEntity) _then;

/// Create a copy of ForumCommentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? createdAt = null,Object? user = null,Object? userVote = freezed,Object? replies = freezed,}) {
  return _then(_ForumCommentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self._mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserEntity,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,replies: freezed == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<ForumCommentEntity>?,
  ));
}

/// Create a copy of ForumCommentEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserEntityCopyWith<$Res> get user {
  
  return $ForumUserEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$ForumUserEntity {

 String get id; String get fullName; String? get avatarUrl; String? get role; bool get isVerified;
/// Create a copy of ForumUserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumUserEntityCopyWith<ForumUserEntity> get copyWith => _$ForumUserEntityCopyWithImpl<ForumUserEntity>(this as ForumUserEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,isVerified);

@override
String toString() {
  return 'ForumUserEntity(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $ForumUserEntityCopyWith<$Res>  {
  factory $ForumUserEntityCopyWith(ForumUserEntity value, $Res Function(ForumUserEntity) _then) = _$ForumUserEntityCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? role, bool isVerified
});




}
/// @nodoc
class _$ForumUserEntityCopyWithImpl<$Res>
    implements $ForumUserEntityCopyWith<$Res> {
  _$ForumUserEntityCopyWithImpl(this._self, this._then);

  final ForumUserEntity _self;
  final $Res Function(ForumUserEntity) _then;

/// Create a copy of ForumUserEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = freezed,Object? isVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ForumUserEntity].
extension ForumUserEntityPatterns on ForumUserEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumUserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumUserEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumUserEntity value)  $default,){
final _that = this;
switch (_that) {
case _ForumUserEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumUserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ForumUserEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? role,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumUserEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.isVerified);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? role,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _ForumUserEntity():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.isVerified);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? avatarUrl,  String? role,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _ForumUserEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc


class _ForumUserEntity implements ForumUserEntity {
  const _ForumUserEntity({required this.id, required this.fullName, this.avatarUrl, this.role, this.isVerified = false});
  

@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String? role;
@override@JsonKey() final  bool isVerified;

/// Create a copy of ForumUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumUserEntityCopyWith<_ForumUserEntity> get copyWith => __$ForumUserEntityCopyWithImpl<_ForumUserEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,isVerified);

@override
String toString() {
  return 'ForumUserEntity(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$ForumUserEntityCopyWith<$Res> implements $ForumUserEntityCopyWith<$Res> {
  factory _$ForumUserEntityCopyWith(_ForumUserEntity value, $Res Function(_ForumUserEntity) _then) = __$ForumUserEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? role, bool isVerified
});




}
/// @nodoc
class __$ForumUserEntityCopyWithImpl<$Res>
    implements _$ForumUserEntityCopyWith<$Res> {
  __$ForumUserEntityCopyWithImpl(this._self, this._then);

  final _ForumUserEntity _self;
  final $Res Function(_ForumUserEntity) _then;

/// Create a copy of ForumUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = freezed,Object? isVerified = null,}) {
  return _then(_ForumUserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ForumCategoryEntity {

 String get id; String get name; String? get description; String? get categoryType;
/// Create a copy of ForumCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumCategoryEntityCopyWith<ForumCategoryEntity> get copyWith => _$ForumCategoryEntityCopyWithImpl<ForumCategoryEntity>(this as ForumCategoryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumCategoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryType, categoryType) || other.categoryType == categoryType));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,categoryType);

@override
String toString() {
  return 'ForumCategoryEntity(id: $id, name: $name, description: $description, categoryType: $categoryType)';
}


}

/// @nodoc
abstract mixin class $ForumCategoryEntityCopyWith<$Res>  {
  factory $ForumCategoryEntityCopyWith(ForumCategoryEntity value, $Res Function(ForumCategoryEntity) _then) = _$ForumCategoryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? categoryType
});




}
/// @nodoc
class _$ForumCategoryEntityCopyWithImpl<$Res>
    implements $ForumCategoryEntityCopyWith<$Res> {
  _$ForumCategoryEntityCopyWithImpl(this._self, this._then);

  final ForumCategoryEntity _self;
  final $Res Function(ForumCategoryEntity) _then;

/// Create a copy of ForumCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? categoryType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryType: freezed == categoryType ? _self.categoryType : categoryType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ForumCategoryEntity].
extension ForumCategoryEntityPatterns on ForumCategoryEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumCategoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumCategoryEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumCategoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _ForumCategoryEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumCategoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ForumCategoryEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? categoryType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumCategoryEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.categoryType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? categoryType)  $default,) {final _that = this;
switch (_that) {
case _ForumCategoryEntity():
return $default(_that.id,_that.name,_that.description,_that.categoryType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? categoryType)?  $default,) {final _that = this;
switch (_that) {
case _ForumCategoryEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.categoryType);case _:
  return null;

}
}

}

/// @nodoc


class _ForumCategoryEntity implements ForumCategoryEntity {
  const _ForumCategoryEntity({required this.id, required this.name, this.description, this.categoryType});
  

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? categoryType;

/// Create a copy of ForumCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumCategoryEntityCopyWith<_ForumCategoryEntity> get copyWith => __$ForumCategoryEntityCopyWithImpl<_ForumCategoryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumCategoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryType, categoryType) || other.categoryType == categoryType));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,categoryType);

@override
String toString() {
  return 'ForumCategoryEntity(id: $id, name: $name, description: $description, categoryType: $categoryType)';
}


}

/// @nodoc
abstract mixin class _$ForumCategoryEntityCopyWith<$Res> implements $ForumCategoryEntityCopyWith<$Res> {
  factory _$ForumCategoryEntityCopyWith(_ForumCategoryEntity value, $Res Function(_ForumCategoryEntity) _then) = __$ForumCategoryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? categoryType
});




}
/// @nodoc
class __$ForumCategoryEntityCopyWithImpl<$Res>
    implements _$ForumCategoryEntityCopyWith<$Res> {
  __$ForumCategoryEntityCopyWithImpl(this._self, this._then);

  final _ForumCategoryEntity _self;
  final $Res Function(_ForumCategoryEntity) _then;

/// Create a copy of ForumCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? categoryType = freezed,}) {
  return _then(_ForumCategoryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryType: freezed == categoryType ? _self.categoryType : categoryType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
