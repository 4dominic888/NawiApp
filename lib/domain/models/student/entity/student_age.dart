enum StudentAge {
  threeYears(3, "3 años", alterName: "tres años"),
  fourYears(4, "4 años", alterName: "cuatro años"),
  fiveYears(5, "5 años", alterName: "cinco años"),
  custom.notDefined("No definido");

  final int value;
  final String name;
  final String? alterName;

  const StudentAge(this.value, this.name, {this.alterName});
  const StudentAge.notDefined(String n) : this(0, n);
}