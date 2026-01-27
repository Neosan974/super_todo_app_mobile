import "package:flutter/material.dart";

enum TaskStatus {
  todo,
  inProgress,
  done
  ;

  Widget get displayWidget {
    switch (this) {
      case TaskStatus.todo:
        return const Chip(label: Text("Todo"));
      case TaskStatus.inProgress:
        return const Chip(label: Text("In Progress"));
      case TaskStatus.done:
        return const Chip(label: Text("Done"));
    }
  }
}
