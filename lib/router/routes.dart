enum Routes {
  root("/"),
  signIn("/signIn"),
  chat("/chat"),
  preferance("/preference");

  final String path;
  const Routes(this.path);
}
