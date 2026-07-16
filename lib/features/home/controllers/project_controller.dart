import 'package:get/get.dart';
import 'package:hobe/features/home/models/project.dart';

class ProjectController extends GetxController {
  var projects = <Project>[
    Project(
      title: "تطبيق تحليل البيانات",
      sector: "تكنولوجيا",
      stage: "فكرة",
      budget: "250,000 دولار",
      progress: 0.4,
    ),
    Project(
      title: "منصة التجارة",
      sector: "بيئة",
      stage: "تطوير",
      budget: "500,000 دولار",
      progress: 0.75,
    ),
  ].obs;
}
