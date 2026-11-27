<?php

declare(strict_types=1);

namespace Unzer\UnzerPayment\PaymentMethods;

use OxidEsales\EshopCommunity\Internal\Framework\Module\Configuration\Bridge\ModuleSettingBridgeInterface;
use OxidEsales\EshopCommunity\Internal\Container\ContainerFactory;
use Unzer\UnzerPayment\Constants\Constants;

class UnzerApplepayPaymentMethod extends AbstractUnzerPaymentMethod
{
    const UNZER_SHORT_CODE = Constants::PAYMENT_METHODS['applepay']['short_code'];
    const UNZER_LONG_CODE =  Constants::PAYMENT_METHODS['applepay']['long_code'];
    const PAYMENT_METHOD_CODE =  Constants::PAYMENT_METHODS['applepay']['payment_method_code'];
    const PAYMENT_METHOD_NAME = Constants::PAYMENT_METHODS['applepay']['name'];

    public function hasExpressCheckout()
    {
        if (ContainerFactory::getInstance()->getContainer()->get(ModuleSettingBridgeInterface::class)->get('UnzerPaymentApplepayExpressCheckout', Constants::MODULE_ID)) {
            return true;
        }
        return false;
    }
}
