<%-- 
    Document   : index
    Created on : 13-mag-2018, 22.51.49
    Author     : Leonardo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/tpls/LoginHeader.jsp" />
 <form class="form-signin" method="POST" action="${pageContext.request.contextPath}/login">
      <img style=" float: left; padding-bottom: 10%;" src="${pageContext.request.contextPath}/img/Logo_Kugo_BI_2.png" alt="Kugo Business Intelligence">
      <br>
      <br>
      <label for="inputName" class="sr-only">Name</label>
      <input type="text" name="name" id="inputName" class="form-control" placeholder="Name" required autofocus>
      <br>
      <label for="inputPassword" class="sr-only">Password</label>
      <input type="password" name="password" id="inputPassword" class="form-control" placeholder="Password" required>
      <br>
      <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
      <p class="mt-5 mb-3 text-muted">&copy; 2017-2018</p>
    </form>
<jsp:include page="WEB-INF/tpls/LoginFooter.jsp" />

