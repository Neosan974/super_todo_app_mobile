import "package:flutter/material.dart";

enum TaskStatus {
  todo(label: "Todo"),
  inProgress(label: "In Progress"),
  done(label: "Done")
  ;

  final String label;

  const TaskStatus({required this.label});

  Widget get displayWidget => Chip(label: Text(label));
}
