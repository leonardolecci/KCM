/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kugobi.service;

import com.kugobi.database.DatabaseManager;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import static jdk.nashorn.internal.objects.NativeMath.round;

/**
 *
 * @author Daniele
 */
public class GeneralService {

    DatabaseManager db = new DatabaseManager();

    public GeneralService() {
    }

    /**
     * ritorna numero arrotondato a due decimale
     *
     * @param numero
     * @return
     */
    public double Rounded(double numero) {
        long factor = (long) Math.pow(10, 2);
        numero = numero * factor;
        long tmp = Math.round(numero);
        numero = ((double) tmp / factor);
        return numero;
    }

    public double getRounded(double numero) {
        round(numero, 2);
        return numero;
    }

    public String GetDate() {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate localDate = LocalDate.now();
        String date = (dtf.format(localDate));
        return date;
    }

    public String GetCurrentYear(){
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate localDate = LocalDate.now();
        String date = (dtf.format(localDate));
        int index=date.lastIndexOf("/");
        String year=date.substring(index+1,date.length());
        return year;
    }
    
    public String getYearFromData(String date){
        int index=date.lastIndexOf("/");
        String year=date.substring(index+1,date.length());
        return year;
    }

    public String CurrecyFormatted(double numero) {
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance();
        String s_numero = currencyFormatter.format(numero);
        return s_numero;
    }

    public String returnStandardVatCode() throws SQLException {
        String s = "";
        Connection con = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement st = con.prepareStatement("SELECT valore FROM `opzioni` WHERE chiave='iva_standard'");
        ResultSet resultSet = st.executeQuery();
        while (resultSet.next()) {
            s = resultSet.getString("valore");
        }
        con.close();

        return s;
    }

    public String returnCurrentVat() throws SQLException {
        String s = "";
        Connection con = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement st = con.prepareStatement("SELECT * FROM codici_iva c, opzioni o WHERE c.codice=o.valore AND chiave='iva_standard'");
        ResultSet resultSet = st.executeQuery();
        while (resultSet.next()) {
            s = resultSet.getString("percentuale");
        }
        con.close();

        return s;
    }

    public String returnCurrentVatDesc() throws SQLException {
        String s = "";
        Connection con = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement st = con.prepareStatement("SELECT * FROM codici_iva c, opzioni o WHERE c.codice=o.valore AND chiave='iva_standard'");
        ResultSet resultSet = st.executeQuery();
        while (resultSet.next()) {
            s = resultSet.getString("descrizione");
        }
        con.close();

        return s;
    }

    public boolean isThisDateValid(String dateToValidate) {

        String dateFromat = "dd/MM/yyyy";

        if (dateToValidate == null) {
            return false;
        }

        SimpleDateFormat sdf = new SimpleDateFormat(dateFromat);
        sdf.setLenient(false);

        try {

            //if not valid, it will throw ParseException
            Date date = sdf.parse(dateToValidate);
            //System.out.println(date);

        } catch (ParseException e) {
            JFrame frame = new JFrame();
            JOptionPane.showMessageDialog(frame, "La data deve essere nel formato gg/mm/aaaa", "Errore", JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
            return false;
        }

        return true;
    }

}
