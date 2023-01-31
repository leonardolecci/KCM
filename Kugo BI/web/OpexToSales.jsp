<%-- 
    Document   : OpexToSales
    Created on : 15-mag-2018, 20.01.19
    Author     : Leonardo
--%>

<%@page import="com.kugobi.service.GeneralService"%>
<%@page import="com.kugobi.database.DatabaseManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonObject"%>
<jsp:include page="WEB-INF/tpls/OpexToSalesHeader.jsp" />

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

// OPEX TO SALES TOTAL ([total expenses]/[total sales])
    GeneralService GS = new GeneralService();
    DatabaseManager db = new DatabaseManager();
    String imponibile = null;
    String data = null;
    String dataPointsBar = null;
    String dataPointsMonth = null;
    String dataPointsOPEXperClient = null;
    String dataPointsMonthCost = null;
    String dataPointsYearCost = null;
    String a = "";
    double b = 0;
    boolean entro = false;
    String cambiodata = "";
    String cambiavalore = "";
    String va = "";
    String varImponibileTotString = "";
    String varData = "";
    double OpSaTot = 0.0;
    double varImponibileTot = 0.0;
    ArrayList<String> dateA = new ArrayList<String>();
    //tot income
    Connection conn = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement stt = conn.prepareStatement("SELECT SUM(fatture_vendita.imponibile) as totImponibile FROM fatture_vendita");
    ResultSet resultSett = stt.executeQuery();
    if (resultSett.next()) {
        varImponibileTotString = resultSett.getString("totImponibile");
        varImponibileTot = Double.valueOf(varImponibileTotString);
    }
    conn.close();

    //tot expenses
    Connection conc = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement stc = conc.prepareStatement("SELECT righe_fattura_vendita.codice as codiceProd, SUM(righe_fattura_vendita.qta) as qta, prodotti.prezzo_acquisto as prz  FROM righe_fattura_vendita, prodotti, fatture_vendita WHERE righe_fattura_vendita.codice_ft=fatture_vendita.codice AND righe_fattura_vendita.codice=prodotti.codice  GROUP BY codiceProd");
    ResultSet resultSetc = stc.executeQuery();
    Gson gsonYearCost = new Gson();
    Map<Object, Object> mapYearCost = null;
    List<Map<Object, Object>> listYearCost = new ArrayList<Map<Object, Object>>();
    a = "";
    b = 0;
    entro = false;
    cambiodata = "";
    cambiavalore = "";
    va = "";
    String varImponibile = "";
    String rounded = "";
    varData = "";
    String prodotto = "";
    String qta = "";
    String prezzo = "";
    double totExpenses = 0.0;
    double q = 0.0;
    int i = 0;
    if (resultSetc.next()) {
        prodotto = resultSetc.getString("codiceProd");
        qta = resultSetc.getString("qta");
        prezzo = resultSetc.getString("prz");
    }
    a = prodotto;
    q = Double.valueOf(qta);
    b = Double.valueOf(prezzo) * q;
    totExpenses += b;
    dateA.add(a);
    while (resultSetc.next()) {

        prodotto = resultSetc.getString("codiceProd");
        if (a.equals(prodotto)) {
            qta = resultSetc.getString("qta");
            prezzo = resultSetc.getString("prz");
            q = Double.valueOf(qta);
            b += Double.valueOf(prezzo) * q;
        } else {
            totExpenses += b;
            a = prodotto;
            i++;
            dateA.add(a);
            qta = resultSetc.getString("qta");
            prezzo = resultSetc.getString("prz");
            q = Double.valueOf(qta);
            b = Double.valueOf(prezzo) * q;
            entro = true;
        }

    }
    if ((entro == false) || (dateA.size() > i)) {
        totExpenses += b;
    }
    OpSaTot = (totExpenses / varImponibileTot) * 100;
    OpSaTot = GS.Rounded(OpSaTot);

    conc.close();

