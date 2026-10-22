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
}
