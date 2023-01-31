/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kugobi.classes;

/**
 *
 * @author Leonardo
 */
public class Supplier {

    String cod_fornitore;
    String rag_soc_fornitore;
    String p_iva_fornitore;
    String cod_fisc_fornitore;
    String indirizzo;
    String citta;
    String cap;
    String prov;
    String nazione;
    String telefono;
    String fax;
    String sito_web;
    String email_fornitore;
    String agente;
    String data_aggiunta;
    String banca;
    String iban;
    String bic_swift;

    public Supplier(String cod_fornitore, String rag_soc_fornitore, String p_iva_fornitore, String cod_fisc_fornitore, String indirizzo, String citta, String cap, String prov, String nazione, String telefono, String fax, String sito_web, String email_fornitore, String agente, String data_aggiunta, String banca, String iban, String bic_swift) {
        this.cod_fornitore = cod_fornitore;
        this.rag_soc_fornitore = rag_soc_fornitore;
        this.p_iva_fornitore = p_iva_fornitore;
        this.cod_fisc_fornitore = cod_fisc_fornitore;
        this.indirizzo = indirizzo;
        this.citta = citta;
        this.cap = cap;
        this.prov = prov;
        this.nazione = nazione;
        this.telefono = telefono;
        this.fax = fax;
        this.sito_web = sito_web;
        this.email_fornitore = email_fornitore;
        this.agente = agente;
        this.data_aggiunta = data_aggiunta;
    }

    public String getCod_fornitore() {
        return cod_fornitore;
    }

    public String getP_iva_fornitore() {
        return p_iva_fornitore;
    }

    public String getRag_soc_fornitore() {
        return rag_soc_fornitore;
    }

    public String getCod_fisc_fornitore() {
        return cod_fisc_fornitore;
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

    public String getEmail_fornitore() {
        return email_fornitore;
    }

    public String getAgente() {
        return agente;
    }

    public String getData_aggiunta() {
        return data_aggiunta;
    }
     public String getbanca() {
        return banca;
    }

    public String getiban() {
        return iban;
    }

    public String getBic_swift() {
        return bic_swift;
    }
}
