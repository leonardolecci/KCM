<%-- 
    Document   : PLDashboard
    Created on : 15-mag-2018, 20.01.04
    Author     : Leonardo
--%>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.kugobi.database.DatabaseManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/tpls/PLDashboardHeader.jsp" />
<%
    //Controllo se esiste una sessione (utente loggato)
    if (session == null) {
        //Sessione non esistente, inoltro alla pagina di login
        response.sendRedirect("Login.jsp");
    } else {
        if (session.getAttribute("businessName") == null) {
            response.sendRedirect("Login.jsp");
        }
    }
    String a = "";
    double b = 0;
    boolean entro = false;
    String cambiodata = "";
    String cambiavalore = "";
    String va = "";
    String varImponibile = "";
    String varData = "";
    int i = 0;
    String max = null;
    int maxint = 0;
    int year = Calendar.getInstance().get(Calendar.YEAR) - 1;
    String yearString = String.valueOf(year);
    Gson gsonMonth = new Gson();
    Map<Object, Object> mapMonth = null;
    List<Map<Object, Object>> listMonth = new ArrayList<Map<Object, Object>>();
    DatabaseManager db = new DatabaseManager();
    String imponibile = null;
    String data = null;
    String dataPointsBar = null;
    String dataPointsMonth = null;
    String dataPointsYear = null;
    String dataPointsMonthCost = null;
    String dataPointsYearCost = null;
    String dataPointsMonthd = null;
    String MonthCD = null;
    String MonthCDD = null;
// FATTURATO PER MESE
    Connection conn = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement stt = conn.prepareStatement("SELECT SUM(imponibile) as totImp, SUBSTRING( data , 4 ,2) as dataImp FROM fatture_vendita WHERE SUBSTRING( data , 7 ,4)>? GROUP BY dataImp");
    stt.setString(1, yearString);
    ResultSet resultSett = stt.executeQuery();

    //mesi anno corrente
    while (resultSett.next()) {
        varImponibile = resultSett.getString("totImp");
        b = Double.valueOf(varImponibile);
        varData = resultSett.getString("dataImp");
        mapMonth = new HashMap<Object, Object>();
        mapMonth.put("y", b);
        mapMonth.put("label", varData);
        listMonth.add(mapMonth);
        dataPointsMonth = gsonMonth.toJson(listMonth);
        if (Integer.valueOf(varData) > maxint) {
            max = varData;
        }
    }
    //mesi anno precedente
    year--;
    int yearCurr = Calendar.getInstance().get(Calendar.YEAR);
    String yearStringCurr = String.valueOf(yearCurr);
    String yearStringPrec = String.valueOf(year);
    Connection connd = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    Gson gsonMonthd = new Gson();
    Map<Object, Object> mapMonthd = null;
    List<Map<Object, Object>> listMonthd = new ArrayList<Map<Object, Object>>();

    PreparedStatement sttd = connd.prepareStatement("SELECT SUM(imponibile) as totImp, SUBSTRING( data , 4 ,2) as dataImp FROM fatture_vendita WHERE SUBSTRING( data , 7 ,4)>? AND SUBSTRING( data , 7 ,4)<? AND SUBSTRING( data , 4 ,2)<=?  GROUP BY dataImp");
    sttd.setString(1, yearStringPrec);
    sttd.setString(2, yearStringCurr);
    sttd.setString(3, max);
    ResultSet resultSettd = sttd.executeQuery();

    while (resultSettd.next()) {
        varImponibile = resultSettd.getString("totImp");
        b = Double.valueOf(varImponibile) + (Double.valueOf(varImponibile) * (0.1));
        varData = resultSettd.getString("dataImp");
        mapMonthd = new HashMap<Object, Object>();
        mapMonthd.put("y", b);
        mapMonthd.put("label", varData);
        listMonthd.add(mapMonthd);
        dataPointsMonthd = gsonMonthd.toJson(listMonthd);
    }
    connd.close();
    conn.close();
    System.out.println("month: " + dataPointsMonth);

    System.out.println("monthdddd: " + dataPointsMonthd);
