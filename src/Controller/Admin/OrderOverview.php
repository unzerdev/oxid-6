<?php

declare(strict_types=1);

namespace Unzer\UnzerPayment\Controller\Admin;

use OxidEsales\Eshop\Core\Field;
use OxidEsales\Eshop\Core\Registry;
use Unzer\UnzerPayment\Classes\UnzerpaymentClient;

class OrderOverview extends OrderOverview_parent
{
    public function render()
    {
        $template = parent::render();
        $order = $this->_aViewData['edit'] ?? null;
        if (!$order || $order->getUnzerExpressTitle() === null
            || !preg_match('/^[a-f0-9]{32}@express\.invalid$/iD', (string) $order->getFieldData('oxbillemail'))
        ) {
            return $template;
        }

        $email = '';
        $paymentId = (string) $order->getFieldData('oxtransid');
        try {
            $client = $paymentId !== '' ? UnzerpaymentClient::getInstance() : null;
            if ($client) {
                $payment = $client->fetchPayment($paymentId);
                $customer = $payment->getCustomer();
                $candidate = $customer ? $customer->getEmail() : null;
                if ($payment->getId() === $paymentId
                    && is_string($candidate)
                    && filter_var($candidate, FILTER_VALIDATE_EMAIL)
                    && !preg_match('/@express\.invalid$/iD', $candidate)
                ) {
                    $email = $candidate;
                }
            }
        } catch (\Throwable $exception) {
            Registry::getLogger()->warning('Could not resolve Express order contact for admin overview');
        }

        $displayOrder = clone $order;
        $displayOrder->oxorder__oxbillemail = new Field($email, Field::T_RAW);
        $this->_aViewData['edit'] = $displayOrder;
        return $template;
    }

    protected function _getPaymentType($oOrder)
    {
        $payment = parent::_getPaymentType($oOrder);
        $title = $oOrder->getUnzerExpressTitle();
        if ($payment && $title !== null) {
            $payment = clone $payment;
            $payment->oxpayments__oxdesc = new Field($title);
        }
        return $payment;
    }
}
