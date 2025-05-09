import 'package:flutter_test/flutter_test.dart';
import 'package:nawiapp/utils/nawi_mapper_utils.dart';

import '../nawi_test_utils.dart';

void main() {
  test('Iniciales de un nombre', () {
    final String oneInitial = MapperUtils.initialName('Pedro');
    customExpect(oneInitial, 'P', about: 'Funcionando con 1 nombre', n: 1);

    final String twoInitial = MapperUtils.initialName('José Fernando');
    customExpect(twoInitial, 'JF', about: 'Funcionando con 2 nombres', n: 2);

    final String toManyInitial = MapperUtils.initialName('Alejandro Raul Paredes Briseño');
    customExpect(toManyInitial, 'AR', about: 'Funcionando con varios nombres', n: 3);

    final String emptyInitial = MapperUtils.initialName('');
    customExpect(emptyInitial, '0', about: 'Funcionando con ningún nombre', n: 4);

    final String emptyInitialWithSpaces = MapperUtils.initialName('     ');
    customExpect(emptyInitialWithSpaces, '0', about: 'Funcionando con espacios en blanco', n: 5);

    final String emptySecondName = MapperUtils.initialName('Jose  ');
    customExpect(emptySecondName, 'J', about: 'Funcionando incluso con espacios', n: 6);

    final String initialsWithAcuteAccent = MapperUtils.initialName('Álfredo Émbrosio');
    customExpect(initialsWithAcuteAccent, 'ÁÉ', about: 'Funcionando incluso con espacios', n: 7);

    final String initialsWithNumbers = MapperUtils.initialName(' 1 2 3');
    customExpect(initialsWithNumbers, '12', about: 'Funcionando con numeros', n: 8);
  });
}