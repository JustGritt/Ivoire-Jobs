import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:barassage_app/config/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyServiceSlidable extends StatefulWidget {
  final Widget child;
  final Function(CompletionHandler handler) onDelete;

  const MyServiceSlidable({
    super.key,
    required this.child,
    required this.onDelete,
  });

  @override
  State<MyServiceSlidable> createState() => _MyServiceSlidableState();
}

class _MyServiceSlidableState extends State<MyServiceSlidable> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SwipeActionCell(
        key: ObjectKey(widget.child),
        leadingActions: <SwipeAction>[
          SwipeAction(
              icon: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child:
                      const Icon(CupertinoIcons.delete, color: Colors.white)),
              widthSpace: 120,
              title: "delete",
              style: theme.textTheme.displayMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onTap: widget.onDelete,
              color: AppColors.red.withOpacity(0.9)),
        ],
        child: widget.child);
  }
}
