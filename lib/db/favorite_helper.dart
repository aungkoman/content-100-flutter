import 'dart:io';

import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
class FavoriteDB {
  getPath() async {

    if(kIsWeb){
      // provide web path for db
      return '/favorites.db';
    }
    else{
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      final path = documentDirectory.path + '/favorites.db';
      return path;
    }

  }

  //Insertion
  add(Map item) async {
    final db = ObjectDB(await getPath());
    db.open();
    db.insert(item);
    db.tidy();
    await db.close();
  }

  Future<int> remove(Map item) async {
    final db = ObjectDB(await getPath());
    db.open();
    int val = await db.remove(item);
    db.tidy();
    await db.close();
    return val;
  }

  Future<List> listAll() async {
    final db = ObjectDB(await getPath());
    db.open();
    List val = await db.find({});
    db.tidy();
    await db.close();
    return val;
  }

  Future<List> check(Map item) async {
    final db = ObjectDB(await getPath());
    db.open();
    List val = await db.find(item);
    db.tidy();
    await db.close();
    return val;
  }
}
