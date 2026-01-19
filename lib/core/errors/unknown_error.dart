import "package:super_todo_app_mobile/core/errors/app_error.dart";

class UnknownError extends AppError {
  UnknownError({super.message = "Une erreur inattendue est survenue"});
}
