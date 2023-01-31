<%-- 
    Document   : Index
    Created on : 14-mag-2018, 21.57.53
    Author     : Leonardo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonObject"%>
<jsp:include page="WEB-INF/tpls/IndexHeader.jsp" />
<nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="Index.jsp">Welcome ${businessName}</a>

    <ul class="navbar-nav px-3">
        <li class="nav-item text-nowrap">
            <a class="nav-link" href="${pageContext.request.contextPath}/Logout">Sign out</a>
        </li>
    </ul>
</nav>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
            <div class="sidebar-sticky">
                <ul class="nav flex-column" >
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/index">
                            <img src="${pageContext.request.contextPath}/img/config.png" style="width: 30px;height: 30px;"/></img>
                            Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Income.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"/></img>
                            Income analytics
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Cost.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"/></img>
                            Cost analytics
                        </a>
                    </li>
                    <li class="nav-item" >
                        <a class="nav-link" href="${pageContext.request.contextPath}/PLDashboard.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"/></img>
                            Profit and Loss 
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link "  href="${pageContext.request.contextPath}/OpexToSales.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"/></img>
                            Opex To Sales
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/PMA.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"/></img>
                            Profit Margin
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link " href="${pageContext.request.contextPath}/customer">
                            <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"/></img>
                            Customers
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link" href="${pageContext.request.contextPath}/supplier">
                            <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"/></img>
                            Supplier
                        </a>
                    </li>
                    
                </ul>
            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4" style="text-align: center;">
            <img src="${pageContext.request.contextPath}/img/Logo_Kugo_BI_sized.png" style="width: 25%;height: 21%;"/>
            <hr/>
            <h1 style="text-align: center;">HOME</h1>
            <hr/>
            <br>
            <h2>Benvenuto ${businessName}</h2>
            <p>
                Hai eseguito l'accesso a Kugo Business Intelligence;<br> 
                qui potrai visualizzare informazioni, indici e grafici 
                relativi alla tua azienda.<br>
                Tutte le informazioni generate da questa Web App sono calcolate da
                dati estrapolati dal database aziendale che viene gestito da Kugo Invoice.
            </p>
            <h2 style="font-style: italic; color: #999; ">
                Welcome ${businessName}
            </h2>
            <p style="font-style: italic; color: #999;">
                You have signed in to Kugo Business Intelligence; <br>
                here you can analyze information, indices and graphs
                about your company. <br>
                All information generated by this Web App is calculated by
                data extracted from the company database that is managed by Kugo Invoice.
            </p>
            <br>
            <hr/>
            <br>
            <div class="w3-row-padding w3-margin-bottom">
                <div class="w3-third">
                    <div class="w3-container w3-red w3-padding-16">
                        <div class="w3-left"></div>
                        <div class="w3-center">
                            <h3>${p_iva}</h3>
                        </div>
                        <div class="w3-clear w3-center">
                            <h4>partita iva</h4>
                        </div>
                    </div>
                </div>
                <div class="w3-third">
                    <div class="w3-container w3-teal w3-padding-16">
                        <div class="w3-left"></div>
                        <div class="w3-center">
                            <h3>${cod_fisc}</h3>
                        </div>
                        <div class="w3-clear w3-center">
                            <h4>cod_fisc</h4>
                        </div>
                    </div>
                </div>
                <div class="w3-third">
                    <div class="w3-container w3-orange w3-text-white w3-padding-16">
                        <div class="w3-left"></div>
                        <div class=" w3-center">
                            <h3>${email}</h3>
                        </div>
                        <div class="w3-clear w3-center">
                            <h4>Email</h4>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery-slim.min.js"><\/script>')</script>
<script src="../../assets/js/vendor/popper.min.js"></script>
<script src="../../dist/js/bootstrap.min.js"></script>

<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>
<jsp:include page="WEB-INF/tpls/IndexFooter.jsp" />