import 'dart:async';

import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder<ResultType> extends Mock
    implements PostgrestFilterBuilder<ResultType> {}

class MockPostgrestTransformBuilder<ResultType> extends Mock
    implements PostgrestTransformBuilder<ResultType> {}

class FakePostgrestFilterBuilder<ResultType> extends Fake
    implements PostgrestFilterBuilder<ResultType> {
  FakePostgrestFilterBuilder(this.value);

  final ResultType value;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(ResultType) onValue, {
    Function? onError,
  }) {
    return Future<ResultType>.value(value).then(onValue, onError: onError);
  }
}

class FakePostgrestTransformBuilder<ResultType> extends Fake
    implements PostgrestTransformBuilder<ResultType> {
  FakePostgrestTransformBuilder(this.value);

  final ResultType value;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(ResultType) onValue, {
    Function? onError,
  }) {
    return Future<ResultType>.value(value).then(onValue, onError: onError);
  }
}

class MockFailureMapper extends Mock implements FailureMapper {}
