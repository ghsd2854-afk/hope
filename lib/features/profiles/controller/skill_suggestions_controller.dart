import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobe/features/profiles/mpdel/skill_suggestions-model.dart';
import 'package:hobe/features/profiles/services/skill_suggestions-services.dart';



class SkillSuggestionController
    extends GetxController {

  final SkillSuggestionService _service =
      SkillSuggestionService();

  final jobTitleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  var isLoading = false.obs;

  var suggestions =
      <SkillSuggestionModel>[].obs;

  Future<void> generate() async {

    try {

      isLoading.value = true;

      await _service.generateSuggestions(
        jobTitle:
            jobTitleController.text,
        description:
            descriptionController.text,
      );

      await loadSuggestions();

    } finally {

      isLoading.value = false;

    }
  }

  Future<void> loadSuggestions() async {

    suggestions.value =
        await _service.getSuggestions();
  }

  Future<void> accept(
      SkillSuggestionModel skill) async {

    await _service.acceptSkill(
      skill.id!,
    );

    suggestions.remove(skill);
  }

  Future<void> reject(
      SkillSuggestionModel skill) async {

    await _service.rejectSkill(
      skill.id!,
    );

    suggestions.remove(skill);
  }

  @override
  void onInit() {

    super.onInit();

    loadSuggestions();
  }

  @override
  void onClose() {

    jobTitleController.dispose();
    descriptionController.dispose();

    super.onClose();
  }
}