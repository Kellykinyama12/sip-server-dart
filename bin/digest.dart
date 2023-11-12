import 'dart:convert';
import 'package:crypto/crypto.dart';

String digest(
    String nonce,
    String realm,
    String uri,
    String username,
    String password,
    String cnonce,
    int nc,
    String qop,
    String entitybody,
    String digestUri,
    String algorithm) {
  // if (digestUri == "none") digestUri = realm;

  List<int>? HA1enc, HA2enc;
  Digest? HA1, HA2;

  String? responsestr;

  //check which algorithm needs to be used for calculating HA1
  if (algorithm.toLowerCase() == "md5") {
    String HA1str = username + ":" + realm + ":" + password;
    HA1enc = utf8.encode(HA1str);
    HA1 = md5.convert(HA1enc);
  }
  //  else if ((algorithm == "MD5-sess") || (algorithm == "md5-sess")) {
  //   HA1str1 = username + ":" + realm + ":" + password;
  //   HA1enc1 = utf8.encode(HA1str1);
  //   HA1str2 = HA1enc1.toString() + ":" + nonce + ":" + cnonce;
  //   HA1enc = utf8.encode(HA1str2);
  // } else //return ERROR if MD5 value is invalid
  //   throw "ERROR";

  //check which qop to use for calculating HA2
  if (qop == "none") {
    String HA2str = "REGISTER:" + uri;
    HA2enc = utf8.encode(HA2str);
    HA2 = md5.convert(HA2enc);
  }
  //  else if (qop == "auth-init") {
  //   HA2str1 = "REGISTER:" + digestUri;
  //   HA2enc1 = utf8.encode(HA2str1);
  //   HA2str = HA2str1 + ":" + HA2enc1.toString();
  //   HA2enc = utf8.encode(HA2str);
  // } else {
  //   //return ERROR if qop value is invalid
  //   //return "ERROR";
  //   throw "Error";
  // }
  //check which qop is used for calculating final MD5 hash
  if (qop == "none") {
    responsestr = HA1.toString() + ":" + nonce + ":" + HA2.toString();
  } else if ((qop == "auth") || (qop == "auth-init")) {
    responsestr = HA1.toString() +
        ":" +
        nonce +
        ":" +
        nc.toString() +
        ":" +
        cnonce +
        ":" +
        qop +
        ":" +
        HA2.toString();
  } else {
    //return ERROR if qop value is invalid

    throw "Error";
  }
  //return the final MD5 hash
  //return str((hashlib.md5(responsestr.encode()).hexdigest()));
  return md5.convert(utf8.encode(responsestr)).toString();
  //return ResponseEncodedString;
}
