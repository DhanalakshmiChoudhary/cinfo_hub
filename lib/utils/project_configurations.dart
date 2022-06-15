import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectConfiguration {
  final String apiKey = "1cc3b6698acd0e7664ebb579048b73fa";
}

final projectConfigProvider = Provider<ProjectConfiguration>((ref) {
  return ProjectConfiguration();
}); 






// 1cc3b6698acd0e7664ebb579048b73fa