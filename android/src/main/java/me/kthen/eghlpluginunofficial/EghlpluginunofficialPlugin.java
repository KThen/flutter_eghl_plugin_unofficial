package me.kthen.eghlpluginunofficial;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.eghl.sdk.EGHL;
import com.eghl.sdk.params.PaymentParams;

import java.text.DecimalFormat;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class EghlpluginunofficialPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private MethodChannel channel;
    private Activity activity;
    private Result result;

    private static EGHL eghl = EGHL.getInstance();
    private static DecimalFormat twoDecimalPlacesFormat = new DecimalFormat("#.00");

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "eghl_plugin_unofficial");
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "eghl_plugin_unofficial");

        EghlpluginunofficialPlugin plugin = new EghlpluginunofficialPlugin();
        plugin.setActivity(registrar.activity());

        registrar.addActivityResultListener(plugin);

        channel.setMethodCallHandler(plugin);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("makePayment")) {
            if (activity == null) {
                result.error("EPU-0003", "App not ready to handle request.", null);
                return;
            }

            this.result = result;

            final PaymentParams.Builder params = new PaymentParams.Builder()
                    .setServiceId(call.argument("serviceId").toString())
                    .setAmount(twoDecimalPlacesFormat.format(call.argument("amount")))
                    .setMerchantName(call.argument("merchantName").toString())
                    .setPaymentId(call.argument("paymentId").toString())
                    .setOrderNumber(call.argument("orderNumber").toString())
                    .setCurrencyCode(call.argument("currencyCode").toString())
                    .setLanguageCode(call.argument("languageCode").toString())
                    .setPaymentMethod(call.argument("paymentMethod").toString())
                    .setPageTimeout(call.argument("pageTimeoutSecs").toString())
                    .setTransactionType(call.argument("transactionType").toString())
                    .setMerchantReturnUrl(call.argument("merchantReturnUrl").toString())
                    .setDebugPaymentURL(getKeyAsBoolean(call, "useDebugPaymentUrl"));

            String paymentDescription = getKeyAsString(call, "paymentDescription");
            if (paymentDescription != null) {
                params.setPaymentDesc(paymentDescription);
            }

            String customerIpAddress = getKeyAsString(call, "customerIpAddress");
            if (customerIpAddress != null) {
                params.setCustIp(customerIpAddress);
            }

            String customerName = getKeyAsString(call, "customerName");
            if (customerName != null) {
                params.setCustName(customerName);
            }

            String customerEmail = getKeyAsString(call, "customerEmail");
            if (customerEmail != null) {
                params.setCustEmail(customerEmail);
            }

            String customerPhone = getKeyAsString(call, "customerPhone");
            if (customerPhone != null) {
                params.setCustPhone(customerPhone);
            }

            String customerMacAddress = getKeyAsString(call, "customerMacAddress");
            if (customerMacAddress != null) {
                params.setCustMac(customerMacAddress);
            }

            Boolean hadCustomerGaveConsent = getKeyAsBoolean(call, "hadCustomerGaveConsent");
            if (hadCustomerGaveConsent != null) {
                params.setCustConsent(hadCustomerGaveConsent);
            }

            String promotionCode = getKeyAsString(call, "promotionCode");
            if (promotionCode != null) {
                params.setPromoCode(promotionCode);
            }

            String beforeTaxAmount = getKeyAsDecimalFormatted(call, "beforeTaxAmount", twoDecimalPlacesFormat);
            if (beforeTaxAmount != null) {
                params.setB4TaxAmt(beforeTaxAmount);
            }

            String taxAmount = getKeyAsDecimalFormatted(call, "taxAmount", twoDecimalPlacesFormat);
            if (taxAmount != null) {
                params.setTaxAmt(taxAmount);
            }

            String eppMonth = getKeyAsString(call, "eppMonth");
            if (eppMonth != null) {
                params.setEppMonth(eppMonth);
            }

            String cardId = getKeyAsString(call, "cardId");
            if (cardId != null) {
                params.setCardID(cardId);
            }

            String cardHolder = getKeyAsString(call, "cardHolder");
            if (cardHolder != null) {
                params.setCardHolder(cardHolder);
            }

            String cardNumber = getKeyAsString(call, "cardNumber");
            if (cardNumber != null) {
                params.setCardNo(cardNumber);
            }

            String cardExpiry = getKeyAsString(call, "cardExpiry");
            if (cardExpiry != null) {
                params.setCardExp(cardExpiry);
            }

            String cardCvv2 = getKeyAsString(call, "cardCvv2");
            if (cardCvv2 != null) {
                params.setCardCvv2(cardCvv2);
            }

            Boolean isCardPageEnabled = getKeyAsBoolean(call, "isCardPageEnabled");
            if (isCardPageEnabled != null) {
                params.setCardPageEnabled(isCardPageEnabled);
            }

            Boolean isCvvOptional = getKeyAsBoolean(call, "isCvvOptional");
            if (isCvvOptional != null) {
                params.setCVVOptional(isCvvOptional);
            }

            String issuingBank = getKeyAsString(call, "issuingBank");
            if (issuingBank != null) {
                params.setIssuingBank(issuingBank);
            }

            String tokenType = getKeyAsString(call, "tokenType");
            if (tokenType != null) {
                params.setTokenType(tokenType);
            }

            String token = getKeyAsString(call, "token");
            if (token != null) {
                params.setToken(token);
            }

            String pairingToken = getKeyAsString(call, "pairingToken");
            if (pairingToken != null) {
                params.setPairingToken(pairingToken);
            }

            String requestToken = getKeyAsString(call, "requestToken");
            if (requestToken != null) {
                params.setReqToken(requestToken);
            }

            String requestVerifier = getKeyAsString(call, "requestVerifier");
            if (requestVerifier != null) {
                params.setReqVerifier(requestVerifier);
            }

            String pairingVerifier = getKeyAsString(call, "pairingVerifier");
            if (pairingVerifier != null) {
                params.setPairingVerifier(pairingVerifier);
            }

            Boolean isTokenizeRequired = getKeyAsBoolean(call, "isTokenizeRequired");
            if (isTokenizeRequired != null) {
                params.setTokenizeRequired(isTokenizeRequired);
            }

            String merchantCallbackUrl = getKeyAsString(call, "merchantCallbackUrl");
            if (merchantCallbackUrl != null) {
                params.setMerchantCallbackUrl(merchantCallbackUrl);
            }

            String merchantApprovalUrl = getKeyAsString(call, "merchantApprovalUrl");
            if (merchantApprovalUrl != null) {
                params.setMerchantApprovalUrl(merchantApprovalUrl);
            }

            String merchantDisapprovalUrl = getKeyAsString(call, "merchantDisapprovalUrl");
            if (merchantDisapprovalUrl != null) {
                params.setMerchantUnapprovalUrl(merchantDisapprovalUrl);
            }

            String checkoutResourceUrl = getKeyAsString(call, "checkoutResourceUrl");
            if (checkoutResourceUrl != null) {
                params.setCheckoutResourceURL(checkoutResourceUrl);
            }

            Boolean shouldTriggerReturnUrl = getKeyAsBoolean(call, "shouldTriggerReturnUrl");
            if (shouldTriggerReturnUrl != null) {
                params.setTriggerReturnURL(shouldTriggerReturnUrl);
            }

            String param6 = getKeyAsString(call, "param6");
            if (param6 != null) {
                params.setParam6(param6);
            }

            String param7 = getKeyAsString(call, "param7");
            if (param7 != null) {
                params.setParam7(param7);
            }

            String billingAddress = getKeyAsString(call, "billingAddress");
            if (billingAddress != null) {
                params.setBillAddr(billingAddress);
            }

            String billingPostalCode = getKeyAsString(call, "billingPostalCode");
            if (billingPostalCode != null) {
                params.setBillPostal(billingPostalCode);
            }

            String billingCity = getKeyAsString(call, "billingCity");
            if (billingCity != null) {
                params.setBillCity(billingCity);
            }

            String billingRegion = getKeyAsString(call, "billingRegion");
            if (billingRegion != null) {
                params.setBillRegion(billingRegion);
            }

            String billingCountry = getKeyAsString(call, "billingCountry");
            if (billingCountry != null) {
                params.setBillCountry(billingCountry);
            }

            String shippingAddress = getKeyAsString(call, "shippingAddress");
            if (shippingAddress != null) {
                params.setShipAddr(shippingAddress);
            }

            String shippingPostalCode = getKeyAsString(call, "shippingPostalCode");
            if (shippingPostalCode != null) {
                params.setShipPostal(shippingPostalCode);
            }

            String shippingCity = getKeyAsString(call, "shippingCity");
            if (shippingCity != null) {
                params.setShipCity(shippingCity);
            }

            String shippingRegion = getKeyAsString(call, "shippingRegion");
            if (shippingRegion != null) {
                params.setShipRegion(shippingRegion);
            }

            String shippingCountry = getKeyAsString(call, "shippingCountry");
            if (shippingCountry != null) {
                params.setShipCountry(shippingCountry);
            }

            String sessionId = getKeyAsString(call, "sessionId");
            if (sessionId != null) {
                params.setSessionId(sessionId);
            }

            String password = getKeyAsString(call, "password");
            if (password != null) {
                params.setPassword(password);
            }

            String preCheckoutId = getKeyAsString(call, "preCheckoutId");
            if (preCheckoutId != null) {
                params.setPreCheckoutID(preCheckoutId);
            }

            eghl.executePayment(params.build(), activity);
        } else if (call.method.equals("generateId")) {
            String prefix = call.arguments().toString();

            result.success(eghl.generateId(prefix));
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activity = null;
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        channel.setMethodCallHandler(this);

        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        channel.setMethodCallHandler(this);

        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        channel.setMethodCallHandler(null);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (result == null) {
            return false;
        }

        if (requestCode == EGHL.REQUEST_PAYMENT) {
            String jsonString = data.getStringExtra(EGHL.RAW_RESPONSE);

            result.success(jsonString);

            result = null;
            return true;
        }

        return false;
    }

    private EghlpluginunofficialPlugin setActivity(Activity activity) {
        this.activity = activity;
        return this;
    }

    private boolean keyExists(@NonNull MethodCall call, @NonNull String key) {
        if (!call.hasArgument(key)) {
            return false;
        }
        if (call.argument(key) == null) {
            return false;
        }
        return true;
    }

    private String getKeyAsString(@NonNull MethodCall call, @NonNull String key) {
        if (!keyExists(call, key)) {
            return null;
        }
        return call.argument(key).toString();
    }

    private Boolean getKeyAsBoolean(@NonNull MethodCall call, @NonNull String key) {
        if (!keyExists(call, key)) {
            return null;
        }
        return Boolean.parseBoolean(call.argument(key).toString());
    }

    private String getKeyAsDecimalFormatted(@NonNull MethodCall call, @NonNull String key, @NonNull DecimalFormat decimalFormat) {
        if (!keyExists(call, key)) {
            return null;
        }
        return decimalFormat.format(call.argument(key));
    }
}
