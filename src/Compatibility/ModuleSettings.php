<?php

declare(strict_types=1);

namespace Unzer\UnzerPayment\Compatibility;

class ModuleSettings
{
    public function get(string $name, string $module)
    {
        $config = \OxidEsales\Eshop\Core\Registry::getConfig();
        return $config->getShopConfVar($name, $config->getShopId(), 'module:' . $module);
    }
}
