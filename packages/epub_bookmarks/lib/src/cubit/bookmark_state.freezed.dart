// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookmarkState {
  BookmarkSegment get selectedSegment => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookmarkStateCopyWith<BookmarkState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkStateCopyWith<$Res> {
  factory $BookmarkStateCopyWith(
          BookmarkState value, $Res Function(BookmarkState) then) =
      _$BookmarkStateCopyWithImpl<$Res, BookmarkState>;
  @useResult
  $Res call({BookmarkSegment selectedSegment});
}

/// @nodoc
class _$BookmarkStateCopyWithImpl<$Res, $Val extends BookmarkState>
    implements $BookmarkStateCopyWith<$Res> {
  _$BookmarkStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedSegment = null,
  }) {
    return _then(_value.copyWith(
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BookmarkSegment selectedSegment});
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedSegment = null,
  }) {
    return _then(_$InitialImpl(
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl({this.selectedSegment = BookmarkSegment.bookmark});

  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.initial(selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return initial(selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return initial?.call(selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements BookmarkState {
  const factory _Initial({final BookmarkSegment selectedSegment}) =
      _$InitialImpl;

  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BookmarkSegment selectedSegment});
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedSegment = null,
  }) {
    return _then(_$LoadingImpl(
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl({this.selectedSegment = BookmarkSegment.bookmark});

  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.loading(selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingImpl &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadingImplCopyWith<_$LoadingImpl> get copyWith =>
      __$$LoadingImplCopyWithImpl<_$LoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return loading(selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return loading?.call(selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements BookmarkState {
  const factory _Loading({final BookmarkSegment selectedSegment}) =
      _$LoadingImpl;

  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadingImplCopyWith<_$LoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BookmarksLoadedImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$BookmarksLoadedImplCopyWith(_$BookmarksLoadedImpl value,
          $Res Function(_$BookmarksLoadedImpl) then) =
      __$$BookmarksLoadedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Bookmark> bookmarks, BookmarkSegment selectedSegment});
}

/// @nodoc
class __$$BookmarksLoadedImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$BookmarksLoadedImpl>
    implements _$$BookmarksLoadedImplCopyWith<$Res> {
  __$$BookmarksLoadedImplCopyWithImpl(
      _$BookmarksLoadedImpl _value, $Res Function(_$BookmarksLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookmarks = null,
    Object? selectedSegment = null,
  }) {
    return _then(_$BookmarksLoadedImpl(
      bookmarks: null == bookmarks
          ? _value._bookmarks
          : bookmarks // ignore: cast_nullable_to_non_nullable
              as List<Bookmark>,
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }
}

/// @nodoc

class _$BookmarksLoadedImpl implements _BookmarksLoaded {
  const _$BookmarksLoadedImpl(
      {required final List<Bookmark> bookmarks,
      this.selectedSegment = BookmarkSegment.bookmark})
      : _bookmarks = bookmarks;

  final List<Bookmark> _bookmarks;
  @override
  List<Bookmark> get bookmarks {
    if (_bookmarks is EqualUnmodifiableListView) return _bookmarks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookmarks);
  }

  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.bookmarksLoaded(bookmarks: $bookmarks, selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookmarksLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._bookmarks, _bookmarks) &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_bookmarks), selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookmarksLoadedImplCopyWith<_$BookmarksLoadedImpl> get copyWith =>
      __$$BookmarksLoadedImplCopyWithImpl<_$BookmarksLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return bookmarksLoaded(bookmarks, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return bookmarksLoaded?.call(bookmarks, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (bookmarksLoaded != null) {
      return bookmarksLoaded(bookmarks, selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return bookmarksLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return bookmarksLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (bookmarksLoaded != null) {
      return bookmarksLoaded(this);
    }
    return orElse();
  }
}

abstract class _BookmarksLoaded implements BookmarkState {
  const factory _BookmarksLoaded(
      {required final List<Bookmark> bookmarks,
      final BookmarkSegment selectedSegment}) = _$BookmarksLoadedImpl;

  List<Bookmark> get bookmarks;
  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookmarksLoadedImplCopyWith<_$BookmarksLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HistoryLoadedImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$HistoryLoadedImplCopyWith(
          _$HistoryLoadedImpl value, $Res Function(_$HistoryLoadedImpl) then) =
      __$$HistoryLoadedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<History> history, BookmarkSegment selectedSegment});
}

/// @nodoc
class __$$HistoryLoadedImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$HistoryLoadedImpl>
    implements _$$HistoryLoadedImplCopyWith<$Res> {
  __$$HistoryLoadedImplCopyWithImpl(
      _$HistoryLoadedImpl _value, $Res Function(_$HistoryLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? history = null,
    Object? selectedSegment = null,
  }) {
    return _then(_$HistoryLoadedImpl(
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<History>,
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }
}

/// @nodoc

class _$HistoryLoadedImpl implements _HistoryLoaded {
  const _$HistoryLoadedImpl(
      {required final List<History> history,
      this.selectedSegment = BookmarkSegment.history})
      : _history = history;

  final List<History> _history;
  @override
  List<History> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.historyLoaded(history: $history, selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryLoadedImpl &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_history), selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryLoadedImplCopyWith<_$HistoryLoadedImpl> get copyWith =>
      __$$HistoryLoadedImplCopyWithImpl<_$HistoryLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return historyLoaded(history, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return historyLoaded?.call(history, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (historyLoaded != null) {
      return historyLoaded(history, selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return historyLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return historyLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (historyLoaded != null) {
      return historyLoaded(this);
    }
    return orElse();
  }
}

abstract class _HistoryLoaded implements BookmarkState {
  const factory _HistoryLoaded(
      {required final List<History> history,
      final BookmarkSegment selectedSegment}) = _$HistoryLoadedImpl;

  List<History> get history;
  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryLoadedImplCopyWith<_$HistoryLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BookmarkTappedImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$BookmarkTappedImplCopyWith(_$BookmarkTappedImpl value,
          $Res Function(_$BookmarkTappedImpl) then) =
      __$$BookmarkTappedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Bookmark bookmark, BookmarkSegment selectedSegment});

  $BookmarkCopyWith<$Res> get bookmark;
}

/// @nodoc
class __$$BookmarkTappedImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$BookmarkTappedImpl>
    implements _$$BookmarkTappedImplCopyWith<$Res> {
  __$$BookmarkTappedImplCopyWithImpl(
      _$BookmarkTappedImpl _value, $Res Function(_$BookmarkTappedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookmark = null,
    Object? selectedSegment = null,
  }) {
    return _then(_$BookmarkTappedImpl(
      bookmark: null == bookmark
          ? _value.bookmark
          : bookmark // ignore: cast_nullable_to_non_nullable
              as Bookmark,
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookmarkCopyWith<$Res> get bookmark {
    return $BookmarkCopyWith<$Res>(_value.bookmark, (value) {
      return _then(_value.copyWith(bookmark: value));
    });
  }
}

/// @nodoc

class _$BookmarkTappedImpl implements _BookmarkTapped {
  const _$BookmarkTappedImpl(
      {required this.bookmark,
      this.selectedSegment = BookmarkSegment.bookmark});

  @override
  final Bookmark bookmark;
  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.bookmarkTapped(bookmark: $bookmark, selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookmarkTappedImpl &&
            (identical(other.bookmark, bookmark) ||
                other.bookmark == bookmark) &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bookmark, selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookmarkTappedImplCopyWith<_$BookmarkTappedImpl> get copyWith =>
      __$$BookmarkTappedImplCopyWithImpl<_$BookmarkTappedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return bookmarkTapped(bookmark, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return bookmarkTapped?.call(bookmark, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (bookmarkTapped != null) {
      return bookmarkTapped(bookmark, selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return bookmarkTapped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return bookmarkTapped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (bookmarkTapped != null) {
      return bookmarkTapped(this);
    }
    return orElse();
  }
}

abstract class _BookmarkTapped implements BookmarkState {
  const factory _BookmarkTapped(
      {required final Bookmark bookmark,
      final BookmarkSegment selectedSegment}) = _$BookmarkTappedImpl;

  Bookmark get bookmark;
  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookmarkTappedImplCopyWith<_$BookmarkTappedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HistoryTappedImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$HistoryTappedImplCopyWith(
          _$HistoryTappedImpl value, $Res Function(_$HistoryTappedImpl) then) =
      __$$HistoryTappedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({History history, BookmarkSegment selectedSegment});

  $HistoryCopyWith<$Res> get history;
}

/// @nodoc
class __$$HistoryTappedImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$HistoryTappedImpl>
    implements _$$HistoryTappedImplCopyWith<$Res> {
  __$$HistoryTappedImplCopyWithImpl(
      _$HistoryTappedImpl _value, $Res Function(_$HistoryTappedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? history = null,
    Object? selectedSegment = null,
  }) {
    return _then(_$HistoryTappedImpl(
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as History,
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HistoryCopyWith<$Res> get history {
    return $HistoryCopyWith<$Res>(_value.history, (value) {
      return _then(_value.copyWith(history: value));
    });
  }
}

/// @nodoc

class _$HistoryTappedImpl implements _HistoryTapped {
  const _$HistoryTappedImpl(
      {required this.history, this.selectedSegment = BookmarkSegment.history});

  @override
  final History history;
  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.historyTapped(history: $history, selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryTappedImpl &&
            (identical(other.history, history) || other.history == history) &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, history, selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryTappedImplCopyWith<_$HistoryTappedImpl> get copyWith =>
      __$$HistoryTappedImplCopyWithImpl<_$HistoryTappedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return historyTapped(history, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return historyTapped?.call(history, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (historyTapped != null) {
      return historyTapped(history, selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return historyTapped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return historyTapped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (historyTapped != null) {
      return historyTapped(this);
    }
    return orElse();
  }
}

abstract class _HistoryTapped implements BookmarkState {
  const factory _HistoryTapped(
      {required final History history,
      final BookmarkSegment selectedSegment}) = _$HistoryTappedImpl;

  History get history;
  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryTappedImplCopyWith<_$HistoryTappedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ShowClearDialogImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$ShowClearDialogImplCopyWith(_$ShowClearDialogImpl value,
          $Res Function(_$ShowClearDialogImpl) then) =
      __$$ShowClearDialogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BookmarkSegment segment, BookmarkSegment selectedSegment});
}

/// @nodoc
class __$$ShowClearDialogImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$ShowClearDialogImpl>
    implements _$$ShowClearDialogImplCopyWith<$Res> {
  __$$ShowClearDialogImplCopyWithImpl(
      _$ShowClearDialogImpl _value, $Res Function(_$ShowClearDialogImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segment = null,
    Object? selectedSegment = null,
  }) {
    return _then(_$ShowClearDialogImpl(
      segment: null == segment
          ? _value.segment
          : segment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }
}

/// @nodoc

class _$ShowClearDialogImpl implements _ShowClearDialog {
  const _$ShowClearDialogImpl(
      {required this.segment, this.selectedSegment = BookmarkSegment.bookmark});

  @override
  final BookmarkSegment segment;
  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.showClearDialog(segment: $segment, selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShowClearDialogImpl &&
            (identical(other.segment, segment) || other.segment == segment) &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, segment, selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShowClearDialogImplCopyWith<_$ShowClearDialogImpl> get copyWith =>
      __$$ShowClearDialogImplCopyWithImpl<_$ShowClearDialogImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return showClearDialog(segment, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return showClearDialog?.call(segment, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (showClearDialog != null) {
      return showClearDialog(segment, selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return showClearDialog(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return showClearDialog?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (showClearDialog != null) {
      return showClearDialog(this);
    }
    return orElse();
  }
}

abstract class _ShowClearDialog implements BookmarkState {
  const factory _ShowClearDialog(
      {required final BookmarkSegment segment,
      final BookmarkSegment selectedSegment}) = _$ShowClearDialogImpl;

  BookmarkSegment get segment;
  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShowClearDialogImplCopyWith<_$ShowClearDialogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res>
    implements $BookmarkStateCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, BookmarkSegment selectedSegment});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$BookmarkStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? selectedSegment = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      selectedSegment: null == selectedSegment
          ? _value.selectedSegment
          : selectedSegment // ignore: cast_nullable_to_non_nullable
              as BookmarkSegment,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(
      {required this.message, this.selectedSegment = BookmarkSegment.bookmark});

  @override
  final String message;
  @override
  @JsonKey()
  final BookmarkSegment selectedSegment;

  @override
  String toString() {
    return 'BookmarkState.error(message: $message, selectedSegment: $selectedSegment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.selectedSegment, selectedSegment) ||
                other.selectedSegment == selectedSegment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, selectedSegment);

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BookmarkSegment selectedSegment) initial,
    required TResult Function(BookmarkSegment selectedSegment) loading,
    required TResult Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)
        bookmarksLoaded,
    required TResult Function(
            List<History> history, BookmarkSegment selectedSegment)
        historyLoaded,
    required TResult Function(
            Bookmark bookmark, BookmarkSegment selectedSegment)
        bookmarkTapped,
    required TResult Function(History history, BookmarkSegment selectedSegment)
        historyTapped,
    required TResult Function(
            BookmarkSegment segment, BookmarkSegment selectedSegment)
        showClearDialog,
    required TResult Function(String message, BookmarkSegment selectedSegment)
        error,
  }) {
    return error(message, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(BookmarkSegment selectedSegment)? initial,
    TResult? Function(BookmarkSegment selectedSegment)? loading,
    TResult? Function(
            List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult? Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult? Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult? Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult? Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult? Function(String message, BookmarkSegment selectedSegment)? error,
  }) {
    return error?.call(message, selectedSegment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BookmarkSegment selectedSegment)? initial,
    TResult Function(BookmarkSegment selectedSegment)? loading,
    TResult Function(List<Bookmark> bookmarks, BookmarkSegment selectedSegment)?
        bookmarksLoaded,
    TResult Function(List<History> history, BookmarkSegment selectedSegment)?
        historyLoaded,
    TResult Function(Bookmark bookmark, BookmarkSegment selectedSegment)?
        bookmarkTapped,
    TResult Function(History history, BookmarkSegment selectedSegment)?
        historyTapped,
    TResult Function(BookmarkSegment segment, BookmarkSegment selectedSegment)?
        showClearDialog,
    TResult Function(String message, BookmarkSegment selectedSegment)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, selectedSegment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_BookmarksLoaded value) bookmarksLoaded,
    required TResult Function(_HistoryLoaded value) historyLoaded,
    required TResult Function(_BookmarkTapped value) bookmarkTapped,
    required TResult Function(_HistoryTapped value) historyTapped,
    required TResult Function(_ShowClearDialog value) showClearDialog,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult? Function(_HistoryLoaded value)? historyLoaded,
    TResult? Function(_BookmarkTapped value)? bookmarkTapped,
    TResult? Function(_HistoryTapped value)? historyTapped,
    TResult? Function(_ShowClearDialog value)? showClearDialog,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_BookmarksLoaded value)? bookmarksLoaded,
    TResult Function(_HistoryLoaded value)? historyLoaded,
    TResult Function(_BookmarkTapped value)? bookmarkTapped,
    TResult Function(_HistoryTapped value)? historyTapped,
    TResult Function(_ShowClearDialog value)? showClearDialog,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements BookmarkState {
  const factory _Error(
      {required final String message,
      final BookmarkSegment selectedSegment}) = _$ErrorImpl;

  String get message;
  @override
  BookmarkSegment get selectedSegment;

  /// Create a copy of BookmarkState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
