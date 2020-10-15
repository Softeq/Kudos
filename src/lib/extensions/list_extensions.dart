extension ListExtensions<T> on List<T> {
  void sortThen([
    int compare(T x, T y),
    int thenCompare(T x, T y),
  ]) {
    this.sort((x, y) {
      var first = compare(x, y);
      if (first == 0) {
        return thenCompare(x, y);
      } else {
        return first;
      }
    });
  }
}
