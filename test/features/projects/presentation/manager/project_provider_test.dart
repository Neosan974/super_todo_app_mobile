import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:super_todo_app_mobile/features/projects/domain/entities/project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/delete_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/get_projects.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/add_project.dart";
import "package:super_todo_app_mobile/features/projects/domain/usecases/update_project.dart";
import "package:super_todo_app_mobile/features/projects/presentation/manager/project_provider.dart";

// On mock les Use Cases car on veut tester uniquement la logique du Provider
class MockGetProjects extends Mock implements GetProjects {}

class MockAddProject extends Mock implements AddProject {}

class MockUpdateProject extends Mock implements UpdateProject {}

class MockDeleteProject extends Mock implements DeleteProject {}

void main() {
  late ProjectProvider provider;
  late MockGetProjects mockGetProjects;
  late MockAddProject mockAddProject;
  late MockUpdateProject mockUpdateProject;
  late MockDeleteProject mockDeleteProject;

  setUp(() {
    mockGetProjects = MockGetProjects();
    mockAddProject = MockAddProject();
    mockUpdateProject = MockUpdateProject();
    mockDeleteProject = MockDeleteProject();
    provider = ProjectProvider(
      getProjectsUseCase: mockGetProjects,
      addProjectUseCase: mockAddProject,
      updateProjectUseCase: mockUpdateProject,
      deleteProjectUseCase: mockDeleteProject,
    );
  });

  setUpAll(() {
    registerFallbackValue(Project(name: "name", description: "description", createdAt: DateTime.now()));
  });

  test("isLoading doit être vrai pendant la récupération des projets", () async {
    // Arrange
    when(() => mockGetProjects.execute()).thenAnswer((_) async => []);

    // Act
    final future = provider.fetchProjects();

    // Assert : Pendant que le futur tourne, isLoading doit être à true
    expect(provider.isLoading, true);

    await future;

    // Après le futur, isLoading repasse à false
    expect(provider.isLoading, false);
    verify(() => mockGetProjects.execute()).called(1);
  });

  test("doit exposer la liste des projets via le getter projects", () async {
    final tProject = Project(name: "name", createdAt: DateTime.now());
    // Arrange : On prépare le mock pour retourner une liste
    when(() => mockGetProjects.execute()).thenAnswer((_) async => [tProject]);

    // Act
    await provider.fetchProjects();

    // Assert
    // En appelant 'provider.projects', tu exécutes la ligne 25
    expect(provider.projects, isA<List<Project>>());
    expect(provider.projects.length, 1);
    expect(provider.projects.first, tProject);
  });

  test("doit ajouter un projet avec succès", () async {
    // Arrange
    const tName = "Nouveau Projet";
    const tDesc = "Description";

    // On doit enregistrer un "FallbackValue" pour Mocktail si on utilise any()
    // Mais ici on utilise le match précis, donc on mock le comportement attendu :
    when(() => mockAddProject.execute(any())).thenAnswer((_) async => {});
    when(() => mockGetProjects.execute()).thenAnswer((_) async => []);

    // Act
    await provider.createProject(tName, tDesc);

    // Assert
    verify(() => mockAddProject.execute(any())).called(1);
    verify(() => mockGetProjects.execute()).called(1);
  });

  test("doit gérer les erreurs lors de la récupération", () async {
    // Arrange
    when(() => mockGetProjects.execute()).thenThrow(Exception("Erreur BDD"));

    // Act
    await provider.fetchProjects();

    // Assert
    expect(provider.isLoading, false);
    // Ici tu pourrais vérifier si tu as une variable 'errorMessage' dans ton provider
  });

  test("doit modifier un projet avec succès", () async {
    // Arrange
    final projectToUpdate = Project(
      id: 1,
      name: "Nom Modifié",
      description: "Desc Modifiée",
      createdAt: DateTime.now(),
    );

    // On mock l'update et le rafraîchissement automatique de la liste
    when(() => mockUpdateProject.execute(projectToUpdate)).thenAnswer((_) async => {});
    when(() => mockGetProjects.execute()).thenAnswer((_) async => []);

    // Act
    await provider.editProject(projectToUpdate); // Assure-toi que le nom de la méthode correspond dans ton provider

    // Assert
    verify(() => mockUpdateProject.execute(projectToUpdate)).called(1);
    verify(() => mockGetProjects.execute()).called(1);
  });

  test("doit supprimer un projet avec succès", () async {
    // Arrange
    const projectId = 1;
    when(() => mockDeleteProject.execute(projectId)).thenAnswer((_) async => {});
    when(() => mockGetProjects.execute()).thenAnswer((_) async => []);

    // Act
    await provider.removeProject(projectId); // Vérifie le nom de ta méthode (removeProject ou deleteProject)

    // Assert
    verify(() => mockDeleteProject.execute(projectId)).called(1);
    verify(() => mockGetProjects.execute()).called(1);
  });
}
