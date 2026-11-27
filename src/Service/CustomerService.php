<?php

namespace Unzer\UnzerPayment\Service;

use Exception;
use OxidEsales\Eshop\Application\Model\Country;
use OxidEsales\Eshop\Application\Model\Order;
use OxidEsales\Eshop\Application\Model\User;
use OxidEsales\Eshop\Core\Registry;
use Unzer\UnzerPayment\Classes\UnzerpaymentClient;
use Unzer\UnzerPayment\Constants\Constants;
use UnzerSDK\Constants\ShippingTypes;
use UnzerSDK\Resources\Customer;
use UnzerSDK\Resources\EmbeddedResources\Address;
use UnzerSDK\Resources\EmbeddedResources\CompanyInfo;

class CustomerService
{
    public const SESSION_KEY_USER_ID = 'unzer_temp_user_id';

    public function calculateCustomerNumber(?string $customerId = null): string
    {
        $config = Registry::getConfig();
        $session = Registry::getSession();

        $shopId = (string) $config->getShopId();

        $prefix = Constants::USER_ID_PREFIX
            . $shopId
            . '-'
            . substr(
                md5(
                    html_entity_decode(
                        $config->getShopUrl(),
                        ENT_QUOTES | ENT_HTML5
                    )
                ),
                0,
                10
            )
            . '-';

        if ($customerId !== null && $customerId !== '') {
            return $prefix . $customerId;
        }

        /** @var User|null $user */
        $user = $session->getUser();

        if ($user && $user->getId()) {
            return $prefix . $user->getId();
        }

        $sessionUserId = $session->getVariable(
            self::SESSION_KEY_USER_ID
        );

        if (empty($sessionUserId)) {
            $sessionUserId = uniqid('', true);

            $session->setVariable(
                self::SESSION_KEY_USER_ID,
                $sessionUserId
            );
        }

        return 'temp-' . $prefix . $sessionUserId;
    }

    public function getCustomerFromOrder($order): Customer
    {
        $order = $this->getOrder($order);
        $unzer = UnzerpaymentClient::getInstance();
        $userId = (string) ($order->oxorder__oxuserid->value ?? '');
        $customerNumber = $this->calculateCustomerNumber($userId ?: null);

        try {
            $customer = $unzer->fetchCustomerByExtCustomerId($customerNumber);
        } catch (Exception $exception) {
            $customer = null;
        }

        if (!$customer) {
            $customer = (new Customer())->setCustomerId($customerNumber);
        }

        $this->applyOrderDataToCustomer($customer, $order);
        return $this->persistCustomer($customer, $unzer);
    }

    public function updatePaypalExpressCustomer($order, Customer $customer): Customer
    {
        $order = $this->getOrder($order);
        $this->applyOrderDataToCustomer($customer, $order);
        return $this->persistCustomer($customer, UnzerpaymentClient::getInstance());
    }

    private function applyOrderDataToCustomer(Customer $customer, Order $order): void
    {
        $company = (string) ($order->oxorder__oxbillcompany->value ?? '');

        $customer
            ->setLanguage($this->getCurrentLanguage())
            ->setFirstname((string) ($order->oxorder__oxbillfname->value ?? ''))
            ->setLastname((string) ($order->oxorder__oxbilllname->value ?? ''))
            ->setPhone((string) ($order->oxorder__oxbillfon->value ?? ''))
            ->setCompany($company)
            ->setEmail((string) ($order->oxorder__oxbillemail->value ?? ''));

        $this->applyCompanyData($customer, $company);
        $this->setAddresses($customer, $order);
    }

    private function persistCustomer(Customer $customer, $unzer): Customer
    {
        try {
            return $customer->getId()
                ? $unzer->updateCustomer($customer)
                : $unzer->createCustomer($customer);
        } catch (Exception $exception) {
            Registry::getLogger()->warning('Could not persist Unzer customer', [
                'customerId' => $customer->getCustomerId(),
                'exception' => $exception,
            ]);

            return $customer;
        }
    }

