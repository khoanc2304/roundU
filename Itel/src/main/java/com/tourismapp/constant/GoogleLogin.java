/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.constant;

import java.io.IOException;
import com.tourismapp.utils.ErrDialog;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.tourismapp.model.GoogleAccount;

/**
 *
 * @author Admin
 */
public class GoogleLogin {

    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(IConstant.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                                .add("client_id", IConstant.GOOGLE_CLIENT_ID)
                                .add("client_secret", IConstant.GOOGLE_CLIENT_SECRET)
                                .add("redirect_uri", IConstant.GOOGLE_REDIRECT_URI)
                                .add("code", code)
                                .add("grant_type", "authorization_code")
                                .build()
                )
                .execute()
                .returnContent()
                .asString();
        ErrDialog.showError("resp: " + response);
        JsonObject obj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = obj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static GoogleAccount getUserInfo(final String accessToken)
            throws ClientProtocolException, IOException {
        String link = IConstant.GOOGLE_LINK_GET_USER_INFO + accessToken;

        String response = Request.Get(link)
                .execute()
                .returnContent()
                .asString();

        GoogleAccount googlePojo = new Gson().fromJson(response, GoogleAccount.class);

        return googlePojo;
    }

}
