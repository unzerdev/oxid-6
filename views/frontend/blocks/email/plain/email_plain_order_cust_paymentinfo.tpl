[{if $payment->oxuserpayments__oxpaymentsid->value == "up_paylater_invoice" || $payment->oxuserpayments__oxpaymentsid->value == "up_prepayment"}]
    [{$oViewConf->getUnzerSessionPaymentInfo()|strip_tags}]
[{/if}]

[{$smarty.block.parent}]
