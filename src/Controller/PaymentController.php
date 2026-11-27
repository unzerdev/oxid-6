<?php

declare(strict_types=1);

namespace Unzer\UnzerPayment\Controller;

use OxidEsales\EshopCommunity\Application\Model\Payment;
use Unzer\UnzerPayment\Service\ExpressCheckoutService;
use Unzer\UnzerPayment\Service\ExpressCheckoutStateService;
use Unzer\UnzerPayment\Service\RedirectSessionService;
use OxidEsales\Eshop\Application\Model\Country;
use OxidEsales\Eshop\Core\Registry;
use Unzer\UnzerPayment\Classes\UnzerpaymentClient;
use Unzer\UnzerPayment\Classes\UnzerpaymentHelper;
use Unzer\UnzerPayment\Service\DebugHandler;
use Unzer\UnzerPayment\Traits\ServiceContainer;

/**
 * @inheritDoc
 *
 * @extends \OxidEsales\Eshop\Application\Controller\PaymentController
 */
class PaymentController extends PaymentController_parent
{
    use ServiceContainer;

    public function render()
    {
        $session = Registry::getSession();
        $row = (new \Unzer\UnzerPayment\Service\PreOrderService())->find('oxid', (string) $session->getVariable('sess_challenge'));
        if ($row) {
            $session->deleteVariable('sess_challenge');
            $session->deleteVariable('UnzerPaypageId');
        }
        return parent::render();
    }


    public function unzerEndExpressCheckout(): void
    {
        $session = Registry::getSession();
        if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST'
            || !$session->checkSessionChallenge()
            || !$session->getVariable(ExpressCheckoutService::SESSION_SELECTED_EXPRESS_METHOD)) {
            return;
        }

        ThankYouController::resetExpressCheckoutSessionData();
        (new ExpressCheckoutStateService())->resetCheckoutPaymentState();
        (new RedirectSessionService())->clear();
        foreach (['expressBasket', 'UnzerPaypageId', 'UnzerMetadataId',
            'UnzerPreparedOrderId', 'UnzerSelectedPaymentMethod'] as $key) {
            $session->deleteVariable($key);
        }
        // Rebuild the payment list and checked method in a fresh payment-page request.
        $url = html_entity_decode(Registry::getConfig()->getShopSecureHomeUrl(), ENT_QUOTES | ENT_HTML5);
        Registry::getUtils()->redirect($url . 'cl=payment', false, 302);
    }

    /**
     * Template variable getter. Returns paymentlist
     *
     * @return array<array-key, mixed>|object
     *
     */
    public function getPaymentList()
    {
        $paymentList = (array)parent::getPaymentList();
        if (UnzerpaymentClient::getInstance()) {
            $unzerPaymentMethods = UnzerpaymentClient::getInstance()->getAvailablePaymentMethods();

            $actShopCurrency = Registry::getConfig()->getActShopCurrencyObject();

            /* @var $oUser \OxidEsales\Eshop\Application\Model\User */
            $oUser = $this->getUser();

            $country = oxNew(Country::class);
            $country->load($oUser->oxuser__oxcountryid->value);
            $billingCountryIso = $country->oxcountry__oxisoalpha2->value;

            $paymentListRaw = $paymentList;
            $paymentList = [];
            $expressMethod = Registry::getSession()->getVariable(ExpressCheckoutService::SESSION_SELECTED_EXPRESS_METHOD);
            if ($expressMethod) {
                $paymentListRaw = array_filter($paymentListRaw, static function ($payment) use ($expressMethod) {
                    return is_object($payment) && $payment->getId() === $expressMethod;
                });
            }

            /**
             * @var \Unzer\UnzerPayment\Model\Payment $payment
             */
            foreach ($paymentListRaw as $key => $payment) {
                if (!is_object($payment)) {
                    continue;
                }
                // any non-unzer payment ...
                if (!$payment->isUnzerPaymentMethod()) {
                    $paymentList[$key] = $payment;
                    continue;
                }

                $currencyOK = false;
                $paymentModel = $payment->getUnzerPaymentMethodModel();

                $countryOK = true;
                if (sizeof($paymentModel::ALLOWED_COUNTRIES)) {
                    if (!in_array($billingCountryIso, $paymentModel::ALLOWED_COUNTRIES)) {
                        $countryOK = false;
                    }
                }

                foreach ($unzerPaymentMethods as $unzerPaymentMethod) {
                    if (str_replace('-', '_', strtolower($unzerPaymentMethod->type)) == $paymentModel::UNZER_LONG_CODE) {
                        if (isset($unzerPaymentMethod->supports[0]->currency)) {
                            foreach ($unzerPaymentMethod->supports[0]->currency as $currency_code) {
                                if ($currency_code == $actShopCurrency->name) {
                                    $currencyOK = true;
                                }
                            }
                        }
                    }
                }

                $customerOK = true;

                if ($oUser->oxuser__oxcompany->value != '') {
                    if ($paymentModel::UNZER_SHORT_CODE == 'pdd' || $paymentModel::UNZER_SHORT_CODE == 'pit' || $paymentModel::UNZER_SHORT_CODE == 'wro') {
                        $customerOK = false;
                    }
                }

                if ($currencyOK && $countryOK && $customerOK) {
                    $paymentList[$key] = $payment;
                }
            }
        }


        return $paymentList;
    }
}