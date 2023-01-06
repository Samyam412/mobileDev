import 'package:batch_student_starter/helper/objectbox.dart';
import 'package:batch_student_starter/state/objectbox_state.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBoxInstance.deleteDatabase();
  // create an Object for ObjectBoxInstance
  ObjectBoxState.objectBoxInstance = await ObjectBoxInstance.init();

  runApp(
    const MyApp(),
  );
}
