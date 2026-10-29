# Task 1.3: add ALL core packages in ONE go (run once from the project root).
# Using `flutter pub add` lets pub pick versions that are compatible with the
# firebase_core / cloud_firestore versions already in pubspec.yaml.
#
# Usage (PowerShell, from smart_health_app/):
#   .\scripts\add_packages.ps1
#
# Already present (skipped here): firebase_core, firebase_auth, cloud_firestore,
# firebase_storage, flutter_bloc, get_it, go_router, shared_preferences,
# image_picker, dartz, flutter_svg.

$ErrorActionPreference = 'Stop'

$deps = @(
  'firebase_analytics',
  'firebase_crashlytics',
  'equatable',
  'hive',
  'hive_flutter',
  'intl',
  'cached_network_image',
  'connectivity_plus',
  'url_launcher',
  'share_plus',
  'permission_handler',
  'geolocator',
  'flutter_image_compress',
  'flutter_local_notifications',
  'timezone',
  'google_sign_in',
  'dio'
)

$devDeps = @(
  'dev:bloc_test',
  'dev:mocktail',
  'dev:fake_cloud_firestore',
  'dev:firebase_auth_mocks',
  'dev:very_good_analysis'
)

Write-Host 'Adding dependencies...' -ForegroundColor Cyan
flutter pub add @deps

Write-Host 'Adding dev dependencies...' -ForegroundColor Cyan
flutter pub add @devDeps

Write-Host 'Done. Now run: flutter pub get ; flutter analyze' -ForegroundColor Green
