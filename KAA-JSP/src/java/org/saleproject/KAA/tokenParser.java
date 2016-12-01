/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.saleproject.KAA;

/**
 *
 * @author Ali-pc
 */
public class tokenParser {
    public static String parseBrowser(String token){
        int i = 0;
        String result = "";
        int countHastag = 0;
        while (i < token.length()){
            char x = token.charAt(i);
            if (x == '|'){
                countHastag++;
                i++;
            }
            if (countHastag == 1){
                result += token.charAt(i);
            }
            i++;
        }
        return result;
    }
    
    public static String parseIP(String token){
        int i = 0;
        String result = "";
        int countHastag = 0;
        while (i < token.length()){
            char x = token.charAt(i);
            if (x == '|'){
                countHastag++;
                i++;
            }
            if (countHastag == 2){
                result += token.charAt(i);
            }
            i++;
        }
        return result;
    }
}
