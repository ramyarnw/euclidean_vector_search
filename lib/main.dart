import 'package:flutter/material.dart';
import 'model.dart';
import 'objectbox_helper.dart';
import 'search_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final objectBox = await ObjectBox.create();
  runApp(MyApp(objectBox: objectBox));
}

class MyApp extends StatelessWidget {
  final ObjectBox objectBox;

  MyApp({super.key, required this.objectBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen(objectBox: objectBox));
  }
}

class HomeScreen extends StatefulWidget {
  final ObjectBox objectBox;

  const HomeScreen({super.key, required this.objectBox});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  late SearchService searchService;
  List<TextItem> results = [];

  @override
  void initState() {
    super.initState();
    searchService = SearchService(widget.objectBox);

    if (widget.objectBox.textBox.isEmpty()) {
      widget.objectBox.textBox.putMany([
        TextItem(text: "Hello world", embedding: [1.0, 0.0, 0.0]),
        TextItem(text: "Hi there", embedding: [0.9, 0.1, 0.1]),
        TextItem(text: "Goodbye", embedding: [0.0, 1.0, 0.0]),
        TextItem(text: "Done", embedding: [1.0, 0.0, 1.0]),

      ]);
    }
  }

  List<double> dummyEmbedding(String text) {
    if (text.toLowerCase().contains("hello")) {
      return [1.0, 0.0, 0.0];
    } else if (text.toLowerCase().contains("bye")) {
      return [0.0, 1.0, 0.0];
    } else {
      return [0.5, 0.5, 0.0];
    }
  }

  void search() {
    final query = _controller.text;
    final queryEmbedding = dummyEmbedding(query);
    final matches = searchService.searchSimilar(query, queryEmbedding, 3);

    setState(() => results = matches);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Euclidean Vector Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller),
            ElevatedButton(onPressed: search, child: Text("Search")),
            SizedBox(height: 20),
            ...results.map((e) => ListTile(title: Text(e.text))),
          ],
        ),
      ),
    );
  }
}
