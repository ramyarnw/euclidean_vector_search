import 'package:objectbox/objectbox.dart';

@Entity()
class TextItem {
  int id = 0;

  String text;

  String embeddingJson; // store vector as JSON string

  TextItem({required this.text, required List<double> embedding})
      : embeddingJson = embedding.join(','); // store as comma-separated

  List<double> get embedding =>
      embeddingJson.split(',').map((e) => double.parse(e)).toList();
  // @Property(type: PropertyType.floatVector)
  // List<double> embedding;
  //
  // TextItem({required this.text, required this.embedding});
}
