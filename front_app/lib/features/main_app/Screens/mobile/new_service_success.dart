import 'package:barassage_app/core/blocs/service/service_bloc.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class NewServiceSuccess extends StatefulWidget {
  final CreateServiceSuccess service;
  const NewServiceSuccess({super.key, required this.service});

  @override
  State<NewServiceSuccess> createState() => _NewServiceSuccessState();
}

class _NewServiceSuccessState extends State<NewServiceSuccess> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      context.goNamed(App.services);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Votre service',
                      style: theme.textTheme.titleMedium,
                    ),
                    TextSpan(
                        text: " ${widget.service.serviceCreateModel.name} ",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                      text: 'a été créé avec succès.',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
