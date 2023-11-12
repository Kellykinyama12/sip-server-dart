import 'dart:isolate';

void concurrent() {
  Isolate isolate = findSomeIsolate();
  Isolate restrictedIsolate = Isolate(isolate.controlPort);
  untrustedCode(restrictedIsolate);
}
