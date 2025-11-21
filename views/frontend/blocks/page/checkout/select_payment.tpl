[{if $paymentmethod->isUnzerPaymentMethod()}]
    <div class="well well-sm">
        [{include file="modules/unzer/unzer_payment/payment/payment_unzer.tpl"}]
    </div>
[{else}]
    [{$smarty.block.parent}]
[{/if}]