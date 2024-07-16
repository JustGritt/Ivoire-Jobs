import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionBarasseurDetailService extends StatefulWidget {
  final ServiceCreatedModel service;
  const SectionBarasseurDetailService({super.key, required this.service});

  @override
  State<SectionBarasseurDetailService> createState() => _SectionBarasseurDetailServiceState();
}

class _SectionBarasseurDetailServiceState extends State<SectionBarasseurDetailService> {
  int hours = 0;

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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Image.network(
                      widget.service.images.first,
                      width: 70,
                      height: 70,
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
              CupertinoButton(
                color: AppColors.greyLight,
                minSize: 0,
                borderRadius: BorderRadius.circular(90),
                padding: EdgeInsets.all(8),
                onPressed: () {},
                child: Icon(
                  CupertinoIcons.mail_solid,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
