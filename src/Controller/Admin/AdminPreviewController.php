<?php

declare(strict_types=1);

namespace Unzer\UnzerPayment\Controller\Admin;

use OxidEsales\Eshop\Application\Controller\Admin\AdminController;
use OxidEsales\Eshop\Core\Registry;
use UnzerSDK\Constants\PaypageCheckoutTypes;
use UnzerSDK\Resources\EmbeddedResources\Address;
use UnzerSDK\Unzer;
use UnzerSDK\Resources\Basket;
use UnzerSDK\Resources\EmbeddedResources\BasketItem;
use UnzerSDK\Resources\Customer;
use UnzerSDK\Resources\EmbeddedResources\Paypage\Style;
use UnzerSDK\Resources\V2\Paypage;

class AdminPreviewController extends AdminController
{
    protected $_sThisTemplate = 'empty.tpl';

    public function render()
    {
        return $this->_sThisTemplate;
    }

    public function createPreview()
    {
        $this->sendJson($this->doCreatePreview());
    }

    protected function doCreatePreview(): array
    {
        try {
            $data = $this->getJsonInput();

            $config = Registry::getConfig();

            $privateKey = (string) $config->getConfigParam('UnzerPaymentPrivateKey');

            if ($privateKey === '') {
                return [
                    'success' => false,
                    'message' => 'Missing Unzer private key.'
                ];
            }

            $unzer = new Unzer($privateKey);

            $style = $this->buildStyleFromPayload($data);

            $basket = $this->buildPreviewBasket();
            $customer = $this->buildPreviewCustomer();

            $unzer->createBasket($basket);
            $unzer->createCustomer($customer);


            $resources = new \UnzerSDK\Resources\EmbeddedResources\Paypage\Resources(
                $customer->getId(),
                $basket->getId(),
            );

            $paypage = new Paypage();

            $paypage->setType("embedded");
            $paypage->setCheckoutType(PaypageCheckoutTypes::PAYMENT_ONLY);
            $paypage->setResources($resources);

            $shopName = trim((string) ($data['shopName'] ?? ''));
            if ($shopName !== '' && method_exists($paypage, 'setShopName')) {
                $paypage->setShopName($shopName);
            }

            if (method_exists($paypage, 'setStyle')) {
                $paypage->setStyle($style);
            }

            if (method_exists($paypage, 'setAmount')) {
                $paypage->setAmount(205.00);
            }

            if (method_exists($paypage, 'setCurrency')) {
                $paypage->setCurrency('EUR');
            }

            if (method_exists($paypage, 'setReturnUrl')) {
                $paypage->setReturnUrl($config->getShopSecureHomeUrl() . 'index.php?cl=content&oxloadid=oximpressum');
            }

            $createdPaypage = $unzer->createPaypage($paypage);

            $previewUrl = $this->extractPreviewUrl($createdPaypage);

            if (!$previewUrl) {
                return [
                    'success' => false,
                    'message' => 'Paypage created, but no preview URL was returned.'
                ];
            }

            return [
                'success' => true,
                'previewUrl' => $previewUrl
            ];
        } catch (\Throwable $e) {
            return [
                'success' => false,
                'message' => $e->getMessage()
            ];
        }
    }

    protected function buildStyleFromPayload(array $data): Style
    {
        $style = new Style();

        $map = [
            'basketBackgroundColor'      => 'setBasketBackgroundColor',
            'paymentFormBackgroundColor' => 'setPaymentFormBackgroundColor',
            'font'                       => 'setFont',
            'brandColor'                 => 'setBrandColor',
            'textColor'                  => 'setTextColor',
            'linkColor'                  => 'setLinkColor',
            'backgroundColor'            => 'setBackgroundColor',
            'logoImage'                  => 'setLogoImage',
            'backgroundImage'            => 'setBackgroundImage',
            'footerColor'                => 'setFooterColor',
            'headerColor'                => 'setHeaderColor',
        ];

        foreach ($map as $payloadKey => $setter) {
            $value = trim((string) ($data[$payloadKey] ?? ''));

            if ($value !== '' && method_exists($style, $setter)) {
                $style->{$setter}($value);
            }
        }

        if (method_exists($style, 'setCornerRadius')) {
            $cornerRadius = trim((string) ($data['cornerRadius'] ?? ''));

            if ($cornerRadius === '') {
                $cornerRadius = '1';
            }

            $style->setCornerRadius((string) ((int) $cornerRadius));
        }

        if (method_exists($style, 'setShadows')) {
            $style->setShadows(!empty($data['shadows']));
        }

        if (method_exists($style, 'setHideUnzerLogo')) {
            $style->setHideUnzerLogo(!empty($data['hideUnzerLogo']));
        }

        if (method_exists($style, 'setHideBasket')) {
            $style->setHideBasket(!empty($data['hideBasket']));
        }

        return $style;
    }

