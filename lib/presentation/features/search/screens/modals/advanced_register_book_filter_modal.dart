import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:nawiapp/data/local/views/register_book_view.dart';
import 'package:nawiapp/data/mappers/student_mapper.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book_type.dart';
import 'package:nawiapp/domain/models/student/summary/student_summary.dart';
import 'package:nawiapp/domain/services/student_service_base.dart';
import 'package:nawiapp/presentation/features/search/widgets/multi_select_student_field.dart';

class AdvancedRegisterBookFilterModal extends StatefulWidget {
  final RegisterBookFilter currentFilter;

  const AdvancedRegisterBookFilterModal({ super.key, required this.currentFilter });

  @override
  State<AdvancedRegisterBookFilterModal> createState() => _AdvancedRegisterBookFilterModalState();
}

class _AdvancedRegisterBookFilterModalState extends State<AdvancedRegisterBookFilterModal> {

  late RegisterBookFilter _filter;
  final service = GetIt.I<StudentServiceBase>();

  final List<StudentSummary> _selectedStudents = [];
  late Future<Iterable<StudentSummary>> _loadMentions;

  late DateTimeRange? _timestampPicker;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _loadMentions = loadMention();
    _timestampPicker = _filter.timestampRange;
  }

  Future<Iterable<StudentSummary>> loadMention() {
    return Future.wait(_filter.searchByStudentsId.map(
      (e) async => (await service.getOne(e)).getValue!.toStudentSummary)      
    ).then((value) => _selectedStudents..addAll(value));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Filtro avanzado", style: Theme.of(context).textTheme.headlineMedium),
      content: FutureBuilder(
        future: _loadMentions,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
          if(snapshot.data == null) return const Center(child: Text('Ha ocurrido un error al cargar el filtro anterior'));
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo', style: Theme.of(context).textTheme.bodyMedium),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<RegisterBookType>(
                      multiSelectionEnabled: false,
                      emptySelectionAllowed: true,
                      segments: [
                        ButtonSegment(value: RegisterBookType.register, label: const Text('Registro')),
                        ButtonSegment(value: RegisterBookType.incident, label: const Text('Incidente')),
                        ButtonSegment(value: RegisterBookType.anecdotal, label: const Text('Anecdótico')),
                      ],
                      selected: _filter.searchByType != null ? { _filter.searchByType! } : { },
                      onSelectionChanged: (byTypeSet) => setState(
                        () => _filter = _filter.copyWith(
                          //* Establece a null el parametro de searchByType si este es nulo
                          searchByType: byTypeSet.firstOrNull,
                          setTypeAsNull: byTypeSet.firstOrNull == null
                        )
                      ),
                    ),
                  ),
          
          
                  Text('Ordenar', style: Theme.of(context).textTheme.bodyMedium),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<RegisterBookViewOrderByType>(
                      multiSelectionEnabled: false,
                      segments: [
                        ButtonSegment(value: RegisterBookViewOrderByType.timestampRecently, label: const Text('Reciente')),
                        ButtonSegment(value: RegisterBookViewOrderByType.timestampOldy, label: const Text('Antiguo')),
                        ButtonSegment(value: RegisterBookViewOrderByType.actionAsc, label: const Text('A-Z')),
                        ButtonSegment(value: RegisterBookViewOrderByType.actionDesc, label: const Text('Z-A')),
                      ],
                      selected: { _filter.orderBy },
                      onSelectionChanged: (orderBySet) => setState(() => _filter = _filter.copyWith(orderBy: orderBySet.first)),
                    ),
                  ),
          
                  const SizedBox(height: 30),
          
                  Text('Por estudiantes', style: Theme.of(context).textTheme.bodyMedium),
                  MultiSelectStudentField(
                    initialSelectedStudents: _selectedStudents,
                    onDeleted: (data) => _filter = _filter.copyWith(searchByStudentsId: data.map((e) => e.id)),
                    onSelected: (data) => _filter = _filter.copyWith(searchByStudentsId: data.map((e) => e.id)),
                  ),

                  const SizedBox(height: 10),

                  Text('Por rango de fechas', style: Theme.of(context).textTheme.bodyMedium),
                  ElevatedButton(
                    child: Text(_timestampPicker != null ?
                      'De ${DateFormat('dd/MM/y').format(_timestampPicker!.start)} hasta ${DateFormat('dd/MM/y').format(_timestampPicker!.end)}' :
                      'Seleccione un rango de fechas',
                    ),
                    onPressed: () async {
                      final dateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                        confirmText: "Aceptar",
                        cancelText: "Cancelar",
                        saveText: "Guardar",
                        helpText: "Selecciona el rango de fechas"
                      );

                      if(dateRange != null) {
                        setState(() {
                          _timestampPicker = dateRange;
                          _filter = _filter.copyWith(timestampRange: _timestampPicker);
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancelar")
        ),
        
        TextButton(
          onPressed: () => Navigator.of(context).pop(_filter),
          child: const Text("Aceptar")
        ),
      ],
    );
  }
}