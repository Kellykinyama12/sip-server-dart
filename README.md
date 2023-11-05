A sip(Session Initiation Protocol) server in dart programming language. Its cross platform and can compile on magor operating systems.

Motivation: Writing a sip server from scratch in C++ is almost impossible and no networking library. Writing a SIP server from scratch in Dart just to a single weekend.

The sip server is highly extensible and can work as a drop in replacement of sip proxy
Currently supports UPD transport protocols. You need to download the Dart SDK and compile or run the project.

Simply clone the project.
-cd to the current directory
-and dart run 

The current registration provides basic authentication.

Features:

UDP yes
TLS no
WSS no

SIP trunks No

Supported headers are in bin/sipMessageHeaders
Supported Sip methods are in bin/sipMessageTypes
RequestHandler handles request and endHanle function sends responses