%>
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
                        <a class="nav-link " href="${pageContext.request.contextPath}/index">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/PLDashboard.jsp">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/supplier">
                            <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"></img>
                            Supplier
                        </a>
                    </li>
                    
                </ul>  
            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <h1 style="text-align: center;">PROFIT AND LOSS DASHBOARD</h1>
            <hr/>
            <br>
            <div style="text-align: center;">
                <h4>
                    A better view on the finiancial status of the company
                </h4>
                <p>
                    A profit and loss statement (P&L) is a financial statement that summarizes the revenues,
                    costs and expenses incurred during a specific period of time.                    
                    A P&L report goes to the manager in charge of each profit center;
                    these confidential profit reports do not circulate outside the business.
                    Its goal is to Provide information about a company’s ability, or lack thereof,
                    to generate profit by increasing revenue, reducing costs, or both.
                </p>
            </div>

            <hr/>
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
                <h3>
                    Vendite previste e vendite reali
                </h3>

                <p>
                    Questo grafico rappresenta le entrate misurate su una frequenza mensile, esso misura sia
                    quelle previste, sia quelle effettivamente realizzate.<br>
                    Il grafico in questione rappresenta una visuale importante sull'andamento
                    delle entrate aziendali mensili confrontandole con quanto ci si aspettava in base ai dati 
                    precedentemente raccolti.
                    <br>
                </p>
                <h4 style="font-style: italic; color: #999;">
                    Predicted sales and actual sales
                </h4>
                <p style="font-style: italic; color: #999;">
                    This graphic represent the income on monthly frequency, it measures  both the predicted
                    sales and the actual sales. <br>
                    This is an important view as compare actual income from different month with the predicted sales,
                    the theorical data are calculated from the data of past incomes retrived from the database.
                </p>
                <br>
                <div id="PeL" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div>
        </main>
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

    <script>
        window.onload = function () {

            var chart = new CanvasJS.Chart("PeL", {
                animationEnabled: true,
                zoomEnabled: true,
                exportEnabled: true,
                theme: "light2",
                title: {
                    text: "Predicted sales and actual sales"
                },
                axisY: {
                    prefix: "€",
                    labelFormatter: addSymbols
                },
                toolTip: {
                    shared: true
                },
                legend: {
                    cursor: "pointer",
                    itemclick: toggleDataSeries
                },
                data: [
                    {
                        type: "column",
                        name: "Actual Sales",
                        showInLegend: true,
                        yValueFormatString: "€#,##0",
                        dataPoints: <%out.print(dataPointsMonth);%>
                    },
                    {
                        type: "line",
                        name: "Expected Sales",
                        showInLegend: true,
                        yValueFormatString: "€#,##0",
                        dataPoints: <%out.print(dataPointsMonthd);%>
                    },
                    {
                        type: "area",
                        name: "Profit",
                        markerBorderColor: "white",
                        markerBorderThickness: 2,
                        showInLegend: true,
                        yValueFormatString: "€#,##0",
                        dataPoints: [

                        ]
                    }]
            });
            chart.render();

            function addSymbols(e) {
                var suffixes = ["", "K", "M", "B"];
                var order = Math.max(Math.floor(Math.log(e.value) / Math.log(1000)), 0);

                if (order > suffixes.length - 1)
                    order = suffixes.length - 1;

                var suffix = suffixes[order];
                return CanvasJS.formatNumber(e.value / Math.pow(1000, order)) + suffix;
            }

            function toggleDataSeries(e) {
                if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
                    e.dataSeries.visible = false;
                } else {
                    e.dataSeries.visible = true;
                }
                e.chart.render();
            }

        }
    </script>
    <jsp:include page="WEB-INF/tpls/PLDashboardFooter.jsp" />
