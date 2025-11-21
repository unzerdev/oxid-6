<?php

declare(strict_types=1);

namespace Unzer\UnzerPayment\PaymentMethods;

use Unzer\UnzerPayment\PaymentMethods\PaymentMethod;

class AbstractUnzerPaymentMethod
{
    const UNZER_SHORT_CODE = '';
    const UNZER_LONG_CODE = '';
    const PAYMENT_METHOD_CODE = '';
    const PAYMENT_METHOD_NAME = '';

    const ALLOWED_COUNTRIES = [];
    protected static ?PaymentMethod $paymentMethod = null;

    final public function getIcon(string $lang = ""): string
    {
        return 'modules/unzer/unzer_payment/assets/icons/' . static::UNZER_LONG_CODE . '.png';
    }

    /**
     * @return array
     */
    public function getAllowedCountries(): array
    {
        return static::ALLOWED_COUNTRIES;
    }


}
