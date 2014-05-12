	<%
	String sessionEndpoint = "http://" + server + ":" + port + "/diapasonws/SessionWS?wsdl";
	SessionWebServiceProxy sessionProxy = new SessionWebServiceProxy(sessionEndpoint);
	SessionWebService sessionWebService = sessionProxy.getSessionWebService();
	Session session = new Session();
	session.setCompany("01SIT01");
	session.setUser("DIAP60");
	session.setPasswd("DIAP60");
	session.setPlant("A");
	session.setLanguage("I");
	session.setLocation("tst:per:std");
		if (verbose != null) {
		session.setVerbose(verbose.trim());
		} else {
		session.setVerbose("1");
		}
	session.setLayout("GMA;/;:;.;,;D;D;A;Y");
	session.setEncoding("ISO-8859-1");
	String sessionId = null;
		try {
			// chiamata ai web service applicativi
			String dapiEndpoint = "http://" + server + ":" + port + "/diapasonws/DAPIWS?wsdl";
			DAPIWebServiceProxy dapiProxy = new DAPIWebServiceProxy(dapiEndpoint);
			DAPIWebService dapiWebService = dapiProxy.getDAPIWebService();
			String sessionId = null;
			try {
			String apiInput = "<GFDFMFDPCD><GFITEMS><FSDPC05><chartAccounts>VA;IT</chartAccounts></FSDPC05></GFITEMS></GFDFMFDPCD>";
			sessionId = sessionWebService.login(session);
			String apiOutput = dapiWebService.execute(sessionId, "GFDFMFDPCD", apiInput);
			sessionWebService.logout(sessionId);
			} catch (Exception e) {
			e.printStackTrace();
			}
		} catch (RemoteException e) {
		e.printStackTrace();
		} finally {
			try {
			if (sessionWebService != null && sessionId != null) {
			sessionWebService.logout(sessionId);
			}
			} catch (RemoteException e) {}
		}

	
/*
Nota Bene:
quando invoco una sola api alla volta utilizzo il metodo "execute" 
es: dapiWebService.execute(sessionId, "NOMEAPI", apiInput);
mentre se devo invocare due api contemporaneamente (come nel caso dell'inserimento dell'ordine) devo usare il metodo
es: dapiWebService.executeApis(sessionId,apiInput);	
però in apiInput le due diverse api devono essere sollecitate con questo schema
<Inputs>
			<API>
			<Input>
			//contenuto api 1
			</Input>
			</API>
			<API>
			<Input>
			//contenuto api 2
			</Input>
			</API>
</Inputs>
*/
	%>