import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user_update.dart';
import 'package:barassage_app/features/auth_mod/widgets/app_button.dart';
import 'package:barassage_app/config/app_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  Map<dynamic, dynamic> errors = {};

  EzSchema formSchema = EzSchema.shape(
    {
      "firstName": EzValidator<String>(label: "Firstname").required(),
      "lastName": EzValidator<String>(label: "Lastname").required(),
      "email": EzValidator<String>(label: "Email").email().required(),
      "bio": EzValidator<String>(label: "Bio").required(),
    },
  );

  @override
  void initState() {
    context.read<AuthenticationBloc>().stream.listen((event) {
      if (event is AuthenticationSuccessState) {
        firstNameController.text = event.user.firstName;
        lastNameController.text = event.user.lastName;
        emailController.text = event.user.email;
        bioController.text = event.user.bio ?? "";
      }
    });
    context.read<AuthenticationBloc>().add(InitiateAuth());
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void validate(BuildContext context) {
    Map<String, dynamic> form = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "bio": bioController.text,
    };
    try {
      final (data, errors_) = formSchema.validateSync(form);
      setState(() {
        errors = errors_;
      });
      if (errors_.entries.every((element) => element.value == null)) {
        context.read<AuthenticationBloc>().add(UpdateUserEvent(UserUpdate(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          bio: bioController.text,
        )));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: theme.primaryColorDark,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Edit Profile',
            style: theme.textTheme.labelMedium,
          ),
        ),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      'Merci de renseigner vos vraies informations, et de vérifier avant de soumettre.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        wordSpacing: 1,
                      )),
                  const SizedBox(height: 50),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 25, top: 16, bottom: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.surface.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(CupertinoIcons.person),
                            const SizedBox(width: 10),
                            Flexible(
                                child: CupertinoTextField(
                              controller: firstNameController,
                              placeholder: appLocalizations.lastname,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                            ))
                          ],
                        ),
                        errors['firstName'] != null
                            ? Row(
                                children: [
                                  Text(errors['firstName'] ?? '',
                                      textAlign: TextAlign.start,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        wordSpacing: 1,
                                      )),
                                ],
                              )
                            : Container(),
                        Container(
                          color: theme.colorScheme.surface.withOpacity(0.3),
                          height: 1,
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        CupertinoTextField(
                          placeholder: appLocalizations.firstname,
                          controller: lastNameController,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        errors['lastName'] != null
                            ? Row(
                                children: [
                                  Text(errors['lastName'] ?? '',
                                      textAlign: TextAlign.start,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        wordSpacing: 1,
                                      )),
                                ],
                              )
                            : Container(),
                        Container(
                          color: theme.colorScheme.surface.withOpacity(0.3),
                          height: 1,
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Row(
                            children: [
                              const Icon(CupertinoIcons.mail),
                              const SizedBox(width: 10),
                              Flexible(
                                child: CupertinoTextField(
                                  placeholder: appLocalizations.email,
                                  controller: emailController,
                                  enabled: false,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                        errors['email'] != null
                            ? Row(
                                children: [
                                  Text(errors['email'] ?? '',
                                      textAlign: TextAlign.start,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        wordSpacing: 1,
                                      )),
                                ],
                              )
                            : Container(),
                        Container(
                          color: theme.colorScheme.surface.withOpacity(0.3),
                          height: 1,
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(CupertinoIcons.text_alignleft),
                              const SizedBox(width: 10),
                              Flexible(
                                child: CupertinoTextField(
                                  placeholder: 'John Doe',
                                  controller: bioController,
                                  minLines: 5,
                                  maxLines: 10,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                        Row(
                          children: [
                            errors['bio'] != null
                                ? Text(errors['bio'] ?? '',
                                    textAlign: TextAlign.start,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      wordSpacing: 1,
                                    ))
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return AppButton(
                        isLoading: state is AuthenticationLoadingState ||
                            state is UpdateProfileLoadingState,
                        onPressed: () => validate(context),
                        label: 'Save',
                        backgroundColor: theme.primaryColor,
                      );
                    },
                  )
                ],
              ),
            )));
  }
}