// OPEX TO SALES PER PRODUCT ([total expenses per pr0duct]/[total sales per product])
    imponibile = null;
    data = null;
    dataPointsOPEXperClient = null;
    a = "";
    b = 0.0;
    entro = false;
    cambiodata = "";
    cambiavalore = "";
    va = "";
    varImponibileTotString = "";
    varData = "";
    double OpSaMonth = 0.0;
    varImponibileTot = 0.0;
    Connection conna = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement stta = conna.prepareStatement("SELECT  righe_fattura_vendita.prezzo as przVend, fatture_vendita.data as dataf, righe_fattura_vendita.codice as codiceProd, SUM( righe_fattura_vendita.qta ) as qta, prodotti.prezzo_acquisto as prz, prodotti.descrizione as descrizione FROM righe_fattura_vendita, prodotti, fatture_vendita WHERE righe_fattura_vendita.codice_ft=fatture_vendita.codice AND righe_fattura_vendita.codice=prodotti.codice GROUP BY righe_fattura_vendita.descrizione");
    ResultSet resultSetta = stta.executeQuery();

    Gson gsonOPPR = new Gson();
    Map<Object, Object> mapOPPR = null;
    List<Map<Object, Object>> listOPPR = new ArrayList<Map<Object, Object>>();
    a = "";
    b = 0;
    entro = false;
    cambiodata = "";
    cambiavalore = "";
    va = "";
    double impProd = 0.0;
    String varImponibileProd = "";
    varData = "";
    String codiceProd = "";
    String p = "";
    String info = "";
    double qtaint = 0;
    double prezzoacq = 0.0;
    double valrounded = 0.0;
    while (resultSetta.next()) {
        prodotto = resultSetta.getString("descrizione");
        b = Double.valueOf(resultSetta.getString("przVend"));
        prezzoacq = Double.valueOf(resultSetta.getString("prz"));
        qta = resultSetta.getString("qta");
        qtaint = Double.valueOf(qta);
        mapOPPR = new HashMap<Object, Object>();
        OpSaMonth = ((qtaint * prezzoacq) / (b * qtaint)) * 100;
        valrounded = GS.Rounded(OpSaMonth);
        impProd = qtaint * b;
        info = String.valueOf(impProd) + ", " + prodotto;
        mapOPPR.put("y", valrounded);
        mapOPPR.put("label", info);
        listOPPR.add(mapOPPR);
        dataPointsOPEXperClient = gsonOPPR.toJson(listOPPR);

    }
    conna.close();

//OPEX TO SALES RATIO PER MONTH
    imponibile = null;
    data = null;
    String dataPointsOPEXperMonth = null;
    a = "";
    b = 0.0;
    entro = false;
    cambiodata = "";
    cambiavalore = "";
    va = "";
    varImponibileTotString = "";
    varData = "";
    OpSaMonth = 0.0;
    int year = Calendar.getInstance().get(Calendar.YEAR) - 1;
    String yearString = String.valueOf(year);
    varImponibileTot = 0.0;

    Connection connam = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement sttam = connam.prepareStatement("SELECT SUBSTRING( fatture_vendita.data , 4 ,2) as dataf, prodotti.prezzo_acquisto as prz,  righe_fattura_vendita.codice as codiceProd, SUM(righe_fattura_vendita.qta) as qta, prodotti.prezzo as przVend  FROM righe_fattura_vendita, prodotti, fatture_vendita WHERE righe_fattura_vendita.codice_ft=fatture_vendita.codice AND righe_fattura_vendita.codice=prodotti.codice AND SUBSTRING( data , 7 ,4)>?  GROUP BY fatture_vendita.data ORDER BY dataf");
    sttam.setString(1, yearString);
    ResultSet resultSettam = sttam.executeQuery();

    Gson gsonOPPM = new Gson();
    Map<Object, Object> mapOPPM = null;
    List<Map<Object, Object>> listOPPM = new ArrayList<Map<Object, Object>>();
    a = "";
    b = 0;
    entro = false;
    cambiodata = "";
    cambiavalore = "";
    va = "";
    double g = 0.0;
    double exp = 0.0;
    impProd = 0.0;
    varImponibileProd = "";
    varData = "";
    codiceProd = "";
    p = "";
    info = "";
    qtaint = 0;
    prezzoacq = 0.0;
    valrounded = 0.0;
    i = 0;
    ArrayList<String> dateM = new ArrayList<String>();

    if (resultSettam.next()) {
        prezzo = resultSettam.getString("prz");
        p = resultSettam.getString("przVend");
        qta = resultSettam.getString("qta");
        data = resultSettam.getString("dataf");
        qtaint = Double.valueOf(qta);
        prezzoacq = Double.valueOf(prezzo);
    }
    a = data;
    b = Double.valueOf(p);
    dateM.add(a);
    g += qtaint * b;
    exp += qtaint * prezzoacq;

    while (resultSettam.next()) {
        varData = resultSettam.getString("dataf");
        if (a.equals(varData)) {
            g += qtaint * b;
            exp += qtaint * prezzoacq;
            b = Double.valueOf(resultSettam.getString("przVend"));
            prezzoacq = Double.valueOf(resultSettam.getString("prz"));
            qta = resultSettam.getString("qta");
            qtaint = Double.valueOf(qta);

        } else {
            mapOPPM = new HashMap<Object, Object>();
            OpSaMonth = (exp / g) * 100;
            valrounded = GS.Rounded(OpSaMonth);
            mapOPPM.put("y", valrounded);
            mapOPPM.put("label", a);
            listOPPM.add(mapOPPM);
            dataPointsOPEXperMonth = gsonOPPM.toJson(listOPPM);
            a = varData;
            dateM.add(a);
            b = Double.valueOf(resultSettam.getString("przVend"));
            prezzoacq = Double.valueOf(resultSettam.getString("prz"));
            qta = resultSettam.getString("qta");
            qtaint = Double.valueOf(qta);
            g = qtaint * b;
            exp = qtaint * prezzoacq;
            entro = true;
            i++;
        }

    }
    if ((entro == false) || (dateM.size() > i)) {
        mapOPPM = new HashMap<Object, Object>();
        a = varData;
        OpSaMonth = (exp / g) * 100;
        valrounded = GS.Rounded(OpSaMonth);
        mapOPPM.put("y", valrounded);
        mapOPPM.put("label", a);
        listOPPM.add(mapOPPM);
        dataPointsOPEXperMonth = gsonOPPM.toJson(listOPPM);
    }
    connam.close();
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/PLDashboard.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Profit and Loss 
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link active"  href="${pageContext.request.contextPath}/OpexToSales.jsp">
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
            <h1 style="text-align: center;">OPEX TO SALES</h1>
            <hr/>
            <br>
            <div style="text-align: center;">
                <h3>
                    Cosa significa 'Operating Ratio'
                </h3>
                <p>
                    L'operating ratio mostra l'efficienza del management di una azienda comparando le spese di gestione rispetto 
                    alle vendite; più basso è l'indice, più l'azienda è efficiente nel generare profitti.
                    Attenzione, l'operating ratio non tiene conto di debiti o altre spese al di fuori di quelle sopra citate.
                </p>
                <h3 style="font-style: italic; color: #999;">
                    What is the 'Operating Ratio'
                </h3>
                <p style="font-style: italic; color: #999;">
                    The operating ratio shows the efficiency of a company's management by comparing operating expense to net sales. 
                    The smaller the ratio, the greater the organization's ability to generate profit if revenues decrease.
                    When using this ratio, however, 
                    investors should be aware that it doesn't take debt repayment or expansion into account.
                </p>
            </div>
            <hr/> 
            <div style="text-align: center;">
                <h3> Opex to sales generale  </h3>
                <p>
                    Questo indice è calcolato sullo storico completo dell'azienda.

                </p>
                <h3 style="font-style: italic; color: #999;"> Total opex to sales ratio </h3>
                <p style="font-style: italic; color: #999;">
                    This ratio is calculated on a total view of the company, from the first invoice to the latest. 

                </p>
            </div>
            <div class="w3-row-padding w3-margin-bottom" style="padding-left: 33.3%">
                <div class="w3-IBAN ">
                    <div class="w3-container w3-red w3-padding-16">
                        <div class="w3-center"></div>
                        <div class="w3-center">
                            <h3><%out.print(OpSaTot);%> %</h3>
                        </div>
                        <div class=" w3-center"><h4>OPEX TO SALES RATIO (%)</h4></div>                        
                    </div>
                </div>
            </div>
            <br>
            <hr/>
            <br> 
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
                <h3>
                    Opex to sales per mese
                </h3>
                <p>
                    Questo grafico mostra l'indice di opex to sales per ogni mese dell'anno corrente.
                </p>
                <h3 style="font-style: italic; color: #999;">
                    Opex to sales ratio per month
                </h3>
                <p style="font-style: italic; color: #999;">
                    This graphic represent the opex to sales ratio on a monthly basis of the current year.
                </p>
                <br>
                <div id="OpexToSalesPerMonth" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div> 
            <br>
            <hr/>
            <br>
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
                <h3>
                    Opex to sales ratio per categoria
                </h3>
                <p>
                    Questo grafico mostra l'indice di opex to sales per ogni categoria di prodotti.
                </p>
                
                    <h3 style="font-style: italic; color: #999;">
                        Opex to sales ratio per category
                    </h3>
                    <p style="font-style: italic; color: #999;">
                        This graphic represent the opex to sales ratio for each category of products.
                    </p>
                <br>
                <div id="OpexToSalesPerClient" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div> 
            <hr/>
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

