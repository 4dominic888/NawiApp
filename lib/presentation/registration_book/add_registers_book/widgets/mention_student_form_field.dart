// import 'package:flutter/material.dart';
// import 'package:flutter_taggable/flutter_taggable.dart';
// import 'package:nawiapp/domain/models/register_book.dart';
// import 'package:nawiapp/domain/models/student.dart';
// import 'package:nawiapp/presentation/registration_book/add_registers_book/widgets/student_mention.dart';
// import 'package:nawiapp/presentation/students/utils/nawi_utils.dart';

// class MentionStudentFormField extends StatefulWidget {
//   const MentionStudentFormField({
//     super.key,
//     required this.formFieldKey,
//     required this.controller,
//     this.onChanged
//   });

//   final Key formFieldKey;
//   final FlutterTaggerController  controller;
//   final void Function()? onChanged;

//   @override
//   State<MentionStudentFormField> createState() => _MentionStudentFormFieldState();
// }

// class _MentionStudentFormFieldState extends State<MentionStudentFormField> {

//   //TODO cambiar a verdadero origen de datos
//   final _rawData = [
//     Student(name: "Juana", age: StudentAge.threeYears),
//     Student(name: "Paolo", age: StudentAge.fourYears),
//     Student(name: "Pedro", age: StudentAge.threeYears),
//     Student(name: "Maria_Jose", age: StudentAge.fiveYears),
//     Student(name: "Jose_Maria", age: StudentAge.fourYears),
//     Student(name: "Mario", age: StudentAge.fiveYears),
//     Student(name: "Pepe", age: StudentAge.threeYears)
//   ];

//   String? _mentionValue;
//   List<Student> _searchResult = [];

//   @override
//   void initState() {
//     _textController = TagTextEditingController(
//       searchTaggables: searchTaggables,
//       buildTaggables: buildTaggables,
//       toFrontendConverter: toFrontendConverter,
//       toBackendConverter: toBackendConverter
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _mentionValue != null ? suggestions() : Expanded(child: SizedBox()),
//           FormField<RegisterBook>(
//             key: widget.formFieldKey,
//             builder: (formState) {
//               return FlutterMentions(
//                 mentions: [
//                   Mention(
//                     trigger: "@"
//                     data: da
//                   )
//                 ]
//               );
//               // return MentionTagTextFormField(
//               //   keyboardType: TextInputType.multiline,
//               //   minLines: 1, maxLines: 5,
//               //   controller: widget.controller,
              
//               //   onMention: (mention) {
//               //     _mentionValue = mention;
//               //     _searchResult.clear();
//               //     setState(() {});
//               //     if(mention == null) return;
//               //     //* Aca simulando una solicitud de datos
//               //     //TODO Cambiar a esto luego
//               //     _searchResult = _rawData.where((data) => data.name.startsWith(mention)).take(3).toList();
//               //     setState(() {});
//               //   },
//               //   mentionTagDecoration: MentionTagDecoration(
//               //     mentionStart: ['@', '#'],
//               //     mentionBreak: ' ',
//               //     allowDecrement: false, allowEmbedding: false,
//               //     showMentionStartSymbol: false, maxWords: null,
//               //     mentionTextStyle: TextStyle(color: Colors.blue, backgroundColor: Colors.blue.shade50)
//               //   ),
//               //   decoration: const InputDecoration(
//               //     labelText: "Acción realizada",
//               //     prefix: Icon(Icons.attractions_sharp),
//               //     border: OutlineInputBorder(),
//               //     errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
//               //   ),
//               //   validator: (value) {
//               //     value = value?.trim();
//               //     if(value == null || value.isEmpty) return "Campo requerido";
//               //     return null;
//               //   },
//               //   onChanged: (value) {
//               //     formState.didChange(RegisterBook(
//               //       action: value,
//               //       mentions: _searchResult
//               //     ));
//               //     widget.onChanged?.call();
//               //   },
//               // );
//             }
//           )
//       ]
//     );
//   }

//   Widget suggestions() {
//     return Flexible(
//       fit: FlexFit.loose,
//       child: ListView.builder(
//         itemCount: _searchResult.length,
//         reverse: true,
//         itemBuilder: (_, index) => GestureDetector(
//           onTap: () {
//             widget.controller.addMention(
//               label: _searchResult[index].name,
//               data: _searchResult[index],
//               stylingWidget: widget.controller.mentions.length == 1 ?
//                StudentMention(
//                 controller: widget.controller,
//                 text: _searchResult[index].name
//                ): null
//             );
//             _mentionValue = null;
//             setState(() {});
//           },
//           child: ListTile(
//             title: Text(_searchResult[index].name),
//             subtitle: Text(_searchResult[index].age.name),
//             tileColor: index % 2 == 0 ?Colors.grey.shade200.withAlpha(80) : Colors.grey.shade200.withAlpha(100),
//             leading: CircleAvatar(
//               backgroundColor: NawiColor.iconColorMap(_searchResult[index].age.value, withOpacity: true),
//               child: Icon(Icons.person, color: NawiColor.iconColorMap(_searchResult[index].age.value)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }