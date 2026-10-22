import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stateful_lab_abenoja/main.dart';

void main() {
  group('CartScreen - initial render', () {
    testWidgets('shows the app bar and the three seeded items', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      expect(find.text('Mini Shopping Cart'), findsOneWidget);
      expect(find.text('Rice'), findsOneWidget);
      expect(find.text('Eggs'), findsOneWidget);
      expect(find.text('Milk'), findsOneWidget);
    });

    testWidgets('computes the starting total from the seeded items',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      // 60 x 2 + 8 x 12 + 95 x 1 = 311
      expect(find.text('Total: PHP 311.00'), findsOneWidget);
      expect(find.textContaining('Items: 3'), findsOneWidget);
      expect(find.textContaining('Got it: 0'), findsOneWidget);
    });
  });

  group('CartScreen - quantity buttons', () {
    testWidgets('the + button raises the quantity and the total',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      final riceTile = find.ancestor(
        of: find.text('Rice'),
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(of: riceTile, matching: find.byIcon(Icons.add_circle_outline)),
      );
      await tester.pump();

      expect(find.text('3'), findsOneWidget);
      // 60 x 3 + 8 x 12 + 95 x 1 = 371
      expect(find.text('Total: PHP 371.00'), findsOneWidget);
    });

    testWidgets('the - button lowers the quantity and the total',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      final riceTile = find.ancestor(
        of: find.text('Rice'),
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(
          of: riceTile,
          matching: find.byIcon(Icons.remove_circle_outline),
        ),
      );
      await tester.pump();

      expect(
        find.descendant(of: riceTile, matching: find.text('1')),
        findsOneWidget,
      );
      // 60 x 1 + 8 x 12 + 95 x 1 = 251
      expect(find.text('Total: PHP 251.00'), findsOneWidget);
    });

    testWidgets('quantity never goes below 1', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      final milkTile = find.ancestor(
        of: find.text('Milk'),
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(
          of: milkTile,
          matching: find.byIcon(Icons.remove_circle_outline),
        ),
      );
      await tester.pump();

      expect(find.text('1'), findsNWidgets(1));
      expect(find.text('Total: PHP 311.00'), findsOneWidget);
    });
  });

  group('CartScreen - add item form', () {
    testWidgets('shows validation errors when the form is empty',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Item name is required'), findsOneWidget);
      expect(find.text('Enter a price greater than 0'), findsOneWidget);
      expect(find.textContaining('Items: 3'), findsOneWidget);
    });

    testWidgets('adds a new item and refreshes the summary', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'Bread');
      await tester.enterText(fields.at(1), '25');
      await tester.pump();

      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Bread'), findsOneWidget);
      expect(find.text('PHP 25.00 each'), findsOneWidget);
      expect(find.textContaining('Items: 4'), findsOneWidget);
      // 311 + 25 = 336
      expect(find.text('Total: PHP 336.00'), findsOneWidget);
      // no leftover errors after a valid add
      expect(find.text('Item name is required'), findsNothing);
      expect(find.text('Enter a price greater than 0'), findsNothing);
    });
  });

  group('CartScreen - checkboxes and clear checked', () {
    testWidgets('checking an item updates the Got it counter', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      expect(find.textContaining('Got it: 1'), findsOneWidget);
      expect(find.textContaining('Got it: 0'), findsNothing);
    });

    testWidgets('Clear checked removes only the checked items', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CartScreen()));

      await tester.tap(find.byType(Checkbox).first); // check Rice
      await tester.pump();
      await tester.tap(find.text('Clear checked'));
      await tester.pump();

      expect(find.text('Rice'), findsNothing);
      expect(find.text('Eggs'), findsOneWidget);
      expect(find.text('Milk'), findsOneWidget);
      expect(find.textContaining('Items: 2'), findsOneWidget);
      // 8 x 12 + 95 x 1 = 191
      expect(find.text('Total: PHP 191.00'), findsOneWidget);
    });
  });
}
