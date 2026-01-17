import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:provider/provider.dart";
import "package:super_todo_app_mobile/features/projects/presentation/manager/project_provider.dart";
import "package:super_todo_app_mobile/features/projects/presentation/pages/project_list_page.dart";

class MockProjectProvider extends Mock implements ProjectProvider {}

void main() {
  late MockProjectProvider mockProjectProvider;

  setUp(() {
    // 2. On instancie le mock avant chaque test
    mockProjectProvider = MockProjectProvider();
  });

  testWidgets("doit afficher un loader quand le provider charge", (WidgetTester tester) async {
    // On crée un mock du provider ou on injecte un état spécifique
    when(() => mockProjectProvider.isLoading).thenReturn(true);
    when(() => mockProjectProvider.projects).thenReturn([]);
    when(() => mockProjectProvider.fetchProjects()).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ProjectProvider>.value(
          value: mockProjectProvider, // Un provider dont isLoading = true
          child: const ProjectListPage(),
        ),
      ),
    );

    // On cherche le widget de chargement
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
