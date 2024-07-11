import 'package:flutter/material.dart';

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850;

bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;