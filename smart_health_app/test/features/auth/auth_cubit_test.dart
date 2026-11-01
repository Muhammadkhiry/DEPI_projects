import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_health_app/core/errors/failures.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_state.dart';
import 'package:smart_health_app/features/auth/presentation/data/models/user_model.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

const _ok = Right<Failure, void>(null);

Left<Failure, void> _fail(String message) =>
    Left<Failure, void>(ServerFailure(message));

Matcher _failureWith(String message) => isA<AuthFailure>().having(
  (state) => state.errMessage,
  'errMessage',
  message,
);

void main() {
  late MockAuthRepo repo;

  setUp(() {
    repo = MockAuthRepo();
  });

  group('login', () {
    void stubLogin(Future<Either<Failure, void>> Function() answer) {
      when(
        () => repo.loginWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => answer());
    }

    blocTest<AuthCubit, AuthState>(
      'emits loading then success when the repo succeeds',
      build: () {
        stubLogin(() async => _ok);
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.login(email: 'a@b.com', password: '123456'),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
      verify: (_) {
        verify(
          () => repo.loginWithEmailAndPassword(
            email: 'a@b.com',
            password: '123456',
          ),
        ).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits loading then the failure message when the repo fails',
      build: () {
        stubLogin(() async => _fail('Incorrect email or password.'));
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.login(email: 'a@b.com', password: 'wrong'),
      expect: () => [
        isA<AuthLoading>(),
        _failureWith('Incorrect email or password.'),
      ],
    );

    test('ignores the result if the screen closed the cubit meanwhile', () async {
      // The router redirects right after sign-in, which disposes the login
      // screen (and closes its cubit) before the request finishes.
      final completer = Completer<Either<Failure, void>>();
      stubLogin(() => completer.future);

      final cubit = AuthCubit(repo);
      final request = cubit.login(email: 'a@b.com', password: '123456');
      await cubit.close();
      completer.complete(_ok);

      await expectLater(request, completes);
    });
  });

  group('signUp', () {
    blocTest<AuthCubit, AuthState>(
      'emits loading then success and passes the name to the repo',
      build: () {
        when(
          () => repo.signUpWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
          ),
        ).thenAnswer((_) async => _ok);
        return AuthCubit(repo);
      },
      act: (cubit) =>
          cubit.signUp(email: 'a@b.com', password: '123456', name: 'Sara'),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
      verify: (_) {
        verify(
          () => repo.signUpWithEmailAndPassword(
            email: 'a@b.com',
            password: '123456',
            name: 'Sara',
          ),
        ).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits the failure when the email is already registered',
      build: () {
        when(
          () => repo.signUpWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
          ),
        ).thenAnswer((_) async => _fail('This email is already registered.'));
        return AuthCubit(repo);
      },
      act: (cubit) =>
          cubit.signUp(email: 'a@b.com', password: '123456', name: 'Sara'),
      expect: () => [
        isA<AuthLoading>(),
        _failureWith('This email is already registered.'),
      ],
    );
  });

  group('sendPasswordReset', () {
    blocTest<AuthCubit, AuthState>(
      'emits loading then success',
      build: () {
        when(
          () => repo.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenAnswer((_) async => _ok);
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.sendPasswordReset(email: 'a@b.com'),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits the failure when the repo fails',
      build: () {
        when(
          () => repo.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenAnswer((_) async => _fail('No user found with this email.'));
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.sendPasswordReset(email: 'nobody@b.com'),
      expect: () => [
        isA<AuthLoading>(),
        _failureWith('No user found with this email.'),
      ],
    );
  });

  group('fetchUserData', () {
    blocTest<AuthCubit, AuthState>(
      'emits the loaded user',
      build: () {
        when(() => repo.getUserData()).thenAnswer(
          (_) async => Right<Failure, UserModel>(
            UserModel(uid: 'u1', email: 'a@b.com', name: 'Sara'),
          ),
        );
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.fetchUserData(),
      expect: () => [
        isA<AuthLoading>(),
        isA<UserDataLoaded>().having(
          (state) => state.userModel.name,
          'name',
          'Sara',
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits the failure when the user cannot be read',
      build: () {
        when(() => repo.getUserData()).thenAnswer(
          (_) async => Left<Failure, UserModel>(ServerFailure('No profile')),
        );
        return AuthCubit(repo);
      },
      act: (cubit) => cubit.fetchUserData(),
      expect: () => [isA<AuthLoading>(), _failureWith('No profile')],
    );
  });
}
