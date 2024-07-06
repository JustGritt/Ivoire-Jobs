import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String reportReason = '';

  submitReport(String reportReason) {
    print(reportReason);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                reportReason = value;
              });
            },
            decoration: const InputDecoration(
                hintText: "Enter the reason for reporting"),
          ),
          const SizedBox(height: 20),
          const Text(
            "All reports are subject to manual verification. Misuse of the reporting system may lead to penalties.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: reportReason.isNotEmpty
              ? () {
                  submitReport(reportReason);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Report submitted successfully')),
                  );
                }
              : null,
        ),
      ],
    );
  }
}
