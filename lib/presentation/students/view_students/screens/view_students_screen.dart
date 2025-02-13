import 'package:flutter/material.dart';
import 'package:nawiapp/presentation/students/utils/nawi_utils.dart';

//* lista de datos de prueba

class ViewStudentsScreen extends StatefulWidget {
  const ViewStudentsScreen({super.key});

  @override
  State<ViewStudentsScreen> createState() => _ViewStudentsScreenState();
}

class _ViewStudentsScreenState extends State<ViewStudentsScreen> {

  //TODO: Cambiar por origen de datos real
  final List<Map<String, dynamic>> students = List.filled(10, [{"name":"Lorem Ipsum Dolor Sit","age": 5},{"name":"Sit Deset Lorem Al","age": 4},{"name":"Amet Lorem Dolor At","age": 3}]).expand((x) => x).toList();

  Widget? _studentsList(_, int i){
    final item = students[i];
    return InkWell(
      onLongPress: () { },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Dismissible(
          key: Key("-"),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if(direction == DismissDirection.startToEnd) {
              //* Action when edit
              return false;
            }
            if(direction == DismissDirection.endToStart) {
              //* Action when delete
              //TODO: agregar un modal para confirmar la eliminacion.
              return true;
            }
            return false;
          },
          background: Container(
            color: Colors.cyan.shade300,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.edit, color: Colors.white)
          ),
          secondaryBackground: Container(
            color: Colors.red.shade400,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.delete, color: Colors.white)              
          ),
          child: ListTile(
            title: Text(item["name"]),
            subtitle: Text('${item["age"]} años'),
            tileColor: i % 2 == 0 ?Colors.grey.shade200.withAlpha(80) : Colors.grey.shade200.withAlpha(100),
            leading: CircleAvatar(
              backgroundColor: NawiColor.iconColorMap(item["age"], withOpacity: true),
              child: Icon(Icons.person, color: NawiColor.iconColorMap(item["age"])),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: students.isNotEmpty ? ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(8.0),
          itemCount: students.length,
          itemBuilder: _studentsList
        ) : 
        GridView.count(crossAxisCount: 1, children: [Center(child: Text("No hay estudiantes registrados"))],),
      ),
    );
  }
}