import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testtask/pages/asianfood.dart';
import 'package:testtask/pages/bucketpage.dart';
import 'package:testtask/pages/mainpage.dart';
import 'package:testtask/models/bucket_model.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => BucketModel(),
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/asian': (context) => AsianFood(),
        '/bucket': (context) => BucketPage(),
      },
    ),
  ),
);
