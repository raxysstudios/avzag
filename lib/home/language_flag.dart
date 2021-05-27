import 'dart:io';
import 'dart:math';
import 'package:avzag/home/models.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

String docDir = "";

String flagPath(Language language) {
  return 'flags/' + (language.flag ?? language.name) + '.png';
}

Future<void> donwloadFlag(Language language) async {
  if (docDir.isEmpty) {
    Directory dir = await getApplicationDocumentsDirectory();
    docDir = dir.path + "/";
  }
  final path = flagPath(language);
  File file = File(docDir + path);
  await file.create(recursive: true);
  await firebase_storage.FirebaseStorage.instance.ref(path).writeToFile(file);
  print("downloaded " + path);
}

class LanguageFlag extends StatelessWidget {
  const LanguageFlag(
    this.language, {
    this.offset = const Offset(0, 0),
    this.scale = 18,
  });
  final Language language;
  final Offset offset;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 4,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: -pi / 4,
          child: Transform.scale(
            scale: scale,
            child: Image.file(
              File(docDir + flagPath(language)),
              repeat: ImageRepeat.repeatX,
              // fit: BoxFit.contain,
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) =>
                  Container(),
            ),
          ),
        ),
      ),
    );
  }
}
