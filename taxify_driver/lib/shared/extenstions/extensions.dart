extension CapText on String {
  String get captalize {
    if (isEmpty) return this;

    return split(" ")
        .map((e) {
          e = e.toLowerCase();
          if (e.isNotEmpty) {
            e = e[0].toUpperCase() + e.substring(1);
          }
          return e;
        })
        .join(" ");
  }
}
