import "package:flutter_test/flutter_test.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task.dart";
import "package:super_todo_app_mobile/features/tasks/domain/entities/task_status.dart";

void main() {
  group("Task Entity", () {
    const tTask1 = Task(id: 1, title: "test", projectId: 1, status: TaskStatus.todo);
    const tTask2 = Task(id: 1, title: "test", projectId: 1, status: TaskStatus.todo);
    // final tTask3 = Task(id: 2, title: "test bis", projectId: 1);

    test("doit supporter la comparaison par valeur (Equatable)", () {
      expect(tTask1, equals(tTask2));
      // expect(tTask1, equals(tTask3));
    });
  });
}
