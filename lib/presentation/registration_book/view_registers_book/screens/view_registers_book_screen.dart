import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:collection/collection.dart';

class ViewRegistersBookScreen extends StatefulWidget {
  const ViewRegistersBookScreen({super.key});

  @override
  State<ViewRegistersBookScreen> createState() => _ViewRegistersBookScreenState();
}

class _ViewRegistersBookScreenState extends State<ViewRegistersBookScreen> {

  //TODO: Cambiar por origen de datos real
  final List<Map<String, dynamic>> registersBook = List.filled(1, [
    {"action": "Jose Pablo ha dicho su nombre", "date": DateTime(2025, 1, 15), "emisors": ["Jose Pablo"]},
    {"action": "Raul ha jugado a las escondidas con Anita", "date": DateTime(2025, 1, 15), "emisors": ["Anita", "Raul"]},
    {"action": "Mario ha pegado a Mahite y Joel", "date": DateTime(2025, 1, 13), "emisors": ["Mario", "Mahite", "Joel"]},
    {"action": "Anita y Joel han aprendido a contar hasta 3", "date": DateTime(2025, 1, 16), "emisors": ["Anita", "Joel"]},
    {"action": "Maria Fernanda dice como es ella y se compara con su mama", "date": DateTime(2025, 1, 16), "emisors": ["Maria Fernanda"]},
  ]).expand((x) => x).toList();

  Widget _registersBookList(_, Map<String, dynamic> item){
    return InkWell(
      onLongPress: () { },
      child: Ink(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400)),
          child: Dismissible(

            //TODO: cambiar por la clave o identificador real
            key: Key("-"),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              if(direction == DismissDirection.startToEnd) {
                //* Action when edit
              }
              if(direction == DismissDirection.endToStart) {
                //* Action when delete
                //TODO: agregar un modal para confirmar la eliminacion.
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
              title: Text(item["action"]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('dd/MM/y').format(item["date"])),
                  Wrap(
                    spacing: 10,
                    children: (item["emisors"] as List<String>).map((e) => 
                      Chip(
                        label: Text(e),
                        backgroundColor: Colors.blueAccent.shade100,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold)
                      )).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final groupedList = groupBy(registersBook, (e) => DateTime((e["date"] as DateTime).year, (e["date"] as DateTime).month, (e["date"] as DateTime).day));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async { },
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: GroupListView(
            sectionsCount: groupedList.keys.length,
            countOfItemInSection: (section) => groupedList.values.elementAt(section).length,
            itemBuilder: (_, index) => _registersBookList(_, groupedList.values.elementAt(index.section).elementAt(index.index)),
            groupHeaderBuilder: (_, section) => Text(DateFormat('EEEE, d MMMM y').format(groupedList.keys.elementAt(section))),
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            sectionSeparatorBuilder: (_, section) => const SizedBox(height: 10),
          )
          // child: GroupedListView< Map<String, dynamic> , DateTime>(
          //   useStickyGroupSeparators: true,
          //   addSemanticIndexes: true,
          //   elements: registersBook,
          //   sort: true,
          //   groupBy: (e) {
          //     final date = e["date"] as DateTime;
          //     return DateTime(date.year, date.month, date.day);
          //   },
          //   groupSeparatorBuilder: (value) => ListTile(title: Text(
          //     DateFormat('EEEE, d MMMM y').format(value),
          //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          //   )),
          //   itemBuilder: (c, element) => registersBook.isNotEmpty ? _registersBookList(c, element) : 
          //     GridView.count(crossAxisCount: 1, children: [const Center(child: Text("No hay registros..."))]),
          //   order: GroupedListOrder.DESC,
          //   itemComparator: (el1, el2) => (el1["date"] as DateTime).compareTo(el2["date"] as DateTime),
          // ),
        )
      ),
    );
  }
}