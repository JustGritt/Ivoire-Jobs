import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/features/main_app/providers/chat_room_services_provider.dart';
import 'package:barassage_app/features/main_app/widgets/details_service/report_dialog.dart'
    as report_dialog;
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/providers/reports_service_provider.dart';
import 'package:barassage_app/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SectionBarasseurDetailService extends StatefulWidget {
  final ServiceCreatedModel service;
  const SectionBarasseurDetailService({super.key, required this.service});

  @override
  State<SectionBarasseurDetailService> createState() =>
      _SectionBarasseurDetailServiceState();
}

class _SectionBarasseurDetailServiceState
    extends State<SectionBarasseurDetailService> {
  TextEditingController _reportController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return report_dialog.ReportDialog(
          title: "Report Service",
          description: "Enter the reason for the report",
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: () {
            if (_formKey.currentState?.validate() ?? false) {
              String reportReason = _reportController.text;
              Provider.of<ReportsServiceProvider>(context, listen: false)
                  .submitReport(widget.service.id, reportReason);
              Navigator.of(context).pop();
            }
          },
          formKey: _formKey,
          reportController: _reportController,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Informations sur le barasseur',
            style: TextStyle(
              color: theme.primaryColorDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Image.network(
                      widget.service.images.first,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: Text(
                          widget.service.name,
                          style: TextStyle(
                            color: theme.primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 4),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: Text(
                          widget.service.description,
                          style: TextStyle(
                            color: theme.colorScheme.surface,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  CupertinoButton(
                    color: Colors.red[600],
                    minSize: 0,
                    borderRadius: BorderRadius.circular(40),
                    padding: EdgeInsets.all(12),
                    onPressed: _showReportDialog,
                    child: Icon(
                      size: 16,
                      CupertinoIcons.flag_fill,
                      color: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer<ChatRoomServicesProvider>(
                    builder: (context, chatRoomProvider, child) {
                      return CupertinoButton(
                        color: AppColors.greyLight,
                        minSize: 0,
                        disabledColor: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(40),
                        padding: EdgeInsets.all(12),
                        onPressed: chatRoomProvider
                                .bookingServiceRequest.isLoading
                            ? null
                            : () {
                                Provider.of<ChatRoomServicesProvider>(context,
                                        listen: false)
                                    .createRoom(widget.service.id)
                                    .then((chatRoom) {
                                  if (chatRoom != null) {
                                    GoRouter.of(context).go(
                                        '${App.bookingServices}/${App.messages}/${App.messagingChat}',
                                        extra: chatRoom);
                                  }
                                });
                              },
                        child: chatRoomProvider.bookingServiceRequest.isLoading
                            ? Container(
                                height: 16,
                                width: 16,
                                child: CupertinoActivityIndicator(
                                  color: theme.primaryColor,
                                ),
                              )
                            : Icon(
                                size: 16,
                                CupertinoIcons.mail_solid,
                                color: theme.primaryColor,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
