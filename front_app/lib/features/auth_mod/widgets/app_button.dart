import 'package:barassage_app/config/config.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:flutter_animated_button/flutter_animated_button.dart';

// ignore: must_be_immutable
class AppButton extends StatefulWidget {
  Color? backgroundColor;
  Color? textColor;
  String label;
  double? paddingValue;
  void Function() onPressed;
  bool? stretch;
  double? width;
  bool isLoading;
  bool isDisabled;

  AppButton({
    super.key,
    this.backgroundColor,
    this.textColor,
    required this.label,
    this.paddingValue = 8.0,
    required this.onPressed,
    this.stretch = false,
    this.width,
    this.isLoading = false,
    this.isDisabled = false,
  });

  static const double _shadowHeight = 4;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _position = 4;

  @override
  Widget build(BuildContext context) {
    double height = 64 - AppButton._shadowHeight;
    double width = widget.width ?? MediaQuery.of(context).size.width * .92;
    ThemeData theme = Theme.of(context);
    bool isCliCkable = !widget.isLoading && !widget.isDisabled;

    return Center(
      child: GestureDetector(
        onTap: () {
          if (isCliCkable) {
            widget.onPressed();
          }
        },
        onTapUp: (_) {
          setState(() {
            _position = 4;
          });
        },
        onTapDown: (_) {
          setState(() {
            _position = 0;
          });
        },
        onTapCancel: () {
          setState(() {
            _position = 4;
          });
        },
        child: SizedBox(
          height: height + AppButton._shadowHeight,
          width: width,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.easeIn,
                bottom: _position,
                duration: const Duration(milliseconds: 70),
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: isCliCkable
                        ? widget.backgroundColor ?? AppColors.teal
                        : AppColors.grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: widget.isLoading
                        ? LoadingAnimationWidget.prograssiveDots(
                            color: Colors.white,
                            size: 40,
                          )
                        : Text(
                            widget.label,
                            style: theme.textTheme.displayLarge!.copyWith(
                              fontSize: 16,
                              color: widget.textColor ?? Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
