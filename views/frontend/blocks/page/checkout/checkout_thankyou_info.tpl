[{assign var="unzerOrder" value=$oView->getOrder()}]
[{if $unzerOrder}]
    [{assign var="expressTitle" value=$unzerOrder->getUnzerExpressTitle()}]
    [{if $expressTitle}]<p>[{oxmultilang ident="PAYMENT_METHOD"}]: [{$expressTitle|escape}]</p>[{/if}]
[{/if}]
[{if isset($unzerPaymentId)}]
    <p style="font-style: italic">
        Unzer Payment-ID: [{$unzerPaymentId}]<br>
        Unzer Short-ID: [{$unzerShortId}]
    </p>
[{/if}]

[{if isset($needsUnzerPaymentInfo)}]
    [{$unzerPaymentInfo}]
[{/if}]

[{$smarty.block.parent}]
