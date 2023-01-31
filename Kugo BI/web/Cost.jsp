<%-- 
    Document   : Income
    Created on : 4-giu-2018, 9.20.41
    Author     : Leonardo
--%>
<%@page import="com.kugobi.service.GeneralService"%>
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
<jsp:include page="WEB-INF/tpls/CostHeader.jsp" />
<%
    Gson gsonObj = new Gson();
    Map<Object, Object> map = null;
    List<Map<Object, Object>> list = new ArrayList<Map<Object, Object>>();
    DatabaseManager db = new DatabaseManager();
    String imponibile = null;
    String data = null;
    String dataPointsBar = null;
    String dataPointsMonth = null;
    String dataPointsYear = null;
    String dataPointsMonthCost = null;
    String dataPointsYearCost = null;
    GeneralService GS = new GeneralService();
    try {
        //Controllo se esiste una sessione (utente loggato)
        if (session == null) {
            //Sessione non esistente, inoltro alla pagina di login
            response.sendRedirect("Login.jsp");
        } else {
            if (session.getAttribute("businessName") == null) {
                response.sendRedirect("Login.jsp");
            }
        }

        // COSTI STIMATI PER ANNO
        Connection conc = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement stc = conc.prepareStatement("SELECT SUBSTRING( fatture_vendita.data , 7 ,4) as dataf, righe_fattura_vendita.codice as codiceProd, SUM(prodotti.prezzo_acquisto*righe_fattura_vendita.qta) as spese  FROM righe_fattura_vendita, prodotti, fatture_vendita WHERE righe_fattura_vendita.codice_ft=fatture_vendita.codice AND righe_fattura_vendita.codice=prodotti.codice  GROUP BY fatture_vendita.data ORDER BY dataf");
        ResultSet resultSetc = stc.executeQuery();

        Gson gsonYearCost = new Gson();
        Map<Object, Object> mapYearCost = null;
        List<Map<Object, Object>> listYearCost = new ArrayList<Map<Object, Object>>();
        String a = "";
        double b = 0;
        boolean entro = false;
        String cambiodata = "";
        String cambiavalore = "";
        String va = "";
        String varImponibile = "";
        String varData = "";
        String prodotto = "";
        String qta = "";
        String prezzo = "";
        Double q;
        int i = 0;
        ArrayList<String> dateA = new ArrayList<String>();

        if (resultSetc.next()) {
            prezzo = resultSetc.getString("spese");
            varData = resultSetc.getString("dataf");

        }
        a = varData;
        b = Double.valueOf(prezzo);
        dateA.add(a);
        while (resultSetc.next()) {
            varData = resultSetc.getString("dataf");
            if (a.equals(varData)) {
                prezzo = resultSetc.getString("spese");
                b += Double.valueOf(prezzo);
            } else {
                mapYearCost = new HashMap<Object, Object>();
                mapYearCost.put("y", GS.Rounded(b));
                mapYearCost.put("label", a);
                listYearCost.add(mapYearCost);
                dataPointsYearCost = gsonYearCost.toJson(listYearCost);
                a = varData;
                dateA.add(a);
                i++;
                prezzo = resultSetc.getString("spese");
                b = Double.valueOf(prezzo);
                entro = true;
            }

        }
        if ((entro == false) || (dateA.size() > i)) {
            mapYearCost = new HashMap<Object, Object>();
            mapYearCost.put("y", GS.Rounded(b));
            mapYearCost.put("label", a);
            listYearCost.add(mapYearCost);
            dataPointsYearCost = gsonYearCost.toJson(listYearCost);
        }
        conc.close();

        // COSTI STIMATI PER MESE
        Connection concc = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        int year = Calendar.getInstance().get(Calendar.YEAR) - 1;
        String yearString = String.valueOf(year);
        PreparedStatement stcc = concc.prepareStatement("SELECT SUBSTRING( fatture_vendita.data , 4 ,2) as dataf, righe_fattura_vendita.codice as codiceProd, SUM(prodotti.prezzo_acquisto*righe_fattura_vendita.qta) as spese  FROM righe_fattura_vendita, prodotti, fatture_vendita WHERE righe_fattura_vendita.codice_ft=fatture_vendita.codice AND righe_fattura_vendita.codice=prodotti.codice AND SUBSTRING( data , 7 ,4)>?  GROUP BY fatture_vendita.data ORDER BY dataf");
        stcc.setString(1, yearString);
        ResultSet resultSetcc = stcc.executeQuery();
        ArrayList<String> dateM = new ArrayList<String>();
        i = 0;
        Gson gsonMonthCost = new Gson();
        Map<Object, Object> mapMonthCost = null;
        List<Map<Object, Object>> listMonthCost = new ArrayList<Map<Object, Object>>();
        a = "";
        b = 0;
        entro = false;
        cambiodata = "";
        cambiavalore = "";
        va = "";
        varImponibile = "";
        varData = "";
        prodotto = "";
        qta = "";
        prezzo = "";
        q = 0.0;

        if (resultSetcc.next()) {
            prezzo = resultSetcc.getString("spese");
            varData = resultSetcc.getString("dataf");
            varData = varData;
        }
        a = varData;
        b = Double.valueOf(prezzo);
        dateM.add(a);
        while (resultSetcc.next()) {

            varData = resultSetcc.getString("dataf");
            if (a.equals(varData)) {
                prezzo = resultSetcc.getString("spese");
                b += Double.valueOf(prezzo);
            } else {
                mapMonthCost = new HashMap<Object, Object>();
                mapMonthCost.put("y", GS.Rounded(b));
                mapMonthCost.put("label", a);
                listMonthCost.add(mapMonthCost);
                dataPointsMonthCost = gsonMonthCost.toJson(listMonthCost);
                a = varData;
                i++;
                dateM.add(a);
                prezzo = resultSetcc.getString("spese");
                b = Double.valueOf(prezzo);
                entro = true;

            }

        }
        if ((entro == false) || (dateM.size() > i)) {
            mapMonthCost = new HashMap<Object, Object>();
            mapMonthCost.put("y", GS.Rounded(b));
            mapMonthCost.put("label", a);
            listMonthCost.add(mapMonthCost);
            dataPointsMonthCost = gsonMonthCost.toJson(listMonthCost);
        }
        concc.close();
    } catch (SQLException ex) {
    }

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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/Cost.jsp">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/supplier">
                            <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"></img>
                            Supplier
                        </a>
                    </li>
                   
                </ul>  
            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <h1 style="text-align: center;">COST DASHBOARD</h1>
            <hr>
            <br>
            <div style="text-align: center;">
                <h4>
                    Una visuale migliore sui costi aziendali
                </h4>
                <p>
                    Nella Cost Dashboard verranno visualizzati i costi aziendali per mese e per anno, i grafici potranno essere 
                    stampati o salvati in diversi formati.<br>
                    Questa sezione è importante per visualizzare i costi dell'azienda, ma è importante non dare troppo peso 
                    ai soli grafici dei costi poiché essi non sono sufficienti per giudicare la salute finanziaria di una
                    azienda.<br>
                    Per avere una visione sui guadagni <a href="Income.jsp"> clicca qui</a>
                </p>
                <h4 style="font-style: italic; color: #999;">
                    A better view on the company's expences
                </h4>
                <p style="font-style: italic; color: #999;">
                    In the Cost Dashboard graphics representing the company's exoences per months and years will be shown .<br>
                    This section is important to better understand the company's costs, but it's fundamental not to give to much
                    importance to the following information as they are not enough to judge the comapny's health<br>
                    For a view on the company's income please <a href="Income.jsp"> click here</a>
                </p>
            </div>
            <br>
            <hr>
            <br> 
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
                <h3>
                    Costi per anno
                </h3>
                
                <p>
                    Questo grafico rappresenta i costi misurati su una frequenza annua,
                    il grafico in questione rappresenta una visuale importante sull'andamento
                    dei costi aziendali di anno in anno, dando così la possibilità di avere una visione
                    più specifica delle finanze aziendali.
                    <br>
                </p>
                <h4 style="font-style: italic; color: #999;">Cost per year</h4>
                <p style="font-style: italic; color: #999;">
                    This graphic represent the costs on yearly frequency, 
                    this is an important view as compare the course of the company's costs from different years,
                    giving the possibility to have a so much wider view on the company's finance situation.
                </p>
                <br>
                <div id="CostoPerAnno" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div>
            <br>
            <hr/>           
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
                <h3>
                    Costi per mese
                </h3>
                
                <p>
                    Questo grafico rappresenta i costi misurati su una frequenza mensile,
                    il grafico in questione rappresenta una visuale importante sull'andamento
                    dei costi aziendali di mese in mese,
                    dando così la possibilità di avere una visione ancora più specifica delle finanze aziendali.
                </p>
                <h4 style="font-style: italic; color: #999;">Cost per month</h4>
                <p style="font-style: italic; color: #999;">
                    This graphic represent the costs on monthly frequency, 
                    this is an important view as compare the course of the company's costs from different months,
                    giving the possibility to have a so much wider view on the company's finance situation.
                </p>
                </p>
                <br>
                <div id="CostoPerMese" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div>
            <hr/>

        </main>
    </div>
    <script type="text/javascript">
        window.onload = function () {
        <% if (dataPointsYearCost != null) { %>
            var chart = new CanvasJS.Chart("CostoPerAnno", {
                animationEnabled: true,
                zoomEnabled: true,
                exportEnabled: true,
                title: {
                    text: "Cost per year"
                },
                axisY: {
                    prefix: "€",
                    title: "COST IN €"
                },

                data: [{
                        type: "spline", //change type to bar, line, area, pie, etc
                        dataPoints: <%out.print(dataPointsYearCost);%>
                    }]
            });
            chart.render();
        <% }%>
        <% if (dataPointsYearCost != null) { %>
            var chart = new CanvasJS.Chart("CostoPerMese", {
                animationEnabled: true,
                zoomEnabled: true,
                exportEnabled: true,
                title: {
                    text: "Cost per month"
                },
                axisY: {
                    prefix: "€",
                    title: "COST IN €"
                },

                data: [{
                        type: "spline", //change type to bar, line, area, pie, etc
                        dataPoints: <%out.print(dataPointsMonthCost);%>
                    }]
            });
            chart.render();
        <% }%>
        }
    </script>
    <jsp:include page="WEB-INF/tpls/CostFooter.jsp" />