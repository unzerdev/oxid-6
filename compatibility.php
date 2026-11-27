<?php
/** Namespace bridge for the official 6.4.0 core. Existing 6.5 classes are untouched. */
$unzerAliases = [
    'Internal\\Container\\ContainerFactory' => 'Unzer\\UnzerPayment\\Compatibility\\ContainerFactory',
    'Internal\\Framework\\Database\\QueryBuilderFactoryInterface' => 'OxidEsales\\EshopCommunity\\Internal\\Common\\Database\\QueryBuilderFactoryInterface',
    'Internal\\Framework\\Templating\\TemplateRendererBridgeInterface' => 'OxidEsales\\EshopCommunity\\Internal\\Templating\\TemplateRendererBridgeInterface',
    'Internal\\Transition\\Utility\\BasicContext' => 'OxidEsales\\EshopCommunity\\Internal\\Application\\Utility\\BasicContext',
    'Internal\\Framework\\Logger\\Factory\\MonologLoggerFactory' => 'OxidEsales\\EshopCommunity\\Internal\\Logger\\Factory\\MonologLoggerFactory',
    'Internal\\Framework\\Logger\\Configuration\\MonologConfiguration' => 'OxidEsales\\EshopCommunity\\Internal\\Logger\\Configuration\\MonologConfiguration',
];
foreach ($unzerAliases as $unzerAlias => $unzerOriginal) {
    $unzerAlias = 'OxidEsales\\EshopCommunity\\' . $unzerAlias;
    if (!class_exists($unzerAlias) && !interface_exists($unzerAlias)
        && (class_exists($unzerOriginal) || interface_exists($unzerOriginal))) {
        class_alias($unzerOriginal, $unzerAlias);
    }
}
unset($unzerAliases, $unzerAlias, $unzerOriginal);
