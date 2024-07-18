import 'package:flutter/material.dart';

class ReportDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function() onCancel;
  final Function() onConfirm;
  final GlobalKey<FormState> formKey;
  final TextEditingController reportController;

  const ReportDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onCancel,
    required this.onConfirm,
    required this.formKey,
    required this.reportController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: formKey,
              child: TextFormField(
                controller: reportController,
                decoration: InputDecoration(
                  hintText: description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason for the report';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reports will be manually verified by administrators. Misuse or false reports will be penalized.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SimpleBtn(
                    text: "Cancel",
                    onPressed: onCancel,
                    color: Colors.red,
                    textColor: Colors.white,
                    borderRadius: 24,
                  ),
                  const SizedBox(width: 8),
                  SimpleBtn(
                    text: "Confirm",
                    onPressed: onConfirm,
                    color: Colors.blue,
                    textColor: Colors.white,
                    borderRadius: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleBtn extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;

  const SimpleBtn({
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
    this.borderRadius = 15,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        alignment: Alignment.center,
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    );
  }
}
