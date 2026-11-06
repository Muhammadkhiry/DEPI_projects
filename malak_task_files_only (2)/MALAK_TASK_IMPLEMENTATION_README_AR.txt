تنفيذ مهمة Malak داخل smart_health_app
=====================================

الملفات/الشاشات التي تم تنفيذها أو ربطها:
1) Home: lib/features/home/presentation/views/home_view.dart
2) Notifications: lib/features/home/presentation/views/notifications_view.dart
3) Emergency Numbers sheet + صفحة بديلة للرابط المباشر:
   lib/features/home/presentation/views/emergency_view.dart
4) Request Details لوضع Requester وDonor:
   lib/features/blood_donation/presentation/views/request_details_view.dart
   اختيار الوضع يتم من خلال query parameter:
   /bloodDonation/request-details?role=requester
   /bloodDonation/request-details?role=donor
5) Shared Widgets / States:
   lib/core/widgets/app_state_widgets.dart
   lib/core/widgets/states_sheet.dart
   lib/core/widgets/app_search_input.dart
   lib/core/widgets/smart_bottom_navigation_bar.dart
6) Blood Donation landing card لفتح وضعي تفاصيل الطلب:
   lib/features/blood_donation/presentation/views/blood_donation_view.dart

ملفات الربط والتنسيق:
- lib/core/routing/app_router.dart
- lib/core/routing/routes.dart
- lib/core/theme/app_theme.dart
- lib/core/widgets/custom_button.dart
- lib/main.dart

مهم قبل الدمج:
- بيانات Home وNotifications وBlood Request بيانات Demo ثابتة، وليست قادمة من Firebase.
- أزرار Edit / Cancel / I Can Donate تعرض تأكيدًا ورسالة محلية فقط؛ لا تُنشئ أو تعدل طلبًا في Backend.
- أرقام الطوارئ المعروضة لأرقام مصر العامة: الإسعاف 123، الشرطة 122، الحماية المدنية/المطافئ 180، شرطة السياحة 126، المرور 128، الكهرباء 121، الغاز 129. زر COPY ينسخ الرقم فقط؛ لا ينفذ اتصالًا هاتفيًا.
- لم أغير Auth أو Doctors أو Medical Records أو ملفات عمل الأعضاء الآخرين.
- لم يتم تنفيذ flutter analyze أو flutter test في بيئة المراجعة لأن Flutter/Dart SDK غير متاحين هنا. يجب تشغيلهما محليًا قبل فتح Pull Request.

خطوات التحقق على جهازك من جذر المستودع:
  cd smart_health_app
  flutter pub get
  dart format lib/main.dart lib/core/routing/app_router.dart lib/core/routing/routes.dart lib/core/theme/app_theme.dart lib/core/widgets/custom_button.dart lib/core/widgets/app_search_input.dart lib/core/widgets/app_state_widgets.dart lib/core/widgets/smart_bottom_navigation_bar.dart lib/core/widgets/states_sheet.dart lib/features/home/presentation/views/home_view.dart lib/features/home/presentation/views/notifications_view.dart lib/features/home/presentation/views/emergency_view.dart lib/features/blood_donation/presentation/views/blood_donation_view.dart lib/features/blood_donation/presentation/views/request_details_view.dart
  flutter analyze
  flutter test

لا ترفعي إلى main مباشرة. راجعي الملفات في Branch خاص بمهمتك، ثم افتحي Pull Request حسب دليل الفريق.
