[{assign var="payment" value=$oView->getPayment()}]
[{if $payment->isUnzerPaymentMethod()}]
    [{include file="modules/unzer/unzer_payment/_inc/unzer_assets.tpl"}]

    <button type="button" class="btn btn-lg btn-primary pull-right submitButton nextStep largeButton" id="unzer-checkout-btn">
        <i class="fa fa-check"></i> [{oxmultilang ident="SUBMIT_ORDER"}]
    </button>

[{else}]
    [{$smarty.block.parent}]
[{/if}]