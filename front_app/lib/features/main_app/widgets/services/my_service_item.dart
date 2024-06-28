// import 'package:barassage_app/config/app_colors.dart';

import 'package:barassage_app/core/helpers/constants_helper.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:barassage_app/core/helpers/services_helper.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MyServiceItem extends StatelessWidget {
  final ServiceModel serviceModel;
  const MyServiceItem({super.key, required this.serviceModel});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      onPressed: () {},
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.surface.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  width: 100,
                  height: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        serviceModel.images.isNotEmpty
                            ? serviceModel.images.first
                            : defaultUrlImage,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 15,
                            maxHeight: 15,
                          ),
                          decoration: BoxDecoration(
                            color: ServicesHelper.getColorStatus(
                                serviceModel.status),
                            border: Border.all(
                              color: theme.primaryColorDark,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(serviceModel.name.truncateTo(20),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.location_circle_fill,
                                      color:
                                          theme.colorScheme.secondaryContainer,
                                      size: 20.0,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                          serviceModel.address.truncateTo(30),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: theme.textTheme.titleSmall!
                                              .copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: theme.colorScheme.primary,
                                          )),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.clock_fill,
                                      color:
                                          theme.colorScheme.secondaryContainer,
                                      size: 20.0,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    RichText(
                                      textHeightBehavior:
                                          const TextHeightBehavior(
                                              applyHeightToFirstAscent: false,
                                              applyHeightToLastDescent: false),
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${(serviceModel.duration).toString().durationToTime} / ',
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          TextSpan(
                                            text:
                                                '${serviceModel.price.toInt()} F ',
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.7, horizontal: 7.0),
                                decoration: BoxDecoration(
                                  color: ServicesHelper.getColorStatus(
                                      serviceModel.status),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          ServicesHelper.getTextStatus(
                                              serviceModel.status),
                                          style: theme.textTheme.titleMedium!
                                              .copyWith(
                                                  color: theme
                                                      .scaffoldBackgroundColor,
                                                  fontSize: 13.0,
                                                  fontStyle: FontStyle.italic)),
                                    ]),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              flex: 1,
              child: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.secondaryContainer,
              ),
            )
          ],
        ),
      ),
    );
  }
}
