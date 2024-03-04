import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_todo_aps/main.dart';

void main() {
  testWidgets('TodoScreen adds todo test', (WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

  // Verify the initial state.
  expect(find.text('Ayo isi todo list kamu!'), findsOneWidget);
  expect(find.text('Tambah Todo List'), findsOneWidget);

  // Tap the 'Tambah Todo List' button and trigger a frame.
  await tester.tap(find.text('Tambah Todo List'));
  await tester.pumpAndSettle(); // Wait for the dialog to fully appear.

  // Enter text into the TextField.
  await tester.enterText(find.byType(TextField), 'My Todo');

  // Tap the 'Tambah' button to add the todo.
  await tester.tap(find.text('Tambah'));
  await tester.pumpAndSettle(); // Wait for the dialog to close and the page to update.

  // Verify that the new todo is added.
  expect(find.text('My Todo'), findsOneWidget);

  // Verify that the todo list page is displayed.
  expect(find.byType(ListTile), findsOneWidget);
  expect(find.byType(ElevatedButton), findsOneWidget);
});
}
