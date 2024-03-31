import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:labplus_for_gitlab/shared/shared.dart';

import 'groups_controller.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen>
    with SingleTickerProviderStateMixin {
  final GroupsController _controller = Get.arguments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
      ),
      body: _buildForms(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.onAddGroup();
        },
        tooltip: 'Create group',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildForms(context) {
    return Form(
      key: _controller.registerFormKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                InputField(
                  labelText: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required.';
                    }
                    return null;
                  },
                  autofocus: true,
                  context: context,
                  controller: _controller.nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                InputField(
                    labelText: "Path",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Path is required.';
                      }
                      return null;
                    },
                    context: context,
                    controller: _controller.pathController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next),
                MultilineInputField(
                    context: context,
                    labelText: "Description",
                    controller: _controller.descriptionController),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
