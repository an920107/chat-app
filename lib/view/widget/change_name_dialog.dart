import 'package:flutter/material.dart';

class ChangeNameDialog extends StatefulWidget {
  const ChangeNameDialog(
    this.originName, {
    super.key,
  });

  final String originName;

  @override
  State<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  final _nameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTextController.text = widget.originName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Name"),
      content: TextField(
        controller: _nameTextController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: "Enter your new name",
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            foregroundColor: Colors.grey.shade800,
          ),
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text("Cancel"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.grey.shade800,
          ),
          onPressed: () => Navigator.of(context).pop(_nameTextController.text),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
