enum Routes {
  root("/"),
  chat("/chat"),
  preferance("/preference");

  final String path;
  const Routes(this.path);
}
