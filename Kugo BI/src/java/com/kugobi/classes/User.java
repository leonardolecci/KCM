package com.kugobi.classes;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/**
 *
 * @author 72150386
 */
public class User {

    String email;
    String password;
    String p_iva;
    String cod_fisc;
    String businessName;

    public User(String email, String password, String p_iva, String cod_fisc, String businessName) {
        this.email = email;
        this.password = password;
        this.p_iva = p_iva;
        this.cod_fisc = cod_fisc;
        this.businessName = businessName;
    }

    public User() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getP_iva() {
        return p_iva;
    }

    public String getCod_fisc() {
        return cod_fisc;
    }
    
    public String getBusinessName() {
        return businessName;
    }
}
