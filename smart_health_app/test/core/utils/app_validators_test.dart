import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_app/core/utils/app_validators.dart';

void main() {
  group('validateEmail', () {
    test('rejects empty values', () {
      expect(AppValidators.validateEmail(null), 'Email is required');
      expect(AppValidators.validateEmail(''), 'Email is required');
      expect(AppValidators.validateEmail('   '), 'Email is required');
    });

    test('rejects malformed emails', () {
      for (final email in ['abc', 'abc@', '@mail.com', 'a@b', 'a b@mail.com']) {
        expect(
          AppValidators.validateEmail(email),
          'Please enter a valid email address',
          reason: email,
        );
      }
    });

    test('accepts normal emails', () {
      for (final email in [
        'user@mail.com',
        'first.last@mail.co.uk',
        'user_name@mail.org',
        'demo@smarthealth.test',
      ]) {
        expect(AppValidators.validateEmail(email), isNull, reason: email);
      }
    });

    test('accepts plus-addressing and long domains', () {
      expect(AppValidators.validateEmail('name+tag@gmail.com'), isNull);
      expect(AppValidators.validateEmail('doctor@clinic.health'), isNull);
    });

    test('ignores spaces around the email', () {
      expect(AppValidators.validateEmail('  user@mail.com  '), isNull);
    });
  });

  group('validatePassword', () {
    test('rejects empty values', () {
      expect(AppValidators.validatePassword(null), 'Password is required');
      expect(AppValidators.validatePassword(''), 'Password is required');
    });

    test('requires at least 6 characters', () {
      expect(
        AppValidators.validatePassword('12345'),
        'Password must be at least 6 characters',
      );
      expect(AppValidators.validatePassword('123456'), isNull);
    });
  });

  group('validateName', () {
    test('rejects empty and blank names', () {
      expect(AppValidators.validateName(null), 'Name is required');
      expect(AppValidators.validateName(''), 'Name is required');
      expect(AppValidators.validateName('   '), 'Name is required');
    });

    test('accepts a name', () {
      expect(AppValidators.validateName('Sara Ali'), isNull);
    });
  });
}
