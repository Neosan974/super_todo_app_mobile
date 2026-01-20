Roadmap TDD pour la Refonte de la Gestion des Tâches

  Voici les étapes à suivre. Faites-les dans l'ordre. Ne passez à l'étape suivante que lorsque tous les tests de l'étape en cours sont au vert.

  Phase 1 : Faire évoluer le Modèle de Domaine (l'Entité `Task`)

  C'est le cœur de votre logique métier. On commence toujours par là.

   * Étape 1.1 (ROUGE) : Créer un test pour le nouveau statut.
       1. Ouvrez (ou créez) test/features/tasks/domain/entities/task_test.dart.
       2. Écrivez un test qui instancie une Task avec une propriété status et une valeur TaskStatus.toDo.
       3. Ce test va échouer car status n'existe pas et l'énumération TaskStatus non plus. C'est parfait.

   * Étape 1.2 (VERT) : Implémenter le statut.
       1. Créez un nouveau fichier pour votre énumération : lib/features/tasks/domain/entities/task_status.dart. Définissez-y enum TaskStatus { toDo, inProgress, done }.
       2. Modifiez l'entité Task (lib/features/tasks/domain/entities/task.dart) :
           * Supprimez la ligne final bool isCompleted;.
           * Ajoutez final TaskStatus status;.
           * Mettez à jour le constructeur et la liste props d'Equatable.
       3. Lancez le test de l'étape 1.1. Il doit maintenant passer.

   * Étape 1.3 (REFACTOR) : Nettoyer.
       1. Parcourez le fichier task.dart. Le code est-il clair ? Les noms sont-ils explicites ? Pour l'instant, ça devrait être simple.
       2. Lancez tous les tests du projet pour vous assurer que vous n'avez rien cassé d'autre. Vous verrez que plein de tests échouent maintenant. C'est normal, nous allons les corriger au
          fur et à mesure.

  Phase 2 : Adapter la Couche de Données (Persistance)

  Maintenant que le domaine est à jour, il faut que la base de données puisse stocker cette nouvelle information.

   * Étape 2.1 (ROUGE) : Mettre à jour les tests de la base de données.
       1. Allez dans les tests de votre TaskDao (ex: test/.../datasources/task_dao_test.dart).
       2. Modifiez un test qui insère et récupère une tâche. Faites en sorte qu'il vérifie que le status de la tâche récupérée est correct.
       3. Le test va échouer car la table de la base de données et le DAO ne connaissent pas le status.

   * Étape 2.2 (VERT) : Mettre à jour la base de données et le DAO.
       1. Table de données (Drift) : Dans le fichier qui définit votre table Tasks (project_table.dart ou similaire), changez la colonne isCompleted en une colonne de texte ou d'entier pour
          le statut.
           * Conseil : Utilisez un TypeConverter de Drift pour mapper automatiquement votre enum TaskStatus vers un String dans la base de données. C'est la méthode la plus propre.
       2. Mise à jour du DAO : Adaptez les méthodes de votre TaskDao pour qu'elles utilisent le champ status.
       3. Mise à jour du Repository : Assurez-vous que votre TaskRepositoryImpl fait correctement la conversion entre le modèle de données de la BDD et votre entité Task.
       4. Lancez le test de l'étape 2.1. Il doit passer.

   * Étape 2.3 (REFACTOR) : Examiner et nettoyer.
       1. Votre TypeConverter est-il bien testé et réutilisable ?
       2. La logique de mapping dans le repository est-elle claire ?
       3. Lancez tous les tests de la couche de données.

  Phase 3 : Mettre à jour les Cas d'Utilisation (Use Cases)

  Votre logique métier pour changer le statut d'une tâche doit être adaptée.

   * Étape 3.1 (ROUGE) : Tester le nouveau cas d'utilisation.
       1. L'ancien ToggleTaskStatusUseCase est obsolète. Supprimez-le et son test.
       2. Créez un nouveau fichier de test pour UpdateTaskStatusUseCase.
       3. Écrivez un test qui vérifie que ce cas d'utilisation appelle bien la méthode updateTask du repository avec le bon ID de tâche et le nouveau statut.
       4. Le test échoue car ce cas d'utilisation n'existe pas.

   * Étape 3.2 (VERT) : Créer le cas d'utilisation.
       1. Créez le fichier update_task_status.dart dans domain/usecases.
       2. Implémentez la classe. Elle prendra probablement en paramètre un id et un TaskStatus. Son unique but est d'appeler le repository.
       3. Le test de l'étape 3.1 doit maintenant passer.

   * Étape 3.3 (REFACTOR) : Vérifier.
       1. La structure est-elle cohérente avec les autres cas d'utilisation ? C'est le moment de s'assurer de l'homogénéité du code.

  Phase 4 : Ajouter les Coordonnées (Répéter le Cycle)

  Maintenant, vous allez ajouter une nouvelle fonctionnalité en suivant exactement le même processus TDD.

   * 4.1 Domaine :
       * (ROUGE) Écrivez un test qui crée une Task avec latitude et longitude. Il échoue.
       * (VERT) Ajoutez final double? latitude; et final double? longitude; à votre entité Task. Mettez à jour le constructeur et props. Le test passe.

   * 4.2 Données :
       * (ROUGE) Modifiez un test du TaskDao pour qu'il vérifie la sauvegarde et la récupération des coordonnées. Il échoue.
       * (VERT) Ajoutez les colonnes latitude et longitude (de type double) à votre table Drift. Mettez à jour le DAO et le Repository. Le test passe.

   * 4.3 Cas d'utilisation :
       * (ROUGE) Écrivez un test pour un UpdateTaskCoordinatesUseCase. Il échoue.
       * (VERT) Créez le cas d'utilisation. Le test passe.

   * 4.4 Refactor : Après chaque cycle, prenez le temps de nettoyer.

  Phase 5 : Mettre à jour la Couche de Présentation (UI)

  C'est la dernière étape. Ici, vous utiliserez les tests de widgets.

   * Étape 5.1 (ROUGE) : Tester l'affichage du statut.
       1. Trouvez ou créez un test de widget pour votre TaskListItem.
       2. Modifiez-le pour vérifier que si une tâche a le statut TaskStatus.done, une icône de validation est affichée (et non plus une checkbox).
       3. Le test échouera car le widget affiche toujours une Checkbox.

   * Étape 5.2 (VERT) : Mettre à jour le Provider et le Widget.
       1. TaskProvider : Remplacez la méthode toggleTask par une nouvelle méthode updateStatus(String taskId, TaskStatus newStatus) qui appelle votre nouveau UpdateTaskStatusUseCase.
       2. TaskListItem Widget :
           * Supprimez la Checkbox.
           * Affichez un Icon, un Chip ou un autre widget qui représente le statut.
           * Pour changer le statut, vous pourriez utiliser un PopupMenuButton qui propose les 3 statuts, ou un simple GestureDetector qui fait cycler les statuts. Au clic, appelez la
             méthode updateStatus du provider.
       3. Le test de widget doit maintenant passer.

   * Étape 5.3 (REFACTOR) : Améliorer l'UX.
       1. Le changement de statut est-il fluide ?
       2. Le code du widget est-il lisible ? Peut-être extraire le "StatusIndicator" dans son propre widget.

   * Étape 5.4 : Intégrer les coordonnées.
       1. Ajoutez un bouton "Localiser" sur votre TaskListItem ou ProjectDetailPage.
       2. Au clic, il pourrait ouvrir un AlertDialog affichant les coordonnées, ou mieux, une nouvelle page avec une carte (en utilisant un package comme google_maps_flutter).
          L'implémentation de la carte elle-même peut être une nouvelle "feature" à développer en TDD !
