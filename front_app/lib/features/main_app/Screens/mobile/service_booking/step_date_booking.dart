import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zod_validation/zod_validation.dart';

class StepDateTimeBooking extends StatefulWidget {
  final DateTime? dateTime;
  final Function(DateTime data) onEnd;
  const StepDateTimeBooking({super.key, this.dateTime, required this.onEnd});

  @override
  State<StepDateTimeBooking> createState() => _StepDateBookingTimeState();
}

class _StepDateBookingTimeState extends State<StepDateTimeBooking> {
  Map<dynamic, dynamic> errors = {};

  Map<String, dynamic> form = {
    'date': null,
    'time': null,
  };

  @override
  void initState() {
    if (widget.dateTime != null) {
      form['date'] = widget.dateTime;
      form['time'] = TimeOfDay.fromDateTime(widget.dateTime!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void validate() {
      try {
        final zod = Zod.validate(
            data: form, params: {'date': Zod().type<DateTime>().required()});
        if (zod.isNotValid) {
          setState(() {
            errors = zod.result;
          });
        } else {
          if (form['date'] != null) {
            widget.onEnd(form['date']!);
          }
        }
      } catch (e) {
        print(e);
      }
    }

    ThemeData theme = Theme.of(context);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quand souhaitez-vous prendre rendez-vous ?',
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 25),
            ),
            const SizedBox(height: 20),
            Text(errors['date'] ?? '',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 16,
                  color: Colors.red,
                )),
            const SizedBox(height: 20),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    //dayBuilder: dayBuilder,
                    selectableDayPredicate: (day) =>
                        day.isAfter(
                            DateTime.now().subtract(Duration(days: 1))) &&
                        day.weekday != DateTime.sunday,
                  ),
                  value: [form['date'] ?? DateTime.now()],
                  onValueChanged: (dates) => {
                    setState(() {
                      form['date'] = dates.first;
                    }),
                    // with time
                    widget.onEnd(DateTime(
                        dates.first.year,
                        dates.first.month,
                        dates.first.day,
                        form['time'].hour,
                        form['time'].minute)),
                  },
                )),
            SizedBox(height: 20),
            Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  minSize: 0,
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: form['time'] ?? TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.input,
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: theme.primaryColor,
                                onPrimary: Colors.white,
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!,
                          );
                        });

                    if (pickedTime != null) {
                      DateTime picked = DateTime(
                          form['date'].year,
                          form['date'].month,
                          form['date'].day,
                          pickedTime.hour,
                          pickedTime.minute);
                      if (picked.isBefore(DateTime.now())) {
                        showMyDialog(
                          context,
                          title: 'Erreur',
                          content:
                              'Vous ne pouvez pas choisir une heure passée',
                        );
                        return;
                      }
                      setState(() {
                        form['time'] = pickedTime;
                      });
                      widget.onEnd(DateTime(
                          form['date'].year,
                          form['date'].month,
                          form['date'].day,
                          pickedTime.hour,
                          pickedTime.minute));
                    }
                  },
                  child: Row(children: [
                    const Icon(Icons.timer),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      form['time'] != null
                          ? (form['time'] as TimeOfDay).format(context)
                          : 'Choisir l\'heure',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                )),
          ],
        ),
      ),
    ]);
  }
}

Widget? dayBuilder({
  required date,
  textStyle,
  decoration,
  isSelected,
  isDisabled,
  isToday,
}) {
  BuildContext context =
      serviceLocator<AppContext>().navigatorKey.currentContext!;

  Widget? dayWidget;
  // day is before today
  if (isDisabled) {
    dayWidget = Container(
      decoration: decoration,
      child: Center(
        child: Text(
          date.day.toString(),
          style: textStyle?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
  return dayWidget;
}
