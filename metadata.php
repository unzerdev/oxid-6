<?php
/**
 * Metadata version
 */
$sMetadataVersion = '2.1';

/**
 * Module information
 */
$aModule = [
    'id' => 'unzer_payment',
    'title' => 'Unzer Payment',
    'description' => [
        'de' => 'Bezahlung mit Unzer',
        'en' => 'Payment with Unzer'
    ],
    'thumbnail' => 'assets/admin/unzer_payment.png',
    'lang' => 'en',
    'version' => '1.0.3',
    'author' => 'Unzer GmbH',
    'email' => 'info@unzer.com',
    'url' => 'https://www.unzer.com/',
    'extend' => [
        \OxidEsales\Eshop\Application\Model\PaymentGateway::class => \Unzer\UnzerPayment\Model\PaymentGateway::class,
        \OxidEsales\Eshop\Application\Model\Payment::class => \Unzer\UnzerPayment\Model\Payment::class,
        \OxidEsales\Eshop\Core\ViewConfig::class => \Unzer\UnzerPayment\Core\ViewConfig::class,
        \OxidEsales\Eshop\Application\Controller\Admin\ModuleConfiguration::class => \Unzer\UnzerPayment\Controller\Admin\ModuleConfiguration::class,
        \OxidEsales\Eshop\Application\Controller\OrderController::class => \Unzer\UnzerPayment\Controller\OrderController::class,
        \OxidEsales\Eshop\Application\Controller\PaymentController::class => \Unzer\UnzerPayment\Controller\PaymentController::class,
        \OxidEsales\Eshop\Application\Controller\ThankYouController::class => \Unzer\UnzerPayment\Controller\ThankYouController::class,
    ],
    'controllers' => [
        'unzer_payment_webhook' => \Unzer\UnzerPayment\Controller\WebhookController::class,
        'unzer_payment_admin_order'   => \Unzer\UnzerPayment\Controller\Admin\AdminOrderController::class,
    ],
    'events' => [
        'onActivate' => \Unzer\UnzerPayment\Core\Events::class . '::onActivate',
        'onDeactivate' => \Unzer\UnzerPayment\Core\Events::class . '::onDeactivate',
    ],
    'templates' => [
        'admin_order_cntrl.tpl' => 'unzer/unzer_payment/views/admin/tpl/admin_order_cntrl.tpl',
        'modules/unzer/unzer_payment/payment/payment_unzer.tpl' => 'unzer/unzer_payment/views/frontend/tpl/payment/payment_unzer.tpl',
        'modules/unzer/unzer_payment/_inc/unzer_assets.tpl' => 'unzer/unzer_payment/views/frontend/_inc/unzer_assets.tpl',
        'modules/unzer/unzer_payment/_inc/transfer_data.tpl' => 'unzer/unzer_payment/views/frontend/_inc/transfer_data.tpl',
    ],
    'blocks' => [
        [
            'template' => 'module_config.tpl',
            'block' => 'admin_module_config_form',
            'file' => 'views/admin/blocks/admin_module_config_form.tpl'
        ],
        [
            'template' => 'payment_main.tpl',
            'block' => 'admin_payment_main_form',
            'file' => 'views/admin/blocks/admin_payment_main_form.tpl'
        ],
        [
            'template' => 'page/checkout/payment.tpl',
            'block' => 'select_payment',
            'file' => 'views/frontend/blocks/page/checkout/select_payment.tpl'
        ],
        [
            'template' => 'page/checkout/order.tpl',
            'block' => 'checkout_order_btn_submit_bottom',
            'file' => 'views/frontend/blocks/page/checkout/checkout_order_btn_submit_bottom.tpl'
        ],
        [
            'template' => 'page/checkout/thankyou.tpl',
            'block' => 'checkout_thankyou_info',
            'file' => 'views/frontend/blocks/page/checkout/checkout_thankyou_info.tpl'
        ],
        [
            'template' => 'email/plain/order_cust.tpl',
            'block' => 'email_plain_order_cust_paymentinfo',
            'file' => 'views/frontend/blocks/email/plain/email_plain_order_cust_paymentinfo.tpl'
        ],
        [
            'template' => 'email/html/order_cust.tpl',
            'block' => 'email_html_order_cust_paymentinfo',
            'file' => 'views/frontend/blocks/email/html/email_html_order_cust_paymentinfo.tpl'
        ],
    ],
    'settings' => [
        [
            'group' => 'unzer_payment_main',
            'name' => 'UnzerPaymentMode',
            'type' => 'select',
            'value' => '0',
            'constraints' => '0|1'
        ],
        [
            'group' => 'unzer_payment_main',
            'name' => 'UnzerPaymentPublicKey',
            'type' => 'str',
            'value' => ''
        ],
        [
            'group' => 'unzer_payment_main',
            'name' => 'UnzerPaymentPrivateKey',
            'type' => 'str',
            'value' => ''
        ],
        [
            'group' => 'unzer_payment_main',
            'name' => 'UnzerPaymentLogLevel',
            'type' => 'select',
            'value' => 'ERROR',
            'constraints' => 'ERROR|WARNING|DEBUG'
        ],
        [
            'group' => 'unzer_payment_specific',
            'name' => 'UnzerPaymentCardChargeMode',
            'type' => 'select',
            'value' => 'authorize|charge',
            'constraints' => 'authorize|charge',
        ],
        [
            'group' => 'unzer_payment_specific',
            'name' => 'UnzerPaymentApplepayChargeMode',
            'type' => 'select',
            'value' => 'authorize|charge',
            'constraints' => 'authorize|charge',
        ],
        [
            'group' => 'unzer_payment_specific',
            'name' => 'UnzerPaymentGooglepayChargeMode',
            'type' => 'select',
            'value' => 'authorize|charge',
            'constraints' => 'authorize|charge',
        ],
        [
            'group' => 'unzer_payment_specific',
            'name' => 'UnzerPaymentPaypalChargeMode',
            'type' => 'select',
            'value' => 'authorize|charge',
            'constraints' => 'authorize|charge',
        ],
        /*
        [
            'group' => 'unzer_payment_specific',
            'name' => 'UnzerPaymentWeroChargeMode',
            'type' => 'select',
            'value' => 'authorize|charge',
            'constraints' => 'authorize|charge',
        ],
        */
        [
            'group' => 'unzer_payment_specific',
            'name' => 'UnzerPaymentClickToPay',
            'type' => 'bool',
            'value' => false
        ]
    ],
];