<!-- Graphs -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
<script type="text/javascript">
    window.onload = function () {
    <% if (dataPointsOPEXperClient != null) { %>
        var chart = new CanvasJS.Chart("OpexToSalesPerClient", {
            animationEnabled: true,
            zoomEnabled: true,
            exportEnabled: true,
            title: {
                text: "OPEX to SALES ratio per Category"
            },
            axisX: {
                title: "Gross Income per Category ",
                prefix: "€",
            },
            axisY: {
                title: "Opex to Sales Ratio",
            },
            data: [{
                    type: "scatter", //change type to bar, line, area, pie, etc
                    toolTipContent: "<b>Income: </b>€{label} <br/><b>Opex to Sales ratio: </b>{y}%",
                    dataPoints: <%out.print(dataPointsOPEXperClient);%>
                }]
        });
        chart.render();
    <% }%>
    <% if (dataPointsOPEXperMonth != null) { %>
        var chart = new CanvasJS.Chart("OpexToSalesPerMonth", {
            animationEnabled: true,
            zoomEnabled: true,
            exportEnabled: true,
            title: {
                text: "OPEX to SALES ratio per Month"
            },
            axisX: {
                title: "Gross Income per Month "
            },
            axisY: {
                title: "Opex to Sales Ratio",
            },
            data: [{
                    type: "scatter", //change type to bar, line, area, pie, etc
                    toolTipContent: "<b>Month: </b>{label} <br/><b>Opex to Sales ratio: </b>{y}%",
                    dataPoints: <%out.print(dataPointsOPEXperMonth);%>
                }]
        });
        chart.render();
    <% }%>

    }
</script>
<jsp:include page="WEB-INF/tpls/OpexToSalesHeader.jsp" />
