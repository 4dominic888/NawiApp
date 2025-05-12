import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/register_book/entity/register_book.dart';
import 'package:nawiapp/presentation/features/home/extra/menu_tabs.dart';
import 'package:nawiapp/presentation/features/home/providers/tab_index_provider.dart';
import 'package:nawiapp/presentation/features/search/providers/selectable_element_for_search_provider.dart';

class EmptyExportWidget extends StatelessWidget {
  const EmptyExportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("¿Cómo exportar mis registros del cuaderno de registro?", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 30),
          Image.asset('assets/images/export_example.png'),
          const SizedBox(height: 30),
          Text("Se generará un vista previa del PDF a generar en base al filtro escogido.\n\nUn filtro vacío hará que se filtre todo.", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: Consumer(
                  builder: (_, ref, __) {
                    return ElevatedButton(
                      child: const Text('Ir'),
                      onPressed: () {
                        ref.read(selectableElementForSearchProvider.notifier).state = RegisterBook;
                        ref.read(tabMenuProvider.notifier).goTo(NawiMenuTabs.search);
                      },
                    );
                  }
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}