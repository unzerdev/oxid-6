<?php

declare(strict_types=1);

namespace Unzer\UnzerPayment\Compatibility;

/** Only used when the modern OXID factory does not exist. */
class ContainerFactory
{
    private static $instance;

    public static function getInstance(): self
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getContainer(): self
    {
        return $this;
    }

    public function get(string $name)
    {
        if ($name === 'OxidEsales\\EshopCommunity\\Internal\\Framework\\Module\\Configuration\\Bridge\\ModuleSettingBridgeInterface') {
            return new ModuleSettings();
        }
        $map = [
            'OxidEsales\\EshopCommunity\\Internal\\Framework\\Database\\QueryBuilderFactoryInterface'
                => 'OxidEsales\\EshopCommunity\\Internal\\Common\\Database\\QueryBuilderFactoryInterface',
            'OxidEsales\\EshopCommunity\\Internal\\Framework\\Templating\\TemplateRendererBridgeInterface'
                => 'OxidEsales\\EshopCommunity\\Internal\\Templating\\TemplateRendererBridgeInterface',
        ];
        $factory = 'OxidEsales\\EshopCommunity\\Internal\\Application\\ContainerFactory';
        $container = $factory::getInstance()->getContainer();
        if ($name === \Unzer\UnzerPayment\Service\DebugHandler::class && !$container->has($name)) {
            $context = new \Unzer\UnzerPayment\Service\Context(\OxidEsales\Eshop\Core\Registry::getConfig());
            $logger = new \Monolog\Logger('Unzer Payment Logger');
            $logger->pushHandler(new \Monolog\Handler\StreamHandler($context->getUnzerLogFilePath()));
            return new \Unzer\UnzerPayment\Service\DebugHandler($logger);
        }
        return $container->get($map[$name] ?? $name);
    }
}
