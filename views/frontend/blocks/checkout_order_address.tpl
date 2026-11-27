[{if $oxcmp_user && $oViewConf->isExpressCheckout()}][{assign var="oxcmp_user" value=$oViewConf->getUnzerCheckoutAddressUser($oxcmp_user)}][{/if}]
[{$smarty.block.parent}]
