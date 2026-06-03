// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forum_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForumPostModel {

 String get id; String get userId; String get title; String get content; String? get contentPreview; String get categoryId;@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> get mediaUrls; int get upvotes; int get downvotes; int get viewCount;@JsonKey(name: '_count') Map<String, dynamic>? get count; String get createdAt; ForumUserModel? get user; Map<String, dynamic>? get category; String? get userVote; List<ForumCommentModel>? get comments; List<ForumUserModel> get participants; String get status;@JsonKey(fromJson: _tagsFromJson) List<String> get tags;@JsonKey(name: 'productMentions', fromJson: _mentionsFromJson) List<ForumProductMentionModel> get productMentions;
/// Create a copy of ForumPostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumPostModelCopyWith<ForumPostModel> get copyWith => _$ForumPostModelCopyWithImpl<ForumPostModel>(this as ForumPostModel, _$identity);

  /// Serializes this ForumPostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumPostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentPreview, contentPreview) || other.contentPreview == contentPreview)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&const DeepCollectionEquality().equals(other.count, count)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.category, category)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.productMentions, productMentions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,title,content,contentPreview,categoryId,const DeepCollectionEquality().hash(mediaUrls),upvotes,downvotes,viewCount,const DeepCollectionEquality().hash(count),createdAt,user,const DeepCollectionEquality().hash(category),userVote,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(participants),status,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(productMentions)]);

@override
String toString() {
  return 'ForumPostModel(id: $id, userId: $userId, title: $title, content: $content, contentPreview: $contentPreview, categoryId: $categoryId, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, viewCount: $viewCount, count: $count, createdAt: $createdAt, user: $user, category: $category, userVote: $userVote, comments: $comments, participants: $participants, status: $status, tags: $tags, productMentions: $productMentions)';
}


}

/// @nodoc
abstract mixin class $ForumPostModelCopyWith<$Res>  {
  factory $ForumPostModelCopyWith(ForumPostModel value, $Res Function(ForumPostModel) _then) = _$ForumPostModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String content, String? contentPreview, String categoryId,@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, int viewCount,@JsonKey(name: '_count') Map<String, dynamic>? count, String createdAt, ForumUserModel? user, Map<String, dynamic>? category, String? userVote, List<ForumCommentModel>? comments, List<ForumUserModel> participants, String status,@JsonKey(fromJson: _tagsFromJson) List<String> tags,@JsonKey(name: 'productMentions', fromJson: _mentionsFromJson) List<ForumProductMentionModel> productMentions
});


$ForumUserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$ForumPostModelCopyWithImpl<$Res>
    implements $ForumPostModelCopyWith<$Res> {
  _$ForumPostModelCopyWithImpl(this._self, this._then);

  final ForumPostModel _self;
  final $Res Function(ForumPostModel) _then;

/// Create a copy of ForumPostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? content = null,Object? contentPreview = freezed,Object? categoryId = null,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? viewCount = null,Object? count = freezed,Object? createdAt = null,Object? user = freezed,Object? category = freezed,Object? userVote = freezed,Object? comments = freezed,Object? participants = null,Object? status = null,Object? tags = null,Object? productMentions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,contentPreview: freezed == contentPreview ? _self.contentPreview : contentPreview // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self.mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserModel?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<ForumCommentModel>?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ForumUserModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,productMentions: null == productMentions ? _self.productMentions : productMentions // ignore: cast_nullable_to_non_nullable
as List<ForumProductMentionModel>,
  ));
}
/// Create a copy of ForumPostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ForumUserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForumPostModel].
extension ForumPostModelPatterns on ForumPostModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumPostModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumPostModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumPostModel value)  $default,){
final _that = this;
switch (_that) {
case _ForumPostModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumPostModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForumPostModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String content,  String? contentPreview,  String categoryId, @JsonKey(fromJson: _mediaFromJson)  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  int viewCount, @JsonKey(name: '_count')  Map<String, dynamic>? count,  String createdAt,  ForumUserModel? user,  Map<String, dynamic>? category,  String? userVote,  List<ForumCommentModel>? comments,  List<ForumUserModel> participants,  String status, @JsonKey(fromJson: _tagsFromJson)  List<String> tags, @JsonKey(name: 'productMentions', fromJson: _mentionsFromJson)  List<ForumProductMentionModel> productMentions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumPostModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.content,_that.contentPreview,_that.categoryId,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.viewCount,_that.count,_that.createdAt,_that.user,_that.category,_that.userVote,_that.comments,_that.participants,_that.status,_that.tags,_that.productMentions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String content,  String? contentPreview,  String categoryId, @JsonKey(fromJson: _mediaFromJson)  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  int viewCount, @JsonKey(name: '_count')  Map<String, dynamic>? count,  String createdAt,  ForumUserModel? user,  Map<String, dynamic>? category,  String? userVote,  List<ForumCommentModel>? comments,  List<ForumUserModel> participants,  String status, @JsonKey(fromJson: _tagsFromJson)  List<String> tags, @JsonKey(name: 'productMentions', fromJson: _mentionsFromJson)  List<ForumProductMentionModel> productMentions)  $default,) {final _that = this;
switch (_that) {
case _ForumPostModel():
return $default(_that.id,_that.userId,_that.title,_that.content,_that.contentPreview,_that.categoryId,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.viewCount,_that.count,_that.createdAt,_that.user,_that.category,_that.userVote,_that.comments,_that.participants,_that.status,_that.tags,_that.productMentions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String content,  String? contentPreview,  String categoryId, @JsonKey(fromJson: _mediaFromJson)  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  int viewCount, @JsonKey(name: '_count')  Map<String, dynamic>? count,  String createdAt,  ForumUserModel? user,  Map<String, dynamic>? category,  String? userVote,  List<ForumCommentModel>? comments,  List<ForumUserModel> participants,  String status, @JsonKey(fromJson: _tagsFromJson)  List<String> tags, @JsonKey(name: 'productMentions', fromJson: _mentionsFromJson)  List<ForumProductMentionModel> productMentions)?  $default,) {final _that = this;
switch (_that) {
case _ForumPostModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.content,_that.contentPreview,_that.categoryId,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.viewCount,_that.count,_that.createdAt,_that.user,_that.category,_that.userVote,_that.comments,_that.participants,_that.status,_that.tags,_that.productMentions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumPostModel extends ForumPostModel {
  const _ForumPostModel({required this.id, this.userId = '', required this.title, this.content = '', this.contentPreview, this.categoryId = '', @JsonKey(fromJson: _mediaFromJson) final  List<ForumMediaItem> mediaUrls = const [], this.upvotes = 0, this.downvotes = 0, this.viewCount = 0, @JsonKey(name: '_count') final  Map<String, dynamic>? count, required this.createdAt, this.user, final  Map<String, dynamic>? category, this.userVote, final  List<ForumCommentModel>? comments, final  List<ForumUserModel> participants = const [], this.status = 'PUBLISHED', @JsonKey(fromJson: _tagsFromJson) final  List<String> tags = const [], @JsonKey(name: 'productMentions', fromJson: _mentionsFromJson) final  List<ForumProductMentionModel> productMentions = const []}): _mediaUrls = mediaUrls,_count = count,_category = category,_comments = comments,_participants = participants,_tags = tags,_productMentions = productMentions,super._();
  factory _ForumPostModel.fromJson(Map<String, dynamic> json) => _$ForumPostModelFromJson(json);

@override final  String id;
@override@JsonKey() final  String userId;
@override final  String title;
@override@JsonKey() final  String content;
@override final  String? contentPreview;
@override@JsonKey() final  String categoryId;
 final  List<ForumMediaItem> _mediaUrls;
@override@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> get mediaUrls {
  if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaUrls);
}

@override@JsonKey() final  int upvotes;
@override@JsonKey() final  int downvotes;
@override@JsonKey() final  int viewCount;
 final  Map<String, dynamic>? _count;
@override@JsonKey(name: '_count') Map<String, dynamic>? get count {
  final value = _count;
  if (value == null) return null;
  if (_count is EqualUnmodifiableMapView) return _count;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String createdAt;
@override final  ForumUserModel? user;
 final  Map<String, dynamic>? _category;
@override Map<String, dynamic>? get category {
  final value = _category;
  if (value == null) return null;
  if (_category is EqualUnmodifiableMapView) return _category;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? userVote;
 final  List<ForumCommentModel>? _comments;
@override List<ForumCommentModel>? get comments {
  final value = _comments;
  if (value == null) return null;
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ForumUserModel> _participants;
@override@JsonKey() List<ForumUserModel> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override@JsonKey() final  String status;
 final  List<String> _tags;
@override@JsonKey(fromJson: _tagsFromJson) List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<ForumProductMentionModel> _productMentions;
@override@JsonKey(name: 'productMentions', fromJson: _mentionsFromJson) List<ForumProductMentionModel> get productMentions {
  if (_productMentions is EqualUnmodifiableListView) return _productMentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_productMentions);
}


/// Create a copy of ForumPostModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumPostModelCopyWith<_ForumPostModel> get copyWith => __$ForumPostModelCopyWithImpl<_ForumPostModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumPostModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumPostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentPreview, contentPreview) || other.contentPreview == contentPreview)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other._mediaUrls, _mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&const DeepCollectionEquality().equals(other._count, _count)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._category, _category)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._productMentions, _productMentions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,title,content,contentPreview,categoryId,const DeepCollectionEquality().hash(_mediaUrls),upvotes,downvotes,viewCount,const DeepCollectionEquality().hash(_count),createdAt,user,const DeepCollectionEquality().hash(_category),userVote,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_participants),status,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_productMentions)]);

@override
String toString() {
  return 'ForumPostModel(id: $id, userId: $userId, title: $title, content: $content, contentPreview: $contentPreview, categoryId: $categoryId, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, viewCount: $viewCount, count: $count, createdAt: $createdAt, user: $user, category: $category, userVote: $userVote, comments: $comments, participants: $participants, status: $status, tags: $tags, productMentions: $productMentions)';
}


}

/// @nodoc
abstract mixin class _$ForumPostModelCopyWith<$Res> implements $ForumPostModelCopyWith<$Res> {
  factory _$ForumPostModelCopyWith(_ForumPostModel value, $Res Function(_ForumPostModel) _then) = __$ForumPostModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String content, String? contentPreview, String categoryId,@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, int viewCount,@JsonKey(name: '_count') Map<String, dynamic>? count, String createdAt, ForumUserModel? user, Map<String, dynamic>? category, String? userVote, List<ForumCommentModel>? comments, List<ForumUserModel> participants, String status,@JsonKey(fromJson: _tagsFromJson) List<String> tags,@JsonKey(name: 'productMentions', fromJson: _mentionsFromJson) List<ForumProductMentionModel> productMentions
});


@override $ForumUserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$ForumPostModelCopyWithImpl<$Res>
    implements _$ForumPostModelCopyWith<$Res> {
  __$ForumPostModelCopyWithImpl(this._self, this._then);

  final _ForumPostModel _self;
  final $Res Function(_ForumPostModel) _then;

/// Create a copy of ForumPostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? content = null,Object? contentPreview = freezed,Object? categoryId = null,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? viewCount = null,Object? count = freezed,Object? createdAt = null,Object? user = freezed,Object? category = freezed,Object? userVote = freezed,Object? comments = freezed,Object? participants = null,Object? status = null,Object? tags = null,Object? productMentions = null,}) {
  return _then(_ForumPostModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,contentPreview: freezed == contentPreview ? _self.contentPreview : contentPreview // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self._mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,count: freezed == count ? _self._count : count // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserModel?,category: freezed == category ? _self._category : category // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<ForumCommentModel>?,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ForumUserModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,productMentions: null == productMentions ? _self._productMentions : productMentions // ignore: cast_nullable_to_non_nullable
as List<ForumProductMentionModel>,
  ));
}

/// Create a copy of ForumPostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $ForumUserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$ForumProductMentionModel {

 String get id; String get name; String? get slug;
/// Create a copy of ForumProductMentionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumProductMentionModelCopyWith<ForumProductMentionModel> get copyWith => _$ForumProductMentionModelCopyWithImpl<ForumProductMentionModel>(this as ForumProductMentionModel, _$identity);

  /// Serializes this ForumProductMentionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumProductMentionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'ForumProductMentionModel(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class $ForumProductMentionModelCopyWith<$Res>  {
  factory $ForumProductMentionModelCopyWith(ForumProductMentionModel value, $Res Function(ForumProductMentionModel) _then) = _$ForumProductMentionModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? slug
});




}
/// @nodoc
class _$ForumProductMentionModelCopyWithImpl<$Res>
    implements $ForumProductMentionModelCopyWith<$Res> {
  _$ForumProductMentionModelCopyWithImpl(this._self, this._then);

  final ForumProductMentionModel _self;
  final $Res Function(ForumProductMentionModel) _then;

/// Create a copy of ForumProductMentionModel
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


/// Adds pattern-matching-related methods to [ForumProductMentionModel].
extension ForumProductMentionModelPatterns on ForumProductMentionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumProductMentionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumProductMentionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumProductMentionModel value)  $default,){
final _that = this;
switch (_that) {
case _ForumProductMentionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumProductMentionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForumProductMentionModel() when $default != null:
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
case _ForumProductMentionModel() when $default != null:
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
case _ForumProductMentionModel():
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
case _ForumProductMentionModel() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumProductMentionModel extends ForumProductMentionModel {
  const _ForumProductMentionModel({required this.id, required this.name, this.slug}): super._();
  factory _ForumProductMentionModel.fromJson(Map<String, dynamic> json) => _$ForumProductMentionModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? slug;

/// Create a copy of ForumProductMentionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumProductMentionModelCopyWith<_ForumProductMentionModel> get copyWith => __$ForumProductMentionModelCopyWithImpl<_ForumProductMentionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumProductMentionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumProductMentionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'ForumProductMentionModel(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$ForumProductMentionModelCopyWith<$Res> implements $ForumProductMentionModelCopyWith<$Res> {
  factory _$ForumProductMentionModelCopyWith(_ForumProductMentionModel value, $Res Function(_ForumProductMentionModel) _then) = __$ForumProductMentionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? slug
});




}
/// @nodoc
class __$ForumProductMentionModelCopyWithImpl<$Res>
    implements _$ForumProductMentionModelCopyWith<$Res> {
  __$ForumProductMentionModelCopyWithImpl(this._self, this._then);

  final _ForumProductMentionModel _self;
  final $Res Function(_ForumProductMentionModel) _then;

/// Create a copy of ForumProductMentionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = freezed,}) {
  return _then(_ForumProductMentionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ForumCommentModel {

 String get id; String get content;@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> get mediaUrls; int get upvotes; int get downvotes; String get createdAt; ForumUserModel get user; String? get userVote; List<ForumCommentModel>? get replies;
/// Create a copy of ForumCommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumCommentModelCopyWith<ForumCommentModel> get copyWith => _$ForumCommentModelCopyWithImpl<ForumCommentModel>(this as ForumCommentModel, _$identity);

  /// Serializes this ForumCommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumCommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.mediaUrls, mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other.replies, replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,const DeepCollectionEquality().hash(mediaUrls),upvotes,downvotes,createdAt,user,userVote,const DeepCollectionEquality().hash(replies));

@override
String toString() {
  return 'ForumCommentModel(id: $id, content: $content, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, createdAt: $createdAt, user: $user, userVote: $userVote, replies: $replies)';
}


}

/// @nodoc
abstract mixin class $ForumCommentModelCopyWith<$Res>  {
  factory $ForumCommentModelCopyWith(ForumCommentModel value, $Res Function(ForumCommentModel) _then) = _$ForumCommentModelCopyWithImpl;
@useResult
$Res call({
 String id, String content,@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, String createdAt, ForumUserModel user, String? userVote, List<ForumCommentModel>? replies
});


$ForumUserModelCopyWith<$Res> get user;

}
/// @nodoc
class _$ForumCommentModelCopyWithImpl<$Res>
    implements $ForumCommentModelCopyWith<$Res> {
  _$ForumCommentModelCopyWithImpl(this._self, this._then);

  final ForumCommentModel _self;
  final $Res Function(ForumCommentModel) _then;

/// Create a copy of ForumCommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? createdAt = null,Object? user = null,Object? userVote = freezed,Object? replies = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self.mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserModel,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,replies: freezed == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<ForumCommentModel>?,
  ));
}
/// Create a copy of ForumCommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserModelCopyWith<$Res> get user {
  
  return $ForumUserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [ForumCommentModel].
