import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:pushable_button/pushable_button.dart';

class StepInformation extends StatefulWidget {
  final Function(int step) onStepChange;

  const StepInformation({super.key, required this.onStepChange});

  @override
  State<StepInformation> createState() => _StepInformationState();
}

class _StepInformationState extends State<StepInformation> {
  // fill list with empty objects
  List<File?> illustrations = [
    null,
    null,
    null,
  ];
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your information', style: theme.textTheme.labelLarge),
            const SizedBox(height: 20.0),
            TextField(context, hint: appLocalizations.service_title),
            const SizedBox(height: 20.0),
            TextField(context, hint: appLocalizations.service_description),
            const SizedBox(height: 20.0),
            TextField(context,
                hint: appLocalizations.service_price,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 20.0),
            Text(appLocalizations.service_illustration,
                style: theme.textTheme.labelLarge!.copyWith(fontSize: 16.0)),
            Text(appLocalizations.service_illustration_description,
                style: TextStyle(
                  color: theme.colorScheme.surface,
                )),
            const SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Illustrations(context,
                  illustration: illustrations[0],
                  setIllustration: (ill) => {
                        setState(() {
                          illustrations.insert(0, ill);
                        })
                      }),
              Illustrations(context,
                  illustration: illustrations[1],
                  setIllustration: (ill) => {
                        setState(() {
                          illustrations.insert(1, ill);
                        })
                      }),
              Illustrations(context, illustration: illustrations[2],
                  setIllustration: (ill) {
                setState(() {
                  illustrations.insert(2, ill);
                });
              }),
            ]),
            const SizedBox(height: 20.0),
            PushableButton(
              child: Text(appLocalizations.next,
                  style: theme.textTheme.titleMedium!
                      .copyWith(color: theme.scaffoldBackgroundColor)),
              height: 40,
              elevation: 3,
              hslColor: HSLColor.fromColor(theme.primaryColor),
              shadow: BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
              onPressed: () => {
                widget.onStepChange(1),
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget Illustrations(BuildContext context,
    {required Function(File) setIllustration, File? illustration}) {
  ThemeData theme = Theme.of(context);
  return CupertinoButton(
    minSize: 0,
    color: Colors.black,
    padding: EdgeInsets.zero,
    onPressed: () {
      InstaAssetPicker.pickAssets(
        context,
        maxAssets: 1,
        closeOnComplete: true,
        cropDelegate: InstaAssetCropDelegate(
          preferredSize: 1080,
        ),
        onCompleted: (Stream<InstaAssetsExportDetails> stream) async {
          InstaAssetsExportDetails photo = await stream.first;
          File? selectedFile = await photo.selectedAssets.first.file;
          if (selectedFile != null) {
            setIllustration(selectedFile);
          }
        },
      );
    },
    child: Row(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.camera,
                    color: theme.primaryColorDark,
                    size: 20.0,
                  ),
                  SizedBox(height: 5.0),
                  Text('Photo',
                      style:
                          theme.textTheme.labelLarge!.copyWith(fontSize: 16.0)),
                ],
              ),
            ),
            illustration != null
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: FileImage(illustration)),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    ),
  );
}

Widget TextField(
  BuildContext context, {
  required String hint,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(hint.split(' ')[0]),
      CupertinoTextField(
        placeholder: hint,
        keyboardType: keyboardType,
        onChanged: (value) {},
        padding: const EdgeInsets.all(13.0),
        cursorRadius: const Radius.circular(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10.0),
        ),
      )
    ],
  );
}
