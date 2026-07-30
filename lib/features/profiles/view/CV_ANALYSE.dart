import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/controller/cv_controller.dart';



class AnalyzeScreen extends StatelessWidget {
  AnalyzeScreen({super.key});

  final AnalyzeController controller =
      Get.put(AnalyzeController());

  @override
  Widget build(BuildContext context) {

    controller.analyze();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "AI Resume Analysis",
        ),
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.analysis.value == null) {
          return const Center(
            child: Text(
              "No Analysis Found",
            ),
          );
        }

        final data =
            controller.analysis.value!;

        return SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                children: [

                  Expanded(
                    child: _scoreCard(
                      "ATS Score",
                      data.atsScore.toString(),
                      Icons.analytics,
                      Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _scoreCard(
                      "Match",
                      data.matchScore.toString(),
                      Icons.star,
                      Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              _scoreCard(
                "Final Score",
                data.finalScore.toString(),
                Icons.workspace_premium,
                Colors.green,
              ),

              const SizedBox(height: 25),

              _sectionTitle(
                "Strengths",
              ),

              ...data.strengths.map(
                (e) => ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text(
                    e.toString(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle(
                "Weaknesses",
              ),

              ...data.weaknesses.map(
                (e) => ListTile(
                  leading: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  title: Text(
                    e.toString(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle(
                "Improvements",
              ),

              ...data.improvements.map(
                (e) => ListTile(
                  leading: const Icon(
                    Icons.lightbulb,
                    color: Colors.orange,
                  ),
                  title: Text(
                    e.toString(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _sectionTitle(
                "Recommended Skills",
              ),

              Wrap(

                spacing: 8,
                runSpacing: 8,

                children: data.recommendedSkills
                    .map(
                      (e) => Chip(
                        label: Text(
                          e.toString(),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 20),

              _sectionTitle(
                "Career Paths",
              ),

              ...data.careerPaths.map(
                (e) => Card(

                  child: ListTile(

                    leading: const Icon(
                      Icons.work,
                    ),

                    title: Text(
                      e["title"] ?? "",
                    ),

                    subtitle: Text(
                      e["description"] ?? "",
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

                const SizedBox(height: 15),

              SizedBox(

                width: double.infinity,

                child: OutlinedButton(

                  onPressed: () {
                    Get.back();
                  },

                  child: const Text(
                    "Back",
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(
    String title,
  ) {

    return Text(

      title,

      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _scoreCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {

    return Card(

      elevation: 3,

      child: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            Icon(
              icon,
              color: color,
              size: 35,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(title),
          ],
        ),
      ),
    );
  }
}