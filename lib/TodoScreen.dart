import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Map<String, dynamic>> _todos = [];
  TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: _buildTodoPage(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildTodoPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Todo List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        _buildTodoList(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _showAddTodoBottomSheet(context);
          },
          child: Text('Add Todo'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodoList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            bool isDone = (_todos[index]['text'] is String) && _todos[index]['text'].startsWith('DONE: ');
            bool isFavorite = _todos[index]['isFavorite'] ?? false;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  isDone ? _todos[index]['text'].substring(6) : _todos[index]['text'],
                  style: TextStyle(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditTodoBottomSheet(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodoBottomSheet(context, index);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _markAsDone(index);
                      },
                      child: Text('Done'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Button color
                        onPrimary: Colors.white, // Text color
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        _toggleFavorite(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddTodoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add Todo', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              TextField(
                controller: _todoController,
                decoration: InputDecoration(hintText: 'Enter todo'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _addTodo();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditTodoBottomSheet(BuildContext context, int index) {
    _todoController.text = _todos[index]['text'];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit Todo', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              TextField(
                controller: _todoController,
                decoration: InputDecoration(hintText: 'Edit todo'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _editTodo(index);
                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTodoBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Delete', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Are you sure you want to delete this todo?'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _deleteTodo(index);
                      Navigator.of(context).pop();
                    },
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _markAsDone(int index) {
    setState(() {
      dynamic currentText = _todos[index]['text'];
      if (currentText is String) {
        if (currentText.startsWith('DONE: ')) {
          _todos[index]['text'] = currentText.substring(6);
          _todos[index]['isDone'] = false;
        } else {
          _todos[index]['text'] = 'DONE: $currentText';
          _todos[index]['isDone'] = true;
        }
      }
    });
  }

  void _addTodo() {
    setState(() {
      _todos.add({
        'text': _todoController.text,
        'isDone': false,
        'isFavorite': false,
      });
      _todoController.clear();
    });
  }

  void _editTodo(int index) {
    setState(() {
      _todos[index]['text'] = _todoController.text;
      _todoController.clear();
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _todos[index]['isFavorite'] = !(_todos[index]['isFavorite'] ?? false);
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: TodoScreen(),
  ));
}
