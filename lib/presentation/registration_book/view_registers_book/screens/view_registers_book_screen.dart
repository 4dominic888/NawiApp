import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ViewRegistersBookScreen extends StatefulWidget {
  const ViewRegistersBookScreen({super.key});

  @override
  State<ViewRegistersBookScreen> createState() => _ViewRegistersBookScreenState();
}

class _ViewRegistersBookScreenState extends State<ViewRegistersBookScreen> {

  //TODO: Cambiar por origen de datos real
  final List<Map<String, dynamic>> registersBook = List.filled(3, [
    {"action": "Lorem Ipsum Dolor sit amet Asit aabbss", "date": DateTime(2025, 1, 15), "emisors": ["Pepe", "Pablo"]},
    {"action": "Amet Silli dolor Awe Dea Cajl", "date": DateTime(2025, 1, 15), "emisors": ["María José"]},
    {"action": "Sit Ipsum Lorem Amet Siti Coja", "date": DateTime(2025, 1, 13), "emisors": ["Mario", "Fernanda", "Julian", "Pepe", "Jose"]},
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async { },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),

          //TODO: Cambiar Map por el tipo de dato real.
          child: GroupedListView< Map<String, dynamic> , DateTime>(
            elements: registersBook,
            groupBy: (e) {
              final date = e["date"] as DateTime;
              return DateTime(date.year, date.month, date.day);
            },
            groupSeparatorBuilder: (value) => ListTile(title: Text(
              DateFormat('EEEE, d MMMM y').format(value),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            itemBuilder: (c, element) => registersBook.isNotEmpty ? _registersBookList(c, element) : 
              GridView.count(crossAxisCount: 1, children: [const Center(child: Text("No hay registros..."))]),
            order: GroupedListOrder.DESC,
            itemComparator: (el1, el2) => (el1["date"] as DateTime).compareTo(el2["date"] as DateTime),
          ),
        )
      ),
    );
  }
}