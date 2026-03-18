<?php

$sLangName = 'English';

$aLang = [
    'charset' => 'UTF-8',

    'SHOP_MODULE_GROUP_unzer_payment_main' => 'Main Settings',
    'SHOP_MODULE_GROUP_unzer_payment_specific' => 'Extended Settings',
    'SHOP_MODULE_UnzerPaymentMode' => 'Mode',
    'SHOP_MODULE_UnzerPaymentMode_0' => 'Sandbox',
    'SHOP_MODULE_UnzerPaymentMode_1' => 'Production',
    'SHOP_MODULE_UnzerPaymentPublicKey' => 'Public Key',
    'SHOP_MODULE_UnzerPaymentPrivateKey' => 'Private Key',
    'SHOP_MODULE_UnzerPaymentLogLevel' => 'Log Level',
    'SHOP_MODULE_UnzerPaymentLogLevel_ERROR' => 'ERROR: Log only errors',
    'SHOP_MODULE_UnzerPaymentLogLevel_WARNING' => 'WARNING: Log warnings and errors',
    'SHOP_MODULE_UnzerPaymentLogLevel_DEBUG' => 'DEBUG: Log all information',
    'SHOP_MODULE_UnzerPaymentClickToPay' => 'Activate Click to Pay for card payments',
    'SHOP_MODULE_UnzerPaymentCardChargeMode' => 'Card booking mode',
    'SHOP_MODULE_UnzerPaymentApplepayChargeMode' => 'Apple Pay booking mode',
    'SHOP_MODULE_UnzerPaymentGooglepayChargeMode' => 'Google Pay booking mode',
    'SHOP_MODULE_UnzerPaymentWeroChargeMode' => 'Wero booking mode',
    'SHOP_MODULE_UnzerPaymentPaypalChargeMode' => 'Paypal booking mode',
    'SHOP_MODULE_UnzerPaymentCardChargeMode_authorize' => 'authorize',
    'SHOP_MODULE_UnzerPaymentCardChargeMode_charge' => 'charge',
    'SHOP_MODULE_UnzerPaymentApplepayChargeMode_authorize' => 'authorize',
    'SHOP_MODULE_UnzerPaymentApplepayChargeMode_charge' => 'charge',
    'SHOP_MODULE_UnzerPaymentGooglepayChargeMode_authorize' => 'authorize',
    'SHOP_MODULE_UnzerPaymentGooglepayChargeMode_charge' => 'charge',
    'SHOP_MODULE_UnzerPaymentPaypalChargeMode_authorize' => 'authorize',
    'SHOP_MODULE_UnzerPaymentPaypalChargeMode_charge' => 'charge',
    'SHOP_MODULE_UnzerPaymentWeroChargeMode_authorize' => 'authorize',
    'SHOP_MODULE_UnzerPaymentWeroChargeMode_charge' => 'charge',
    'UNZER_WEBHOOKS' => 'Webhooks',
    'UNZER_ID' => 'ID',
    'UNZER_ORDERNR' => 'Unzer OrderNr.',
    'UNZER_SHORT_ID' => 'Short-ID',
    'UNZER_WEBHOOK_EVENT' => 'Event',
    'UNZER_WEBHOOK_URL' => 'URL',
    'UNZER_WEBHOOK_DELETE_CONFIRM' => 'Do you really want to delete this webhook?',
    'UNZER_WEBHOOK_CREATE_CONFIRM' => 'Do you really want to register the webhook?',
    'UNZER_CREATE_WEBHOOK' => 'Register webhook',
    'tbclorder_unzerpayment' => 'Unzer Payment',
    'NO_UNZER_PAYMENT_ORDER' => 'The selected order is not an Unzer Payment order',
    'UNZER_TOTAL_AMOUNT' => 'Total amount',
    'UNZER_CHARGED_AMOUNT' => 'Charged amount',
    'UNZER_CANCELLED_AMOUNT' => 'Cancelled amount',
    'UNZER_REMAINING_AMOUNT' => 'Remaining amount',
    'UNZER_TIME' => 'Time',
    'UNZER_TYPE' => 'Type',
    'UNZER_AMOUNT' => 'Amount',
    'UNZER_STATUS' => 'Status',
    'UNZER_CONFIRM_ACTION' => 'Should the action really be executed?',
    'UNZER_CONFIRM_ACTION_CAPTURE' => 'Are you sure to capture the following amount: ',
    'UNZER_CONFIRM_ACTION_REFUND' => 'Are you sure to refund the following amount: ',
    'UNZER_CONFIRM_ACTION_CANCEL' => 'Are you sure to cancel the following amount: ',
    'UNZER_CAPTURE_AMOUNT' => 'Capture amount',
    'UNZER_REFUND_AMOUNT' => 'Refund amount',
    'UNZER_CANCEL_ORDER' => 'Cancel amount',
    'UNZER_LEGACY_ORDER_INFO' => 'ATTENTION: The order has been placed with a legacy, unsupported module. You still can capture and refund amounts.',

    'UNZER_PLEASE_TRANSFER' => 'Please transfer the amount of %s %s to the following account:',
    'UNZER_HOLDER' => 'Account Holder',
    'UNZER_IBAN' => 'IBAN',
    'UNZER_BIC' => 'BIC',
    'UNZER_PLEASE_USE_DESCRIPTOR' => 'Please use only this identification number as the descriptor',

    'SHOP_MODULE_GROUP_unzer_payment_design' => 'Design customization',

    'SHOP_MODULE_sUnzerPaymentDesignShopName' => 'Shop name',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignShopName' => 'Will be passed to Unzer as shopName.',

    'SHOP_MODULE_sUnzerPaymentDesignBasketBackgroundColor' => 'Basket background color',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignBasketBackgroundColor' => 'HEX color value, e.g. #a39193',

    'SHOP_MODULE_sUnzerPaymentDesignPaymentFormBackgroundColor' => 'Payment form background color',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignPaymentFormBackgroundColor' => 'HEX color value, e.g. #cebfb6',

    'SHOP_MODULE_sUnzerPaymentDesignFont' => 'Font',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignFont' => 'CSS font-family, e.g. Inter, Arial, sans-serif',

    'SHOP_MODULE_sUnzerPaymentDesignBrandColor' => 'Brand color',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignBrandColor' => 'HEX color value, e.g. #000000',

    'SHOP_MODULE_blUnzerPaymentDesignShadows' => 'Enable shadows',
    'HELP_SHOP_MODULE_blUnzerPaymentDesignShadows' => 'Enables shadows on the payment page.',

    'SHOP_MODULE_sUnzerPaymentDesignTextColor' => 'Text color',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignTextColor' => 'HEX color value, e.g. #0C1332',

    'SHOP_MODULE_sUnzerPaymentDesignLinkColor' => 'Link color',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignLinkColor' => 'HEX color value, e.g. #1B6AD7',

    'SHOP_MODULE_sUnzerPaymentDesignCornerRadius' => 'Corner radius',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignCornerRadius' => 'Numeric value, e.g. 6',

    'SHOP_MODULE_blUnzerPaymentDesignHideUnzerLogo' => 'Hide Unzer logo',
    'HELP_SHOP_MODULE_blUnzerPaymentDesignHideUnzerLogo' => 'Hides the Unzer logo on the payment page.',

    'SHOP_MODULE_sUnzerPaymentDesignLogoImage' => 'Logo image URL',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignLogoImage' => 'Absolute URL to the logo image.',

    'SHOP_MODULE_sUnzerPaymentDesignFooterColor' => 'Footer color',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignFooterColor' => 'HEX color value for the footer.',

    'SHOP_MODULE_sUnzerPaymentDesignHeaderColor' => 'Header color',
    'HELP_SHOP_MODULE_sUnzerPaymentDesignHeaderColor' => 'HEX color value, e.g. #FFFFFF',

    'SHOP_MODULE_blUnzerPaymentDesignHideBasket' => 'Hide basket',
    'HELP_SHOP_MODULE_blUnzerPaymentDesignHideBasket' => 'Hides the basket on the payment page.',

    'SHOP_MODULE_sUnzerPaymentDesignFont_' => '',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Arial' => 'Arial',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Verdana' => 'Verdana',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Tahoma' => 'Tahoma',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Trebuchet MS' => 'Trebuchet MS',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Times New Roman' => 'Times New Roman',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Georgia' => 'Georgia',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Garamond' => 'Garamond',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Courier New' => 'Courier New',
    'SHOP_MODULE_sUnzerPaymentDesignFont_UnzerVisuelt' => 'UnzerVisuelt',
    'SHOP_MODULE_sUnzerPaymentDesignFont_Inter' => 'Inter',
    'SHOP_MODULE_sUnzerPaymentDesignFont_SFMono' => 'SFMono',
];