    protected function buildPreviewBasket(): Basket
    {
        $basket = new Basket();
        $basket->setTotalValueGross(205.00);
        $basket->setCurrencyCode('EUR');

        $item = new BasketItem();
        $item->setBasketItemReferenceId('item-1');
        $item->setQuantity(2);
        $item->setTitle('Hoodie');
        $item->setSubTitle('Clothes');
        $item->setType('goods');
        $item->setAmountPerUnitGross(20.00);
        $item->setAmountDiscountPerUnitGross(0.00);
        $item->setVat(19.0);
        $item->setImageUrl('https://stg-static.unzer.com/assets/images/baskets/ZippHoodie_Unzer.jpg');
        $basket->addBasketItem($item);

        $item = new BasketItem();
        $item->setBasketItemReferenceId('item-2');
        $item->setQuantity(6);
        $item->setTitle('Writing Pad');
        $item->setSubTitle('Office Supplies');
        $item->setType('goods');
        $item->setUnit('Pc.');
        $item->setAmountPerUnitGross(5.00);
        $item->setAmountDiscountPerUnitGross(0.00);
        $item->setVat(7.0);
        $item->setImageUrl('https://stg-static.unzer.com/assets/images/baskets/WritingPad.jpg');
        $basket->addBasketItem($item);

        $item = new BasketItem();
        $item->setBasketItemReferenceId('item-6');
        $item->setQuantity(1);
        $item->setTitle('Writing Pad Exclusive');
        $item->setSubTitle('Office Supplies');
        $item->setType('goods');
        $item->setUnit('Pc.');
        $item->setAmountPerUnitGross(135.00);
        $item->setAmountDiscountPerUnitGross(0.00);
        $item->setVat(7.0);
        $item->setImageUrl('https://stg-static.unzer.com/assets/images/baskets/WritingPad.jpg');
        $basket->addBasketItem($item);

        $item = new BasketItem();
        $item->setTitle('10 EUR voucher newsletter registration');
        $item->setBasketItemReferenceId('item-4');
        $item->setQuantity(1);
        $item->setAmountPerUnitGross(0);
        $item->setAmountDiscountPerUnitGross(5);
        $item->setVat(1);
        $item->setType('voucher');
        $basket->addBasketItem($item);

        $item = new BasketItem();
        $item->setTitle('Shipping');
        $item->setSubTitle('Insured standard shipment');
        $item->setBasketItemReferenceId('item-5');
        $item->setQuantity(1);
        $item->setAmountPerUnitGross(5);
        $item->setVat(1);
        $item->setType('shipment');
        $basket->addBasketItem($item);

        return $basket;
    }

    protected function buildPreviewCustomer(): Customer
    {
        $customer = new Customer('Preview', 'User');

        $customer->setLastname('Preview');
        $customer->setFirstname('Mister');

        if (method_exists($customer, 'setEmail')) {
            $customer->setEmail('preview@example.com');
        }

        if (method_exists($customer, 'setBillingAddress')) {
            $billingAddress = new Address();
            $billingAddress->setName('Preview User');
            $billingAddress->setStreet('Preview Street 1');
            $billingAddress->setCity('Berlin');
            $billingAddress->setZip('10115');
            $billingAddress->setCountry('DE');
            $customer->setBillingAddress(
                $billingAddress
            );
        }

        return $customer;
    }

    protected function extractPreviewUrl($paypage): string
    {
        $candidates = [
            'getRedirectUrl',
            'getUrl',
            'getIframeUrl',
            'getHostedPageUrl'
        ];

        foreach ($candidates as $method) {
            if (is_object($paypage) && method_exists($paypage, $method)) {
                $value = (string) $paypage->{$method}();
                if ($value !== '') {
                    return $value;
                }
            }
        }

        return '';
    }

    protected function getJsonInput(): array
    {
        $raw = file_get_contents('php://input');
        if (!$raw) {
            return [];
        }

        $decoded = json_decode($raw, true);

        return is_array($decoded) ? $decoded : [];
    }

    protected function sendJson(array $data): void
    {
        while (ob_get_level()) {
            ob_end_clean();
        }

        header('Content-Type: application/json; charset=UTF-8');
        echo json_encode($data);
        exit;
    }
}