import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fit_strong/main.dart';

void main() {
  testWidgets('home dashboard renders', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FitStrongApp());
    expect(find.text('PUSH YOUR LIMITS'), findsOneWidget);
    expect(find.text('EVERY DAY'), findsOneWidget);
    expect(find.text("Today's Progress"), findsOneWidget);
    expect(find.text('68%'), findsOneWidget);
  });

  testWidgets('bottom navigation opens workouts and progress', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FitStrongApp());
    await tester.tap(find.text('Workouts').last);
    await tester.pumpAndSettle();
    expect(find.text('next workout.'), findsOneWidget);
    expect(find.text('Workout library'), findsOneWidget);

    await tester.tap(find.text('Progress').last);
    await tester.pumpAndSettle();
    expect(find.text('Your activity'), findsOneWidget);
    expect(find.text('7,842'), findsOneWidget);
  });

  testWidgets('workout category filter narrows the list', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FitStrongApp());
    await tester.tap(find.text('Workouts').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cardio').first);
    await tester.pumpAndSettle();

    expect(find.text('HIIT Cardio'), findsOneWidget);
    expect(find.text('Upper Body Strength'), findsNothing);
  });

  testWidgets('a workout can be started and completed', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FitStrongApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Start session'), findsOneWidget);
    await tester.tap(find.text('Start session'));
    await tester.pumpAndSettle();
    expect(find.text('Complete workout'), findsOneWidget);
    await tester.tap(find.text('Complete workout'));
    await tester.pumpAndSettle();
    expect(find.text('Workout completed. Great work!'), findsOneWidget);
  });
}