extension ForumCommentModelPatterns on ForumCommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumCommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumCommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumCommentModel value)  $default,){
final _that = this;
switch (_that) {
case _ForumCommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumCommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForumCommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String content, @JsonKey(fromJson: _mediaFromJson)  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  String createdAt,  ForumUserModel user,  String? userVote,  List<ForumCommentModel>? replies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumCommentModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String content, @JsonKey(fromJson: _mediaFromJson)  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  String createdAt,  ForumUserModel user,  String? userVote,  List<ForumCommentModel>? replies)  $default,) {final _that = this;
switch (_that) {
case _ForumCommentModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String content, @JsonKey(fromJson: _mediaFromJson)  List<ForumMediaItem> mediaUrls,  int upvotes,  int downvotes,  String createdAt,  ForumUserModel user,  String? userVote,  List<ForumCommentModel>? replies)?  $default,) {final _that = this;
switch (_that) {
case _ForumCommentModel() when $default != null:
return $default(_that.id,_that.content,_that.mediaUrls,_that.upvotes,_that.downvotes,_that.createdAt,_that.user,_that.userVote,_that.replies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumCommentModel extends ForumCommentModel {
  const _ForumCommentModel({required this.id, required this.content, @JsonKey(fromJson: _mediaFromJson) final  List<ForumMediaItem> mediaUrls = const [], this.upvotes = 0, this.downvotes = 0, required this.createdAt, required this.user, this.userVote, final  List<ForumCommentModel>? replies}): _mediaUrls = mediaUrls,_replies = replies,super._();
  factory _ForumCommentModel.fromJson(Map<String, dynamic> json) => _$ForumCommentModelFromJson(json);

@override final  String id;
@override final  String content;
 final  List<ForumMediaItem> _mediaUrls;
@override@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> get mediaUrls {
  if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaUrls);
}

@override@JsonKey() final  int upvotes;
@override@JsonKey() final  int downvotes;
@override final  String createdAt;
@override final  ForumUserModel user;
@override final  String? userVote;
 final  List<ForumCommentModel>? _replies;
@override List<ForumCommentModel>? get replies {
  final value = _replies;
  if (value == null) return null;
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ForumCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumCommentModelCopyWith<_ForumCommentModel> get copyWith => __$ForumCommentModelCopyWithImpl<_ForumCommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumCommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumCommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._mediaUrls, _mediaUrls)&&(identical(other.upvotes, upvotes) || other.upvotes == upvotes)&&(identical(other.downvotes, downvotes) || other.downvotes == downvotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.userVote, userVote) || other.userVote == userVote)&&const DeepCollectionEquality().equals(other._replies, _replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,const DeepCollectionEquality().hash(_mediaUrls),upvotes,downvotes,createdAt,user,userVote,const DeepCollectionEquality().hash(_replies));

@override
String toString() {
  return 'ForumCommentModel(id: $id, content: $content, mediaUrls: $mediaUrls, upvotes: $upvotes, downvotes: $downvotes, createdAt: $createdAt, user: $user, userVote: $userVote, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$ForumCommentModelCopyWith<$Res> implements $ForumCommentModelCopyWith<$Res> {
  factory _$ForumCommentModelCopyWith(_ForumCommentModel value, $Res Function(_ForumCommentModel) _then) = __$ForumCommentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String content,@JsonKey(fromJson: _mediaFromJson) List<ForumMediaItem> mediaUrls, int upvotes, int downvotes, String createdAt, ForumUserModel user, String? userVote, List<ForumCommentModel>? replies
});


@override $ForumUserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$ForumCommentModelCopyWithImpl<$Res>
    implements _$ForumCommentModelCopyWith<$Res> {
  __$ForumCommentModelCopyWithImpl(this._self, this._then);

  final _ForumCommentModel _self;
  final $Res Function(_ForumCommentModel) _then;

/// Create a copy of ForumCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? mediaUrls = null,Object? upvotes = null,Object? downvotes = null,Object? createdAt = null,Object? user = null,Object? userVote = freezed,Object? replies = freezed,}) {
  return _then(_ForumCommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaUrls: null == mediaUrls ? _self._mediaUrls : mediaUrls // ignore: cast_nullable_to_non_nullable
as List<ForumMediaItem>,upvotes: null == upvotes ? _self.upvotes : upvotes // ignore: cast_nullable_to_non_nullable
as int,downvotes: null == downvotes ? _self.downvotes : downvotes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ForumUserModel,userVote: freezed == userVote ? _self.userVote : userVote // ignore: cast_nullable_to_non_nullable
as String?,replies: freezed == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<ForumCommentModel>?,
  ));
}

