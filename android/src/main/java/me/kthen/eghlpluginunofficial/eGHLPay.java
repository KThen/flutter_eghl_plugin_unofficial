// This code can only handle one payment at any given moment - no concurrent payments
// are allowed!

package me.kthen.eghlpluginunofficial;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

import com.eghl.sdk.EGHL;
import com.eghl.sdk.interfaces.MasterpassCallback;
import com.eghl.sdk.params.MasterpassParams;
import com.eghl.sdk.params.PaymentParams;
import com.eghl.sdk.params.Params;
import com.eghl.sdk.payment.PaymentActivity;

import com.google.gson.Gson;

import android.content.Intent;
import android.util.Log;

import android.app.Activity;

public class eGHLPay {

    // Constants -------------------------------------------------------
    private static final String TAG = "eGHLPay";


    // Indicate payment are in progress --------------------------------
    private static boolean isInProgress = false;

    private Result _result;

    private EGHL eghl;

    private EghlPayment eghlPayParams;

    private Activity _activity;

    // Methods ---------------------------------------------------------

    public eGHLPay(Activity activity) {
        this._activity = activity;
    }

    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("makePayment")) {
            if(isInProgress) {
                result.error("REQUEST_IN_PROGRESS","Another request is in progress. Please wait a few seconds.", null);

            } else {
                this._result = result;
                try{
                    eghlPayParams = new Gson().fromJson(new Gson().toJsonTree(call.arguments()).getAsJsonObject().toString(), EghlPayment.class);

                } catch (Exception e) {
                    this._result.error("INVALID_PARAMETER", "Required parameter missing or invalid. " + e.getMessage(), null);
                }

                eghl = EGHL.getInstance();

                payViaEGHL();

            }
        } else if (call.method.equals("mpeRequest")) {
            if(isInProgress) {
                result.error("REQUEST_IN_PROGRESS","Another request is in progress. Please wait a few seconds.", null);

            } else {
                this._result = result;

                isInProgress = true;

                try{
                    EghlPayment arg0 = new Gson().fromJson(new Gson().toJsonTree(call.arguments()).getAsJsonObject().toString(), EghlPayment.class);

                    MasterpassParams.Builder params = new MasterpassParams.Builder();
                    params.setPaymentGateway(arg0.getPaymentGateway());
                    params.setServiceID(arg0.getServiceId());
                    params.setPassword(arg0.getPassword());
                    params.setCurrencyCode(arg0.getCurrencyCode());
                    params.setAmount(arg0.getAmount());
                    params.setTokenType(arg0.getTokenType());
                    params.setToken(arg0.getToken());
                    params.setPaymentDesc(arg0.getPaymentDesc());

                    EGHL eghl = EGHL.getInstance();
                    eghl.executeMasterpassRequest(
                            this._activity,
                            params.build(),
                            new MasterpassCallback() {
                                @Override
                                public void onResponse(final String response) {
                                    isInProgress = false;
                                    // Note: response string needs to be checked on
                                    // JavaScript side, as it could be successful or erronous.
                                    _result.success(response);
                                }

                                @Override
                                public void onError(Exception e) {
                                    isInProgress = false;
                                    _result.error("MPE_ERROR", "Masterpass request error. " + e.getMessage(), null);
                                }
                            }
                    );

                } catch (Exception e) {
                    this._result.error("INVALID_PARAMETER","Required parameter missing or invalid. " + e.getMessage(), null);
                }

            }
        } else {
            result.notImplemented();
        }
    }

    public void onActivityResult (int requestCode, int resultCode, Intent data)
    {
        if (requestCode == EGHL.REQUEST_PAYMENT) {
            isInProgress = false;
            String message = data.getStringExtra(EGHL.TXN_MESSAGE);
            switch (resultCode) {
                case EGHL.TRANSACTION_SUCCESS:
                    Log.d(TAG, "onActivityResult: payment successful");
                    String resultString = data.getStringExtra(EGHL.RAW_RESPONSE);
                    this._result.success(resultString);
                    this._result = null;

                    break;
                case EGHL.TRANSACTION_FAILED:
                    if(message == null) {
                        Log.d(TAG, "onActivityResult: payment failure");
                        this._result.error("PAYMENT_FAILED", String.valueOf(resultCode), null);
                        this._result = null;
                    } else {
                        // Check for "buyer cancelled" string in JS
                        Log.d(TAG, "onActivityResult: payment failure or cancelled '"+message+"'");
                        this._result.error("PAYMENT_CANCELLED", message, null);
                        this._result = null;
                    }

                    break;
                default:
                    Log.d(TAG, "onActivityResult: " + resultCode);
                    if(message == null) {
                        this._result.error("UNKNOWN_FAILED", String.valueOf(resultCode), null);
                        this._result = null;
                    } else {
                        this._result.error("UNKNOWN_CANCELLED", message, null);
                    }

                    break;
            }
        }
    }

    private void payViaEGHL ()
    {
        PaymentParams.Builder params;
        params = new PaymentParams.Builder()
                .setB4TaxAmt(eghlPayParams.getB4TaxAmt())
                .setTaxAmt(eghlPayParams.getTaxAmt())
                .setMerchantApprovalUrl(eghlPayParams.getMerchantApprovalUrl())
                .setMerchantUnapprovalUrl(eghlPayParams.getMerchantUnapprovalUrl())
                .setMerchantReturnUrl(eghlPayParams.getMerchantReturnUrl())
                .setMerchantCallbackUrl(eghlPayParams.getMerchantCallbackUrl())
                .setPaymentDesc(eghlPayParams.getPaymentDesc())
                .setLanguageCode(eghlPayParams.getLanguageCode())
                .setPageTimeout(eghlPayParams.getPageTimeout())
                .setPaymentGateway(eghlPayParams.getPaymentGateway())
                .setServiceId(eghlPayParams.getServiceId())
                .setPassword(eghlPayParams.getPassword())
                .setIssuingBank(eghlPayParams.getIssuingBank())
                .setAmount(eghlPayParams.getAmount())
                .setEppMonth(eghlPayParams.getEppMonth())
                .setBillAddr(eghlPayParams.getBillAddr())
                .setBillCity(eghlPayParams.getBillCity())
                .setBillCountry(eghlPayParams.getBillCountry())
                .setBillPostal(eghlPayParams.getBillPostal())
                .setBillRegion(eghlPayParams.getBillRegion())
                .setHashValue(eghlPayParams.getHashValue())
                .setShipAddr(eghlPayParams.getShipAddr())
                .setShipCity(eghlPayParams.getShipCity())
                .setShipCountry(eghlPayParams.getShipCountry())
                .setShipPostal(eghlPayParams.getShipPostal())
                .setShipRegion(eghlPayParams.getShipRegion())
                .setCustName(eghlPayParams.getCustName())
                .setCustEmail(eghlPayParams.getCustEmail())
                .setCustMac(eghlPayParams.getCustMac())
                .setCustPhone(eghlPayParams.getCustPhone())
                .setCustIp(eghlPayParams.getCustIp())
                .setMerchantName(eghlPayParams.getMerchantName())
                .setCurrencyCode(eghlPayParams.getCurrencyCode())
                .setToken(eghlPayParams.getToken())
                .setTokenType(eghlPayParams.getTokenType())
                .setTransactionType(eghlPayParams.getTransactionType())
                .setPaymentMethod(eghlPayParams.getPaymentMethod())
                .setPaymentTimeout(eghlPayParams.getPaymentTimeout())
                .setPaymentId(eghlPayParams.getPaymentId())
                .setSessionId(eghlPayParams.getSessionId())
                .setOrderNumber(eghlPayParams.getOrderNumber())
                .setPromoCode(eghlPayParams.getPromoCode())
                .setReqToken(eghlPayParams.getReqToken())
                .setReqVerifier(eghlPayParams.getReqVerifier())
                .setPairingToken(eghlPayParams.getPairingToken())
                .setPairingVerifier(eghlPayParams.getPairingVerifier())
                .setCheckoutResourceURL(eghlPayParams.getCheckoutResourceURL())
                .setCardID(eghlPayParams.getCardID())
                .setCardHolder(eghlPayParams.getCardHolder())
                .setCardNo(eghlPayParams.getCardNo())
                .setCardExp(eghlPayParams.getCardExp())
                .setCardCvv2(eghlPayParams.getCardCvv2())
                .setPreCheckoutID(eghlPayParams.getPreCheckoutID())
                .setParam6(eghlPayParams.getParam6())
                .setParam7(eghlPayParams.getParam7());

        // eGHL intent.
        Intent payment = new Intent(this._activity, PaymentActivity.class);
        payment.putExtras(params.build());

        // Launch the EGHL activity.
        isInProgress = true;
        this._activity.startActivityForResult(payment, EGHL.REQUEST_PAYMENT);
    }
}
