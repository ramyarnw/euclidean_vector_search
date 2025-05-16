import 'package:objectbox/objectbox.dart';
import 'model.dart';
import 'objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;
  late final Box<TextItem> textBox;

  ObjectBox._create(this.store) {
    textBox = Box<TextItem>(store);
  }

  static Future<ObjectBox> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${dir.path}/objectbox');

    return ObjectBox._create(store);
  }
}
