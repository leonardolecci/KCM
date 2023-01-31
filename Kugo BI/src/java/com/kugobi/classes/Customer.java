package com.kugobi.classes;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Leonardo
 */
public class Customer {

    String cod_cliente;
    String rag_soc_cliente;
    String p_iva_cliente;
    String cod_fisc_cliente;
    String indirizzo;
    String citta;
    String cap;
    String prov;
    String nazione;
    String telefono;
    String fax;
    String sito_web;
    String email_cliente;
    String agente;
    String data_aggiunta;

    public Customer(String cod_cliente, String rag_soc_cliente, String p_iva_cliente, String cod_fisc_cliente, String indirizzo, String citta, String cap, String prov, String nazione, String telefono, String fax, String sito_web, String email_cliente, String agente, String data_aggiunta) {
        this.cod_cliente = cod_cliente;
        this.rag_soc_cliente = rag_soc_cliente;
        this.p_iva_cliente = p_iva_cliente;
        this.cod_fisc_cliente = cod_fisc_cliente;
        this.indirizzo = indirizzo;
        this.citta = citta;
        this.cap = cap;
        this.prov = prov;
        this.nazione = nazione;
        this.telefono = telefono;
        this.fax = fax;
        this.sito_web = sito_web;
        this.email_cliente = email_cliente;
        this.agente = agente;
        this.data_aggiunta = data_aggiunta;
    }

    public String getCod_cliente() {
        return cod_cliente;
    }

    public String getP_iva_cliente() {
        return p_iva_cliente;
    }

    public String getRag_soc_cliente() {
        return rag_soc_cliente;
    }

    public String getCod_fisc_cliente() {
        return cod_fisc_cliente;
    }

    public String getIndirizzo() {
        return indirizzo;
    }

    public String getCitta() {
        return citta;
    }

    public String getCap() {
        return cap;
    }

    public String getProv() {
        return prov;
    }

    public String getNazione() {
        return nazione;
    }

    public String getTelefono() {
        return telefono;
    }

    public String getFax() {
        return fax;
    }

    public String getSito_web() {
        return sito_web;
    }

    public String getEmail_cliente() {
        return email_cliente;
    }

    public String getAgente() {
        return agente;
    }

    public String getData_aggiunta() {
        return data_aggiunta;
    }
}
