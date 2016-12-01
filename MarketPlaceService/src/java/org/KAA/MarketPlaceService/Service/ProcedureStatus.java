/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

import javax.xml.bind.*;
import javax.xml.bind.annotation.*;
/**
 *
 * @author Ali-pc
 */
@XmlRootElement(name = "ProcedureStatus")
public class ProcedureStatus {
    @XmlElement(name="status",required=true)
    private String status;
    
    public ProcedureStatus(){
        status = "FAILED";
    }
    
    public ProcedureStatus(String message){
        status = message;
    }
}
