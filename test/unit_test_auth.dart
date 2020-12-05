import 'package:flutter_familly_app/firebase_services/auth.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

//auth mock
class MockAuth extends Mock implements Auth {}

void main() {
  final MockAuth mockAuth = MockAuth();
  setUp(() {});
  tearDown(() {});

  //test the authStateChage
  test("emit occurs");
}
