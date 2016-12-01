/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

import java.sql.Timestamp;
import java.util.Calendar;
import javax.xml.bind.annotation.XmlElement;

/**
 *
 * @author Azka Hanif Imtiyaz
 */
public class TS {
    @XmlElement(name="date",required=true)
    private String date;
    
    public TS(Timestamp t){
        Calendar c = Calendar.getInstance();
        c.setTimeInMillis(t.getTime());
        date = "" + c.getTime().toString();
    }
    
    public String getDate(){
        return date;
    }
}
