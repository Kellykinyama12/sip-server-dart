class sockaddr_in {
  sockaddr_in(String addr, int port)
      : this.addr = addr,
        this.port = port {}
  String addr;
  int port;
}
