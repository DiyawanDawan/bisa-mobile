// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketplaceState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketplaceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketplaceState()';
}


}

/// @nodoc
class $MarketplaceStateCopyWith<$Res>  {
$MarketplaceStateCopyWith(MarketplaceState _, $Res Function(MarketplaceState) __);
}


/// Adds pattern-matching-related methods to [MarketplaceState].
extension MarketplaceStatePatterns on MarketplaceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _SuppliersLoaded value)?  suppliersLoaded,TResult Function( _CollectionsLoaded value)?  collectionsLoaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _SuppliersLoaded() when suppliersLoaded != null:
return suppliersLoaded(_that);case _CollectionsLoaded() when collectionsLoaded != null:
return collectionsLoaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _SuppliersLoaded value)  suppliersLoaded,required TResult Function( _CollectionsLoaded value)  collectionsLoaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _SuppliersLoaded():
return suppliersLoaded(_that);case _CollectionsLoaded():
return collectionsLoaded(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _SuppliersLoaded value)?  suppliersLoaded,TResult? Function( _CollectionsLoaded value)?  collectionsLoaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _SuppliersLoaded() when suppliersLoaded != null:
return suppliersLoaded(_that);case _CollectionsLoaded() when collectionsLoaded != null:
return collectionsLoaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ProductEntity> products,  bool hasReachedMax)?  loaded,TResult Function( List<SupplierModel> suppliers)?  suppliersLoaded,TResult Function( List<ProductCollectionEntity> collections)?  collectionsLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.products,_that.hasReachedMax);case _SuppliersLoaded() when suppliersLoaded != null:
return suppliersLoaded(_that.suppliers);case _CollectionsLoaded() when collectionsLoaded != null:
return collectionsLoaded(_that.collections);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ProductEntity> products,  bool hasReachedMax)  loaded,required TResult Function( List<SupplierModel> suppliers)  suppliersLoaded,required TResult Function( List<ProductCollectionEntity> collections)  collectionsLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.products,_that.hasReachedMax);case _SuppliersLoaded():
return suppliersLoaded(_that.suppliers);case _CollectionsLoaded():
return collectionsLoaded(_that.collections);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ProductEntity> products,  bool hasReachedMax)?  loaded,TResult? Function( List<SupplierModel> suppliers)?  suppliersLoaded,TResult? Function( List<ProductCollectionEntity> collections)?  collectionsLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.products,_that.hasReachedMax);case _SuppliersLoaded() when suppliersLoaded != null:
return suppliersLoaded(_that.suppliers);case _CollectionsLoaded() when collectionsLoaded != null:
return collectionsLoaded(_that.collections);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements MarketplaceState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketplaceState.initial()';
}


}




/// @nodoc


class _Loading implements MarketplaceState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketplaceState.loading()';
}


}




/// @nodoc


class _Loaded implements MarketplaceState {
  const _Loaded(final  List<ProductEntity> products, {this.hasReachedMax = false}): _products = products;
  

 final  List<ProductEntity> _products;
 List<ProductEntity> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@JsonKey() final  bool hasReachedMax;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),hasReachedMax);

@override
String toString() {
  return 'MarketplaceState.loaded(products: $products, hasReachedMax: $hasReachedMax)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $MarketplaceStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<ProductEntity> products, bool hasReachedMax
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,Object? hasReachedMax = null,}) {
  return _then(_Loaded(
null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _SuppliersLoaded implements MarketplaceState {
  const _SuppliersLoaded(final  List<SupplierModel> suppliers): _suppliers = suppliers;
  

 final  List<SupplierModel> _suppliers;
 List<SupplierModel> get suppliers {
  if (_suppliers is EqualUnmodifiableListView) return _suppliers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suppliers);
}


/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuppliersLoadedCopyWith<_SuppliersLoaded> get copyWith => __$SuppliersLoadedCopyWithImpl<_SuppliersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuppliersLoaded&&const DeepCollectionEquality().equals(other._suppliers, _suppliers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_suppliers));

@override
String toString() {
  return 'MarketplaceState.suppliersLoaded(suppliers: $suppliers)';
}


}

/// @nodoc
abstract mixin class _$SuppliersLoadedCopyWith<$Res> implements $MarketplaceStateCopyWith<$Res> {
  factory _$SuppliersLoadedCopyWith(_SuppliersLoaded value, $Res Function(_SuppliersLoaded) _then) = __$SuppliersLoadedCopyWithImpl;
@useResult
$Res call({
 List<SupplierModel> suppliers
});




}
/// @nodoc
class __$SuppliersLoadedCopyWithImpl<$Res>
    implements _$SuppliersLoadedCopyWith<$Res> {
  __$SuppliersLoadedCopyWithImpl(this._self, this._then);

  final _SuppliersLoaded _self;
  final $Res Function(_SuppliersLoaded) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? suppliers = null,}) {
  return _then(_SuppliersLoaded(
null == suppliers ? _self._suppliers : suppliers // ignore: cast_nullable_to_non_nullable
as List<SupplierModel>,
  ));
}


}

/// @nodoc


class _CollectionsLoaded implements MarketplaceState {
  const _CollectionsLoaded(final  List<ProductCollectionEntity> collections): _collections = collections;
  

 final  List<ProductCollectionEntity> _collections;
 List<ProductCollectionEntity> get collections {
  if (_collections is EqualUnmodifiableListView) return _collections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_collections);
}


/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionsLoadedCopyWith<_CollectionsLoaded> get copyWith => __$CollectionsLoadedCopyWithImpl<_CollectionsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionsLoaded&&const DeepCollectionEquality().equals(other._collections, _collections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_collections));

@override
String toString() {
  return 'MarketplaceState.collectionsLoaded(collections: $collections)';
}


}

/// @nodoc
abstract mixin class _$CollectionsLoadedCopyWith<$Res> implements $MarketplaceStateCopyWith<$Res> {
  factory _$CollectionsLoadedCopyWith(_CollectionsLoaded value, $Res Function(_CollectionsLoaded) _then) = __$CollectionsLoadedCopyWithImpl;
@useResult
$Res call({
 List<ProductCollectionEntity> collections
});




}
/// @nodoc
class __$CollectionsLoadedCopyWithImpl<$Res>
    implements _$CollectionsLoadedCopyWith<$Res> {
  __$CollectionsLoadedCopyWithImpl(this._self, this._then);

  final _CollectionsLoaded _self;
  final $Res Function(_CollectionsLoaded) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? collections = null,}) {
  return _then(_CollectionsLoaded(
null == collections ? _self._collections : collections // ignore: cast_nullable_to_non_nullable
as List<ProductCollectionEntity>,
  ));
}


}

/// @nodoc


class _Error implements MarketplaceState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MarketplaceState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $MarketplaceStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of MarketplaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
