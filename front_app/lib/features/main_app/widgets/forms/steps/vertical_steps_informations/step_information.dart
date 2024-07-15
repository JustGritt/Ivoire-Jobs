import 'dart:io';

import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/exceptions/file_exception.dart';
import 'package:barassage_app/core/helpers/files_helper.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:pushable_button/pushable_button.dart';

class StepInformation extends StatefulWidget {
  final Function(StepInformationData data) onEnd;

  const StepInformation({super.key, required this.onEnd});

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
  Map<dynamic, dynamic> errors = {};
  Map<String, dynamic> form = {
    "illustrations": [],
    "title": "",
    "description": "",
    "price": 0.0,
  };

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);

    EzSchema formSchema = EzSchema.shape(
      {
        "title": EzValidator<String>(label: "Title").required(),
        "description": EzValidator<String>(label: "Description").required(),
        "price": EzValidator<double>(label: "Price").required().number().min(1000, 'Le prix doit être supérieur à 1000 XOF'),
        "illustrations": EzValidator<List<File?>>(label: "Illustrations")
            .required()
            .arrayOf(EzValidator<File>(label: "Illustration").required())
            .minLength(1),
      },
    );

    void validate() {
      try {
        form['illustrations'] = illustrations.whereType<File>().toList();
        final (data, errors_) = formSchema.validateSync(form);
        setState(() {
          errors = errors_;
        });
        if (errors_.entries.every((element) => element.value == null)) {
          widget.onEnd(StepInformationData(
              title: data['title'],
              description: data['description'],
              price: data['price'],
              illustrations: data['illustrations'] as List<File>));
        }
      } catch (e) {
        print(e);
      }
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your information', style: theme.textTheme.labelLarge),
            const SizedBox(height: 20.0),
            TextField(context, hint: appLocalizations.service_title,
                onChanged: (value) {
              setState(() {
                form['title'] = value;
              });
            }),
            Text(errors['title'] ?? '',
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: AppColors.red)),
            const SizedBox(height: 3.0),
            TextField(context, hint: appLocalizations.service_description,
                onChanged: (value) {
              setState(() {
                form['description'] = value;
              });
            }),
            Text(errors['description'] ?? '',
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: AppColors.red)),
            const SizedBox(height: 3.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                    flex: 3,
                    child:
                        TextField(context, hint: appLocalizations.service_price,
                            onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          form['price'] = double.parse(value);
                        });
                      }
                    }, keyboardType: TextInputType.phone)),
                const SizedBox(width: 12),
                Text(
                  "XOF",
                  style: theme.textTheme.labelLarge!.copyWith(fontSize: 16.0),
                ),
              ],
            ),
            Text(errors['price'] ?? '',
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: AppColors.red)),
            const SizedBox(height: 4.0),
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
            Text(errors['illustrations'] ?? '',
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: AppColors.red)),
            const SizedBox(height: 20.0),
            PushableButton(
              height: 40,
              elevation: 3,
              hslColor: HSLColor.fromColor(theme.primaryColor),
              shadow: BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
              onPressed: validate,
              child: Text(appLocalizations.next,
                  style: theme.textTheme.titleMedium!
                      .copyWith(color: theme.scaffoldBackgroundColor)),
            ),
          ],
        ),
      ),
    );
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
          maxAssets: 3,
          closeOnComplete: true,
          selectedAssets: illustrations.whereType<AssetEntity>().toList(),
          onCompleted: (Stream<InstaAssetsExportDetails> stream) async {
            InstaAssetsExportDetails photo = await stream.first;
            List<AssetEntity>? selectedFiles = photo.selectedAssets;
            for (AssetEntity asset in selectedFiles) {
              File? originalFile = await asset.originFile;
              if (originalFile == null) break;
              try {
                File compressedFile = await compressAndGetFile(originalFile);
                print(compressedFile.path);
                int size = compressedFile.lengthSync();
                if (size > 5000000) throw FileException('File too large');
                setIllustration(compressedFile);
              } catch (e) {
                showMyDialog(context, title: 'Error', content: e.toString());
              }
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
                    const SizedBox(height: 5.0),
                    Text('Photo',
                        style: theme.textTheme.labelLarge!
                            .copyWith(fontSize: 16.0)),
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
                              fit: BoxFit.cover,
                              image: FileImage(illustration)),
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
}

Widget TextField(
  BuildContext context, {
  required String hint,
  TextInputType keyboardType = TextInputType.text,
  Function(String)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(hint.split(' ')[0]),
      CupertinoTextField(
        placeholder: hint,
        keyboardType: keyboardType,
        onChanged: onChanged,
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

class StepInformationData {
  final String title;
  final String description;
  final double price;
  final List<File> illustrations;

  StepInformationData(
      {required this.title,
      required this.description,
      required this.price,
      required this.illustrations});

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'illustrations': illustrations,
      };
}
