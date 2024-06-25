// import 'package:barassage_app/config/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MyServiceItem extends StatelessWidget {
  const MyServiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  width: 100,
                  height: 140,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                    fit: BoxFit.cover,
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
                                Text('Nettoyage de maison',
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
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '19 rue des fleurs, 75000 Parihhjhjsdsd sdfsdsdsd h s',
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
                                    SizedBox(
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
                                              text: '2 Heures / ',
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          TextSpan(
                                            text: '20.000 F ',
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
                              Text('Chez ',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: theme.primaryColorDark,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.7, horizontal: 7.0),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const CircleAvatar(
                                        maxRadius: 12.0,
                                        backgroundImage: NetworkImage(
                                            'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text('Alex dieudonne',
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
