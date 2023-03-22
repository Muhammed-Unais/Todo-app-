import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/core/style.dart';
import 'package:http/http.dart' as http;

class AddTodoList extends StatefulWidget {
  const AddTodoList({super.key, this.item});

  final Map? item;

  @override
  State<AddTodoList> createState() => _AddTodoListState();
}

final GlobalKey<FormState> formkey = GlobalKey<FormState>();

class _AddTodoListState extends State<AddTodoList> {
  TextEditingController titileTextEditingController = TextEditingController();
  TextEditingController discriptTextEditingController = TextEditingController();
  bool itemValueCheck = false;

  @override
  void initState() {
    super.initState();

    final item = widget.item;
    if (item != null) {
      itemValueCheck = true;
      final title = item['title'];
      final descrption = item['description'];
      titileTextEditingController.text = title;
      discriptTextEditingController.text = descrption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(itemValueCheck ? "Edit Your Todo " : "Create Your Todo"),
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // first title textform field============
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Valid Title";
                }
                return null;
              },
              controller: titileTextEditingController,
              decoration: const InputDecoration(
                hintText: "Titile",
              ),
            ),
            // contont textform field============
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || value.length <= 10) {
                  return "Enter atleast 10 words";
                }
                return null;
              },
              controller: discriptTextEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              minLines: 5,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
            ),
            // Elavated Button================
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
              ),
              onPressed: () async {
                if (formkey.currentState!.validate() &&
                    formkey.currentState != null) {
                  if (itemValueCheck) {
                    editData();
                  } else {
                    submitData();
                    titileTextEditingController.clear();
                    discriptTextEditingController.clear();
                  }
                  // Navigator.pop(context);
                } else {
                  showSnackbar(
                    "Creation failed",
                    Colors.red,
                  );
                }
              },
              child: TextandStyles(
                titles: itemValueCheck == true ? "Upadate" : "Create",
                fsize: 18,
                clr: Colors.black,
                fwhit: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

//  Edit data function===========================
  Future<void> editData() async {
    final todo = widget.item;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];
    final title = titileTextEditingController.text;
    final discrption = discriptTextEditingController.text;
    final body = {
      "title": title,
      "description": discrption,
      "is_completed": false
    };
    // here we are using api with http packat=ge ===============
    final url = "http://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    print(uri);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      showSnackbar("Upadation Successfull", Colors.black);
    } else {
      log(response.statusCode.toString());
    }
  }

// Submit data or add data function=====================
  void submitData() async {
    final title = titileTextEditingController.text;
    final discrption = discriptTextEditingController.text;
    final body = {
      "title": title,
      "description": discrption,
      "is_completed": false
    };

    // here we are using api with http packat=ge ===============
    const url = "http://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      showSnackbar("Creation Successfull", Colors.black);
    } else {
      log(response.statusCode.toString());
    }
  }

// Show snack bar function=====================
  void showSnackbar(String success, Color clr) {
    final snackBar = SnackBar(
      content: Text(
        success,
        style: TextStyle(color: clr),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
