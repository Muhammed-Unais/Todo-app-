import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app/core/style.dart';
import 'package:http/http.dart' as http;
import 'add_todo_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List items = [];
  bool isloading = true;
  // late Future<List<Albam>> albamFetch;

  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextandStyles(
          titles: "Todo App",
          fsize: 24,
          clr: Colors.greenAccent,
          fwhit: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToaddTodo();
        },
        label: const TextandStyles(
          titles: "Add Your Day",
          clr: Colors.black,
          fsize: 16,
          fwhit: FontWeight.bold,
        ),
      ),
      body: Visibility(
        visible: isloading,
        replacement: RefreshIndicator(
          onRefresh: () {
            return fetchTodo();
          },
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: TextandStyles(
                titles: "Make Your Day",
                fsize: 22,
                clr: Colors.white,
                fwhit: FontWeight.bold,
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.white38,
                  thickness: 2,
                );
              },
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'];
                return Card(
                  elevation: 10,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: TextandStyles(
                      titles: item['title'],
                      fsize: 20,
                      clr: Colors.white,
                      fwhit: FontWeight.w700,
                    ),
                    subtitle: Text(
                      item['description'],
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "Delete") {
                          delete(id);
                        } else if (value == "Edit") {
                          navigateToEditpage(item);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: "Delete",
                            child: Text(
                              "Delete",
                            ),
                          ),
                          const PopupMenuItem(
                            value: "Edit",
                            child: Text(
                              "Edit",
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }

// navigate to Edit =====================================
  void navigateToEditpage(Map itemz) async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoList(item: itemz);
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

// navigate to add =====================================
  void navigateToaddTodo() async {
    final route = MaterialPageRoute(
      builder: (context) {
        return const AddTodoList();
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

// fetch all datas===============================
  Future<void> fetchTodo() async {
    const url = "http://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      final itemsjson = json['items'] as List;
      print(itemsjson);

      setState(() {
        items = itemsjson;
      });
    }
    setState(() {
      isloading = false;
    });
  }

// delete functon===================================
  delete(String id) async {
    final url = "http://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filterd = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filterd;
      });
    } else {}
    showSnackbar("Deleted", Colors.red);
  }

// show snackbar===================================
  void showSnackbar(String success, Color clr) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 500),
      content: Text(
        success,
        style: TextStyle(color: clr),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
