<%-- 
    Document   : Supplier
    Created on : 28-mag-2018, 9.46.29
    Author     : Leonardo
--%>

<%@page import="com.kugobi.classes.Supplier"%>
<%@page import="java.lang.String"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="WEB-INF/tpls/SupplierHeader.jsp" />
<nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">Welcome, ${businessName}</a>

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
                        <a class="nav-link" href="${pageContext.request.contextPath}/index">
                            <img src="${pageContext.request.contextPath}/img/config.png" style="width: 30px;height: 30px;"></img>
                            Home
                        </a>
                    </li>
                     <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Income.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Income analytics
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Cost.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Cost analytics
                        </a>
                    </li>
                    <li class="nav-item" >
                        <a class="nav-link" href="${pageContext.request.contextPath}/PLDashboard.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Profit and Loss 
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link "  href="${pageContext.request.contextPath}/OpexToSales.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Opex To Sales
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/PMA.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Profit Margin
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link " href="${pageContext.request.contextPath}/customer">
                            <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"></img>
                            Customers
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/supplier">
                           <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"></img>
                            Supplier
                        </a>
                    </li>
                    
                </ul>
            </div>
        </nav>


        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                <h1>SUPPLIER</h1>
            </div>
            <div>
                <input type="text" id="myInput" onkeyup="SearchBusinessNameFunction()" placeholder="Search for business name..." title="Type in a business name">
                <table style="text-align: center; border:solid 1px;" id="myTable">
                    <tr style="border:solid 1px;">
                        <th>Ragione Sociale</th>
                        <th>Codice Cliente</th>                        
                        <th>Partita IVA</th>
                        <!--<th>Codice Fiscale</th>-->
                        <th>Indirizzo</th>
                        <th>Città</th>
                        <th>CAP</th>
                        <th>Provincia</th>
                        <th>Nazione</th>
                        <th>Telefono</th>
                        <!--<th>Fax</th>
                        <th>Sito Web</th>-->
                        <th>Email</th>
                        <!--<th>Agente</th>
                        <th>Data Aggiunta</th>-->
                    </tr>
                    <c:forEach items="${SupplierList}" var="supplier">
                        <tr style="border:solid 1px;">
                            <td>${supplier.rag_soc_fornitore}</td>
                            <td>${supplier.cod_fornitore}</td>    
                            <td>${supplier.p_iva_fornitore}</td>    
                            <!--<td>${supplier.cod_fisc_fornitore}</td>    -->
                            <td>${supplier.indirizzo}</td>
                            <td>${supplier.citta}</td>  
                            <td>${supplier.cap}</td>    
                            <td>${supplier.prov}</td>    
                            <td>${supplier.nazione}</td>    
                            <td>${supplier.telefono}</td>    
                            <!--<td>${supplier.fax}</td>  
                            <td>${supplier.sito_web}</td>  -->  
                            <td>${supplier.email_fornitore}</td>    
                            <!--<td>${supplier.agente}</td>    
                            <td>${supplier.data_aggiunta}</td>    -->
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </main>
    </div>
</div>

<script>
    function SearchBusinessNameFunction() {
        var input, filter, table, tr, td, i;
        input = document.getElementById("myInput");
        filter = input.value.toUpperCase();
        table = document.getElementById("myTable");
        tr = table.getElementsByTagName("tr");
        for (i = 0; i < tr.length; i++) {
            td = tr[i].getElementsByTagName("td")[0];
            if (td) {
                if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }
</script>                    
<jsp:include page="WEB-INF/tpls/SupplierHeader.jsp" />