    protected function setAddresses(
        Customer $customer,
        Order $order
    ): void {
        $billingAddress = (new Address())
            ->setName(
                trim(
                    (string) (
                        $order->oxorder__oxbillfname->value
                        ?? ''
                    )
                    . ' '
                    . (string) (
                        $order->oxorder__oxbilllname->value
                        ?? ''
                    )
                )
            )
            ->setStreet(
                $this->combineStreet(
                    (string) (
                        $order->oxorder__oxbillstreet->value
                        ?? ''
                    ),
                    (string) (
                        $order->oxorder__oxbillstreetnr->value
                        ?? ''
                    )
                )
            )
            ->setZip(
                (string) (
                    $order->oxorder__oxbillzip->value
                    ?? ''
                )
            )
            ->setCity(
                (string) (
                    $order->oxorder__oxbillcity->value
                    ?? ''
                )
            )
            ->setCountry(
                $this->getCountryIso2(
                    (string) (
                        $order->oxorder__oxbillcountryid->value
                        ?? ''
                    )
                )
            );

        $hasShippingAddress = $this->orderHasShippingAddress(
            $order
        );

        if ($hasShippingAddress) {
            $shippingAddress = (new Address())
                ->setName(
                    trim(
                        (string) (
                            $order->oxorder__oxdelfname->value
                            ?? ''
                        )
                        . ' '
                        . (string) (
                            $order->oxorder__oxdellname->value
                            ?? ''
                        )
                    )
                )
                ->setStreet(
                    $this->combineStreet(
                        (string) (
                            $order->oxorder__oxdelstreet->value
                            ?? ''
                        ),
                        (string) (
                            $order->oxorder__oxdelstreetnr->value
                            ?? ''
                        )
                    )
                )
                ->setZip(
                    (string) (
                        $order->oxorder__oxdelzip->value
                        ?? ''
                    )
                )
                ->setCity(
                    (string) (
                        $order->oxorder__oxdelcity->value
                        ?? ''
                    )
                )
                ->setCountry(
                    $this->getCountryIso2(
                        (string) (
                            $order->oxorder__oxdelcountryid->value
                            ?? ''
                        )
                    )
                )
                ->setShippingType(
                    ShippingTypes::DIFFERENT_ADDRESS
                );
        } else {
            $shippingAddress = (new Address())
                ->setName(
                    $billingAddress->getName()
                )
                ->setStreet(
                    $billingAddress->getStreet()
                )
                ->setZip(
                    $billingAddress->getZip()
                )
                ->setCity(
                    $billingAddress->getCity()
                )
                ->setCountry(
                    $billingAddress->getCountry()
                )
                ->setShippingType(
                    ShippingTypes::EQUALS_BILLING
                );
        }

        $customer
            ->setShippingAddress(
                $shippingAddress
            )
            ->setBillingAddress(
                $billingAddress
            );
    }

    protected function orderHasShippingAddress(
        Order $order
    ): bool {
        return trim(
                (string) (
                    $order->oxorder__oxdellname->value
                    ?? ''
                )
            ) !== ''
            || trim(
                (string) (
                    $order->oxorder__oxdelstreet->value
                    ?? ''
                )
            ) !== '';
    }

    protected function applyCompanyData(
        Customer $customer,
        string $company
    ): void {
        $company = trim(
            $company
        );

        $updatedCompany = (
            (string) $customer->getCompany()
            !== $company
        );

        $customer->setCompany(
            $company
        );

        if ($company === '') {
            $customer->setCompanyInfo(
                null
            );

            return;
        }

        $companyInfo = $customer->getCompanyInfo();

        if (!$companyInfo) {
            $companyInfo = new CompanyInfo();
        }

        if (
            empty($companyInfo->getCompanyType())
            || $updatedCompany
        ) {
            $companyInfo->setCompanyType(
                'Company Type'
            );
        }

        $customer->setCompanyInfo(
            $companyInfo
        );
    }

    protected function getCountryIso2(
        string $countryId
    ): string {
        $countryId = trim(
            $countryId
        );

        if ($countryId === '') {
            return '';
        }

        /*
         * Already ISO-2?
         */
        if (
            strlen($countryId) === 2
            && ctype_alpha($countryId)
        ) {
            return strtoupper(
                $countryId
            );
        }

        /** @var Country $country */
        $country = oxNew(
            Country::class
        );

        if (!$country->load($countryId)) {
            return '';
        }

        return strtoupper(
            (string) (
                $country->oxcountry__oxisoalpha2->value
                ?? ''
            )
        );
    }

    protected function combineStreet(
        string $street,
        string $streetNumber
    ): string {
        return trim(
            $street
            . ' '
            . $streetNumber
        );
    }

    protected function getCurrentLanguage(): string
    {
        $language = Registry::getLang()
            ->getLanguageAbbr();

        return substr(
            $language ?: 'en',
            0,
            2
        );
    }

    protected function getOrder(
        $order
    ): Order {
        if ($order instanceof Order) {
            return $order;
        }

        /** @var Order $orderObject */
        $orderObject = oxNew(
            Order::class
        );

        if (!$orderObject->load($order)) {
            throw new \RuntimeException(
                'Could not load OXID order: '
                . $order
            );
        }

        return $orderObject;
    }
}
