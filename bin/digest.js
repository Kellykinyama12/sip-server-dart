exports.digest = function (req, res){
    console.log(req.body);
    
   var sipObj = sip.parse(req.body.sipmsg);
   //remove quotes some vendors put quotes in sip headers...
   for (var x in sipObj.headers.authorization[0]){
      sipObj.headers.authorization[0][x] = sipObj.headers.authorization[0][x].replace(/['"]/g,'');
    }
    
   console.log(sipObj);
   console.log(sipObj.headers.authorization[0]);
   var session = {realm : sipObj.headers.authorization[0].realm};
   session.proxy = false;
   session.nonce = sipObj.headers.authorization[0].nonce;
   session.qop = 'auth,auth-int';
   session.algorithm = 'md5';
   if(digest.authenticateRequest(
     session, 
     sipObj, 
     {user: req.body.username, password: req.body.password})){
        console.log('success');
        res.render('result' , {passed: true, sipmsg: req.body.sipmsg, username: req.body.username, password: req.body.password});
    }
    else{
        console.log('failed');
        res.render('result' , {passed: false, sipmsg: req.body.sipmsg, username: req.body.username, password: req.body.password});
    }
    
    
  }