/// Create a copy of ForumCommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForumUserModelCopyWith<$Res> get user {
  
  return $ForumUserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$ForumUserModel {

 String get id; String get fullName; String? get avatarUrl; String? get role; Map<String, dynamic>? get verification;
/// Create a copy of ForumUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumUserModelCopyWith<ForumUserModel> get copyWith => _$ForumUserModelCopyWithImpl<ForumUserModel>(this as ForumUserModel, _$identity);

  /// Serializes this ForumUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.verification, verification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,const DeepCollectionEquality().hash(verification));

@override
String toString() {
  return 'ForumUserModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, verification: $verification)';
}


}

/// @nodoc
abstract mixin class $ForumUserModelCopyWith<$Res>  {
  factory $ForumUserModelCopyWith(ForumUserModel value, $Res Function(ForumUserModel) _then) = _$ForumUserModelCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? role, Map<String, dynamic>? verification
});




}
/// @nodoc
class _$ForumUserModelCopyWithImpl<$Res>
    implements $ForumUserModelCopyWith<$Res> {
  _$ForumUserModelCopyWithImpl(this._self, this._then);

  final ForumUserModel _self;
  final $Res Function(ForumUserModel) _then;

/// Create a copy of ForumUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = freezed,Object? verification = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,verification: freezed == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ForumUserModel].
extension ForumUserModelPatterns on ForumUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumUserModel value)  $default,){
final _that = this;
switch (_that) {
case _ForumUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForumUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? role,  Map<String, dynamic>? verification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForumUserModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.verification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? role,  Map<String, dynamic>? verification)  $default,) {final _that = this;
switch (_that) {
case _ForumUserModel():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.verification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? avatarUrl,  String? role,  Map<String, dynamic>? verification)?  $default,) {final _that = this;
switch (_that) {
case _ForumUserModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.role,_that.verification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumUserModel extends ForumUserModel {
  const _ForumUserModel({required this.id, required this.fullName, this.avatarUrl, this.role, final  Map<String, dynamic>? verification}): _verification = verification,super._();
  factory _ForumUserModel.fromJson(Map<String, dynamic> json) => _$ForumUserModelFromJson(json);

@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String? role;
 final  Map<String, dynamic>? _verification;
@override Map<String, dynamic>? get verification {
  final value = _verification;
  if (value == null) return null;
  if (_verification is EqualUnmodifiableMapView) return _verification;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of ForumUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumUserModelCopyWith<_ForumUserModel> get copyWith => __$ForumUserModelCopyWithImpl<_ForumUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._verification, _verification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,role,const DeepCollectionEquality().hash(_verification));

@override
String toString() {
  return 'ForumUserModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, role: $role, verification: $verification)';
}


}

/// @nodoc
abstract mixin class _$ForumUserModelCopyWith<$Res> implements $ForumUserModelCopyWith<$Res> {
  factory _$ForumUserModelCopyWith(_ForumUserModel value, $Res Function(_ForumUserModel) _then) = __$ForumUserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? role, Map<String, dynamic>? verification
});




}
/// @nodoc
class __$ForumUserModelCopyWithImpl<$Res>
    implements _$ForumUserModelCopyWith<$Res> {
  __$ForumUserModelCopyWithImpl(this._self, this._then);

  final _ForumUserModel _self;
  final $Res Function(_ForumUserModel) _then;

/// Create a copy of ForumUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? role = freezed,Object? verification = freezed,}) {
  return _then(_ForumUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,verification: freezed == verification ? _self._verification : verification // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$ForumCategoryModel {

 String get id; String get name; String? get description; String? get categoryType;
/// Create a copy of ForumCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForumCategoryModelCopyWith<ForumCategoryModel> get copyWith => _$ForumCategoryModelCopyWithImpl<ForumCategoryModel>(this as ForumCategoryModel, _$identity);

  /// Serializes this ForumCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForumCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryType, categoryType) || other.categoryType == categoryType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,categoryType);

@override
String toString() {
  return 'ForumCategoryModel(id: $id, name: $name, description: $description, categoryType: $categoryType)';
}


}

/// @nodoc
abstract mixin class $ForumCategoryModelCopyWith<$Res>  {
  factory $ForumCategoryModelCopyWith(ForumCategoryModel value, $Res Function(ForumCategoryModel) _then) = _$ForumCategoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? categoryType
});




}
/// @nodoc
class _$ForumCategoryModelCopyWithImpl<$Res>
    implements $ForumCategoryModelCopyWith<$Res> {
  _$ForumCategoryModelCopyWithImpl(this._self, this._then);

  final ForumCategoryModel _self;
  final $Res Function(ForumCategoryModel) _then;

/// Create a copy of ForumCategoryModel
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


/// Adds pattern-matching-related methods to [ForumCategoryModel].
extension ForumCategoryModelPatterns on ForumCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForumCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForumCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForumCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ForumCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForumCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ForumCategoryModel() when $default != null:
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
case _ForumCategoryModel() when $default != null:
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
case _ForumCategoryModel():
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
case _ForumCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.categoryType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForumCategoryModel extends ForumCategoryModel {
  const _ForumCategoryModel({required this.id, required this.name, this.description, this.categoryType}): super._();
  factory _ForumCategoryModel.fromJson(Map<String, dynamic> json) => _$ForumCategoryModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? categoryType;

/// Create a copy of ForumCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForumCategoryModelCopyWith<_ForumCategoryModel> get copyWith => __$ForumCategoryModelCopyWithImpl<_ForumCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForumCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForumCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryType, categoryType) || other.categoryType == categoryType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,categoryType);

@override
String toString() {
  return 'ForumCategoryModel(id: $id, name: $name, description: $description, categoryType: $categoryType)';
}


}

/// @nodoc
abstract mixin class _$ForumCategoryModelCopyWith<$Res> implements $ForumCategoryModelCopyWith<$Res> {
  factory _$ForumCategoryModelCopyWith(_ForumCategoryModel value, $Res Function(_ForumCategoryModel) _then) = __$ForumCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? categoryType
});




}
/// @nodoc
class __$ForumCategoryModelCopyWithImpl<$Res>
    implements _$ForumCategoryModelCopyWith<$Res> {
  __$ForumCategoryModelCopyWithImpl(this._self, this._then);

  final _ForumCategoryModel _self;
  final $Res Function(_ForumCategoryModel) _then;

/// Create a copy of ForumCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? categoryType = freezed,}) {
  return _then(_ForumCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryType: freezed == categoryType ? _self.categoryType : categoryType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
