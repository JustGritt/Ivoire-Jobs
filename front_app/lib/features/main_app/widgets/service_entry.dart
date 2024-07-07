import 'package:barassage_app/features/main_app/models/service_models/service_create_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:flutter/material.dart';

class ServiceEntry extends StatelessWidget {
  final ServiceCreatedModel service;

  const ServiceEntry({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ListView.builder(itemBuilder: (context, index) {
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  service.images[index],
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            service.category.first,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 8, vertical: 4),
                        //     decoration: BoxDecoration(
                        //       color: Colors.black54,
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     child: Row(children: [
                        //       Text(
                        //         service.rating.toStringAsFixed(2),
                        //         style: const TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 12,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //       const SizedBox(width: 4),
                        //       const Icon(Icons.star,
                        //           color: Colors.white, size: 12),
                        //     ])),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
