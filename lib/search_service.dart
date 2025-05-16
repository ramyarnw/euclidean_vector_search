import 'dart:math';
import 'model.dart';
import 'objectbox_helper.dart';

class SearchService {
  final ObjectBox objectBox;

  SearchService(this.objectBox);

  double euclideanDistance(List<double> a, List<double> b) {
    return sqrt(a.asMap().entries.map((e) {
      final diff = e.value - b[e.key];
      return diff * diff;
    }).reduce((a, b) => a + b));
  }

  List<TextItem> searchSimilar(String query, List<double> queryEmbedding, int topK) {
    final allItems = objectBox.textBox.getAll();

    allItems.sort((a, b) =>
        euclideanDistance(queryEmbedding, a.embedding)
            .compareTo(euclideanDistance(queryEmbedding, b.embedding)));

    return allItems.take(topK).toList();
  }
}
