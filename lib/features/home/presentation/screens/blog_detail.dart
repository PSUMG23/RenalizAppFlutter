import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/config/config.dart';
import 'package:renalizapp/features/home/presentation/widgets/widgets.dart';

class BlogDetail extends StatefulWidget {
  final GoRouter appRouter;

  const BlogDetail({required this.appRouter});

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  @override
  Widget build(BuildContext context) {
    List<Widget> images = [];
    blogDetail['images'].forEach((url) {
      images.add(Image.network(url, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
        return Container(
          alignment: Alignment.center,
          child: const Text(
            'Error loading image!',
            style: TextStyle(fontSize: 30),
          ),
        );
      }));
      images.add(SizedBox(
        height: 8,
      ));
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          blogDetail["title"],
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Fecha de Publicación: ${DateTime.fromMicrosecondsSinceEpoch(blogDetail['publication_date']["_seconds"] * 1000000).toLocal().toString().split('.')[0]}",
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              blogDetail["description"],
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            ...images,
            Text(
              "Autor: ${blogDetail["author"]}",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "Categoría: ${blogDetail["category"]}",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Etiquetas:",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            blogDetail["tags"].isNotEmpty
                ? Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: (blogDetail["tags"] as List).map((tag) {
                      return Chip(
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0,
                                horizontal:
                                    2.0), // Ajusta el padding según tus preferencias
                            child: Text(tag),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          backgroundColor: generateColor(tag),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ));
                    }).toList(),
                  )
                : Text("No hay etiquetas para mostrar..."),
            SizedBox(height: 16.0),
            // Coloca las imágenes aquí si lo deseas
          ],
        ),
      ),
    );
  }
}

Color generateColor(String text) {
  final random = Random(text.hashCode);
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}
